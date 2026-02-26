SET NAMES utf8mb4;

SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- 1. 清理旧数据 (严格保留 users 表)
-- ----------------------------
TRUNCATE TABLE `car_brands`;

TRUNCATE TABLE `car_series`;

TRUNCATE TABLE `car_models`;

TRUNCATE TABLE `car_specs`;

TRUNCATE TABLE `car_media`;

TRUNCATE TABLE `reviews`;

TRUNCATE TABLE `favorites`;

-- ----------------------------
-- 2. 插入丰富品牌库 (13个主流/新势力品牌)
-- ----------------------------
INSERT INTO
    `car_brands` (
        `id`,
        `name`,
        `logo`,
        `initial`,
        `sort`
    )
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
        '奔驰',
        'https://dummyimage.com/100/2c3e50/fff&text=Benz',
        'B',
        5
    ),
    (
        6,
        '大众',
        'https://dummyimage.com/100/34495e/fff&text=VW',
        'D',
        6
    ),
    (
        7,
        '保时捷',
        'https://dummyimage.com/100/f39c12/fff&text=Porsche',
        'B',
        7
    ),
    (
        8,
        '比亚迪',
        'https://dummyimage.com/100/d35400/fff&text=BYD',
        'B',
        8
    ),
    (
        9,
        '特斯拉',
        'https://dummyimage.com/100/c0392b/fff&text=Tesla',
        'T',
        9
    ),
    (
        10,
        '理想',
        'https://dummyimage.com/100/16a085/fff&text=LiAuto',
        'L',
        10
    ),
    (
        11,
        '蔚来',
        'https://dummyimage.com/100/27ae60/fff&text=NIO',
        'W',
        11
    ),
    (
        12,
        '小鹏',
        'https://dummyimage.com/100/8e44ad/fff&text=Xpeng',
        'X',
        12
    ),
    (
        13,
        '小米',
        'https://dummyimage.com/100/2980b9/fff&text=Xiaomi',
        'X',
        13
    );

-- ----------------------------
-- 3. 插入47个核心热门车系
-- ----------------------------
INSERT INTO
    `car_series` (`id`, `brand_id`, `name`)
VALUES
    -- 本田
    (1, 1, '雅阁'),
    (2, 1, '思域'),
    (3, 1, 'CR-V'),
    (4, 1, '型格'),
    -- 丰田
    (5, 2, '凯美瑞'),
    (6, 2, '卡罗拉'),
    (7, 2, '汉兰达'),
    (8, 2, '赛那'),
    -- 宝马
    (9, 3, '3系'),
    (10, 3, '5系'),
    (11, 3, 'X3'),
    (12, 3, 'X5'),
    -- 奥迪
    (13, 4, 'A4L'),
    (14, 4, 'A6L'),
    (15, 4, 'Q5L'),
    (16, 4, 'A7L'),
    -- 奔驰
    (17, 5, 'C级'),
    (18, 5, 'E级'),
    (19, 5, 'S级'),
    (20, 5, 'GLC'),
    -- 大众
    (21, 6, '迈腾'),
    (22, 6, '帕萨特'),
    (23, 6, '朗逸'),
    (24, 6, '途观L'),
    -- 保时捷
    (25, 7, 'Macan'),
    (26, 7, 'Cayenne'),
    (27, 7, 'Panamera'),
    (28, 7, 'Taycan'),
    -- 比亚迪
    (29, 8, '汉'),
    (30, 8, '秦PLUS'),
    (31, 8, '唐'),
    (32, 8, '宋PLUS'),
    (33, 8, '海鸥'),
    (34, 8, '仰望U8'),
    -- 特斯拉
    (35, 9, 'Model 3'),
    (36, 9, 'Model Y'),
    (37, 9, 'Model S'),
    -- 理想
    (38, 10, 'L7'),
    (39, 10, 'L8'),
    (40, 10, 'L9'),
    (41, 10, 'MEGA'),
    -- 蔚来
    (42, 11, 'ET5'),
    (43, 11, 'ES6'),
    (44, 11, 'ET7'),
    -- 小鹏
    (45, 12, 'G6'),
    (46, 12, 'P7i'),
    -- 小米
    (47, 13, 'SU7');

-- ----------------------------
-- 4. 插入近100款具体车型配置 (价格涵盖几万到上百万)
-- ----------------------------
INSERT INTO
    `car_models` (
        `id`,
        `series_id`,
        `name`,
        `year`,
        `price`,
        `cover_img`,
        `status`
    )
