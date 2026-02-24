package model

import (
	"github.com/zeromicro/go-zero/core/stores/cache"
	"github.com/zeromicro/go-zero/core/stores/sqlx"
)

var _ ReviewsModel = (*customReviewsModel)(nil)

type (
	// ReviewsModel is an interface to be customized, add more methods here,
	// and implement the added methods in customReviewsModel.
	ReviewsModel interface {
		reviewsModel
	}

	customReviewsModel struct {
		*defaultReviewsModel
	}
)

// NewReviewsModel returns a model for the database table.
func NewReviewsModel(conn sqlx.SqlConn, c cache.CacheConf, opts ...cache.Option) ReviewsModel {
	return &customReviewsModel{
		defaultReviewsModel: newReviewsModel(conn, c, opts...),
	}
}
