package public

import (
	"context"
	"fmt"
	"strings"

	"car-app/internal/svc"
	"car-app/internal/types"

	"github.com/zeromicro/go-zero/core/logx"
)

type SearchCarsLogic struct {
	logx.Logger
	ctx    context.Context
	svcCtx *svc.ServiceContext
}

func NewSearchCarsLogic(ctx context.Context, svcCtx *svc.ServiceContext) *SearchCarsLogic {
	return &SearchCarsLogic{
		Logger: logx.WithContext(ctx),
		ctx:    ctx,
		svcCtx: svcCtx,
	}
}

// DbCarBaseInfo 用于接收数据库 SQL 查询映射（带 db 标签）
type DbCarBaseInfo struct {
	Id        int64   `db:"id"`
	BrandName string  `db:"brand_name"`
	Series    string  `db:"series"`
	ModelName string  `db:"model_name"`
	Price     float64 `db:"price"`
	CoverImg  string  `db:"cover_img"`
}

func (l *SearchCarsLogic) SearchCars(req *types.SearchCarReq) (resp *types.SearchCarResp, err error) {
	// 1. 构建基础 SQL 语句 (左连接品牌表和车系表)
	baseSelect := `
		SELECT m.id, b.name as brand_name, s.name as series, m.name as model_name, m.price, m.cover_img
		FROM car_models m
		LEFT JOIN car_series s ON m.series_id = s.id
		LEFT JOIN car_brands b ON s.brand_id = b.id
		WHERE m.status = 1
	`
	countSelect := `
		SELECT count(m.id)
		FROM car_models m
		LEFT JOIN car_series s ON m.series_id = s.id
		LEFT JOIN car_brands b ON s.brand_id = b.id
		WHERE m.status = 1
	`

	var conditions []string
	var args []interface{}

	// 2. 动态拼接查询条件
	if req.Keyword != "" {
		// 关键词匹配：车型名、车系名、品牌名
		conditions = append(conditions, "(m.name LIKE ? OR b.name LIKE ? OR s.name LIKE ?)")
		kw := "%" + req.Keyword + "%"
		args = append(args, kw, kw, kw)
	}
	if req.BrandId > 0 {
		conditions = append(conditions, "b.id = ?")
		args = append(args, req.BrandId)
	}
	if req.MinPrice > 0 {
		conditions = append(conditions, "m.price >= ?")
		args = append(args, req.MinPrice)
	}
	if req.MaxPrice > 0 {
		conditions = append(conditions, "m.price <= ?")
		args = append(args, req.MaxPrice)
	}

	// 将条件追加到 SQL 语句中
	whereClause := ""
	if len(conditions) > 0 {
		whereClause = " AND " + strings.Join(conditions, " AND ")
		baseSelect += whereClause
		countSelect += whereClause
	}

	// 3. 查询总数 (用于前端分页)
	var total int64
	err = l.svcCtx.DbConn.QueryRowCtx(l.ctx, &total, countSelect, args...)
	if err != nil {
		l.Logger.Errorf("查询车辆总数失败: %v", err)
		return nil, err
	}

	// 4. 查询当前页数据
	// 如果前端没传分页数据，赋默认值
	if req.PageIndex <= 0 {
		req.PageIndex = 1
	}
	if req.PageSize <= 0 {
		req.PageSize = 10
	}
	offset := (req.PageIndex - 1) * req.PageSize
	baseSelect += fmt.Sprintf(" ORDER BY m.id DESC LIMIT %d, %d", offset, req.PageSize)

	var dbList []DbCarBaseInfo
	err = l.svcCtx.DbConn.QueryRowsCtx(l.ctx, &dbList, baseSelect, args...)
	if err != nil {
		l.Logger.Errorf("查询车辆列表失败: %v", err)
		return nil, err
	}

	// 5. 将数据库结构体转换为 API 响应结构体
	var respList []types.CarBaseInfo
	for _, item := range dbList {
		respList = append(respList, types.CarBaseInfo{
			Id:        item.Id,
			BrandName: item.BrandName,
			Series:    item.Series,
			ModelName: item.ModelName,
			Price:     item.Price,
			CoverImg:  item.CoverImg,
		})
	}

	// 6. 避免返回 null 导致前端报错，空数组默认返回 []
	if respList == nil {
		respList = make([]types.CarBaseInfo, 0)
	}

	return &types.SearchCarResp{
		Total: total,
		List:  respList,
	}, nil
}
