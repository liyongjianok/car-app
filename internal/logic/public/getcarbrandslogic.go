package public

import (
	"context"

	"car-app/internal/svc"
	"car-app/internal/types"

	"github.com/zeromicro/go-zero/core/logx"
)

type GetCarBrandsLogic struct {
	logx.Logger
	ctx    context.Context
	svcCtx *svc.ServiceContext
}

func NewGetCarBrandsLogic(ctx context.Context, svcCtx *svc.ServiceContext) *GetCarBrandsLogic {
	return &GetCarBrandsLogic{
		Logger: logx.WithContext(ctx),
		ctx:    ctx,
		svcCtx: svcCtx,
	}
}

func (l *GetCarBrandsLogic) GetCarBrands() (resp *types.GetCarBrandsResp, err error) {
	// 调用 FindAll 方法去数据库拉取所有品牌
	brands, err := l.svcCtx.CarBrandsModel.FindAll(l.ctx)
	if err != nil {
		l.Logger.Errorf("查询品牌列表失败: %v", err)
		return nil, err
	}

	// 初始化响应数组
	resp = &types.GetCarBrandsResp{
		List: make([]types.CarBrand, 0),
	}

	// 组装返回给前端的数据
	for _, b := range brands {
		resp.List = append(resp.List, types.CarBrand{
			Id:   int64(b.Id),
			Name: b.Name,
			Logo: b.Logo,
		})
	}

	return resp, nil
}
