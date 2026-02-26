package model

import (
	"context"
	"fmt"

	"github.com/zeromicro/go-zero/core/stores/cache"
	"github.com/zeromicro/go-zero/core/stores/sqlx"
)

var _ CarBrandsModel = (*customCarBrandsModel)(nil)

type (
	CarBrandsModel interface {
		carBrandsModel
		// 查询所有品牌的方法
		FindAll(ctx context.Context) ([]*CarBrands, error)
	}

	customCarBrandsModel struct {
		*defaultCarBrandsModel
	}
)

func NewCarBrandsModel(conn sqlx.SqlConn, c cache.CacheConf, opts ...cache.Option) CarBrandsModel {
	return &customCarBrandsModel{
		defaultCarBrandsModel: newCarBrandsModel(conn, c, opts...),
	}
}

// FindAll 按照 sort 字段升序查询所有品牌
func (m *customCarBrandsModel) FindAll(ctx context.Context) ([]*CarBrands, error) {
	query := fmt.Sprintf("select %s from %s order by sort asc", carBrandsRows, m.table)
	var resp []*CarBrands
	err := m.QueryRowsNoCacheCtx(ctx, &resp, query)
	return resp, err
}
