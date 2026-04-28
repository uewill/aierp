package com.aierp.common.interceptor;

import com.aierp.common.util.JwtUtil;
import com.aierp.common.util.TenantContext;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

/**
 * JWT Token拦截器 - 解析Token并设置用户信息到请求头
 */
@Component
public class JwtInterceptor implements HandlerInterceptor {
    
    private final JwtUtil jwtUtil;
    
    public JwtInterceptor(JwtUtil jwtUtil) {
        this.jwtUtil = jwtUtil;
    }
    
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) {
        String token = extractToken(request);
        
        if (token != null && jwtUtil.validateToken(token)) {
            Long userId = jwtUtil.getUserId(token);
            Long tenantId = jwtUtil.getTenantId(token);
            Long companyId = jwtUtil.getCompanyId(token);
            
            // 设置到TenantContext，供业务层使用
            com.aierp.common.util.TenantContext.setUserId(userId);
            com.aierp.common.util.TenantContext.setTenantId(tenantId);
            com.aierp.common.util.TenantContext.setCompanyId(companyId);
            
            // 也设置到请求属性
            request.setAttribute("userId", userId);
            request.setAttribute("tenantId", tenantId);
            request.setAttribute("companyId", companyId);
        }
        
        return true;
    }
    
    /**
     * 从请求中提取Token
     */
    private String extractToken(HttpServletRequest request) {
        String bearerToken = request.getHeader("Authorization");
        if (bearerToken != null && bearerToken.startsWith("Bearer ")) {
            return bearerToken.substring(7);
        }
        return null;
    }
    
    /**
     * 请求完成后清理ThreadLocal
     */
    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) {
        TenantContext.clear();
    }
}