package config

import (
	"github.com/zeromicro/go-zero/core/stores/cache"
	"github.com/zeromicro/go-zero/rest"
)

type Config struct {
	rest.RestConf

	// JWT Auth
	Auth struct {
		AccessSecret string
		AccessExpire int64
	}

	// Database
	DataSource string

	// Redis Cache
	CacheRedis cache.CacheConf

	// MinIO Config
	MinIO struct {
		Endpoint  string
		AccessKey string
		SecretKey string
		UseSSL    bool
		Bucket    string
	}
}
