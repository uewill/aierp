package com.aierp.business.service;

import com.aierp.business.entity.PurchaseOrder;
import com.aierp.business.entity.PurchaseOrderDetail;
import com.aierp.business.repository.PurchaseOrderDetailRepository;
import com.aierp.business.repository.PurchaseOrderRepository;
import com.aierp.common.util.TenantContext;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

/**
 * 采购单服务
 */
@Service
public class PurchaseOrderService {
    
    private final PurchaseOrderRepository purchaseOrderRepository;
    private final PurchaseOrderDetailRepository detailRepository;
    
    public PurchaseOrderService(PurchaseOrderRepository purchaseOrderRepository,
                                PurchaseOrderDetailRepository detailRepository) {
        this.purchaseOrderRepository = purchaseOrderRepository;
        this.detailRepository = detailRepository;
    }
    
    public Page<PurchaseOrder> page(Integer pageNum, Integer pageSize, String status, String keyword) {
        LambdaQueryWrapper<PurchaseOrder> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(PurchaseOrder::getTenantId, TenantContext.getTenantId());
        wrapper.eq(PurchaseOrder::getCompanyId, TenantContext.getCompanyId());
        
        if (status != null && !status.isEmpty()) {
            wrapper.eq(PurchaseOrder::getStatus, status);
        }
        
        if (keyword != null && !keyword.isEmpty()) {
            wrapper.like(PurchaseOrder::getOrderNo, keyword)
                   .or()
                   .like(PurchaseOrder::getSupplierName, keyword);
        }
        
        wrapper.orderByDesc(PurchaseOrder::getCreateTime);
        
        Page<PurchaseOrder> page = purchaseOrderRepository.selectPage(new Page<>(pageNum, pageSize), wrapper);
        
        page.getRecords().forEach(order -> {
            LambdaQueryWrapper<PurchaseOrderDetail> detailWrapper = new LambdaQueryWrapper<>();
            detailWrapper.eq(PurchaseOrderDetail::getOrderId, order.getId());
            List<PurchaseOrderDetail> details = detailRepository.selectList(detailWrapper);
            order.setDetails(details);
        });
        
        return page;
    }
    
    @Transactional
    public PurchaseOrder create(PurchaseOrder order) {
        order.setTenantId(TenantContext.getTenantId());
        order.setCompanyId(TenantContext.getCompanyId());
        
        if (order.getOrderNo() == null || order.getOrderNo().isEmpty()) {
            order.setOrderNo(generateOrderNo());
        }
        
        order.setOrderDate(LocalDate.now());
        if (order.getStatus() == null || order.getStatus().isEmpty()) {
            order.setStatus("DRAFT");
        }
        order.setOperatorId(TenantContext.getUserId());
        
        BigDecimal totalAmount = order.getTotalAmount() != null ? order.getTotalAmount() : BigDecimal.ZERO;
        
        // 先插入采购单，获取ID
        if (order.getDetails() != null && !order.getDetails().isEmpty()) {
            BigDecimal detailsTotal = BigDecimal.ZERO;
            for (PurchaseOrderDetail detail : order.getDetails()) {
                BigDecimal amount = detail.getQuantity().multiply(detail.getPrice());
                detail.setAmount(amount);
                detailsTotal = detailsTotal.add(amount);
            }
            totalAmount = detailsTotal;
        }
        
        order.setTotalAmount(totalAmount);
        
        // 先插入采购单
        purchaseOrderRepository.insert(order);
        
        // 再插入明细（此时order.getId()已有值）
        if (order.getDetails() != null && !order.getDetails().isEmpty()) {
            for (PurchaseOrderDetail detail : order.getDetails()) {
                detail.setTenantId(TenantContext.getTenantId());
                detail.setOrderId(order.getId());
                detailRepository.insert(detail);
            }
        }
        
        return order;
    }
    
    @Transactional
    public PurchaseOrder approve(Long id) {
        PurchaseOrder order = purchaseOrderRepository.selectById(id);
        if (order == null) {
            throw new RuntimeException("采购单不存在");
        }
        
        order.setStatus("APPROVED");
        purchaseOrderRepository.updateById(order);
        
        return order;
    }
    
    private String generateOrderNo() {
        return "PO" + LocalDate.now().format(java.time.format.DateTimeFormatter.ofPattern("yyyyMMdd")) + 
               String.format("%04d", System.currentTimeMillis() % 10000);
    }
}