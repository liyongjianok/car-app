package model

import (
	"context"
	"fmt"

	"github.com/zeromicro/go-zero/core/stores/cache"
	"github.com/zeromicro/go-zero/core/stores/sqlx"
)

var _ ReviewsModel = (*customReviewsModel)(nil)

type (
	ReviewsModel interface {
		reviewsModel
		FindListByUid(ctx context.Context, uid int64, offset int, limit int) ([]*Reviews, error)
		CountByUid(ctx context.Context, uid int64) (int64, error)
	}

	customReviewsModel struct {
		*defaultReviewsModel
	}
)

func NewReviewsModel(conn sqlx.SqlConn, c cache.CacheConf, opts ...cache.Option) ReviewsModel {
	return &customReviewsModel{
		defaultReviewsModel: newReviewsModel(conn, c, opts...),
	}
}

// FindListByUid 根据用户ID查询评价列表
func (m *customReviewsModel) FindListByUid(ctx context.Context, uid int64, offset int, limit int) ([]*Reviews, error) {
	query := fmt.Sprintf("select %s from %s where `user_id` = ? order by `create_time` desc limit ?, ?", reviewsRows, m.table)
	var resp []*Reviews
	err := m.QueryRowsNoCacheCtx(ctx, &resp, query, uid, offset, limit)
	return resp, err
}

// CountByUid 根据用户ID统计总数
func (m *customReviewsModel) CountByUid(ctx context.Context, uid int64) (int64, error) {
	query := fmt.Sprintf("select count(*) from %s where `user_id` = ?", m.table)
	var count int64
	err := m.QueryRowNoCacheCtx(ctx, &count, query, uid)
	return count, err
}
