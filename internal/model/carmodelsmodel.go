package model

import (
	"github.com/zeromicro/go-zero/core/stores/cache"
	"github.com/zeromicro/go-zero/core/stores/sqlx"
)

var _ CarModelsModel = (*customCarModelsModel)(nil)

type (
	// CarModelsModel is an interface to be customized, add more methods here,
	// and implement the added methods in customCarModelsModel.
	CarModelsModel interface {
		carModelsModel
	}

	customCarModelsModel struct {
		*defaultCarModelsModel
	}
)

// NewCarModelsModel returns a model for the database table.
func NewCarModelsModel(conn sqlx.SqlConn, c cache.CacheConf, opts ...cache.Option) CarModelsModel {
	return &customCarModelsModel{
		defaultCarModelsModel: newCarModelsModel(conn, c, opts...),
	}
}
