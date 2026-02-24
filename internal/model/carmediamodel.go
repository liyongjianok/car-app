package model

import (
	"github.com/zeromicro/go-zero/core/stores/cache"
	"github.com/zeromicro/go-zero/core/stores/sqlx"
)

var _ CarMediaModel = (*customCarMediaModel)(nil)

type (
	// CarMediaModel is an interface to be customized, add more methods here,
	// and implement the added methods in customCarMediaModel.
	CarMediaModel interface {
		carMediaModel
	}

	customCarMediaModel struct {
		*defaultCarMediaModel
	}
)

// NewCarMediaModel returns a model for the database table.
func NewCarMediaModel(conn sqlx.SqlConn, c cache.CacheConf, opts ...cache.Option) CarMediaModel {
	return &customCarMediaModel{
		defaultCarMediaModel: newCarMediaModel(conn, c, opts...),
	}
}
