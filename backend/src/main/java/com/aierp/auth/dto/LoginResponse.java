package com.aierp.auth.dto;

import java.util.List;

/**
 * 登录响应
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
    
    public String getToken() { return token; }
    public void setToken(String token) { this.token = token; }
    
    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }
    
    public Long getTenantId() { return tenantId; }
    public void setTenantId(Long tenantId) { this.tenantId = tenantId; }
    
    public Long getCompanyId() { return companyId; }
    public void setCompanyId(Long companyId) { this.companyId = companyId; }
    
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
    
    public String getNickname() { return nickname; }
    public void setNickname(String nickname) { this.nickname = nickname; }
    
    public String getAvatar() { return avatar; }
    public void setAvatar(String avatar) { this.avatar = avatar; }
    
    public String getRole() { return role; }
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