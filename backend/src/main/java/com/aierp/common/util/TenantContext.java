package com.aierp.common.util;

/**
 * 租户上下文工具 - 存储当前用户租户信息
 */
public class TenantContext {
    
    private static final ThreadLocal<Long> TENANT_ID = new ThreadLocal<>();
    private static final ThreadLocal<Long> COMPANY_ID = new ThreadLocal<>();
    private static final ThreadLocal<Long> USER_ID = new ThreadLocal<>();
    
    public static void setTenantId(Long tenantId) {
        TENANT_ID.set(tenantId);
    }
    
    public static Long getTenantId() {
        return TENANT_ID.get();
    }
    
    public static void setCompanyId(Long companyId) {
        COMPANY_ID.set(companyId);
    }
    
    public static Long getCompanyId() {
        return COMPANY_ID.get();
    }
    
    public static void setUserId(Long userId) {
        USER_ID.set(userId);
    }
    
    public static Long getUserId() {
        return USER_ID.get();
    }
    
    public static void clear() {
        TENANT_ID.remove();
        COMPANY_ID.remove();
        USER_ID.remove();
    }
}