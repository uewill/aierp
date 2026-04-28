package com.aierp.auth.dto;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonProperty;

import java.util.List;

/**
 * 登录响应 - 前端兼容字段名
 */
public class LoginResponse {
    
    private String token;
    private Long userId;
    private Long tenantId;
    private Long companyId;
    private String phone;
    private String nickname;
    private String avatar;
    private String role;
    private List<CompanyInfo> companies;
    private String registrationDate;
    
    public String getToken() { return token; }
    public void setToken(String token) { this.token = token; }
    
    @JsonIgnore
    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }
    
    public Long getTenantId() { return tenantId; }
    public void setTenantId(Long tenantId) { this.tenantId = tenantId; }
    
    public Long getCompanyId() { return companyId; }
    public void setCompanyId(Long companyId) { this.companyId = companyId; }
    
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
    
    @JsonIgnore
    public String getNickname() { return nickname; }
    public void setNickname(String nickname) { this.nickname = nickname; }
    
    // 前端兼容：name 对应 nickname
    @JsonProperty("name")
    public String getName() { return nickname; }
    public void setName(String name) { this.nickname = name; }
    
    // 前端兼容：accountId 对应 userId
    @JsonProperty("accountId")
    public String getAccountId() { return userId != null ? userId.toString() : null; }
    
    public String getRegistrationDate() { return registrationDate; }
    public void setRegistrationDate(String registrationDate) { this.registrationDate = registrationDate; }
    
    public String getAvatar() { return avatar; }
    public void setAvatar(String avatar) { this.avatar = avatar; }
    
    // 前端兼容：role 返回小写
    public String getRole() { return role != null ? role.toLowerCase() : null; }
    public void setRole(String role) { this.role = role; }
    
    public List<CompanyInfo> getCompanies() { return companies; }
    public void setCompanies(List<CompanyInfo> companies) { this.companies = companies; }
    
    public static class CompanyInfo {
        private Long id;
        private String name;
        private Boolean isDefault;
        
        public Long getId() { return id; }
        public void setId(Long id) { this.id = id; }
        
        public String getName() { return name; }
        public void setName(String name) { this.name = name; }
        
        public Boolean getIsDefault() { return isDefault; }
        public void setIsDefault(Boolean isDefault) { this.isDefault = isDefault; }
    }
}