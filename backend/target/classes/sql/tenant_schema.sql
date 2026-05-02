-- 租户管理表
CREATE TABLE IF NOT EXISTS sys_tenant (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL COMMENT '租户名称',
    contact_name VARCHAR(50) COMMENT '联系人',
    contact_phone VARCHAR(20) COMMENT '联系电话',
    contact_email VARCHAR(100) COMMENT '联系邮箱',
    address VARCHAR(200) COMMENT '地址',
    
    subscription_plan VARCHAR(20) DEFAULT 'basic' COMMENT '订阅套餐: basic/standard/premium',
    expire_time DATETIME COMMENT '到期时间',
    
    status INT DEFAULT 1 COMMENT '状态: 0-禁用 1-正常 2-欠费',
    auto_renew INT DEFAULT 0 COMMENT '自动续费: 0-否 1-是',
    
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_name (name),
    INDEX idx_status (status),
    INDEX idx_expire_time (expire_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='租户信息表';

-- 订阅记录表
CREATE TABLE IF NOT EXISTS sys_subscription (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    tenant_id BIGINT NOT NULL COMMENT '租户ID',
    plan VARCHAR(20) NOT NULL COMMENT '套餐: basic/standard/premium',
    months INT NOT NULL COMMENT '续费月数',
    amount DECIMAL(10,2) NOT NULL COMMENT '支付金额',
    
    start_time DATETIME NOT NULL COMMENT '开始时间',
    end_time DATETIME NOT NULL COMMENT '结束时间',
    
    pay_status INT DEFAULT 0 COMMENT '支付状态: 0-待支付 1-已支付',
    pay_method VARCHAR(20) COMMENT '支付方式: wechat/alipay/bank/manual',
    
    operator VARCHAR(50) COMMENT '操作人',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    
    INDEX idx_tenant_id (tenant_id),
    INDEX idx_create_time (create_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='订阅记录表';

-- 操作记录表
CREATE TABLE IF NOT EXISTS sys_operation_log (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    tenant_id BIGINT COMMENT '租户ID',
    type VARCHAR(50) NOT NULL COMMENT '操作类型',
    content VARCHAR(500) COMMENT '操作内容',
    operator VARCHAR(50) COMMENT '操作人',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    
    INDEX idx_tenant_id (tenant_id),
    INDEX idx_create_time (create_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='操作记录表';

-- 插入示例数据
INSERT INTO sys_tenant (name, contact_name, contact_phone, contact_email, address, subscription_plan, expire_time, status) VALUES
('示例公司A', '张经理', '13800138001', 'zhang@example.com', '四川省成都市天府软件园', 'standard', '2026-05-28 00:00:00', 1),
('示例公司B', '李总', '13900139001', 'li@example.com', '北京市朝阳区望京', 'premium', '2026-08-28 00:00:00', 1),
('示例公司C', '王老板', '13700137001', 'wang@example.com', '广东省深圳市南山', 'basic', '2026-04-15 00:00:00', 2);