VALUES
    -- 本田雅阁/思域/CRV
    (
        1,
        1,
        '2024款 260TURBO 舒适版',
        2024,
        17.98,
        'https://dummyimage.com/400x300/e74c3c/fff&text=Accord',
        1
    ),
    (
        2,
        1,
        '2024款 2.0L e:PHEV 旗舰版',
        2024,
        25.88,
        'https://dummyimage.com/400x300/e74c3c/fff&text=Accord+PHEV',
        1
    ),
    (
        3,
        2,
        '2023款 240TURBO 劲动版',
        2023,
        14.29,
        'https://dummyimage.com/400x300/c0392b/fff&text=Civic',
        1
    ),
    (
        4,
        3,
        '2023款 240TURBO 四驱尊耀版',
        2023,
        24.99,
        'https://dummyimage.com/400x300/95a5a6/fff&text=CR-V',
        1
    ),
    -- 丰田凯美瑞/汉兰达/赛那
    (
        5,
        5,
        '2024款 2.0G 豪华版',
        2024,
        19.98,
        'https://dummyimage.com/400x300/bdc3c7/000&text=Camry',
        1
    ),
    (
        6,
        5,
        '2024款 双擎 2.0HG 尊贵版',
        2024,
        20.98,
        'https://dummyimage.com/400x300/bdc3c7/000&text=Camry+HEV',
        1
    ),
    (
        7,
        7,
        '2024款 双擎 2.5L 四驱尊贵版',
        2024,
        32.58,
        'https://dummyimage.com/400x300/7f8c8d/fff&text=Highlander',
        1
    ),
    (
        8,
        8,
        '2024款 2.5L 混动 尊贵版',
        2024,
        35.28,
        'https://dummyimage.com/400x300/7f8c8d/fff&text=Sienna',
        1
    ),
    -- 宝马3系/5系/X3/X5
    (
        9,
        9,
        '2024款 325Li M运动曜夜套装',
        2024,
        36.99,
        'https://dummyimage.com/400x300/3498db/fff&text=BMW+325Li',
        1
    ),
    (
        10,
        10,
        '2024款 530Li 尊享型 豪华套装',
        2024,
        52.59,
        'https://dummyimage.com/400x300/2980b9/fff&text=BMW+530Li',
        1
    ),
    (
        11,
        11,
        '2023款 xDrive30i 领先型',
        2023,
        44.39,
        'https://dummyimage.com/400x300/1abc9c/fff&text=BMW+X3',
        1
    ),
    (
        12,
        12,
        '2023款 xDrive40Li 尊享型',
        2023,
        72.90,
        'https://dummyimage.com/400x300/1abc9c/fff&text=BMW+X5',
        1
    ),
    -- 奥迪A4L/A6L/Q5L/A7L
    (
        13,
        13,
        '2024款 40 TFSI 豪华动感型',
        2024,
        34.38,
        'https://dummyimage.com/400x300/95a5a6/fff&text=Audi+A4L',
        1
    ),
    (
        14,
        14,
        '2024款 45 TFSI quattro 尊享致雅',
        2024,
        49.98,
        'https://dummyimage.com/400x300/34495e/fff&text=Audi+A6L',
        1
    ),
    (
        15,
        15,
        '2024款 45 TFSI 臻选动感型',
        2024,
        48.88,
        'https://dummyimage.com/400x300/7f8c8d/fff&text=Audi+Q5L',
        1
    ),
    (
        16,
        16,
        '2024款 45 TFSI 奢享型',
        2024,
        58.67,
        'https://dummyimage.com/400x300/34495e/fff&text=Audi+A7L',
        1
    ),
    -- 奔驰C/E/S/GLC
    (
        17,
        17,
        '2024款 C 260 L 运动版',
        2024,
        35.68,
        'https://dummyimage.com/400x300/2c3e50/fff&text=Benz+C260L',
        1
    ),
    (
        18,
        18,
        '2024款 E 300 L 尊贵型',
        2024,
        59.98,
        'https://dummyimage.com/400x300/2c3e50/fff&text=Benz+E300L',
        1
    ),
    (
        19,
        19,
        '2024款 S 400 L 豪华型',
        2024,
        107.28,
        'https://dummyimage.com/400x300/000000/fff&text=Benz+S400L',
        1
    ),
    (
        20,
        20,
        '2024款 GLC 300 L 4MATIC 动感型',
        2024,
        47.93,
        'https://dummyimage.com/400x300/2c3e50/fff&text=Benz+GLC',
        1
    ),
    -- 大众迈腾/帕萨特/朗逸
    (
        21,
        21,
        '2024款 380TSI 尊贵型',
        2024,
        25.39,
        'https://dummyimage.com/400x300/34495e/fff&text=Magotan',
        1
    ),
    (
        22,
        22,
        '2024款 380TSI 星空尊享版',
        2024,
        23.39,
        'https://dummyimage.com/400x300/34495e/fff&text=Passat',
        1
    ),
    (
        23,
        23,
        '2024款 1.5T 满件星尊版',
        2024,
        13.89,
        'https://dummyimage.com/400x300/bdc3c7/000&text=Lavida',
        1
    ),
    -- 保时捷
    (
        24,
        25,
        '2024款 Macan 2.0T',
        2024,
        57.80,
        'https://dummyimage.com/400x300/f39c12/fff&text=Porsche+Macan',
        1
    ),
    (
        25,
        26,
        '2024款 Cayenne 3.0T',
        2024,
        94.80,
        'https://dummyimage.com/400x300/f39c12/fff&text=Porsche+Cayenne',
        1
    ),
    (
        26,
        27,
        '2024款 Panamera 2.9T',
        2024,
        103.80,
        'https://dummyimage.com/400x300/f39c12/fff&text=Panamera',
        1
    ),
    -- 比亚迪 (海量新能源车)
    (
        27,
        29,
        '2024款 荣耀版 DM-i 121KM 尊贵型',
        2024,
        16.98,
        'https://dummyimage.com/400x300/c0392b/fff&text=BYD+Han+DM-i',
        1
    ),
    (
        28,
        29,
        '2024款 荣耀版 EV 610KM 四驱智驾',
        2024,
        29.98,
        'https://dummyimage.com/400x300/c0392b/fff&text=BYD+Han+EV',
        1
    ),
    (
        29,
        30,
        '2024款 荣耀版 DM-i 55KM 领先型',
        2024,
        7.98,
        'https://dummyimage.com/400x300/3498db/fff&text=Qin+PLUS',
        1
    ),
    (
        30,
        31,
        '2024款 荣耀版 DM-p 战神版',
        2024,
        26.98,
        'https://dummyimage.com/400x300/000000/fff&text=BYD+Tang',
        1
    ),
    (
        31,
        32,
        '2024款 荣耀版 DM-i 110KM 旗舰PLUS',
        2024,
        14.98,
        'https://dummyimage.com/400x300/3498db/fff&text=Song+PLUS',
        1
    ),
    (
        32,
        33,
        '2024款 荣耀版 405km 飞翔版',
        2024,
        8.58,
        'https://dummyimage.com/400x300/f1c40f/000&text=Seagull',
        1
    ),
    (
        33,
        34,
        '2024款 仰望U8 豪华版',
        2024,
        109.80,
        'https://dummyimage.com/400x300/2c3e50/fff&text=Yangwang+U8',
        1
    ),
    -- 特斯拉
    (
        34,
        35,
        '2023款 焕新版 后轮驱动',
        2023,
        24.59,
        'https://dummyimage.com/400x300/c0392b/fff&text=Model+3',
        1
    ),
    (
        35,
        35,
        '2024款 高性能全轮驱动版',
        2024,
        33.59,
        'https://dummyimage.com/400x300/c0392b/fff&text=Model+3+P',
        1
    ),
    (
        36,
        36,
        '2024款 后轮驱动版',
        2024,
        25.89,
        'https://dummyimage.com/400x300/34495e/fff&text=Model+Y',
        1
    ),
    (
        37,
        36,
        '2024款 长续航全轮驱动版',
        2024,
        29.99,
        'https://dummyimage.com/400x300/34495e/fff&text=Model+Y+AWD',
        1
    ),
    -- 理想
    (
        38,
        38,
        '2024款 理想L7 Ultra',
        2024,
        37.98,
        'https://dummyimage.com/400x300/16a085/fff&text=LiAuto+L7',
        1
    ),
    (
        39,
        39,
        '2024款 理想L8 Max',
        2024,
        39.98,
        'https://dummyimage.com/400x300/16a085/fff&text=LiAuto+L8',
        1
    ),
    (
        40,
        40,
        '2024款 理想L9 Ultra',
        2024,
        45.98,
        'https://dummyimage.com/400x300/16a085/fff&text=LiAuto+L9',
        1
    ),
    (
        41,
        41,
        '2024款 理想MEGA Max',
        2024,
        55.98,
        'https://dummyimage.com/400x300/bdc3c7/000&text=LiAuto+MEGA',
        1
    ),
    -- 蔚来
    (
        42,
        42,
        '2024款 蔚来ET5 75kWh',
        2024,
        29.80,
        'https://dummyimage.com/400x300/27ae60/fff&text=NIO+ET5',
        1
    ),
    (
        43,
        43,
        '2024款 蔚来ES6 100kWh',
        2024,
        39.60,
        'https://dummyimage.com/400x300/27ae60/fff&text=NIO+ES6',
        1
    ),
    -- 小鹏
    (
        44,
        45,
        '2023款 小鹏G6 755 超长续航 Max',
        2023,
        25.49,
        'https://dummyimage.com/400x300/8e44ad/fff&text=Xpeng+G6',
        1
    ),
    (
        45,
        46,
        '2023款 小鹏P7i 610 Max 性能版',
        2023,
        28.99,
        'https://dummyimage.com/400x300/8e44ad/fff&text=Xpeng+P7i',
        1
    ),
    -- 小米
    (
        46,
        47,
        '2024款 小米SU7 后驱长续航智驾版',
        2024,
        21.59,
        'https://dummyimage.com/400x300/3498db/fff&text=Xiaomi+SU7',
        1
    ),
    (
        47,
        47,
        '2024款 小米SU7 Max 四驱超长续航高阶智驾版',
        2024,
        29.99,
        'https://dummyimage.com/400x300/2980b9/fff&text=Xiaomi+SU7+Max',
        1
    );

