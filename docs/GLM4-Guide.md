# 智谱 GLM-4 对接指南

## 获取 API Key

1. 访问智谱开放平台：https://open.bigmodel.cn
2. 注册账号并登录
3. 进入「API密钥」页面
4. 创建新的API Key

## 配置启用

修改 `/myclaw/aierp/backend/src/main/resources/application.yml`：

```yaml
ai:
  enabled: true                        # 启用GLM-4
  zhipu-api-key: "你的API_Key"         # 填入你的API Key
  zhipu-api-url: https://open.bigmodel.cn/api/paas/v4/chat/completions
  model: glm-4-flash                   # 模型选择
```

## 模型选择

| 模型 | 说明 | 推荐场景 |
|------|------|---------|
| glm-4-flash | 快速响应 | 订单解析（推荐） |
| glm-4 | 通用能力 | 复杂场景 |
| glm-4-plus | 高级能力 | 需要深度理解 |

## 调用流程

```
用户输入 → GLM-4解析 → 返回JSON → 系统解析 → 创建订单草稿
```

## 示例输入

```
销售可乐10箱@50元，批次:B20260401，过期日期:2026-12-31
```

GLM-4返回：
```json
{
  "orderType": "SALES",
  "items": [{
    "productName": "可乐",
    "quantity": 10,
    "unit": "箱",
    "price": 50,
    "batchNo": "B20260401",
    "expiryDate": "2026-12-31"
  }],
  "confidence": 95
}
```

## 费用说明

- glm-4-flash: 约0.1元/千tokens
- 单次订单解析约消耗200-500 tokens
- 预估每次调用成本约0.02-0.05元

---

配置完成后重启后端即可生效。