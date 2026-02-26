package auth

import (
	"context"
	"encoding/json"
	"errors"

	"car-app/internal/svc"
	"car-app/internal/types"

	"github.com/zeromicro/go-zero/core/logx"
)

type GetMyFavoritesLogic struct {
	logx.Logger
	ctx    context.Context
	svcCtx *svc.ServiceContext
}

func NewGetMyFavoritesLogic(ctx context.Context, svcCtx *svc.ServiceContext) *GetMyFavoritesLogic {
	return &GetMyFavoritesLogic{
		Logger: logx.WithContext(ctx),
		ctx:    ctx,
		svcCtx: svcCtx,
	}
}

func (l *GetMyFavoritesLogic) GetMyFavorites(req *types.GetMyFavoritesReq) (resp *types.GetMyFavoritesResp, err error) {
	uidNumber, ok := l.ctx.Value("uid").(json.Number)
	if !ok {
		return nil, errors.New("未授权或 token 失效")
	}
	uid, _ := uidNumber.Int64()
	offset := (req.PageIndex - 1) * req.PageSize

	favorites, err := l.svcCtx.FavoritesModel.FindListByUid(l.ctx, uid, offset, req.PageSize)
	if err != nil {
		l.Logger.Errorf("查询收藏列表失败: %v", err)
		return nil, errors.New("查询列表失败")
	}

	total, _ := l.svcCtx.FavoritesModel.CountByUid(l.ctx, uid)

	resp = &types.GetMyFavoritesResp{
		Total: total,
		List:  make([]types.FavoriteItem, 0),
	}

	for _, f := range favorites {
		var carName, carImg string
		var price float64
		carInfo, err := l.svcCtx.CarModelsModel.FindOne(l.ctx, uint64(f.ModelId))
		if err == nil && carInfo != nil {
			carName = carInfo.Name
			carImg = carInfo.CoverImg
			price = carInfo.Price // 假设数据库叫 price
		} else {
			carName = "未知车型"
			carImg = "https://dummyimage.com/100/ccc/fff&text=No+Img"
		}

		resp.List = append(resp.List, types.FavoriteItem{
			Id:      int64(f.Id),
			ModelId: int64(f.ModelId),
			CarName: carName,
			CarImg:  carImg,
			Price:   price,
		})
	}
	return resp, nil
}
