// Code scaffolded by goctl. Safe to edit.
// goctl 1.9.2

package public

import (
	"context"

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

func (l *SearchCarsLogic) SearchCars(req *types.SearchCarReq) (resp *types.SearchCarResp, err error) {
	// todo: add your logic here and delete this line

	return
}
