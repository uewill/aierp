package com.aierp.common.config;

import com.aierp.common.util.TenantContext;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * 租户拦截器 - 开发模式下设置默认租户
 */
@Component
public class TenantInterceptor implements HandlerInterceptor {
    
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) {
        // 开发模式：设置默认租户（生产环境应从 JWT Token 获取）
        TenantContext.setTenantId(1L);
        TenantContext.setCompanyId(1L);
        TenantContext.setUserId(1L);
        return true;
    }
    
    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) {
        TenantContext.clear();
    }
}