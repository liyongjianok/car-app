package public

import (
	"context"
	"database/sql"
	"encoding/json"
	"errors" // 新增了 errors 库引入

	"car-app/internal/svc"
	"car-app/internal/types"

	"github.com/zeromicro/go-zero/core/logx"
)

type GetCarDetailLogic struct {
	logx.Logger
	ctx    context.Context
	svcCtx *svc.ServiceContext
}

func NewGetCarDetailLogic(ctx context.Context, svcCtx *svc.ServiceContext) *GetCarDetailLogic {
	return &GetCarDetailLogic{
		Logger: logx.WithContext(ctx),
		ctx:    ctx,
		svcCtx: svcCtx,
	}
}

// 接收参数的内部结构体
type DbCarSpecs struct {
	Engine       string `db:"engine"`
	Transmission string `db:"transmission"`
	Dimensions   string `db:"dimensions"`
	BaseParams   string `db:"base_params"`
	SafetyParams string `db:"safety_params"`
	MediaParams  string `db:"media_params"`
}

type DbCarMedia struct {
	MediaType int    `db:"media_type"`
	Url       string `db:"url"`
}

func (l *GetCarDetailLogic) GetCarDetail(req *types.CarDetailReq) (resp *types.CarDetailResp, err error) {
	// 初始化返回结构体
	resp = &types.CarDetailResp{
		Specs:  make(map[string]interface{}),
		Images: make([]string, 0),
	}

	// 1. 查询车辆基础信息
	type DbCarBaseInfo struct {
		Id        int64   `db:"id"`
		BrandName string  `db:"brand_name"`
		Series    string  `db:"series"`
		ModelName string  `db:"model_name"`
		Price     float64 `db:"price"`
		CoverImg  string  `db:"cover_img"`
	}
	var baseInfo DbCarBaseInfo
	baseSql := `
		SELECT m.id, b.name as brand_name, s.name as series, m.name as model_name, m.price, m.cover_img
		FROM car_models m
		LEFT JOIN car_series s ON m.series_id = s.id
		LEFT JOIN car_brands b ON s.brand_id = b.id
		WHERE m.id = ? AND m.status = 1
	`
	err = l.svcCtx.DbConn.QueryRowCtx(l.ctx, &baseInfo, baseSql, req.Id)
	if err != nil {
		if err == sql.ErrNoRows {
			return nil, errors.New("车型不存在")
		}
		l.Logger.Errorf("查询车辆基础信息失败: %v", err)
		return nil, err
	}
	resp.BaseInfo = types.CarBaseInfo{
		Id:        baseInfo.Id,
		BrandName: baseInfo.BrandName,
		Series:    baseInfo.Series,
		ModelName: baseInfo.ModelName,
		Price:     baseInfo.Price,
		CoverImg:  baseInfo.CoverImg,
	}

	// 2. 查询并解析 JSON 车辆配置
	var dbSpecs DbCarSpecs
	specsSql := `
		SELECT engine, transmission, dimensions, 
		       IFNULL(base_params, '{}') as base_params, 
		       IFNULL(safety_params, '{}') as safety_params, 
		       IFNULL(media_params, '{}') as media_params
		FROM car_specs WHERE model_id = ?
	`
	err = l.svcCtx.DbConn.QueryRowCtx(l.ctx, &dbSpecs, specsSql, req.Id)
	if err == nil {
		// 组装核心结构化参数
		resp.Specs["发动机"] = dbSpecs.Engine
		resp.Specs["变速箱"] = dbSpecs.Transmission
		resp.Specs["长宽高"] = dbSpecs.Dimensions

		// 解析 JSON 字段，归类到统一的字典中
		var baseMap, safetyMap, mediaMap map[string]interface{}
		_ = json.Unmarshal([]byte(dbSpecs.BaseParams), &baseMap)
		_ = json.Unmarshal([]byte(dbSpecs.SafetyParams), &safetyMap)
		_ = json.Unmarshal([]byte(dbSpecs.MediaParams), &mediaMap)

		if len(baseMap) > 0 {
			resp.Specs["基础参数"] = baseMap
		}
		if len(safetyMap) > 0 {
			resp.Specs["安全配置"] = safetyMap
		}
		if len(mediaMap) > 0 {
			resp.Specs["多媒体配置"] = mediaMap
		}
	} else if err != sql.ErrNoRows {
		l.Logger.Errorf("查询车辆配置失败: %v", err)
	}

	// 3. 查询图片和视频媒体
	var mediaList []DbCarMedia
	mediaSql := `SELECT media_type, url FROM car_media WHERE model_id = ? ORDER BY sort ASC`
	_ = l.svcCtx.DbConn.QueryRowsCtx(l.ctx, &mediaList, mediaSql, req.Id)

	for _, m := range mediaList {
		if m.MediaType == 1 {
			// 图片放入图集数组
			resp.Images = append(resp.Images, m.Url)
		} else if m.MediaType == 2 && resp.VideoUrl == "" {
			// 视频放入单字段
			resp.VideoUrl = m.Url
		}
	}

	return resp, nil
}
