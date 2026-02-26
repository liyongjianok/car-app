package auth

import (
	"context"
	"encoding/json"
	"errors"

	"car-app/internal/svc"
	"car-app/internal/types"

	"github.com/zeromicro/go-zero/core/logx"
)

type GetMyReviewsLogic struct {
	logx.Logger
	ctx    context.Context
	svcCtx *svc.ServiceContext
}

func NewGetMyReviewsLogic(ctx context.Context, svcCtx *svc.ServiceContext) *GetMyReviewsLogic {
	return &GetMyReviewsLogic{
		Logger: logx.WithContext(ctx),
		ctx:    ctx,
		svcCtx: svcCtx,
	}
}

func (l *GetMyReviewsLogic) GetMyReviews(req *types.GetMyReviewsReq) (resp *types.GetMyReviewsResp, err error) {
	uidNumber, ok := l.ctx.Value("uid").(json.Number)
	if !ok {
		return nil, errors.New("未授权或 token 失效")
	}
	uid, err := uidNumber.Int64()
	if err != nil {
		l.Logger.Errorf("解析UID失败: %v", err)
		return nil, errors.New("身份信息异常")
	}

	offset := (req.PageIndex - 1) * req.PageSize

	// 1. 查询评论列表
	reviews, err := l.svcCtx.ReviewsModel.FindListByUid(l.ctx, uid, offset, req.PageSize)
	if err != nil {
		l.Logger.Errorf("查询评价列表失败: %v", err)
		return nil, errors.New("查询列表失败")
	}

	// 2. 查询总数
	total, err := l.svcCtx.ReviewsModel.CountByUid(l.ctx, uid)
	if err != nil {
		l.Logger.Errorf("查询评价总数失败: %v", err)
		return nil, errors.New("查询总数失败")
	}

	resp = &types.GetMyReviewsResp{
		Total: total,
		List:  make([]types.MyReviewInfo, 0),
	}

	// 3. 组装数据，去具体的车型表查名字和图片
	for _, r := range reviews {
		var carName string
		var carImg string

		carInfo, err := l.svcCtx.CarModelsModel.FindOne(l.ctx, uint64(r.ModelId))

		if err == nil && carInfo != nil {
			carName = carInfo.Name
			carImg = carInfo.CoverImg
		} else {
			carName = "未知车型"
			carImg = "https://dummyimage.com/100/ccc/fff&text=No+Img"
		}

		resp.List = append(resp.List, types.MyReviewInfo{
			Id:         int64(r.Id),
			ModelId:    int64(r.ModelId),
			CarName:    carName,
			CarImg:     carImg,
			Score:      r.Score,
			Content:    r.Content,
			CreateTime: r.CreateTime.Format("2006-01-02 15:04"),
		})
	}

	return resp, nil
}
