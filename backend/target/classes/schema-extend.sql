-- =====================================================
-- aierp 系统扩展 - 商品高级功能
-- 功能：多规格、多单位、批次管理、保质期、序列号、条码、客户价格本
-- =====================================================

USE aierp;

-- =====================================================
-- 一、商品表扩展（添加启用字段）
-- =====================================================

-- 添加商品启用功能字段
ALTER TABLE bas_product ADD COLUMN enable_multi_spec INT DEFAULT 0 COMMENT '启用多规格: 0否 1是' AFTER remark;
ALTER TABLE bas_product ADD COLUMN enable_multi_unit INT DEFAULT 0 COMMENT '启用多单位: 0否 1是' AFTER enable_multi_spec;
ALTER TABLE bas_product ADD COLUMN enable_batch INT DEFAULT 0 COMMENT '启用批次管理: 0否 1是' AFTER enable_multi_unit;
ALTER TABLE bas_product ADD COLUMN enable_expiry INT DEFAULT 0 COMMENT '启用保质期管理: 0否 1是' AFTER enable_batch;
ALTER TABLE bas_product ADD COLUMN enable_serial INT DEFAULT 0 COMMENT '启用序列号管理: 0否 1是' AFTER enable_expiry;
ALTER TABLE bas_product ADD COLUMN shelf_life_days INT COMMENT '保质期天数（天数）' AFTER enable_serial;
ALTER TABLE bas_product ADD COLUMN expiry_warn_days INT DEFAULT 30 COMMENT '过期预警天数' AFTER shelf_life_days;

-- =====================================================
-- 二、多单位管理（单位组+单位换算）
-- =====================================================

