# aierp - AI 驱动进销存系统

> **核心理念**：语音/文字/图片智能录入，让开单像聊天一样简单

## 🎯 项目定位

一款面向中小企业的 AI 进销存软件，核心特色：

- **AI 智能录入**：语音识别、文字解析、图片 OCR → 自动生成订单
- **手机号注册**：验证码登录，自动注册租户
- **多租户架构**：每个用户独立租户，支持多公司切换
- **移动端优先**：Flutter 跨平台

## ✅ 项目阶段交付完成（2026-04-28）

| 模块 | 状态 | 验证 |
|------|------|------|
| 数据库设计 | ✅ | 24张表（多租户+AI模块） |
| Spring Boot 后端 | ✅ | 8090端口运行中 |
| 认证 API | ✅ | `/api/auth/send-code` `/api/auth/login` |
| AI 文字解析 | ✅ | 商品名正确识别 |
| 智谱 GLM-4 | ✅ 预留 | 配置启用即可 |
| Flutter APK | ✅ | **21.1MB 已打包上传** |

## 📱 Flutter APK 下载

**下载链接**：[app-release.apk](https://lightai.cloud.tencent.com/drive/preview?filePath=1777340068188/app-release.apk)

**文件大小**：21.1MB

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
  -d '{"content":"销售可乐10箱@50元，矿泉水5瓶@3元"}'
# 返回: 商品明细正确识别（置信度85%）
```

## 🗄️ 数据库设计（24张表）

- 系统管理：sys_tenant, sys_user, sys_verify_code, sys_company
- 基础数据：bas_product, bas_partner, bas_warehouse
- 业务单据：biz_sales_order, biz_purchase_order
- AI模块：ai_session, ai_message, ai_order_draft

## 🔧 配置启用智谱 GLM-4

修改 `application.yml`：
```yaml
ai:
  enabled: true
  zhipu-api-key: "你的智谱API Key"
  model: glm-4-flash
```

---

**Git提交**：已完成  
**APK下载**：https://lightai.cloud.tencent.com/drive/preview?filePath=1777340068188/app-release.apk  
**后端状态**：8090端口运行中