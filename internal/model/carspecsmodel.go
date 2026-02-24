package model

import (
	"github.com/zeromicro/go-zero/core/stores/cache"
	"github.com/zeromicro/go-zero/core/stores/sqlx"
)

var _ CarSpecsModel = (*customCarSpecsModel)(nil)

type (
	// CarSpecsModel is an interface to be customized, add more methods here,
	// and implement the added methods in customCarSpecsModel.
	CarSpecsModel interface {
		carSpecsModel
	}

	customCarSpecsModel struct {
		*defaultCarSpecsModel
	}
)

// NewCarSpecsModel returns a model for the database table.
func NewCarSpecsModel(conn sqlx.SqlConn, c cache.CacheConf, opts ...cache.Option) CarSpecsModel {
	return &customCarSpecsModel{
		defaultCarSpecsModel: newCarSpecsModel(conn, c, opts...),
	}
}
