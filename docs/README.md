# aierp - AI 驱动进销存系统

> **核心理念**：语音/文字/图片智能录入，让开单像聊天一样简单

## 🎯 项目定位

一款面向中小企业的 AI 进销存软件，核心特色：

- **AI 智能录入**：语音识别、文字解析、图片 OCR → 自动生成订单
- **手机号注册**：验证码登录，自动注册租户
- **多租户架构**：每个用户独立租户，支持多公司切换
- **移动端优先**：Flutter 跨平台，Arco Design 风格

## 📦 技术栈

| 模块 | 技术 | 说明 |
|------|------|------|
| 后端 | Spring Boot 3.2 + MySQL 8 | 单体架构，端口 8090 |
| 移动端 | Flutter 3.x + TDesign | 移动端优先设计 |
| UI 风格 | Arco Design | 企业级中后台风格 |
| AI | 智谱 GLM-4（预留） + 规则引擎 | 文字解析 + 语义理解 |

## ✅ 已完成进度（2026-04-28）

| 模块 | 状态 | 说明 |
|------|------|------|
| 数据库 | ✅ | 24张表已创建（多租户+AI模块） |
| 后端 | ✅ 运行中 | Spring Boot 8090端口 |
| 认证 API | ✅ | `/api/auth/send-code` `/api/auth/login` |
| AI 文字解析 | ✅ | `/api/ai/text-input` 规则引擎 |
| 智谱 GLM-4 | ✅ 预留 | 配置 `ai.enabled=true` 启用 |
| Flutter 移动端 | ✅ 基础 | 登录页+AI录入页+Tab导航 |

## 🚀 API 接口（已验证）

```bash
# 发送验证码
curl -X POST http://localhost:8090/api/auth/send-code \
  -H "Content-Type: application/json" \
  -d '{"phone":"18190780080"}'
# 返回: {"code":200}

# AI 文字解析订单
curl -X POST http://localhost:8090/api/ai/text-input \
  -H "Content-Type: application/json" \
  -d '{"content":"销售可乐10箱"}'
# 返回: 解析结果 JSON（置信度85%）
```

## 🗄️ 数据库设计（24张表）

### 系统管理（多租户）
- `sys_tenant` - 租户表
- `sys_user` - 用户表（手机号注册）
- `sys_verify_code` - 验证码表
- `sys_company` - 公司表
- `sys_user_company` - 用户公司关联

### 基础数据
- `bas_category` `bas_product` `bas_product_sku` - 商品管理
- `bas_partner` - 往来单位（客户/供应商）
- `bas_warehouse` - 仓库表

### 业务单据
- `biz_purchase_order` `biz_purchase_order_detail` - 采购单
- `biz_sales_order` `biz_sales_order_detail` - 销售单
- `biz_inventory` `biz_inventory_log` - 库存管理

### AI智能录入
- `ai_session` `ai_message` - AI会话记录
- `ai_voice_record` `ai_image_record` - 语音/图片识别
- `ai_order_draft` - AI订单草稿

## 🔧 配置启用智谱 GLM-4

修改 `application.yml`：
```yaml
ai:
  enabled: true
  zhipu-api-key: "你的智谱API Key"
  model: glm-4-flash
```

获取 API Key：https://open.bigmodel.cn

## 📱 Flutter 移动端

```bash
cd /myclaw/aierp/mobile
flutter pub get
flutter run  # 或 flutter build apk
```

页面结构：
- `LoginPage` - 手机号验证码登录
- `HomePage` - Tab 导航首页
- `AIInputPage` - AI录入核心功能
- 销售单/商品/更多（待完善）

## 📁 项目结构

```
/myclaw/aierp/
├── backend/
│   ├── src/main/java/com/aierp/
│   │   ├── auth/         # 认证模块
│   │   ├── business/     # 业务模块
│   │   ├── ai/           # AI模块（GLM-4+规则引擎）
│   │   └── common/       # 公共组件（TenantContext等）
│   └── src/main/resources/
│       ├── schema.sql    # 数据库设计
│       └── application.yml
├── mobile/
│   ├── lib/main.dart     # Flutter 主程序
│   └── pubspec.yaml
└── docs/README.md        # 本文档
```

## 🔮 下一步工作

1. **完善 AI 解析规则** - 改进商品名提取逻辑
2. **对接语音识别** - 腾讯云/阿里云语音 API
3. **对接图片 OCR** - 单据图片识别
4. **完善 Flutter 页面** - 商品管理、订单详情
5. **部署生产环境** - nginx 配置、域名绑定

---

**开发时间**: 2026-04-28 | **状态**: 后端 API 完成，移动端基础页面完成

**API 文档**: http://localhost:8090/doc.html