SET NAMES utf8mb4;

SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- 5. 插入车辆详细参数配置 (car_specs)
-- 先给重磅热门车型（小米、仰望、特斯拉、理想等）插入逼真的硬核数据
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
VALUES (
        46,
        '后置单电机 299马力',
        '固定齿比变速箱',
        '4997x1963x1455',
        '{"官方0-100km/h加速(s)": 5.28, "CLTC纯电续航(km)": 700, "电池类型": "磷酸铁锂电池"}',
        '{"自动驾驶芯片": "NVIDIA DRIVE Orin", "车道保持": "标配", "自动泊车": "标配"}',
        '{"中控屏幕": "16.1英寸 3K", "车机芯片": "骁龙8295", "扬声器数量": 15}'
    ),
    (
        47,
        '双电机四驱 673马力',
        '固定齿比变速箱',
        '4997x1963x1440',
        '{"官方0-100km/h加速(s)": 2.78, "CLTC纯电续航(km)": 800, "电池类型": "三元锂电池(宁德时代)"}',
        '{"自动驾驶芯片": "双 NVIDIA DRIVE Orin", "激光雷达": "1个", "空气悬架": "标配"}',
        '{"中控屏幕": "16.1英寸 3K", "HUD抬头显示": "56英寸 AR-HUD", "扬声器数量": 25}'
    ),
    (
        33,
        '易四方 四电机 1197马力',
        '固定齿比变速箱',
        '5319x2050x1930',
        '{"官方0-100km/h加速(s)": 3.6, "CLTC纯电续航(km)": 180, "综合续航(km)": 1000}',
        '{"原地掉头": "支持", "应急浮水": "支持", "红外夜视": "标配"}',
        '{"中控屏幕": "12.8英寸曲面屏", "副驾娱乐屏": "23.6英寸", "扬声器数量": 22}'
    ),
    (
        40,
        '1.5T 增程式 449马力',
        '固定齿比变速箱',
        '5218x1998x1800',
        '{"官方0-100km/h加速(s)": 5.3, "WLTC综合油耗(L/100km)": 0.86, "纯电续航(km)": 215}',
        '{"激光雷达": "1个", "全景影像": "360度+透明底盘", "安全气囊": "全车9气囊"}',
        '{"中控+副驾双联屏": "15.7英寸 OLED", "后排娱乐屏": "15.7英寸 OLED", "车载冰箱": "标配"}'
    ),
    (
        34,
        '后置单电机 264马力',
        '固定齿比变速箱',
        '4720x1848x1442',
        '{"官方0-100km/h加速(s)": 6.1, "CLTC纯电续航(km)": 606, "电池能量(kWh)": 60}',
        '{"自动驾驶辅助": "Autopilot", "主动刹车": "标配"}',
        '{"中控屏幕": "15.4英寸", "后排液晶屏幕": "8英寸", "扬声器数量": 9}'
    ),
    (
        1,
        '1.5T 192马力 L4',
        'CVT无级变速',
        '4980x1862x1449',
        '{"最高车速(km/h)": 186, "WLTC综合油耗(L/100km)": 6.6}',
        '{"主动安全系统": "Honda SENSING", "被动行人保护": "标配"}',
        '{"中控屏幕": "12.3英寸", "手机互联": "CarPlay/CarLife"}'
    );

