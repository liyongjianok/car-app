package public

import (
	"context"
	"errors"

	"car-app/internal/model"
	"car-app/internal/svc"
	"car-app/internal/types"

	"github.com/zeromicro/go-zero/core/logx"
	"golang.org/x/crypto/bcrypt"
)

type RegisterLogic struct {
	logx.Logger
	ctx    context.Context
	svcCtx *svc.ServiceContext
}

func NewRegisterLogic(ctx context.Context, svcCtx *svc.ServiceContext) *RegisterLogic {
	return &RegisterLogic{
		Logger: logx.WithContext(ctx),
		ctx:    ctx,
		svcCtx: svcCtx,
	}
}

func (l *RegisterLogic) Register(req *types.RegisterReq) (resp *types.RegisterResp, err error) {
	// 1. 检查手机号是否已被注册
	_, err = l.svcCtx.UsersModel.FindOneByPhone(l.ctx, req.Phone)
	if err == nil {
		return nil, errors.New("该手机号已注册，请直接登录")
	} else if err != model.ErrNotFound {
		l.Logger.Errorf("查询手机号失败: %v", err)
		return nil, errors.New("系统繁忙，请稍后再试")
	}

	// 2. 密码加密 (使用 Bcrypt)
	hashPwd, err := bcrypt.GenerateFromPassword([]byte(req.Password), bcrypt.DefaultCost)
	if err != nil {
		l.Logger.Errorf("密码加密失败: %v", err)
		return nil, errors.New("系统内部错误，注册失败")
	}

	// 3. 准备新用户数据 (默认生成一个昵称和头像)
	phoneLen := len(req.Phone)
	defaultNickname := "车友_"
	if phoneLen >= 4 {
		defaultNickname += req.Phone[phoneLen-4:]
	} else {
		defaultNickname += req.Phone
	}
	defaultAvatar := "https://dummyimage.com/150/3498db/fff&text=New"

	newUser := &model.Users{
		Phone:    req.Phone,
		Password: string(hashPwd), // 存入密文！
		Nickname: defaultNickname,
		Avatar:   defaultAvatar,
	}

	// 4. 插入数据库
	_, err = l.svcCtx.UsersModel.Insert(l.ctx, newUser)
	if err != nil {
		l.Logger.Errorf("插入新用户失败: %v", err)
		return nil, errors.New("注册失败，请稍后再试")
	}

	return &types.RegisterResp{
		Message: "注册成功，请登录",
	}, nil
}
