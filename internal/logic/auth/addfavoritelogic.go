package auth

import (
	"context"
	"encoding/json"
	"errors"

	"car-app/internal/svc"
	"car-app/internal/types"

	"github.com/zeromicro/go-zero/core/logx"
)

type AddFavoriteLogic struct {
	logx.Logger
	ctx    context.Context
	svcCtx *svc.ServiceContext
}

func NewAddFavoriteLogic(ctx context.Context, svcCtx *svc.ServiceContext) *AddFavoriteLogic {
	return &AddFavoriteLogic{
		Logger: logx.WithContext(ctx),
		ctx:    ctx,
		svcCtx: svcCtx,
	}
}

func (l *AddFavoriteLogic) AddFavorite(req *types.FavoriteReq) (resp *types.FavoriteResp, err error) {
	// 1. 获取当前用户 UID
	uidNumber, ok := l.ctx.Value("uid").(json.Number)
	if !ok {
		return nil, errors.New("未授权或 token 失效")
	}
	uid, _ := uidNumber.Int64()

	// 2. 使用原生 DbConn 执行插入。
	// 使用 insert ignore 防止用户快速重复点击导致数据库抛出唯一索引异常
	query := "insert ignore into favorites (user_id, model_id) values (?, ?)"
	_, err = l.svcCtx.DbConn.ExecCtx(l.ctx, query, uid, req.ModelId)
	if err != nil {
		l.Logger.Errorf("添加收藏失败: %v", err)
		return nil, errors.New("添加收藏失败")
	}

	return &types.FavoriteResp{
		Message: "收藏成功",
	}, nil
}