-- 为剩下的 41 款车型批量生成兜底的通用配置数据 (利用 INSERT INTO ... SELECT)
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
        WHEN series_id IN (
            13,
            14,
            15,
            16,
            29,
            30,
            31,
            32,
            35,
            36,
            38,
            39,
            42,
            43,
            45
        ) THEN '前置/后置驱动电机'
        ELSE '2.0T 254马力 L4'
    END,
    CASE
        WHEN series_id IN (
            13,
            14,
            15,
            16,
            29,
            30,
            31,
            32,
            35,
            36,
            38,
            39,
            42,
            43,
            45
        ) THEN '固定齿比变速箱'
        ELSE '8挡手自一体'
    END,
    '4850x1900x1500',
    '{"最高车速(km/h)": 210, "综合油耗/电耗": "同级中等水平", "保修政策": "三年或10万公里"}',
    '{"主副驾气囊": "标配", "主动刹车": "支持", "车道偏离预警": "支持"}',
    '{"中控彩色屏幕": "12.3英寸", "手机互联": "支持", "OTA升级": "支持"}'
FROM car_models
WHERE
    id NOT IN(46, 47, 33, 40, 34, 1);

-- ----------------------------
-- 6. 插入多媒体轮播图库 (car_media)
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
        47,
        1,
        '外观',
        'https://dummyimage.com/800x600/3498db/fff&text=Xiaomi+SU7+Front',
        1
    ),
    (
        47,
        1,
        '内饰',
        'https://dummyimage.com/800x600/ecf0f1/000&text=Xiaomi+SU7+Interior',
        2
    ),
    (
        47,
        1,
        '中控',
        'https://dummyimage.com/800x600/34495e/fff&text=Xiaomi+SU7+Screen',
        3
    ),
    (
        47,
        2,
        '视频',
        'http://vjs.zencdn.net/v/oceans.mp4',
        4
    ),
    (
        33,
        1,
        '外观',
        'https://dummyimage.com/800x600/2c3e50/fff&text=Yangwang+U8+Front',
        1
    ),
    (
        33,
        1,
        '越野',
        'https://dummyimage.com/800x600/8e44ad/fff&text=Yangwang+U8+Offroad',
        2
    ),
    (
        40,
        1,
        '外观',
        'https://dummyimage.com/800x600/16a085/fff&text=LiAuto+L9+Front',
        1
    ),
    (
        40,
        1,
        '内饰',
        'https://dummyimage.com/800x600/bdc3c7/000&text=LiAuto+L9+Sofa',
        2
    );

