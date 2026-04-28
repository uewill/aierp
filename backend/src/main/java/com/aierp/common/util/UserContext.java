package com.aierp.common.util;

import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import jakarta.servlet.http.HttpServletRequest;

/**
 * 用户上下文工具 - 从请求中获取当前用户信息
 */
public class UserContext {
    
    private static final String HEADER_TENANT_ID = "X-Tenant-Id";
    private static final String HEADER_COMPANY_ID = "X-Company-Id";
    private static final String HEADER_USER_ID = "X-User-Id";
    
    /**
     * 获取租户ID
     */
    public static Long getTenantId() {
        return getLongHeader(HEADER_TENANT_ID);
    }
    
    /**
     * 获取公司ID
     */
    public static Long getCompanyId() {
        return getLongHeader(HEADER_COMPANY_ID);
    }
    
    /**
     * 获取用户ID
     */
    public static Long getUserId() {
        return getLongHeader(HEADER_USER_ID);
    }
    
    /**
     * 从请求头获取Long值
     */
    private static Long getLongHeader(String headerName) {
        HttpServletRequest request = getRequest();
        if (request == null) {
            return null;
        }
        String value = request.getHeader(headerName);
        if (value == null || value.isEmpty()) {
            return null;
        }
        try {
            return Long.parseLong(value);
        } catch (NumberFormatException e) {
            return null;
        }
    }
    
    /**
     * 获取当前请求
     */
    private static HttpServletRequest getRequest() {
        ServletRequestAttributes attrs = (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
        return attrs != null ? attrs.getRequest() : null;
    }
}