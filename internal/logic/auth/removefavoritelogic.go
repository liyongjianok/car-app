package auth

import (
	"context"
	"encoding/json"
	"errors"

	"car-app/internal/svc"
	"car-app/internal/types"

	"github.com/zeromicro/go-zero/core/logx"
)

type RemoveFavoriteLogic struct {
	logx.Logger
	ctx    context.Context
	svcCtx *svc.ServiceContext
}

func NewRemoveFavoriteLogic(ctx context.Context, svcCtx *svc.ServiceContext) *RemoveFavoriteLogic {
	return &RemoveFavoriteLogic{
		Logger: logx.WithContext(ctx),
		ctx:    ctx,
		svcCtx: svcCtx,
	}
}

func (l *RemoveFavoriteLogic) RemoveFavorite(req *types.FavoriteReq) (resp *types.FavoriteResp, err error) {
	// 1. 获取当前用户 UID
	uidNumber, ok := l.ctx.Value("uid").(json.Number)
	if !ok {
		return nil, errors.New("未授权或 token 失效")
	}
	uid, _ := uidNumber.Int64()

	// 2. 使用原生 DbConn 精准删除对应的收藏记录
	query := "delete from favorites where user_id = ? and model_id = ?"
	_, err = l.svcCtx.DbConn.ExecCtx(l.ctx, query, uid, req.ModelId)
	if err != nil {
		l.Logger.Errorf("取消收藏失败: %v", err)
		return nil, errors.New("取消收藏失败")
	}

	return &types.FavoriteResp{
		Message: "已取消收藏",
	}, nil
}