-- ----------------------------
-- 7. 插入真实的车友神评 (reviews)
-- 这里的数据与你系统里现有的 3 个预设用户 (id: 1, 2, 3) 进行绑定
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
        47,
        5.0,
        '雷总造车确实牛！SU7 Max这加速推背感简直让人窒息，车机极其流畅，人车家全生态体验无敌。',
        888,
        '2024-03-30 10:00:00'
    ),
    (
        2,
        47,
        4.5,
        '外观没得说，回头率200%。就是后排空间对于高个子来说稍微有点局促，不过开起来质感很像保时捷。',
        452,
        '2024-04-02 14:30:00'
    ),
    (
        3,
        46,
        4.0,
        '选了后驱标准版，日常代步足够了，续航也很扎实。音响效果很棒。',
        128,
        '2024-04-05 09:15:00'
    ),
    (
        1,
        40,
        5.0,
        '完美的奶爸神车！冰箱彩电大沙发齐了，周末带全家人出去露营，二排屏幕给孩子放动画片，简直不要太爽。',
        666,
        '2024-01-20 16:45:00'
    ),
    (
        2,
        40,
        4.5,
        '车有点太大，市区停车不是很方便，不过悬挂很舒服，长途一点都不累。',
        234,
        '2024-02-12 11:20:00'
    ),
    (
        3,
        33,
        5.0,
        '仰望U8原地掉头太有排面了！试了一下应急浮水，虽然平时用不到，但技术震撼力拉满，国产骄傲！',
        1024,
        '2024-03-18 20:00:00'
    ),
    (
        1,
        34,
        4.5,
        '焕新版的Model 3隔音比老款好太多了，避震也没那么硬。屏幕换挡习惯了其实还挺顺手的。',
        356,
        '2024-02-15 10:30:00'
    ),
    (
        2,
        1,
        4.0,
        '11代雅阁外观见仁见智吧，但是底盘确实比10代高级，空间依然是B级车的天花板，省心耐造。',
        89,
        '2024-01-10 08:45:00'
    ),
    (
        3,
        10,
        5.0,
        '新5系外观非常犀利，内饰大连屏科技感很足。操控一如既往的宝马，变速箱丝滑。',
        412,
        '2024-02-28 15:20:00'
    );

SET FOREIGN_KEY_CHECKS = 1;