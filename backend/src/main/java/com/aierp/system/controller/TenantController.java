package com.aierp.system.controller;

import com.aierp.common.dto.ApiResponse;
import com.aierp.system.entity.Tenant;
import com.aierp.system.entity.Subscription;
import com.aierp.system.repository.TenantRepository;
import com.aierp.system.repository.SubscriptionRepository;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 租户管理API
 */
@Tag(name = "租户管理", description = "租户信息管理接口")
@RestController
@RequestMapping("/api/system/tenant")
@RequiredArgsConstructor
public class TenantController {
    
    private final TenantRepository tenantRepository;
    private final SubscriptionRepository subscriptionRepository;
    
    /**
     * 租户列表（分页）
     */
    @Operation(summary = "租户列表")
    @GetMapping("/page")
    public ApiResponse<Page<Tenant>> page(
            @RequestParam(defaultValue = "1") Integer current,
            @RequestParam(defaultValue = "10") Integer size,
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) Integer status) {
        
        QueryWrapper<Tenant> wrapper = new QueryWrapper<>();
        if (keyword != null && !keyword.isEmpty()) {
            wrapper.like("name", keyword).or().like("contact_name", keyword);
        }
        if (status != null) {
            wrapper.eq("status", status);
        }
        wrapper.orderByDesc("create_time");
        
        Page<Tenant> page = tenantRepository.selectPage(new Page<>(current, size), wrapper);
        return ApiResponse.success(page);
    }
    
    /**
     * 租户详情
     */
    @Operation(summary = "租户详情")
    @GetMapping("/{id}")
    public ApiResponse<Map<String, Object>> detail(@PathVariable Long id) {
        Tenant tenant = tenantRepository.selectById(id);
        List<Subscription> subscriptions = subscriptionRepository.findByTenantId(id);
        
        Map<String, Object> result = new HashMap<>();
        result.put("tenant", tenant);
        result.put("subscriptions", subscriptions);
        
        return ApiResponse.success(result);
    }
    
    /**
     * 创建租户
     */
    @Operation(summary = "创建租户")
    @PostMapping
    public ApiResponse<Tenant> create(@RequestBody Tenant tenant) {
        tenant.setStatus(1);
        tenant.setAutoRenew(0);
        tenant.setCreateTime(LocalDateTime.now());
        tenant.setUpdateTime(LocalDateTime.now());
        tenantRepository.insert(tenant);
        return ApiResponse.success(tenant);
    }
    
    /**
     * 更新租户
     */
    @Operation(summary = "更新租户")
    @PutMapping
    public ApiResponse<Tenant> update(@RequestBody Tenant tenant) {
        tenant.setUpdateTime(LocalDateTime.now());
        tenantRepository.updateById(tenant);
        return ApiResponse.success(tenant);
    }
    
    /**
     * 删除租户
     */
    @Operation(summary = "删除租户")
    @DeleteMapping("/{id}")
    public ApiResponse<Void> delete(@PathVariable Long id) {
        tenantRepository.deleteById(id);
        return ApiResponse.success();
    }
    
    /**
     * 续费订阅
     */
    @Operation(summary = "续费订阅")
    @PostMapping("/renew")
    public ApiResponse<Subscription> renew(@RequestBody Map<String, Object> params) {
        Long tenantId = Long.parseLong(params.get("tenantId").toString());
        String plan = params.get("plan").toString();
        Integer months = Integer.parseInt(params.get("months").toString());
        String payMethod = params.getOrDefault("payMethod", "manual").toString();
        
        // 计算金额
        BigDecimal amount = calculateAmount(plan, months);
        
        // 创建订阅记录
        Subscription subscription = new Subscription();
        subscription.setTenantId(tenantId);
        subscription.setPlan(plan);
        subscription.setMonths(months);
        subscription.setAmount(amount);
        subscription.setPayMethod(payMethod);
        subscription.setPayStatus(payMethod.equals("manual") ? 1 : 0);
        subscription.setStartTime(LocalDateTime.now());
        subscription.setEndTime(LocalDateTime.now().plusMonths(months));
        subscription.setOperator("系统管理员");
        subscription.setCreateTime(LocalDateTime.now());
        subscriptionRepository.insert(subscription);
        
        // 更新租户到期时间
        Tenant tenant = tenantRepository.selectById(tenantId);
        tenant.setSubscriptionPlan(plan);
        tenant.setExpireTime(subscription.getEndTime());
        tenant.setStatus(1);
        tenant.setUpdateTime(LocalDateTime.now());
        tenantRepository.updateById(tenant);
        
        return ApiResponse.success(subscription);
    }
    
    /**
     * 切换自动续费
     */
    @Operation(summary = "切换自动续费")
    @PostMapping("/{id}/auto-renew")
    public ApiResponse<Void> toggleAutoRenew(@PathVariable Long id, @RequestParam Integer autoRenew) {
        Tenant tenant = tenantRepository.selectById(id);
        tenant.setAutoRenew(autoRenew);
        tenant.setUpdateTime(LocalDateTime.now());
        tenantRepository.updateById(tenant);
        return ApiResponse.success();
    }
    
    /**
     * 统计数据
     */
    @Operation(summary = "统计数据")
    @GetMapping("/statistics")
    public ApiResponse<Map<String, Object>> statistics() {
        Map<String, Object> stats = new HashMap<>();
        stats.put("total", tenantRepository.selectCount(null));
        stats.put("normal", tenantRepository.selectCount(new QueryWrapper<Tenant>().eq("status", 1)));
        stats.put("expiring", tenantRepository.findExpiringTenants().size());
        stats.put("overdue", tenantRepository.findOverdueTenants().size());
        // TODO: 本月续费收入统计
        stats.put("monthlyIncome", 0);
        return ApiResponse.success(stats);
    }
    
    /**
     * 计算续费金额
     */
    private BigDecimal calculateAmount(String plan, Integer months) {
        BigDecimal monthlyFee;
        switch (plan) {
            case "basic":
                monthlyFee = new BigDecimal("99");
                break;
            case "standard":
                monthlyFee = new BigDecimal("199");
                break;
            case "premium":
                monthlyFee = new BigDecimal("399");
                break;
            default:
                monthlyFee = new BigDecimal("99");
        }
        return monthlyFee.multiply(new BigDecimal(months));
    }
}