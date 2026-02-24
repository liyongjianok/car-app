package model

import (
	"github.com/zeromicro/go-zero/core/stores/cache"
	"github.com/zeromicro/go-zero/core/stores/sqlx"
)

var _ CarBrandsModel = (*customCarBrandsModel)(nil)

type (
	// CarBrandsModel is an interface to be customized, add more methods here,
	// and implement the added methods in customCarBrandsModel.
	CarBrandsModel interface {
		carBrandsModel
	}

	customCarBrandsModel struct {
		*defaultCarBrandsModel
	}
)

// NewCarBrandsModel returns a model for the database table.
func NewCarBrandsModel(conn sqlx.SqlConn, c cache.CacheConf, opts ...cache.Option) CarBrandsModel {
	return &customCarBrandsModel{
		defaultCarBrandsModel: newCarBrandsModel(conn, c, opts...),
	}
}
