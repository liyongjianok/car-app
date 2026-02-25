package auth

import (
	"context"
	"encoding/json"
	"errors"

	"car-app/internal/svc"
	"car-app/internal/types"

	"github.com/zeromicro/go-zero/core/logx"
)

type UpdateUserInfoLogic struct {
	logx.Logger
	ctx    context.Context
	svcCtx *svc.ServiceContext
}

func NewUpdateUserInfoLogic(ctx context.Context, svcCtx *svc.ServiceContext) *UpdateUserInfoLogic {
	return &UpdateUserInfoLogic{
		Logger: logx.WithContext(ctx),
		ctx:    ctx,
		svcCtx: svcCtx,
	}
}

func (l *UpdateUserInfoLogic) UpdateUserInfo(req *types.UpdateUserReq) (resp *types.UpdateUserResp, err error) {
	uidNumber, ok := l.ctx.Value("uid").(json.Number)
	if !ok {
		return nil, errors.New("未授权或 token 失效")
	}

	uid, err := uidNumber.Int64()
	if err != nil {
		l.Logger.Errorf("解析UID失败: %v", err)
		return nil, errors.New("身份信息异常")
	}

	userInfo, err := l.svcCtx.UsersModel.FindOne(l.ctx, uint64(uid))
	if err != nil {
		l.Logger.Errorf("查询用户失败, uid: %d, err: %v", uid, err)
		return nil, errors.New("用户不存在或状态异常")
	}

	// 动态更新字段：如果有传值就更新
	if req.Nickname != "" {
		userInfo.Nickname = req.Nickname
	}
	if req.Avatar != "" {
		userInfo.Avatar = req.Avatar
	}

	err = l.svcCtx.UsersModel.Update(l.ctx, userInfo)
	if err != nil {
		l.Logger.Errorf("更新用户信息失败: %v", err)
		return nil, errors.New("系统繁忙，请稍后再试")
	}

	return &types.UpdateUserResp{
		Message: "资料更新成功",
	}, nil
}
