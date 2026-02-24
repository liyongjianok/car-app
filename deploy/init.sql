CREATE DATABASE IF NOT EXISTS `car_db` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE `car_db`;

-- 1. 用户表
CREATE TABLE `users` (
    `id` bigint unsigned NOT NULL AUTO_INCREMENT,
    `phone` varchar(20) NOT NULL COMMENT '手机号',
    `password` varchar(100) NOT NULL COMMENT '密码哈希',
    `nickname` varchar(50) NOT NULL DEFAULT '' COMMENT '昵称',
    `avatar` varchar(255) NOT NULL DEFAULT '' COMMENT '头像URL(MinIO)',
    `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `idx_phone` (`phone`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = '用户表';

-- 2. 汽车品牌表
CREATE TABLE `car_brands` (
    `id` bigint unsigned NOT NULL AUTO_INCREMENT,
    `name` varchar(50) NOT NULL COMMENT '品牌名称，如：本田',
    `logo` varchar(255) NOT NULL DEFAULT '' COMMENT '品牌Logo(MinIO)',
    `initial` char(1) NOT NULL COMMENT '首字母A-Z',
    `sort` int NOT NULL DEFAULT '0' COMMENT '排序',
    PRIMARY KEY (`id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = '汽车品牌表';

-- 3. 车系表
CREATE TABLE `car_series` (
    `id` bigint unsigned NOT NULL AUTO_INCREMENT,
    `brand_id` bigint unsigned NOT NULL COMMENT '关联品牌ID',
    `name` varchar(50) NOT NULL COMMENT '车系名称，如：雅阁',
    PRIMARY KEY (`id`),
    KEY `idx_brand_id` (`brand_id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = '车系表';

-- 4. 车型表 (具体款式)
CREATE TABLE `car_models` (
    `id` bigint unsigned NOT NULL AUTO_INCREMENT,
    `series_id` bigint unsigned NOT NULL COMMENT '关联车系ID',
    `name` varchar(100) NOT NULL COMMENT '车型名称，如：2024款 260TURBO 豪华版',
    `year` int NOT NULL COMMENT '年款，如：2024',
    `price` decimal(10, 2) NOT NULL DEFAULT '0.00' COMMENT '指导价(万元)',
    `cover_img` varchar(255) NOT NULL DEFAULT '' COMMENT '列表封面图(MinIO)',
    `status` tinyint NOT NULL DEFAULT '1' COMMENT '状态：1在售，0停售',
    PRIMARY KEY (`id`),
    KEY `idx_series_id` (`series_id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = '具体车型表';

-- 5. 车型配置表 (核心：使用 JSON 应对繁杂参数)
CREATE TABLE `car_specs` (
    `model_id` bigint unsigned NOT NULL COMMENT '关联车型ID，作为主键',
    `engine` varchar(50) NOT NULL DEFAULT '' COMMENT '发动机，如：1.5T 192马力 L4',
    `transmission` varchar(50) NOT NULL DEFAULT '' COMMENT '变速箱，如：CVT无级变速',
    `dimensions` varchar(50) NOT NULL DEFAULT '' COMMENT '长宽高(mm)',
    `base_params` json NULL COMMENT '基础参数(JSON结构)',
    `safety_params` json NULL COMMENT '安全配置(JSON结构)',
    `media_params` json NULL COMMENT '多媒体配置(JSON结构)',
    PRIMARY KEY (`model_id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = '车型详细配置表';

-- 6. 多媒体资源表 (图片/视频)
CREATE TABLE `car_media` (
    `id` bigint unsigned NOT NULL AUTO_INCREMENT,
    `model_id` bigint unsigned NOT NULL COMMENT '关联车型ID',
    `media_type` tinyint NOT NULL COMMENT '1:图片 2:视频',
    `position` varchar(20) NOT NULL DEFAULT '外观' COMMENT '位置分类：外观/内饰/中控/视频',
    `url` varchar(255) NOT NULL COMMENT '资源地址(MinIO)',
    `sort` int NOT NULL DEFAULT '0' COMMENT '展示排序',
    PRIMARY KEY (`id`),
    KEY `idx_model_id` (`model_id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = '车型多媒体表';

-- 7. 用户评论表
CREATE TABLE `reviews` (
    `id` bigint unsigned NOT NULL AUTO_INCREMENT,
    `user_id` bigint unsigned NOT NULL,
    `model_id` bigint unsigned NOT NULL,
    `score` decimal(2, 1) NOT NULL DEFAULT '5.0' COMMENT '评分1.0-5.0',
    `content` text NOT NULL COMMENT '评论内容',
    `likes` int NOT NULL DEFAULT '0' COMMENT '点赞数',
    `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_model_id` (`model_id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = '用户评论表';