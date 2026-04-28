package com.aierp.auth.dto;

import jakarta.validation.constraints.NotBlank;

/**
 * 发送验证码请求
 */
public class SendCodeRequest {
    
    @NotBlank(message = "手机号不能为空")
    private String phone;
    
    private String type = "LOGIN";
    
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
    
    public String getType() { return type; }
    public void setType(String type) { this.type = type; }
}