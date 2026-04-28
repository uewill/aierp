-- =====================================================
-- aierp - AI 驱动进销存系统数据库设计
-- 核心特性：多租户 + 手机号注册 + AI智能录入
-- =====================================================

CREATE DATABASE IF NOT EXISTS aierp DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE aierp;

-- =====================================================
-- 一、系统管理模块（多租户 + 手机号注册）
-- =====================================================

-- 租户表
CREATE TABLE IF NOT EXISTS sys_tenant (
    id BIGINT PRIMARY KEY COMMENT '租户ID',
    name VARCHAR(100) NOT NULL COMMENT '租户名称',
    code VARCHAR(50) UNIQUE COMMENT '租户编码',
    logo VARCHAR(200) COMMENT 'Logo URL',
    status INT DEFAULT 1 COMMENT '状态: 1正常 0禁用',
    expire_time DATETIME COMMENT '到期时间',
    max_users INT DEFAULT 10 COMMENT '最大用户数',
    max_companies INT DEFAULT 1 COMMENT '最大公司数',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted INT DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='租户表';

-- 用户表（手机号注册）
CREATE TABLE IF NOT EXISTS sys_user (
    id BIGINT PRIMARY KEY COMMENT '用户ID',
    tenant_id BIGINT NOT NULL COMMENT '租户ID',
    phone VARCHAR(20) NOT NULL COMMENT '手机号',
    nickname VARCHAR(50) COMMENT '昵称',
    avatar VARCHAR(200) COMMENT '头像URL',
    password VARCHAR(100) COMMENT '密码（可选，手机号登录可不设密码）',
    role VARCHAR(20) DEFAULT 'USER' COMMENT '角色: ADMIN/MANAGER/USER',
    status INT DEFAULT 1 COMMENT '状态: 1正常 0禁用',
    last_login_time DATETIME COMMENT '最后登录时间',
    last_login_ip VARCHAR(50) COMMENT '最后登录IP',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted INT DEFAULT 0,
    UNIQUE KEY uk_tenant_phone (tenant_id, phone)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户表';

-- 验证码表
CREATE TABLE IF NOT EXISTS sys_verify_code (
    id BIGINT PRIMARY KEY,
    phone VARCHAR(20) NOT NULL COMMENT '手机号',
    code VARCHAR(6) NOT NULL COMMENT '验证码',
    type VARCHAR(20) DEFAULT 'LOGIN' COMMENT '类型: LOGIN/REGISTER/RESET_PASSWORD',
    expire_time DATETIME NOT NULL COMMENT '过期时间',
    used INT DEFAULT 0 COMMENT '是否已使用',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='验证码表';

-- 公司表（租户下可多公司）
CREATE TABLE IF NOT EXISTS sys_company (
    id BIGINT PRIMARY KEY COMMENT '公司ID',
    tenant_id BIGINT NOT NULL COMMENT '租户ID',
    name VARCHAR(100) NOT NULL COMMENT '公司名称',
    code VARCHAR(50) COMMENT '公司编码',
    address VARCHAR(200) COMMENT '地址',
    contact_phone VARCHAR(20) COMMENT '联系电话',
    tax_no VARCHAR(50) COMMENT '税号',
    bank_name VARCHAR(50) COMMENT '开户银行',
    bank_account VARCHAR(50) COMMENT '银行账号',
    logo VARCHAR(200) COMMENT 'Logo',
    status INT DEFAULT 1,
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted INT DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='公司表';

-- 用户公司关联表
CREATE TABLE IF NOT EXISTS sys_user_company (
    id BIGINT PRIMARY KEY,
    user_id BIGINT NOT NULL COMMENT '用户ID',
    company_id BIGINT NOT NULL COMMENT '公司ID',
    is_default INT DEFAULT 0 COMMENT '是否默认公司',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户公司关联表';

-- =====================================================
-- 二、基础数据模块（商品/往来单位/仓库）
-- =====================================================

-- 商品分类表
CREATE TABLE IF NOT EXISTS bas_category (
    id BIGINT PRIMARY KEY,
    tenant_id BIGINT NOT NULL COMMENT '租户ID',
    company_id BIGINT NOT NULL COMMENT '公司ID',
    parent_id BIGINT DEFAULT 0 COMMENT '父分类ID',
    name VARCHAR(50) NOT NULL COMMENT '分类名称',
    code VARCHAR(50) COMMENT '分类编码',
    sort INT DEFAULT 0 COMMENT '排序',
    status INT DEFAULT 1,
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted INT DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='商品分类表';

-- 商品表
CREATE TABLE IF NOT EXISTS bas_product (
    id BIGINT PRIMARY KEY,
    tenant_id BIGINT NOT NULL COMMENT '租户ID',
    company_id BIGINT NOT NULL COMMENT '公司ID',
    code VARCHAR(50) NOT NULL COMMENT '商品编码',
    name VARCHAR(100) NOT NULL COMMENT '商品名称',
    barcode VARCHAR(50) COMMENT '条码',
    category_id BIGINT COMMENT '分类ID',
    spec VARCHAR(100) COMMENT '规格',
    unit VARCHAR(20) COMMENT '基本单位',
    purchase_price DECIMAL(12,2) COMMENT '进货价',
    sale_price DECIMAL(12,2) COMMENT '销售价',
    min_price DECIMAL(12,2) COMMENT '最低售价',
    stock DECIMAL(12,2) DEFAULT 0 COMMENT '库存',
    stock_warn DECIMAL(12,2) COMMENT '库存预警',
    image VARCHAR(200) COMMENT '商品图片',
    status INT DEFAULT 1 COMMENT '状态: 1正常 0禁用',
    remark VARCHAR(500) COMMENT '备注',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted INT DEFAULT 0,
    INDEX idx_tenant_company (tenant_id, company_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='商品表';

-- 商品SKU表（多规格）
CREATE TABLE IF NOT EXISTS bas_product_sku (
    id BIGINT PRIMARY KEY,
    tenant_id BIGINT NOT NULL,
    company_id BIGINT NOT NULL,
    product_id BIGINT NOT NULL COMMENT '商品ID',
    sku_code VARCHAR(50) COMMENT 'SKU编码',
    sku_name VARCHAR(100) COMMENT 'SKU名称',
    barcode VARCHAR(50) COMMENT 'SKU条码',
    spec_values VARCHAR(200) COMMENT '规格值JSON',
    purchase_price DECIMAL(12,2) COMMENT '进货价',
    sale_price DECIMAL(12,2) COMMENT '销售价',
    stock DECIMAL(12,2) DEFAULT 0,
    image VARCHAR(200) COMMENT 'SKU图片',
    status INT DEFAULT 1,
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted INT DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='商品SKU表';

-- 往来单位表（客户/供应商）
CREATE TABLE IF NOT EXISTS bas_partner (
    id BIGINT PRIMARY KEY,
    tenant_id BIGINT NOT NULL COMMENT '租户ID',
    company_id BIGINT NOT NULL COMMENT '公司ID',
    code VARCHAR(50) NOT NULL COMMENT '编码',
    name VARCHAR(100) NOT NULL COMMENT '名称',
    type VARCHAR(20) NOT NULL COMMENT '类型: CUSTOMER/SUPPLIER',
    category VARCHAR(50) COMMENT '客户分类',
    contact VARCHAR(50) COMMENT '联系人',
    phone VARCHAR(20) COMMENT '电话',
    address VARCHAR(200) COMMENT '地址',
    tax_no VARCHAR(50) COMMENT '税号',
    bank_name VARCHAR(50) COMMENT '开户银行',
    bank_account VARCHAR(50) COMMENT '银行账号',
    credit_level VARCHAR(10) COMMENT '信用等级',
    credit_amount DECIMAL(12,2) COMMENT '信用额度',
    balance DECIMAL(12,2) DEFAULT 0 COMMENT '往来余额',
    status INT DEFAULT 1,
    remark VARCHAR(500) COMMENT '备注',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted INT DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='往来单位表';

-- 仓库表
CREATE TABLE IF NOT EXISTS bas_warehouse (
    id BIGINT PRIMARY KEY,
    tenant_id BIGINT NOT NULL COMMENT '租户ID',
    company_id BIGINT NOT NULL COMMENT '公司ID',
    code VARCHAR(50) NOT NULL COMMENT '仓库编码',
    name VARCHAR(100) NOT NULL COMMENT '仓库名称',
    address VARCHAR(200) COMMENT '地址',
    manager VARCHAR(50) COMMENT '负责人',
    phone VARCHAR(20) COMMENT '联系电话',
    type VARCHAR(20) DEFAULT 'NORMAL' COMMENT '类型: NORMAL/VIRTUAL',
    status INT DEFAULT 1,
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted INT DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='仓库表';

-- =====================================================
-- 三、业务单据模块（采购/销售/库存）
-- =====================================================

-- 采购单表
CREATE TABLE IF NOT EXISTS biz_purchase_order (
    id BIGINT PRIMARY KEY,
    tenant_id BIGINT NOT NULL COMMENT '租户ID',
    company_id BIGINT NOT NULL COMMENT '公司ID',
    order_no VARCHAR(50) NOT NULL COMMENT '单号',
    supplier_id BIGINT COMMENT '供应商ID',
    supplier_name VARCHAR(100) COMMENT '供应商名称',
    warehouse_id BIGINT COMMENT '入库仓库ID',
    warehouse_name VARCHAR(100) COMMENT '仓库名称',
    total_amount DECIMAL(12,2) DEFAULT 0 COMMENT '总金额',
    paid_amount DECIMAL(12,2) DEFAULT 0 COMMENT '已付金额',
    status VARCHAR(20) DEFAULT 'DRAFT' COMMENT '状态: DRAFT/PENDING/APPROVED/CANCELLED',
    order_date DATE COMMENT '订单日期',
    expected_date DATE COMMENT '预计到货日期',
    operator_id BIGINT COMMENT '经办人ID',
    operator_name VARCHAR(50) COMMENT '经办人',
    remark VARCHAR(500) COMMENT '备注',
    ai_source VARCHAR(20) COMMENT 'AI来源: VOICE/IMAGE/TEXT',
    ai_session_id BIGINT COMMENT 'AI会话ID',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted INT DEFAULT 0,
    UNIQUE KEY uk_tenant_order_no (tenant_id, order_no)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='采购单表';

-- 采购单明细表
CREATE TABLE IF NOT EXISTS biz_purchase_order_detail (
    id BIGINT PRIMARY KEY,
    tenant_id BIGINT NOT NULL,
    order_id BIGINT NOT NULL COMMENT '采购单ID',
    product_id BIGINT COMMENT '商品ID',
    product_name VARCHAR(100) COMMENT '商品名称',
    sku_id BIGINT COMMENT 'SKU ID',
    sku_name VARCHAR(100) COMMENT 'SKU名称',
    barcode VARCHAR(50) COMMENT '条码',
    quantity DECIMAL(12,2) NOT NULL COMMENT '数量',
    unit VARCHAR(20) COMMENT '单位',
    price DECIMAL(12,2) COMMENT '单价',
    amount DECIMAL(12,2) COMMENT '金额',
    remark VARCHAR(200) COMMENT '备注',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='采购单明细表';

-- 销售单表
CREATE TABLE IF NOT EXISTS biz_sales_order (
    id BIGINT PRIMARY KEY,
    tenant_id BIGINT NOT NULL COMMENT '租户ID',
    company_id BIGINT NOT NULL COMMENT '公司ID',
    order_no VARCHAR(50) NOT NULL COMMENT '单号',
    customer_id BIGINT COMMENT '客户ID',
    customer_name VARCHAR(100) COMMENT '客户名称',
    warehouse_id BIGINT COMMENT '出库仓库ID',
    warehouse_name VARCHAR(100) COMMENT '仓库名称',
    total_amount DECIMAL(12,2) DEFAULT 0 COMMENT '总金额',
    discount_amount DECIMAL(12,2) DEFAULT 0 COMMENT '优惠金额',
    actual_amount DECIMAL(12,2) DEFAULT 0 COMMENT '实收金额',
    paid_amount DECIMAL(12,2) DEFAULT 0 COMMENT '已收金额',
    status VARCHAR(20) DEFAULT 'DRAFT' COMMENT '状态: DRAFT/PENDING/APPROVED/CANCELLED',
    order_date DATE COMMENT '订单日期',
    operator_id BIGINT COMMENT '经办人ID',
    operator_name VARCHAR(50) COMMENT '经办人',
    remark VARCHAR(500) COMMENT '备注',
    ai_source VARCHAR(20) COMMENT 'AI来源: VOICE/IMAGE/TEXT',
    ai_session_id BIGINT COMMENT 'AI会话ID',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted INT DEFAULT 0,
    UNIQUE KEY uk_tenant_order_no (tenant_id, order_no)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='销售单表';

-- 销售单明细表
CREATE TABLE IF NOT EXISTS biz_sales_order_detail (
    id BIGINT PRIMARY KEY,
    tenant_id BIGINT NOT NULL,
    order_id BIGINT NOT NULL COMMENT '销售单ID',
    product_id BIGINT COMMENT '商品ID',
    product_name VARCHAR(100) COMMENT '商品名称',
    sku_id BIGINT COMMENT 'SKU ID',
    sku_name VARCHAR(100) COMMENT 'SKU名称',
    barcode VARCHAR(50) COMMENT '条码',
    quantity DECIMAL(12,2) NOT NULL COMMENT '数量',
    unit VARCHAR(20) COMMENT '单位',
    price DECIMAL(12,2) COMMENT '单价',
    amount DECIMAL(12,2) COMMENT '金额',
    remark VARCHAR(200) COMMENT '备注',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='销售单明细表';

-- 库存表
CREATE TABLE IF NOT EXISTS biz_inventory (
    id BIGINT PRIMARY KEY,
    tenant_id BIGINT NOT NULL COMMENT '租户ID',
    company_id BIGINT NOT NULL COMMENT '公司ID',
    warehouse_id BIGINT NOT NULL COMMENT '仓库ID',
    product_id BIGINT NOT NULL COMMENT '商品ID',
    sku_id BIGINT COMMENT 'SKU ID',
    quantity DECIMAL(12,2) DEFAULT 0 COMMENT '库存数量',
    frozen_quantity DECIMAL(12,2) DEFAULT 0 COMMENT '冻结数量',
    cost_price DECIMAL(12,2) COMMENT '成本价',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uk_tenant_warehouse_sku (tenant_id, warehouse_id, product_id, sku_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='库存表';

-- 库存流水表
CREATE TABLE IF NOT EXISTS biz_inventory_log (
    id BIGINT PRIMARY KEY,
    tenant_id BIGINT NOT NULL,
    company_id BIGINT NOT NULL,
    warehouse_id BIGINT NOT NULL,
    product_id BIGINT NOT NULL,
    sku_id BIGINT,
    change_type VARCHAR(20) NOT NULL COMMENT '类型: PURCHASE_IN/SALES_OUT/ADJUST',
    change_quantity DECIMAL(12,2) NOT NULL COMMENT '变动数量',
    before_quantity DECIMAL(12,2) COMMENT '变动前数量',
    after_quantity DECIMAL(12,2) COMMENT '变动后数量',
    order_id BIGINT COMMENT '关联单据ID',
    order_no VARCHAR(50) COMMENT '关联单号',
    operator_id BIGINT COMMENT '操作人ID',
    operator_name VARCHAR(50) COMMENT '操作人',
    remark VARCHAR(200) COMMENT '备注',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='库存流水表';

-- =====================================================
-- 四、AI智能录入模块（核心特色）
-- =====================================================

-- AI会话表（语音/文字/图片交互）
CREATE TABLE IF NOT EXISTS ai_session (
    id BIGINT PRIMARY KEY,
    tenant_id BIGINT NOT NULL COMMENT '租户ID',
    company_id BIGINT NOT NULL COMMENT '公司ID',
    user_id BIGINT NOT NULL COMMENT '用户ID',
    session_type VARCHAR(20) NOT NULL COMMENT '类型: VOICE/IMAGE/TEXT',
    status VARCHAR(20) DEFAULT 'ACTIVE' COMMENT '状态: ACTIVE/COMPLETED/CANCELLED',
    context JSON COMMENT '会话上下文JSON',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    end_time DATETIME COMMENT '结束时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='AI会话表';

-- AI消息记录表
CREATE TABLE IF NOT EXISTS ai_message (
    id BIGINT PRIMARY KEY,
    session_id BIGINT NOT NULL COMMENT '会话ID',
    tenant_id BIGINT NOT NULL COMMENT '租户ID',
    role VARCHAR(20) NOT NULL COMMENT '角色: USER/ASSISTANT',
    content TEXT COMMENT '消息内容',
    content_type VARCHAR(20) DEFAULT 'TEXT' COMMENT '类型: TEXT/IMAGE/AUDIO',
    media_url VARCHAR(200) COMMENT '媒体文件URL',
    intent VARCHAR(50) COMMENT '识别意图: CREATE_ORDER/QUERY_STOCK/ADD_PRODUCT',
    parsed_data JSON COMMENT '解析后的结构化数据',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='AI消息记录表';

-- 语音识别记录表
CREATE TABLE IF NOT EXISTS ai_voice_record (
    id BIGINT PRIMARY KEY,
    tenant_id BIGINT NOT NULL COMMENT '租户ID',
    company_id BIGINT NOT NULL COMMENT '公司ID',
    user_id BIGINT NOT NULL COMMENT '用户ID',
    session_id BIGINT COMMENT '会话ID',
    audio_url VARCHAR(200) COMMENT '音频文件URL',
    audio_duration INT COMMENT '音频时长（秒）',
    original_text TEXT COMMENT '原始识别文本',
    corrected_text TEXT COMMENT '修正后文本',
    confidence DECIMAL(5,2) COMMENT '识别置信度',
    intent VARCHAR(50) COMMENT '识别意图',
    parsed_result JSON COMMENT '解析结果JSON',
    status VARCHAR(20) DEFAULT 'PROCESSING' COMMENT '状态: PROCESSING/SUCCESS/FAILED',
    error_msg VARCHAR(200) COMMENT '错误信息',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    process_time DATETIME COMMENT '处理完成时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='语音识别记录表';

-- 图片识别记录表（商品图片/单据图片）
CREATE TABLE IF NOT EXISTS ai_image_record (
    id BIGINT PRIMARY KEY,
    tenant_id BIGINT NOT NULL COMMENT '租户ID',
    company_id BIGINT NOT NULL COMMENT '公司ID',
    user_id BIGINT NOT NULL COMMENT '用户ID',
    session_id BIGINT COMMENT '会话ID',
    image_url VARCHAR(200) COMMENT '图片URL',
    image_type VARCHAR(20) COMMENT '类型: PRODUCT/ORDER/DOCUMENT/BARCODE',
    ocr_result TEXT COMMENT 'OCR识别结果',
    detected_objects JSON COMMENT '检测到的对象',
    intent VARCHAR(50) COMMENT '识别意图',
    parsed_result JSON COMMENT '解析结果JSON',
    status VARCHAR(20) DEFAULT 'PROCESSING' COMMENT '状态: PROCESSING/SUCCESS/FAILED',
    error_msg VARCHAR(200) COMMENT '错误信息',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    process_time DATETIME COMMENT '处理完成时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='图片识别记录表';

-- AI订单草稿表（解析后待确认的订单）
CREATE TABLE IF NOT EXISTS ai_order_draft (
    id BIGINT PRIMARY KEY,
    tenant_id BIGINT NOT NULL COMMENT '租户ID',
    company_id BIGINT NOT NULL COMMENT '公司ID',
    user_id BIGINT NOT NULL COMMENT '用户ID',
    session_id BIGINT COMMENT '会话ID',
    order_type VARCHAR(20) NOT NULL COMMENT '类型: PURCHASE/SALES',
    draft_data JSON NOT NULL COMMENT '草稿数据JSON',
    confidence DECIMAL(5,2) COMMENT '解析置信度',
    status VARCHAR(20) DEFAULT 'DRAFT' COMMENT '状态: DRAFT/CONFIRMED/REJECTED',
    confirmed_order_id BIGINT COMMENT '确认后生成的单据ID',
    remark VARCHAR(500) COMMENT '备注',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    confirm_time DATETIME COMMENT '确认时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='AI订单草稿表';

-- =====================================================
-- 五、打印模板（支持小票/标签/PDF）
-- =====================================================

-- 打印模板表
CREATE TABLE IF NOT EXISTS sys_print_template (
    id BIGINT PRIMARY KEY,
    tenant_id BIGINT NOT NULL COMMENT '租户ID',
    company_id BIGINT NOT NULL COMMENT '公司ID',
    name VARCHAR(50) NOT NULL COMMENT '模板名称',
    type VARCHAR(20) NOT NULL COMMENT '类型: RECEIPT/LABEL/PDF',
    content TEXT COMMENT '模板内容',
    width INT COMMENT '宽度',
    height INT COMMENT '高度',
    is_default INT DEFAULT 0 COMMENT '是否默认',
    status INT DEFAULT 1,
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted INT DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='打印模板表';

-- =====================================================
-- 六、系统配置表
-- =====================================================

-- 系统配置表（租户级）
CREATE TABLE IF NOT EXISTS sys_config (
    id BIGINT PRIMARY KEY,
    tenant_id BIGINT NOT NULL COMMENT '租户ID',
    company_id BIGINT COMMENT '公司ID（NULL表示租户级）',
    config_key VARCHAR(50) NOT NULL COMMENT '配置键',
    config_value VARCHAR(500) COMMENT '配置值',
    config_type VARCHAR(20) DEFAULT 'TEXT' COMMENT '类型: TEXT/JSON/NUMBER',
    remark VARCHAR(200) COMMENT '备注',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uk_tenant_key (tenant_id, company_id, config_key)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='系统配置表';

-- =====================================================
-- 七、操作日志表
-- =====================================================

CREATE TABLE IF NOT EXISTS sys_operation_log (
    id BIGINT PRIMARY KEY,
    tenant_id BIGINT NOT NULL COMMENT '租户ID',
    company_id BIGINT COMMENT '公司ID',
    user_id BIGINT COMMENT '用户ID',
    module VARCHAR(50) COMMENT '模块',
    operation VARCHAR(50) COMMENT '操作',
    method VARCHAR(100) COMMENT '方法',
    params TEXT COMMENT '参数',
    result TEXT COMMENT '结果',
    ip VARCHAR(50) COMMENT 'IP',
    status INT COMMENT '状态',
    error_msg VARCHAR(500) COMMENT '错误',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='操作日志表';