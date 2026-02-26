package public

import (
	"context"
	"errors"
	"time"

	"car-app/internal/model"
	"car-app/internal/svc"
	"car-app/internal/types"

	"github.com/golang-jwt/jwt/v4"
	"github.com/zeromicro/go-zero/core/logx"
	"golang.org/x/crypto/bcrypt"
)

type LoginLogic struct {
	logx.Logger
	ctx    context.Context
	svcCtx *svc.ServiceContext
}

func NewLoginLogic(ctx context.Context, svcCtx *svc.ServiceContext) *LoginLogic {
	return &LoginLogic{
		Logger: logx.WithContext(ctx),
		ctx:    ctx,
		svcCtx: svcCtx,
	}
}

func (l *LoginLogic) Login(req *types.LoginReq) (resp *types.LoginResp, err error) {
	// 1. 根据手机号查询用户
	userInfo, err := l.svcCtx.UsersModel.FindOneByPhone(l.ctx, req.Phone)
	if err != nil {
		if err == model.ErrNotFound {
			return nil, errors.New("用户不存在，请检查手机号")
		}
		l.Logger.Errorf("查询用户失败: %v", err)
		return nil, errors.New("数据库查询错误")
	}

	// 2. 密码校验与平滑升级 (Bcrypt)
	// 判断是否已经是 Bcrypt 密文 (特征：长度>=60 且以 $2a$ 或 $2b$ 开头)
	isBcrypt := len(userInfo.Password) >= 60 && (userInfo.Password[:4] == "$2a$" || userInfo.Password[:4] == "$2b$")

	if isBcrypt {
		// 已经是密文，使用 bcrypt 对比
		err = bcrypt.CompareHashAndPassword([]byte(userInfo.Password), []byte(req.Password))
		if err != nil {
			return nil, errors.New("密码错误")
		}
	} else {
		// 还是老旧的明文，进行直接对比
		if userInfo.Password != req.Password {
			return nil, errors.New("密码错误")
		}

		// 密码正确！触发平滑升级：将明文加密后存入数据库
		hashPwd, err := bcrypt.GenerateFromPassword([]byte(req.Password), bcrypt.DefaultCost)
		if err == nil {
			userInfo.Password = string(hashPwd)
			updateErr := l.svcCtx.UsersModel.Update(l.ctx, userInfo)
			if updateErr != nil {
				l.Logger.Errorf("安全升级：更新用户密码失败: %v", updateErr)
			} else {
				l.Logger.Infof("安全升级：用户 ID [%d] 的密码已成功平滑升级为 Bcrypt 密文", userInfo.Id)
			}
		} else {
			l.Logger.Errorf("安全升级：生成 Bcrypt 密文失败: %v", err)
		}
	}

	// 3. 密码正确，生成 JWT Token
	now := time.Now().Unix()
	accessExpire := l.svcCtx.Config.Auth.AccessExpire
	jwtSecret := l.svcCtx.Config.Auth.AccessSecret

	// 这里将 uint64 类型的 userInfo.Id 强转为 int64
	jwtToken, err := l.getJwtToken(jwtSecret, now, accessExpire, int64(userInfo.Id))
	if err != nil {
		l.Logger.Errorf("生成 Token 失败: %v", err)
		return nil, errors.New("系统内部错误，生成授权凭证失败")
	}

	// 4. 返回包含 Token 的结果
	return &types.LoginResp{
		Token: jwtToken,
		Uid:   int64(userInfo.Id), // 这里同样进行强转
	}, nil
}

// 私有方法：生成 JWT 令牌
func (l *LoginLogic) getJwtToken(secretKey string, iat, seconds, userId int64) (string, error) {
	claims := make(jwt.MapClaims)
	claims["exp"] = iat + seconds
	claims["iat"] = iat
	claims["uid"] = userId

	token := jwt.New(jwt.SigningMethodHS256)
	token.Claims = claims
	return token.SignedString([]byte(secretKey))
}
