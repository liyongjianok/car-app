package auth

import (
	"context"
	"encoding/json"
	"errors"

	"car-app/internal/model"
	"car-app/internal/svc"
	"car-app/internal/types"

	"github.com/zeromicro/go-zero/core/logx"
)

type GetUserInfoLogic struct {
	logx.Logger
	ctx    context.Context
	svcCtx *svc.ServiceContext
}

func NewGetUserInfoLogic(ctx context.Context, svcCtx *svc.ServiceContext) *GetUserInfoLogic {
	return &GetUserInfoLogic{
		Logger: logx.WithContext(ctx),
		ctx:    ctx,
		svcCtx: svcCtx,
	}
}

func (l *GetUserInfoLogic) GetUserInfo() (resp *types.UserInfoResp, err error) {
	var uid int64

	// 兼容处理：尝试作为 json.Number 解析 (Go-Zero 推荐标准)
	if uidNum, ok := l.ctx.Value("uid").(json.Number); ok {
		uid, err = uidNum.Int64()
		if err != nil {
			return nil, errors.New("身份认证数据异常(Number)")
		}
		// 兼容处理：尝试作为 float64 解析 (标准 JWT 库默认行为)
	} else if uidFloat, ok := l.ctx.Value("uid").(float64); ok {
		uid = int64(uidFloat)
	} else {
		// 如果都不是，打印出到底是个什么类型，方便排查
		l.Logger.Errorf("JWT 解析失败，uid 类型为: %T", l.ctx.Value("uid"))
		return nil, errors.New("身份认证失败，请重新登录")
	}

	// 根据获取到的 uid 查询用户详细信息
	userInfo, err := l.svcCtx.UsersModel.FindOne(l.ctx, uint64(uid))
	if err != nil {
		if err == model.ErrNotFound {
			return nil, errors.New("用户不存在")
		}
		l.Logger.Errorf("查询用户信息失败: %v", err)
		return nil, errors.New("获取用户信息失败")
	}

	// 组装返回数据给前端
	return &types.UserInfoResp{
		Uid:      int64(userInfo.Id),
		Phone:    userInfo.Phone,
		Nickname: userInfo.Nickname,
		Avatar:   userInfo.Avatar,
	}, nil
}
