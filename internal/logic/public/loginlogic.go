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

	// 2. 校验密码
	if userInfo.Password != req.Password {
		return nil, errors.New("密码错误")
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
