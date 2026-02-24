package public

import (
	"context"

	"car-app/internal/svc"
	"car-app/internal/types"

	"github.com/zeromicro/go-zero/core/logx"
)

type GetReviewListLogic struct {
	logx.Logger
	ctx    context.Context
	svcCtx *svc.ServiceContext
}

func NewGetReviewListLogic(ctx context.Context, svcCtx *svc.ServiceContext) *GetReviewListLogic {
	return &GetReviewListLogic{
		Logger: logx.WithContext(ctx),
		ctx:    ctx,
		svcCtx: svcCtx,
	}
}

// 映射联查结果的内部结构体
type DbReviewItem struct {
	Id         int64   `db:"id"`
	Uid        int64   `db:"user_id"`
	Nickname   string  `db:"nickname"`
	Avatar     string  `db:"avatar"`
	Score      float64 `db:"score"`
	Content    string  `db:"content"`
	Likes      int64   `db:"likes"`
	CreateTime string  `db:"create_time"` // 用 SQL 的 DATE_FORMAT 直接转成格式化字符串
}

func (l *GetReviewListLogic) GetReviewList(req *types.GetReviewListReq) (resp *types.GetReviewListResp, err error) {
	// 1. 查询该车型的评论总数
	var total int64
	countSql := "SELECT count(id) FROM reviews WHERE model_id = ?"
	err = l.svcCtx.DbConn.QueryRowCtx(l.ctx, &total, countSql, req.ModelId)
	if err != nil {
		l.Logger.Errorf("查询评论总数失败: %v", err)
		return nil, err
	}

	// 如果没有评论，直接返回空列表
	if total == 0 {
		return &types.GetReviewListResp{
			Total: 0,
			List:  make([]types.ReviewInfo, 0),
		}, nil
	}

	// 2. 分页查出评论详情并联查用户信息
	if req.PageIndex <= 0 {
		req.PageIndex = 1
	}
	if req.PageSize <= 0 {
		req.PageSize = 10
	}
	offset := (req.PageIndex - 1) * req.PageSize

	// 注意这里的 DATE_FORMAT，让数据库直接帮我们把时间格式化好，省得在 Go 里面转时区
	listSql := `
		SELECT r.id, r.user_id, u.nickname, u.avatar, r.score, r.content, r.likes, 
		       DATE_FORMAT(r.create_time, '%Y-%m-%d %H:%i') as create_time
		FROM reviews r
		LEFT JOIN users u ON r.user_id = u.id
		WHERE r.model_id = ?
		ORDER BY r.create_time DESC
		LIMIT ?, ?
	`

	var dbList []DbReviewItem
	err = l.svcCtx.DbConn.QueryRowsCtx(l.ctx, &dbList, listSql, req.ModelId, offset, req.PageSize)
	if err != nil {
		l.Logger.Errorf("查询评论列表失败: %v", err)
		return nil, err
	}

	// 3. 数据组装
	respList := make([]types.ReviewInfo, 0, len(dbList))
	for _, item := range dbList {
		// 如果用户没设置头像，给个默认头像以防前端破图
		avatar := item.Avatar
		if avatar == "" {
			avatar = "https://dummyimage.com/100x100/cccccc/ffffff&text=User"
		}

		respList = append(respList, types.ReviewInfo{
			Id:         item.Id,
			Uid:        item.Uid,
			Nickname:   item.Nickname,
			Avatar:     avatar,
			Score:      item.Score,
			Content:    item.Content,
			Likes:      item.Likes,
			CreateTime: item.CreateTime,
		})
	}

	return &types.GetReviewListResp{
		Total: total,
		List:  respList,
	}, nil
}
