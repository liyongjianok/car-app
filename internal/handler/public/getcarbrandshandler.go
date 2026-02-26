// Code scaffolded by goctl. Safe to edit.
// goctl 1.9.2

package public

import (
	"net/http"

	"car-app/internal/logic/public"
	"car-app/internal/svc"
	"github.com/zeromicro/go-zero/rest/httpx"
)

func GetCarBrandsHandler(svcCtx *svc.ServiceContext) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		l := public.NewGetCarBrandsLogic(r.Context(), svcCtx)
		resp, err := l.GetCarBrands()
		if err != nil {
			httpx.ErrorCtx(r.Context(), w, err)
		} else {
			httpx.OkJsonCtx(r.Context(), w, resp)
		}
	}
}
