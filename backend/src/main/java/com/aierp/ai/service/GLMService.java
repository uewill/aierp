package com.aierp.ai.service;

import com.aierp.ai.config.AIConfig;
import com.alibaba.fastjson2.JSON;
import com.alibaba.fastjson2.JSONArray;
import com.alibaba.fastjson2.JSONObject;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.util.HashMap;
import java.util.Map;

/**
 * 智谱 GLM-4 调用服务
 */
@Service
public class GLMService {
    
    private final AIConfig aiConfig;
    private final RestTemplate restTemplate;
    
    public GLMService(AIConfig aiConfig) {
        this.aiConfig = aiConfig;
        this.restTemplate = new RestTemplate();
    }
    
    /**
     * 调用智谱 GLM-4 解析订单内容
     * 
     * @param content 用户输入的文字
     * @param orderType 订单类型（可选）
     * @return 解析结果 JSON
     */
    public String parseOrderContent(String content, String orderType) {
        if (!aiConfig.isEnabled() || aiConfig.getZhipuApiKey() == null) {
            // 未启用或无 API Key，返回 null（使用规则引擎）
            return null;
        }
        
        // 构建提示词
        String prompt = buildPrompt(content, orderType);
        
        // 构建请求
        JSONObject requestBody = new JSONObject();
        requestBody.put("model", aiConfig.getModel());
        
        JSONArray messages = new JSONArray();
        JSONObject systemMsg = new JSONObject();
        systemMsg.put("role", "system");
        systemMsg.put("content", getSystemPrompt());
        messages.add(systemMsg);
        
        JSONObject userMsg = new JSONObject();
        userMsg.put("role", "user");
        userMsg.put("content", prompt);
        messages.add(userMsg);
        
        requestBody.put("messages", messages);
        
        // 发送请求
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        headers.set("Authorization", "Bearer " + aiConfig.getZhipuApiKey());
        
        HttpEntity<String> entity = new HttpEntity<>(requestBody.toJSONString(), headers);
        
        try {
            ResponseEntity<String> response = restTemplate.exchange(
                aiConfig.getZhipuApiUrl(),
                HttpMethod.POST,
                entity,
                String.class
            );
            
            if (response.getStatusCode() == HttpStatus.OK) {
                JSONObject result = JSON.parseObject(response.getBody());
                JSONArray choices = result.getJSONArray("choices");
                if (choices != null && !choices.isEmpty()) {
                    JSONObject choice = choices.getJSONObject(0);
                    JSONObject message = choice.getJSONObject("message");
                    return message.getString("content");
                }
            }
        } catch (Exception e) {
            System.err.println("智谱 API 调用失败: " + e.getMessage());
        }
        
        return null;
    }
    
    /**
     * 构建用户提示词
     */
    private String buildPrompt(String content, String orderType) {
        StringBuilder sb = new StringBuilder();
        sb.append("请解析以下订单内容：\n");
        sb.append(content);
        sb.append("\n\n");
        if (orderType != null) {
            sb.append("订单类型：").append(orderType.equals("SALES") ? "销售单" : "采购单").append("\n");
        }
        sb.append("请以 JSON 格式返回解析结果。");
        return sb.toString();
    }
    
    /**
     * 系统提示词 - 定义 AI 的角色和输出格式
     */
    private String getSystemPrompt() {
        return """
你是一个进销存系统的智能订单解析助手。你的任务是从用户的自然语言描述中提取订单信息。

支持的订单类型：
- 销售单（SALES）：卖给客户商品
- 采购单（PURCHASE）：从供应商进货

你需要提取以下信息：
1. 订单类型（orderType）：SALES 或 PURCHASE
2. 往来单位名称（partnerName）：客户或供应商名称
3. 商品明细（items）：数组，每个包含 productName、quantity、unit、price
4. 备注（remark）：如有

返回格式示例：
{
  "orderType": "SALES",
  "partnerName": "张三",
  "items": [
    {"productName": "可乐", "quantity": 10, "unit": "箱", "price": 50},
    {"productName": "矿泉水", "quantity": 5, "unit": "瓶", "price": 3}
  ],
  "remark": "",
  "confidence": 95
}

注意：
- 只返回 JSON，不要其他解释
- 如果无法识别，confidence 设为较低值
- 数量和价格必须是数字
- 单位支持：箱、瓶、件、袋、盒、个、公斤、斤、克、吨
""";
    }
}