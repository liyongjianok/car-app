package model

import (
	"context"
	"fmt"

	"github.com/zeromicro/go-zero/core/stores/cache"
	"github.com/zeromicro/go-zero/core/stores/sqlx"
)

var _ FavoritesModel = (*customFavoritesModel)(nil)

type (
	// FavoritesModel is an interface to be customized, add more methods here,
	// and implement the added methods in customFavoritesModel.
	FavoritesModel interface {
		favoritesModel
		// 自定义查询列表和总数
		FindListByUid(ctx context.Context, uid int64, offset int, limit int) ([]*Favorites, error)
		CountByUid(ctx context.Context, uid int64) (int64, error)
	}

	customFavoritesModel struct {
		*defaultFavoritesModel
	}
)

// NewFavoritesModel returns a model for the database table.
func NewFavoritesModel(conn sqlx.SqlConn, c cache.CacheConf, opts ...cache.Option) FavoritesModel {
	return &customFavoritesModel{
		defaultFavoritesModel: newFavoritesModel(conn, c, opts...),
	}
}

// FindListByUid 根据用户ID查询收藏列表
func (m *customFavoritesModel) FindListByUid(ctx context.Context, uid int64, offset int, limit int) ([]*Favorites, error) {
	query := fmt.Sprintf("select %s from %s where `user_id` = ? order by `id` desc limit ?, ?", favoritesRows, m.table)
	var resp []*Favorites
	err := m.QueryRowsNoCacheCtx(ctx, &resp, query, uid, offset, limit)
	return resp, err
}

// CountByUid 根据用户ID统计收藏总数
func (m *customFavoritesModel) CountByUid(ctx context.Context, uid int64) (int64, error) {
	query := fmt.Sprintf("select count(*) from %s where `user_id` = ?", m.table)
	var count int64
	err := m.QueryRowNoCacheCtx(ctx, &count, query, uid)
	return count, err
}