-- 单位组表
CREATE TABLE IF NOT EXISTS bas_unit_group (
    id BIGINT PRIMARY KEY,
    tenant_id BIGINT NOT NULL COMMENT '租户ID',
    company_id BIGINT NOT NULL COMMENT '公司ID',
    product_id BIGINT NOT NULL COMMENT '商品ID',
    group_name VARCHAR(50) COMMENT '单位组名称',
    base_unit VARCHAR(20) NOT NULL COMMENT '基本单位',
    status INT DEFAULT 1,
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted INT DEFAULT 0,
    INDEX idx_product (product_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='单位组表';

-- 单位换算表
CREATE TABLE IF NOT EXISTS bas_unit_conversion (
    id BIGINT PRIMARY KEY,
    tenant_id BIGINT NOT NULL,
    company_id BIGINT NOT NULL,
    group_id BIGINT NOT NULL COMMENT '单位组ID',
    unit_name VARCHAR(20) NOT NULL COMMENT '单位名称',
    unit_code VARCHAR(20) COMMENT '单位编码',
    ratio DECIMAL(12,4) NOT NULL COMMENT '换算比率（相对于基本单位）',
    is_base INT DEFAULT 0 COMMENT '是否基本单位',
    purchase_price DECIMAL(12,2) COMMENT '进货价（此单位）',
    sale_price DECIMAL(12,2) COMMENT '销售价（此单位）',
    min_price DECIMAL(12,2) COMMENT '最低售价（此单位）',
    status INT DEFAULT 1,
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted INT DEFAULT 0,
    INDEX idx_group (group_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='单位换算表';

-- =====================================================
-- 三、批次管理+保质期管理
-- =====================================================

-- 批次表
CREATE TABLE IF NOT EXISTS biz_batch (
    id BIGINT PRIMARY KEY,
    tenant_id BIGINT NOT NULL COMMENT '租户ID',
    company_id BIGINT NOT NULL COMMENT '公司ID',
    batch_no VARCHAR(50) NOT NULL COMMENT '批次号',
    product_id BIGINT NOT NULL COMMENT '商品ID',
    sku_id BIGINT COMMENT 'SKU ID',
    warehouse_id BIGINT NOT NULL COMMENT '仓库ID',
    
    -- 批次基本信息
    production_date DATE COMMENT '生产日期',
    expiry_date DATE COMMENT '过期日期',
    shelf_life_days INT COMMENT '保质期天数',
    
    -- 成本信息
    cost_price DECIMAL(12,2) COMMENT '成本价',
    
    -- 库存信息
    quantity DECIMAL(12,2) DEFAULT 0 COMMENT '批次库存数量',
    frozen_quantity DECIMAL(12,2) DEFAULT 0 COMMENT '冻结数量',
    
    -- 来源信息
    source_order_id BIGINT COMMENT '来源单据ID',
    source_order_no VARCHAR(50) COMMENT '来源单号',
    source_type VARCHAR(20) COMMENT '来源类型: PURCHASE/PRODUCTION/TRANSFER',
    
    -- 状态
    status VARCHAR(20) DEFAULT 'NORMAL' COMMENT '状态: NORMAL/WARN/EXPIRED',
    
    remark VARCHAR(200) COMMENT '备注',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted INT DEFAULT 0,
    
    UNIQUE KEY uk_tenant_batch (tenant_id, batch_no),
    INDEX idx_product_warehouse (product_id, warehouse_id),
    INDEX idx_expiry (expiry_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='批次表';

-- 批次流水表
CREATE TABLE IF NOT EXISTS biz_batch_log (
    id BIGINT PRIMARY KEY,
    tenant_id BIGINT NOT NULL,
    batch_id BIGINT NOT NULL COMMENT '批次ID',
    change_type VARCHAR(20) NOT NULL COMMENT '变动类型',
    change_quantity DECIMAL(12,2) NOT NULL COMMENT '变动数量',
    before_quantity DECIMAL(12,2) COMMENT '变动前数量',
    after_quantity DECIMAL(12,2) COMMENT '变动后数量',
    order_id BIGINT COMMENT '关联单据ID',
    order_no VARCHAR(50) COMMENT '关联单号',
    operator_id BIGINT COMMENT '操作人ID',
    operator_name VARCHAR(50) COMMENT '操作人',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='批次流水表';

-- =====================================================
-- 四、序列号管理
-- =====================================================

-- 序列号表
CREATE TABLE IF NOT EXISTS biz_serial_number (
    id BIGINT PRIMARY KEY,
    tenant_id BIGINT NOT NULL COMMENT '租户ID',
    company_id BIGINT NOT NULL COMMENT '公司ID',
    serial_no VARCHAR(100) NOT NULL COMMENT '序列号',
    product_id BIGINT NOT NULL COMMENT '商品ID',
    sku_id BIGINT COMMENT 'SKU ID',
    warehouse_id BIGINT NOT NULL COMMENT '仓库ID',
    batch_id BIGINT COMMENT '批次ID（可选）',
    
    -- 序列号状态
    status VARCHAR(20) DEFAULT 'IN_STOCK' COMMENT '状态: IN_STOCK/SOLD/RETURNED/SCRAPPED',
    
    -- 来源信息
    source_order_id BIGINT COMMENT '入库单据ID',
    source_order_no VARCHAR(50) COMMENT '入库单号',
    
    -- 销售信息
    sold_order_id BIGINT COMMENT '销售单据ID',
    sold_order_no VARCHAR(50) COMMENT '销售单号',
    sold_date DATE COMMENT '销售日期',
    sold_customer_id BIGINT COMMENT '销售客户ID',
    
    -- 备注
    remark VARCHAR(200) COMMENT '备注',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted INT DEFAULT 0,
    
    UNIQUE KEY uk_tenant_serial (tenant_id, serial_no),
    INDEX idx_product_warehouse (product_id, warehouse_id),
    INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='序列号表';

-- =====================================================
-- 五、商品条码管理（完善）
-- =====================================================

-- 商品条码表（支持多条码）
CREATE TABLE IF NOT EXISTS bas_product_barcode (
    id BIGINT PRIMARY KEY,
    tenant_id BIGINT NOT NULL COMMENT '租户ID',
    company_id BIGINT NOT NULL COMMENT '公司ID',
    barcode VARCHAR(50) NOT NULL COMMENT '条码',
    product_id BIGINT NOT NULL COMMENT '商品ID',
    sku_id BIGINT COMMENT 'SKU ID',
    
    -- 条码信息
    barcode_type VARCHAR(20) DEFAULT 'STANDARD' COMMENT '类型: STANDARD/INTERNAL/CUSTOM',
    is_main INT DEFAULT 0 COMMENT '是否主条码',
    
    -- 单位价格信息（条码可关联特定单位）
    unit_name VARCHAR(20) COMMENT '关联单位',
    unit_ratio DECIMAL(12,4) COMMENT '单位换算比率',
    purchase_price DECIMAL(12,2) COMMENT '进货价',
    sale_price DECIMAL(12,2) COMMENT '销售价',
    
    -- 包装信息
    package_spec VARCHAR(50) COMMENT '包装规格',
    package_quantity DECIMAL(12,2) COMMENT '包装数量',
    
    status INT DEFAULT 1,
    remark VARCHAR(200) COMMENT '备注',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted INT DEFAULT 0,
    
    UNIQUE KEY uk_tenant_barcode (tenant_id, barcode),
    INDEX idx_product (product_id),
    INDEX idx_sku (sku_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='商品条码表';

-- =====================================================
-- 六、客户价格本（价格跟踪记忆）
-- =====================================================

-- 客户商品价格表（客户价格本）
CREATE TABLE IF NOT EXISTS bas_customer_price (
    id BIGINT PRIMARY KEY,
    tenant_id BIGINT NOT NULL COMMENT '租户ID',
    company_id BIGINT NOT NULL COMMENT '公司ID',
    customer_id BIGINT NOT NULL COMMENT '客户ID',
    product_id BIGINT NOT NULL COMMENT '商品ID',
    sku_id BIGINT COMMENT 'SKU ID',
    
    -- 价格信息
    unit_name VARCHAR(20) COMMENT '单位',
    price DECIMAL(12,2) COMMENT '最近成交价',
    discount DECIMAL(5,2) COMMENT '最近折扣百分比',
    actual_price DECIMAL(12,2) COMMENT '实际单价（价格×折扣）',
    
    -- 价格来源
    last_order_id BIGINT COMMENT '最近成交订单ID',
    last_order_no VARCHAR(50) COMMENT '最近成交单号',
    last_order_date DATE COMMENT '最近成交日期',
    
    -- 价格统计
    avg_price DECIMAL(12,2) COMMENT '平均成交价',
    min_price DECIMAL(12,2) COMMENT '最低成交价',
    max_price DECIMAL(12,2) COMMENT '最高成交价',
    order_count INT DEFAULT 0 COMMENT '成交次数',
    
    -- 备注
    remark VARCHAR(200) COMMENT '备注',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted INT DEFAULT 0,
    
    UNIQUE KEY uk_customer_product (tenant_id, customer_id, product_id, sku_id),
    INDEX idx_customer (customer_id),
    INDEX idx_product (product_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='客户商品价格表';

-- 价格跟踪记录表（每次价格变化记录）
CREATE TABLE IF NOT EXISTS biz_price_history (
    id BIGINT PRIMARY KEY,
    tenant_id BIGINT NOT NULL COMMENT '租户ID',
    company_id BIGINT NOT NULL COMMENT '公司ID',
    customer_id BIGINT NOT NULL COMMENT '客户ID',
    product_id BIGINT NOT NULL COMMENT '商品ID',
    sku_id BIGINT COMMENT 'SKU ID',
    
    -- 本次价格
    unit_name VARCHAR(20) COMMENT '单位',
    original_price DECIMAL(12,2) COMMENT '原始价格',
    discount DECIMAL(5,2) COMMENT '折扣百分比',
    actual_price DECIMAL(12,2) COMMENT '实际单价',
    
    -- 订单信息
    order_id BIGINT COMMENT '订单ID',
    order_no VARCHAR(50) COMMENT '订单号',
    order_type VARCHAR(20) COMMENT '订单类型: SALES/PURCHASE',
    order_date DATE COMMENT '订单日期',
    
    -- 变化分析
    price_change DECIMAL(12,2) COMMENT '与上次价格差异',
    discount_change DECIMAL(5,2) COMMENT '与上次折扣差异',
    
    -- 操作人
    operator_id BIGINT COMMENT '操作人ID',
    operator_name VARCHAR(50) COMMENT '操作人',
    
    remark VARCHAR(200) COMMENT '备注',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='价格跟踪记录表';

-- =====================================================
-- 七、订单明细扩展（批次、序列号支持）
-- =====================================================

-- 销售单明细扩展
ALTER TABLE biz_sales_order_detail ADD COLUMN batch_id BIGINT COMMENT '批次ID' AFTER sku_id;
ALTER TABLE biz_sales_order_detail ADD COLUMN batch_no VARCHAR(50) COMMENT '批次号' AFTER batch_id;
ALTER TABLE biz_sales_order_detail ADD COLUMN serial_no VARCHAR(100) COMMENT '序列号' AFTER batch_no;
ALTER TABLE biz_sales_order_detail ADD COLUMN original_price DECIMAL(12,2) COMMENT '原始价格' AFTER amount;
ALTER TABLE biz_sales_order_detail ADD COLUMN discount DECIMAL(5,2) COMMENT '折扣百分比' AFTER original_price;
ALTER TABLE biz_sales_order_detail ADD COLUMN unit_ratio DECIMAL(12,4) COMMENT '单位换算比率' AFTER unit;

-- 采购单明细扩展
ALTER TABLE biz_purchase_order_detail ADD COLUMN batch_id BIGINT COMMENT '批次ID' AFTER sku_id;
ALTER TABLE biz_purchase_order_detail ADD COLUMN batch_no VARCHAR(50) COMMENT '批次号' AFTER batch_id;
ALTER TABLE biz_purchase_order_detail ADD COLUMN serial_no VARCHAR(100) COMMENT '序列号' AFTER batch_no;
ALTER TABLE biz_purchase_order_detail ADD COLUMN production_date DATE COMMENT '生产日期' AFTER batch_no;
ALTER TABLE biz_purchase_order_detail ADD COLUMN expiry_date DATE COMMENT '过期日期' AFTER production_date;
ALTER TABLE biz_purchase_order_detail ADD COLUMN unit_ratio DECIMAL(12,4) COMMENT '单位换算比率' AFTER unit;

-- =====================================================
-- 八、库存表扩展（批次支持）
-- =====================================================

ALTER TABLE biz_inventory ADD COLUMN batch_id BIGINT COMMENT '批次ID' AFTER sku_id;

-- =====================================================
-- 九、过期预警视图
-- =====================================================

CREATE OR REPLACE VIEW v_expiry_warning AS
SELECT 
    b.id AS batch_id,
    b.batch_no,
    b.product_id,
    p.name AS product_name,
    p.code AS product_code,
    b.warehouse_id,
    w.name AS warehouse_name,
    b.expiry_date,
    b.quantity,
    DATEDIFF(b.expiry_date, CURDATE()) AS days_to_expire,
    CASE 
        WHEN b.expiry_date < CURDATE() THEN '已过期'
        WHEN DATEDIFF(b.expiry_date, CURDATE()) <= p.expiry_warn_days THEN '即将过期'
        ELSE '正常'
    END AS expiry_status
FROM biz_batch b
LEFT JOIN bas_product p ON b.product_id = p.id
LEFT JOIN bas_warehouse w ON b.warehouse_id = w.id
WHERE b.deleted = 0 AND b.quantity > 0
ORDER BY b.expiry_date ASC;

-- =====================================================
-- 十、示例数据（测试）
-- =====================================================

-- 示例：启用多单位的商品
-- INSERT INTO bas_unit_group (id, tenant_id, company_id, product_id, group_name, base_unit) VALUES
-- (1, 1, 1, 1, '可乐单位组', '瓶');

-- INSERT INTO bas_unit_conversion (id, tenant_id, company_id, group_id, unit_name, ratio, is_base, sale_price) VALUES
-- (1, 1, 1, 1, '瓶', 1, 1, 3.00),
-- (2, 1, 1, 1, '箱', 24, 0, 50.00);