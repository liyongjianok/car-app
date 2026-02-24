// Code scaffolded by goctl. Safe to edit.
// goctl 1.9.2

package public

import (
	"context"

	"car-api/internal/svc"
	"car-api/internal/types"

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

func (l *GetCarDetailLogic) GetCarDetail(req *types.CarDetailReq) (resp *types.CarDetailResp, err error) {
	// todo: add your logic here and delete this line

	return
}
