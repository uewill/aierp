package com.aierp.ai.dto;

import jakarta.validation.constraints.NotBlank;

/**
 * AI文字录入请求
 */
public class AITextInputRequest {
    
    @NotBlank(message = "输入内容不能为空")
    private String content;
    
    private String orderType;
    
    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }
    
    public String getOrderType() { return orderType; }
    public void setOrderType(String orderType) { this.orderType = orderType; }
}