package svc

import (
	"car-app/internal/config"
	"car-app/internal/model"

	"github.com/zeromicro/go-zero/core/stores/sqlx"
)

type ServiceContext struct {
	Config config.Config

	// 注册生成的数据库 Model
	UsersModel     model.UsersModel
	CarBrandsModel model.CarBrandsModel
	CarSeriesModel model.CarSeriesModel
	CarModelsModel model.CarModelsModel
	CarSpecsModel  model.CarSpecsModel
	CarMediaModel  model.CarMediaModel
	ReviewsModel   model.ReviewsModel
}

func NewServiceContext(c config.Config) *ServiceContext {
	// 1. 初始化 sqlx 数据库连接
	conn := sqlx.NewMysql(c.DataSource)

	// 2. 实例化各个表的 Model，并传入数据库连接和 Redis 缓存配置
	return &ServiceContext{
		Config:         c,
		UsersModel:     model.NewUsersModel(conn, c.Cache),
		CarBrandsModel: model.NewCarBrandsModel(conn, c.Cache),
		CarSeriesModel: model.NewCarSeriesModel(conn, c.Cache),
		CarModelsModel: model.NewCarModelsModel(conn, c.Cache),
		CarSpecsModel:  model.NewCarSpecsModel(conn, c.Cache),
		CarMediaModel:  model.NewCarMediaModel(conn, c.Cache),
		ReviewsModel:   model.NewReviewsModel(conn, c.Cache),
	}
}
