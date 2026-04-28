package com.aierp.business.service;

import com.aierp.business.entity.SalesOrder;
import com.aierp.business.entity.SalesOrderDetail;
import com.aierp.business.repository.SalesOrderDetailRepository;
import com.aierp.business.repository.SalesOrderRepository;
import com.aierp.common.util.TenantContext;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

/**
 * 销售单服务
 */
@Service
public class SalesOrderService {
    
    private final SalesOrderRepository salesOrderRepository;
    private final SalesOrderDetailRepository detailRepository;
    
    public SalesOrderService(SalesOrderRepository salesOrderRepository,
                             SalesOrderDetailRepository detailRepository) {
        this.salesOrderRepository = salesOrderRepository;
        this.detailRepository = detailRepository;
    }
    
    public Page<SalesOrder> page(Integer pageNum, Integer pageSize, String status, String keyword) {
        LambdaQueryWrapper<SalesOrder> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(SalesOrder::getTenantId, TenantContext.getTenantId());
        wrapper.eq(SalesOrder::getCompanyId, TenantContext.getCompanyId());
        
        if (status != null && !status.isEmpty()) {
            wrapper.eq(SalesOrder::getStatus, status);
        }
        
        if (keyword != null && !keyword.isEmpty()) {
            wrapper.like(SalesOrder::getOrderNo, keyword)
                   .or()
                   .like(SalesOrder::getCustomerName, keyword);
        }
        
        wrapper.orderByDesc(SalesOrder::getCreateTime);
        
        Page<SalesOrder> page = salesOrderRepository.selectPage(new Page<>(pageNum, pageSize), wrapper);
        
        page.getRecords().forEach(order -> {
            LambdaQueryWrapper<SalesOrderDetail> detailWrapper = new LambdaQueryWrapper<>();
            detailWrapper.eq(SalesOrderDetail::getOrderId, order.getId());
            List<SalesOrderDetail> details = detailRepository.selectList(detailWrapper);
            order.setDetails(details);
        });
        
        return page;
    }
    
    @Transactional
    public SalesOrder create(SalesOrder order) {
        order.setTenantId(TenantContext.getTenantId());
        order.setCompanyId(TenantContext.getCompanyId());
        
        // 如果没有订单号，自动生成
        if (order.getOrderNo() == null || order.getOrderNo().isEmpty()) {
            order.setOrderNo(generateOrderNo());
        }
        
        order.setOrderDate(LocalDate.now());
        if (order.getStatus() == null || order.getStatus().isEmpty()) {
            order.setStatus("DRAFT");
        }
        order.setOperatorId(TenantContext.getUserId());
        
        // 计算总金额（如果有明细）
        BigDecimal totalAmount = order.getTotalAmount() != null ? order.getTotalAmount() : BigDecimal.ZERO;
        
        if (order.getDetails() != null && !order.getDetails().isEmpty()) {
            for (SalesOrderDetail detail : order.getDetails()) {
                detail.setTenantId(TenantContext.getTenantId());
                detail.setOrderId(order.getId());
                BigDecimal amount = detail.getQuantity().multiply(detail.getPrice());
                detail.setAmount(amount);
                totalAmount = totalAmount.add(amount);
            }
        }
        
        order.setTotalAmount(totalAmount);
        order.setActualAmount(totalAmount.subtract(
            order.getDiscountAmount() != null ? order.getDiscountAmount() : BigDecimal.ZERO
        ));
        
        salesOrderRepository.insert(order);
        
        for (SalesOrderDetail detail : order.getDetails()) {
            detail.setOrderId(order.getId());
            detailRepository.insert(detail);
        }
        
        return order;
    }
    
    @Transactional
    public SalesOrder approve(Long orderId) {
        SalesOrder order = salesOrderRepository.selectById(orderId);
        if (order == null) {
            throw new RuntimeException("订单不存在");
        }
        
        if (!order.getTenantId().equals(TenantContext.getTenantId())) {
            throw new RuntimeException("无权限操作此订单");
        }
        
        order.setStatus("APPROVED");
        salesOrderRepository.updateById(order);
        
        return order;
    }
    
    private String generateOrderNo() {
        return "SO" + LocalDate.now().toString().replace("-", "") + 
               String.format("%04d", System.currentTimeMillis() % 10000);
    }
}