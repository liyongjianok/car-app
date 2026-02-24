package auth

import (
	"context"
	"encoding/json"
	"errors"

	"car-app/internal/svc"
	"car-app/internal/types"

	"github.com/zeromicro/go-zero/core/logx"
)

type PostReviewLogic struct {
	logx.Logger
	ctx    context.Context
	svcCtx *svc.ServiceContext
}

func NewPostReviewLogic(ctx context.Context, svcCtx *svc.ServiceContext) *PostReviewLogic {
	return &PostReviewLogic{
		Logger: logx.WithContext(ctx),
		ctx:    ctx,
		svcCtx: svcCtx,
	}
}

func (l *PostReviewLogic) PostReview(req *types.PostReviewReq) error {
	// 1. 健壮地提取当前登录的 uid
	var uid int64
	if uidNum, ok := l.ctx.Value("uid").(json.Number); ok {
		uid, _ = uidNum.Int64()
	} else if uidFloat, ok := l.ctx.Value("uid").(float64); ok {
		uid = int64(uidFloat)
	} else {
		return errors.New("身份认证失效，请重新登录")
	}

	// 2. 基础参数校验
	if req.Score < 1.0 || req.Score > 5.0 {
		return errors.New("评分必须在 1.0 到 5.0 之间")
	}
	if len(req.Content) < 5 {
		return errors.New("评论内容不能少于 5 个字符")
	}

	// 3. 执行数据库插入 (直接使用原生 SQL，绕开 generated model 的类型转换繁琐)
	insertSql := "INSERT INTO `reviews` (`user_id`, `model_id`, `score`, `content`) VALUES (?, ?, ?, ?)"
	_, err := l.svcCtx.DbConn.ExecCtx(l.ctx, insertSql, uid, req.ModelId, req.Score, req.Content)
	if err != nil {
		l.Logger.Errorf("发表评论失败: %v", err)
		return errors.New("系统繁忙，发表评论失败")
	}

	return nil
}
