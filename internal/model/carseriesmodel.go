package model

import (
	"github.com/zeromicro/go-zero/core/stores/cache"
	"github.com/zeromicro/go-zero/core/stores/sqlx"
)

var _ CarSeriesModel = (*customCarSeriesModel)(nil)

type (
	// CarSeriesModel is an interface to be customized, add more methods here,
	// and implement the added methods in customCarSeriesModel.
	CarSeriesModel interface {
		carSeriesModel
	}

	customCarSeriesModel struct {
		*defaultCarSeriesModel
	}
)

// NewCarSeriesModel returns a model for the database table.
func NewCarSeriesModel(conn sqlx.SqlConn, c cache.CacheConf, opts ...cache.Option) CarSeriesModel {
	return &customCarSeriesModel{
		defaultCarSeriesModel: newCarSeriesModel(conn, c, opts...),
	}
}
