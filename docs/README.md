# aierp - AI 驱动进销存系统

> **核心理念**：语音/文字/图片智能录入，让开单像聊天一样简单

## 🎯 项目定位

一款面向中小企业的 AI 进销存软件，核心特色：

- **AI 智能录入**：语音识别、文字解析、图片 OCR → 自动生成订单
- **手机号注册**：验证码登录，自动注册租户
- **多租户架构**：每个用户独立租户，支持多公司切换
- **移动端优先**：Flutter 跨平台
- **商品高级功能**：多规格、多单位、批次管理、保质期、序列号、条码、客户价格本

## ✅ 项目进度（2026-04-28）

| 模块 | 状态 | 说明 |
|------|------|------|
| 数据库设计 | ✅ | **31张表 + 1视图** |
| Spring Boot 后端 | ✅ | 8090端口运行 |
| 认证 API | ✅ | 验证码登录 |
| AI 文字解析 | ✅ | 商品名正确识别 |
| AI 语音识别 | ✅ | 接口已实现 |
| 商品扩展功能 | ✅ | **多单位/批次/保质期/序列号/条码/客户价格本** |
| Flutter APK | ✅ | 21.1MB已上传 |

## 📱 Flutter APK 下载

**下载链接**：[app-release.apk](https://lightai.cloud.tencent.com/drive/preview?filePath=1777340068188/app-release.apk)

## 🗄️ 数据库设计（31张表）

### 系统管理（5张）
- `sys_tenant` `sys_user` `sys_verify_code` `sys_company` `sys_user_company`

### 基础数据（8张）
- `bas_category` `bas_product` `bas_product_sku` 
- `bas_partner` `bas_warehouse`
- `bas_unit_group` `bas_unit_conversion` - **多单位管理**
- `bas_product_barcode` - **商品条码**
- `bas_customer_price` - **客户价格本**

### 业务单据（6张）
- `biz_purchase_order` `biz_purchase_order_detail`
- `biz_sales_order` `biz_sales_order_detail`
- `biz_inventory` `biz_inventory_log`

### 商品高级功能（5张）
- `biz_batch` `biz_batch_log` - **批次管理+保质期**
- `biz_serial_number` - **序列号管理**
- `biz_price_history` - **价格跟踪记录**

### AI模块（5张）
- `ai_session` `ai_message` `ai_order_draft`
- `ai_voice_record` `ai_image_record`

### 系统配置（2张）
- `sys_config` `sys_print_template` `sys_operation_log`

### 视图
- `v_expiry_warning` - **过期预警视图**

## 🚀 API 接口

### 认证
```
POST /api/auth/send-code   发送验证码
POST /api/auth/login       手机号登录
```

### AI智能录入
```
POST /api/ai/text-input    文字解析订单
POST /api/ai/voice-input   语音识别录入
POST /api/ai/draft/{id}/confirm  确认订单草稿
```

### 商品扩展功能（新增）
```
GET  /api/product/extend/units/{productId}      获取商品可用单位
POST /api/product/extend/unit/convert           单位换算计算
GET  /api/product/extend/batches/{productId}/{warehouseId} 批次查询(FIFO)
POST /api/product/extend/batch                  创建批次
GET  /api/product/extend/customer-price/{customerId}/{productId} 客户价格
POST /api/product/extend/customer-price/update  更新客户价格
GET  /api/product/extend/barcode/{barcode}      条码查询
GET  /api/product/extend/barcodes/{productId}   商品条码列表
```

### 业务管理
```
GET  /api/business/product/list      商品列表
GET  /api/business/partner/customer/list  客户列表
GET  /api/business/sales-order/page  销售单分页
POST /api/business/sales-order       创建销售单
```

## 🔧 商品高级功能说明

### 1. 多单位管理
商品可设置多个单位及换算比率：
- 例：可乐 基本单位=瓶，可设置 箱=24瓶
- API换算：`convert(productId, "箱", "瓶", 1)` → 返回24

### 2. 批次管理+保质期
- 入库时创建批次，记录生产日期、过期日期
- 出库按先进先出（FIFO）选择批次
- 过期预警视图：`v_expiry_warning`

### 3. 序列号管理
- 每件商品唯一序列号追踪
- 记录入库、销售全过程

### 4. 商品条码管理
- 支持一个商品多个条码
- 条码可关联特定单位和价格

### 5. 客户价格本
- 记录每个客户对每个商品的历史价格
- 开单时自动带出最近成交价和折扣
- 价格跟踪：每次修改价格自动记录

## 🔧 配置启用 AI 服务

```yaml
ai:
  enabled: true
  zhipu-api-key: "你的智谱API Key"
  model: glm-4-flash
  voice:
    enabled: true
    provider: tencent
```

## 📁 项目地址

- **GitHub**: [github.com/uewill/aierp](https://github.com/uewill/aierp)
- **APK下载**: [app-release.apk](https://lightai.cloud.tencent.com/drive/preview?filePath=1777340068188/app-release.apk)
- **后端API**: `localhost:8090`（需腾讯云开放端口）

---

**更新时间**: 2026-04-28 | **数据库**: 31张表 | **Git**: 已推送