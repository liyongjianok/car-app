package config

import (
	"github.com/zeromicro/go-zero/core/stores/cache"
	"github.com/zeromicro/go-zero/rest"
)

type Config struct {
	rest.RestConf

	Auth struct {
		AccessSecret string `json:"AccessSecret"`
		AccessExpire int64  `json:"AccessExpire"`
	} `json:"Auth"`

	DataSource string `json:"DataSource"`

	// 强制映射 Cache 数组
	Cache cache.CacheConf `json:"Cache"`

	MinIO struct {
		Endpoint  string `json:"Endpoint"`
		AccessKey string `json:"AccessKey"`
		SecretKey string `json:"SecretKey"`
		UseSSL    bool   `json:"UseSSL"`
		Bucket    string `json:"Bucket"`
	} `json:"MinIO"`
}
