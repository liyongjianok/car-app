CREATE DATABASE IF NOT EXISTS `car_db` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE `car_db`;

SET NAMES utf8mb4;

SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- 表结构重建
-- ----------------------------
DROP TABLE IF EXISTS `users`;

CREATE TABLE `users` (
    `id` bigint unsigned NOT NULL AUTO_INCREMENT,
    `phone` varchar(20) NOT NULL,
    `password` varchar(100) NOT NULL,
    `nickname` varchar(50) NOT NULL DEFAULT '',
    `avatar` varchar(255) NOT NULL DEFAULT '',
    `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `idx_phone` (`phone`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

DROP TABLE IF EXISTS `car_brands`;

CREATE TABLE `car_brands` (
    `id` bigint unsigned NOT NULL AUTO_INCREMENT,
    `name` varchar(50) NOT NULL,
    `logo` varchar(255) NOT NULL DEFAULT '',
    `initial` char(1) NOT NULL,
    `sort` int NOT NULL DEFAULT '0',
    PRIMARY KEY (`id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

DROP TABLE IF EXISTS `car_series`;

CREATE TABLE `car_series` (
    `id` bigint unsigned NOT NULL AUTO_INCREMENT,
    `brand_id` bigint unsigned NOT NULL,
    `name` varchar(50) NOT NULL,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

DROP TABLE IF EXISTS `car_models`;

CREATE TABLE `car_models` (
    `id` bigint unsigned NOT NULL AUTO_INCREMENT,
    `series_id` bigint unsigned NOT NULL,
    `name` varchar(100) NOT NULL,
    `year` int NOT NULL,
    `price` decimal(10, 2) NOT NULL DEFAULT '0.00',
    `cover_img` varchar(255) NOT NULL DEFAULT '',
    `status` tinyint NOT NULL DEFAULT '1',
    PRIMARY KEY (`id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

DROP TABLE IF EXISTS `car_specs`;

CREATE TABLE `car_specs` (
    `model_id` bigint unsigned NOT NULL,
    `engine` varchar(50) NOT NULL DEFAULT '',
    `transmission` varchar(50) NOT NULL DEFAULT '',
    `dimensions` varchar(50) NOT NULL DEFAULT '',
    `base_params` json NULL,
    `safety_params` json NULL,
    `media_params` json NULL,
    PRIMARY KEY (`model_id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

DROP TABLE IF EXISTS `car_media`;

CREATE TABLE `car_media` (
    `id` bigint unsigned NOT NULL AUTO_INCREMENT,
    `model_id` bigint unsigned NOT NULL,
    `media_type` tinyint NOT NULL COMMENT '1:图片 2:视频',
    `position` varchar(20) NOT NULL DEFAULT '外观',
    `url` varchar(255) NOT NULL,
    `sort` int NOT NULL DEFAULT '0',
    PRIMARY KEY (`id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

DROP TABLE IF EXISTS `reviews`;

CREATE TABLE `reviews` (
    `id` bigint unsigned NOT NULL AUTO_INCREMENT,
    `user_id` bigint unsigned NOT NULL,
    `model_id` bigint unsigned NOT NULL,
    `score` decimal(2, 1) NOT NULL DEFAULT '5.0',
    `content` text NOT NULL,
    `likes` int NOT NULL DEFAULT '0',
    `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

-- ----------------------------
-- 插入测试数据 (基础数据)
-- ----------------------------
-- 1. 插入用户 (密码统一为 123456)
INSERT INTO
    `users`
VALUES (
        1,
        '13800138000',
        '123456',
        '懂车帝体验官',
        'https://dummyimage.com/100/3498db/fff&text=U1',
        NOW(),
        NOW()
    ),
    (
        2,
        '13900139000',
        '123456',
        '极速蜗牛',
        'https://dummyimage.com/100/e74c3c/fff&text=U2',
        NOW(),
        NOW()
    ),
    (
        3,
        '13700137000',
        '123456',
        '老司机带带我',
        'https://dummyimage.com/100/2ecc71/fff&text=U3',
        NOW(),
        NOW()
    );

-- 2. 插入品牌
INSERT INTO
    `car_brands`
VALUES (
        1,
        '本田',
        'https://dummyimage.com/100/c0392b/fff&text=Honda',
        'B',
        1
    ),
    (
        2,
        '丰田',
        'https://dummyimage.com/100/bdc3c7/000&text=Toyota',
        'F',
        2
    ),
    (
        3,
        '宝马',
        'https://dummyimage.com/100/2980b9/fff&text=BMW',
        'B',
        3
    ),
    (
        4,
        '奥迪',
        'https://dummyimage.com/100/7f8c8d/fff&text=Audi',
        'A',
        4
    ),
    (
        5,
        '比亚迪',
        'https://dummyimage.com/100/d35400/fff&text=BYD',
        'B',
        5
    ),
    (
        6,
        '特斯拉',
        'https://dummyimage.com/100/c0392b/fff&text=Tesla',
        'T',
        6
    );

-- 3. 插入车系
INSERT INTO
    `car_series`
VALUES (1, 1, '雅阁'),
    (2, 1, '思域'),
    (3, 1, 'CR-V'),
    (4, 2, '凯美瑞'),
    (5, 2, '卡罗拉'),
    (6, 2, '汉兰达'),
    (7, 3, '3系'),
    (8, 3, '5系'),
    (9, 3, 'X3'),
    (10, 4, 'A4L'),
    (11, 4, 'A6L'),
    (12, 4, 'Q5L'),
    (13, 5, '汉'),
    (14, 5, '秦PLUS'),
    (15, 6, 'Model 3'),
    (16, 6, 'Model Y');

-- ----------------------------
-- 4. 批量插入 50 款具体车型
-- ----------------------------
INSERT INTO
    `car_models` (
        `id`,
        `series_id`,
        `name`,
        `year`,
        `price`,
        `cover_img`
    )
VALUES (
        1,
        1,
        '2024款 260TURBO 舒适版',
        2024,
        17.98,
        'https://dummyimage.com/400x300/e74c3c/fff&text=Accord'
    ),
    (
        2,
        1,
        '2024款 260TURBO 豪华版',
        2024,
        19.78,
        'https://dummyimage.com/400x300/e74c3c/fff&text=Accord'
    ),
    (
        3,
        1,
        '2024款 260TURBO 尊贵版',
        2024,
        21.48,
        'https://dummyimage.com/400x300/e74c3c/fff&text=Accord'
    ),
    (
        4,
        1,
        '2024款 2.0L e:PHEV 智享版',
        2024,
        22.58,
        'https://dummyimage.com/400x300/e74c3c/fff&text=Accord+PHEV'
    ),
    (
        5,
        2,
        '2023款 240TURBO 劲动版',
        2023,
        14.29,
        'https://dummyimage.com/400x300/c0392b/fff&text=Civic'
    ),
    (
        6,
        2,
        '2023款 240TURBO 燃擎版',
        2023,
        16.39,
        'https://dummyimage.com/400x300/c0392b/fff&text=Civic'
    ),
    (
        7,
        2,
        '2023款 2.0L e:HEV 极锐版',
        2023,
        17.39,
        'https://dummyimage.com/400x300/c0392b/fff&text=Civic+HEV'
    ),
    (
        8,
        3,
        '2023款 240TURBO 两驱锋尚版',
        2023,
        20.19,
        'https://dummyimage.com/400x300/95a5a6/fff&text=CR-V'
    ),
    (
        9,
        3,
        '2023款 240TURBO 四驱尊耀版',
        2023,
        24.99,
        'https://dummyimage.com/400x300/95a5a6/fff&text=CR-V'
    ),
    (
        10,
        4,
        '2024款 2.0E 精英版',
        2024,
        17.98,
        'https://dummyimage.com/400x300/bdc3c7/000&text=Camry'
    ),
    (
        11,
        4,
        '2024款 2.0G 豪华版',
        2024,
        19.98,
        'https://dummyimage.com/400x300/bdc3c7/000&text=Camry'
    ),
    (
        12,
        4,
        '2024款 双擎 2.0HG 尊贵版',
        2024,
        20.98,
        'https://dummyimage.com/400x300/bdc3c7/000&text=Camry+HEV'
    ),
    (
        13,
        5,
        '2023款 1.2T S-CVT 领先版',
        2023,
        11.68,
        'https://dummyimage.com/400x300/ecf0f1/000&text=Corolla'
    ),
    (
        14,
        5,
        '2023款 双擎 1.8L 精英版',
        2023,
        13.98,
        'https://dummyimage.com/400x300/ecf0f1/000&text=Corolla+HEV'
    ),
    (
        15,
        6,
        '2024款 双擎 2.5L 两驱精英版',
        2024,
        26.88,
        'https://dummyimage.com/400x300/7f8c8d/fff&text=Highlander'
    ),
    (
        16,
        6,
        '2024款 双擎 2.5L 四驱尊贵版',
        2024,
        32.58,
        'https://dummyimage.com/400x300/7f8c8d/fff&text=Highlander'
    ),
    (
        17,
        7,
        '2024款 320i M运动套装',
        2024,
        29.99,
        'https://dummyimage.com/400x300/3498db/fff&text=BMW+320i'
    ),
    (
        18,
        7,
        '2024款 325Li M运动曜夜套装',
        2024,
        36.99,
        'https://dummyimage.com/400x300/3498db/fff&text=BMW+325Li'
    ),
    (
        19,
        7,
        '2024款 330Li 尊享型 M运动曜夜',
        2024,
        39.99,
        'https://dummyimage.com/400x300/3498db/fff&text=BMW+330Li'
    ),
    (
        20,
        8,
        '2024款 525Li 豪华套装',
        2024,
        43.99,
        'https://dummyimage.com/400x300/2980b9/fff&text=BMW+525Li'
    ),
    (
        21,
        8,
        '2024款 530Li 尊享型 豪华套装',
        2024,
        52.59,
        'https://dummyimage.com/400x300/2980b9/fff&text=BMW+530Li'
    ),
    (
        22,
        9,
        '2023款 xDrive25i M运动套装',
        2023,
        39.96,
        'https://dummyimage.com/400x300/1abc9c/fff&text=BMW+X3'
    ),
    (
        23,
        9,
        '2023款 xDrive30i 领先型',
        2023,
        44.39,
        'https://dummyimage.com/400x300/1abc9c/fff&text=BMW+X3'
    ),
    (
        24,
        10,
        '2024款 40 TFSI 时尚动感型',
        2024,
        32.18,
        'https://dummyimage.com/400x300/95a5a6/fff&text=Audi+A4L'
    ),
    (
        25,
        10,
        '2024款 40 TFSI 豪华动感型',
        2024,
        34.38,
        'https://dummyimage.com/400x300/95a5a6/fff&text=Audi+A4L'
    ),
    (
        26,
        10,
        '2024款 45 TFSI quattro 臻选',
        2024,
        40.08,
        'https://dummyimage.com/400x300/95a5a6/fff&text=Audi+A4L+45'
    ),
    (
        27,
        11,
        '2024款 40 TFSI 豪华致雅型',
        2024,
        42.79,
        'https://dummyimage.com/400x300/34495e/fff&text=Audi+A6L'
    ),
    (
        28,
        11,
        '2024款 45 TFSI quattro 尊享',
        2024,
        49.98,
        'https://dummyimage.com/400x300/34495e/fff&text=Audi+A6L+45'
    ),
    (
        29,
        11,
        '2024款 55 TFSI quattro 旗舰',
        2024,
        65.68,
        'https://dummyimage.com/400x300/34495e/fff&text=Audi+A6L+55'
    ),
    (
        30,
        12,
        '2024款 40 TFSI 时尚动感型',
        2024,
        39.88,
        'https://dummyimage.com/400x300/7f8c8d/fff&text=Audi+Q5L'
    ),
    (
        31,
        12,
        '2024款 45 TFSI 臻选动感型',
        2024,
        48.88,
        'https://dummyimage.com/400x300/7f8c8d/fff&text=Audi+Q5L+45'
    ),
    (
        32,
        13,
        '2024款 荣耀版 DM-i 121KM 尊贵型',
        2024,
        16.98,
        'https://dummyimage.com/400x300/c0392b/fff&text=BYD+Han+DM-i'
    ),
    (
        33,
        13,
        '2024款 荣耀版 DM-i 200KM 旗舰型',
        2024,
        22.58,
        'https://dummyimage.com/400x300/c0392b/fff&text=BYD+Han+DM-i'
    ),
    (
        34,
        13,
        '2024款 荣耀版 EV 715KM 旗舰型',
        2024,
        24.98,
        'https://dummyimage.com/400x300/c0392b/fff&text=BYD+Han+EV'
    ),
    (
        35,
        13,
        '2024款 荣耀版 EV 610KM 四驱智驾',
        2024,
        29.98,
        'https://dummyimage.com/400x300/c0392b/fff&text=BYD+Han+EV+AWD'
    ),
    (
        36,
        14,
        '2024款 荣耀版 DM-i 55KM 领先型',
        2024,
        7.98,
        'https://dummyimage.com/400x300/3498db/fff&text=Qin+PLUS'
    ),
    (
        37,
        14,
        '2024款 荣耀版 DM-i 120KM 超越型',
        2024,
        10.58,
        'https://dummyimage.com/400x300/3498db/fff&text=Qin+PLUS'
    ),
    (
        38,
        14,
        '2024款 荣耀版 EV 420KM 领先型',
        2024,
        10.98,
        'https://dummyimage.com/400x300/3498db/fff&text=Qin+PLUS+EV'
    ),
    (
        39,
        14,
        '2024款 荣耀版 EV 510KM 卓越型',
        2024,
        13.98,
        'https://dummyimage.com/400x300/3498db/fff&text=Qin+PLUS+EV'
    ),
    (
        40,
        15,
        '2023款 焕新版 后轮驱动',
        2023,
        24.59,
        'https://dummyimage.com/400x300/c0392b/fff&text=Model+3'
    ),
    (
        41,
        15,
        '2023款 长续航全轮驱动版',
        2023,
        28.59,
        'https://dummyimage.com/400x300/c0392b/fff&text=Model+3+AWD'
    ),
    (
        42,
        16,
        '2024款 后轮驱动版',
        2024,
        25.89,
        'https://dummyimage.com/400x300/34495e/fff&text=Model+Y'
    ),
    (
        43,
        16,
        '2024款 长续航全轮驱动版',
        2024,
        29.99,
        'https://dummyimage.com/400x300/34495e/fff&text=Model+Y+AWD'
    ),
    (
        44,
        16,
        '2024款 Performance高性能版',
        2024,
        36.39,
        'https://dummyimage.com/400x300/34495e/fff&text=Model+Y+P'
    ),
    (
        45,
        1,
        '2024款 2.0L e:PHEV 旗舰版',
        2024,
        25.88,
        'https://dummyimage.com/400x300/e74c3c/fff&text=Accord+PHEV+Max'
    ),
    (
        46,
        2,
        '2023款 HATCHBACK 极锐版',
        2023,
        17.99,
        'https://dummyimage.com/400x300/c0392b/fff&text=Civic+Hatch'
    ),
    (
        47,
        4,
        '2024款 双擎 2.0HG 旗舰版',
        2024,
        23.98,
        'https://dummyimage.com/400x300/bdc3c7/000&text=Camry+HEV+Max'
    ),
    (
        48,
        7,
        '2024款 330i M运动曜夜套装',
        2024,
        38.19,
        'https://dummyimage.com/400x300/3498db/fff&text=BMW+330i'
    ),
    (
        49,
        13,
        '2024款 战神版 DM-p',
        2024,
        25.98,
        'https://dummyimage.com/400x300/000/fff&text=BYD+Han+Ares'
    ),
    (
        50,
        15,
        '2024款 高性能全轮驱动版',
        2024,
        33.59,
        'https://dummyimage.com/400x300/c0392b/fff&text=Model+3+P'
    );

-- ----------------------------
-- 5. 插入车辆参数 (精简写法，利用存储过程批量模拟 JSON)
-- 为了确保能直接运行，我们为前 10 款和特殊车型详细插入，其余默认生成
-- ----------------------------
INSERT INTO
    `car_specs` (
        `model_id`,
        `engine`,
        `transmission`,
        `dimensions`,
        `base_params`,
        `safety_params`,
        `media_params`
    )
SELECT
    id,
    CASE
        WHEN series_id IN (1, 2, 3, 4, 10) THEN '1.5T/2.0L 燃油'
        WHEN series_id IN (13, 14, 15, 16) THEN '纯电/混动电机'
        ELSE '2.0T 高功率'
    END,
    CASE
        WHEN series_id IN (1, 2, 3, 4, 5) THEN 'CVT无级变速'
        WHEN series_id IN (13, 14, 15, 16) THEN '固定齿比变速箱'
        ELSE '8挡手自一体'
    END,
    '4800x1850x1450',
    '{"最高车速(km/h)": 210, "综合油耗/电耗": "6.5L / 13kWh", "保修政策": "三年或10万公里"}',
    '{"主副驾气囊": "标配", "主动刹车": "支持", "车道偏离预警": "支持"}',
    '{"中控彩色屏幕": "12.3英寸", "手机互联": "支持", "语音识别": "支持"}'
FROM car_models;

-- 覆盖更新几款核心测试车的详细真实参数
UPDATE `car_specs`
SET
    `engine` = '1.5T 192马力 L4',
    `base_params` = '{"最高车速(km/h)": 186, "WLTC综合油耗(L/100km)": 6.6}',
    `media_params` = '{"中控彩色屏幕": "12.3英寸", "扬声器数量": 8, "手机互联": "CarPlay/CarLife"}'
WHERE
    model_id = 2;

UPDATE `car_specs`
SET
    `engine` = '纯电动 264马力',
    `base_params` = '{"官方0-100km/h加速(s)": 6.1, "CLTC纯电续航里程(km)": 606, "电池能量(kWh)": 60}',
    `media_params` = '{"中控屏幕": "15.4英寸", "后排液晶屏幕": "8英寸", "扬声器数量": 9}'
WHERE
    model_id = 40;

-- ----------------------------
-- 6. 插入多媒体库
-- ----------------------------
INSERT INTO
    `car_media` (
        `model_id`,
        `media_type`,
        `position`,
        `url`,
        `sort`
    )
VALUES (
        2,
        1,
        '外观',
        'https://dummyimage.com/800x600/e74c3c/fff&text=Accord+Front',
        1
    ),
    (
        2,
        1,
        '外观',
        'https://dummyimage.com/800x600/e74c3c/fff&text=Accord+Side',
        2
    ),
    (
        2,
        1,
        '内饰',
        'https://dummyimage.com/800x600/bdc3c7/000&text=Accord+Interior',
        3
    ),
    (
        2,
        2,
        '视频',
        'http://vjs.zencdn.net/v/oceans.mp4',
        4
    ),
    (
        40,
        1,
        '外观',
        'https://dummyimage.com/800x600/c0392b/fff&text=Model3+Front',
        1
    ),
    (
        40,
        1,
        '内饰',
        'https://dummyimage.com/800x600/ecf0f1/000&text=Model3+Interior',
        2
    );

-- ----------------------------
-- 7. 插入丰富的用户评论
-- ----------------------------
INSERT INTO
    `reviews` (
        `user_id`,
        `model_id`,
        `score`,
        `content`,
        `likes`,
        `create_time`
    )
VALUES (
        1,
        2,
        4.5,
        '动力输出很平顺，1.5T市区代步足够了，空间依然是同级别天花板。',
        45,
        '2024-01-15 10:00:00'
    ),
    (
        2,
        2,
        3.5,
        '胎噪和风噪还是稍微有点大，车机系统比上一代好一点，但还是不够智能化。',
        12,
        '2024-01-20 14:30:00'
    ),
    (
        3,
        2,
        5.0,
        '底盘质感提升非常明显！这代雅阁越来越好开了。',
        88,
        '2024-02-05 09:15:00'
    ),
    (
        2,
        40,
        4.8,
        '焕新版改掉了老款的很多痛点，悬挂终于不那么颠了，屏幕换挡需要适应一下。',
        120,
        '2024-02-10 16:45:00'
    ),
    (
        1,
        40,
        4.0,
        '去掉了转向灯拨杆有点反人类，但是续航很扎实，电耗控制得一如既往的好。',
        56,
        '2024-02-12 11:20:00'
    ),
    (
        3,
        18,
        4.5,
        '人生绕不开的一台3系！哪怕现在的3系越来越向舒适妥协，但依然好开。',
        210,
        '2024-02-18 20:00:00'
    );

SET FOREIGN_KEY_CHECKS = 1;