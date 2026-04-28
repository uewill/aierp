package com.aierp.business.service;

import com.aierp.business.entity.Inventory;
import com.aierp.business.repository.InventoryRepository;
import com.aierp.common.util.TenantContext;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.List;

/**
 * 库存服务
 */
@Service
public class InventoryService {
    
    private final InventoryRepository inventoryRepository;
    
    public InventoryService(InventoryRepository inventoryRepository) {
        this.inventoryRepository = inventoryRepository;
    }
    
    /**
     * 分页查询库存
     */
    public Page<Inventory> page(Integer pageNum, Integer pageSize, Long warehouseId, String keyword) {
        LambdaQueryWrapper<Inventory> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Inventory::getTenantId, TenantContext.getTenantId());
        wrapper.eq(Inventory::getCompanyId, TenantContext.getCompanyId());
        
        if (warehouseId != null) {
            wrapper.eq(Inventory::getWarehouseId, warehouseId);
        }
        
        if (keyword != null && !keyword.isEmpty()) {
            wrapper.like(Inventory::getProductName, keyword)
                   .or()
                   .like(Inventory::getSkuName, keyword);
        }
        
        wrapper.orderByDesc(Inventory::getUpdateTime);
        
        return inventoryRepository.selectPage(new Page<>(pageNum, pageSize), wrapper);
    }
    
    /**
     * 查询商品库存列表
     */
    public List<Inventory> listByProduct(Long productId) {
        LambdaQueryWrapper<Inventory> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Inventory::getTenantId, TenantContext.getTenantId());
        wrapper.eq(Inventory::getProductId, productId);
        return inventoryRepository.selectList(wrapper);
    }
    
    /**
     * 查询仓库库存列表
     */
    public List<Inventory> listByWarehouse(Long warehouseId) {
        LambdaQueryWrapper<Inventory> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Inventory::getTenantId, TenantContext.getTenantId());
        wrapper.eq(Inventory::getWarehouseId, warehouseId);
        return inventoryRepository.selectList(wrapper);
    }
    
    /**
     * 获取商品可用库存
     */
    public BigDecimal getAvailableQuantity(Long productId, Long warehouseId) {
        LambdaQueryWrapper<Inventory> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Inventory::getTenantId, TenantContext.getTenantId());
        wrapper.eq(Inventory::getProductId, productId);
        if (warehouseId != null) {
            wrapper.eq(Inventory::getWarehouseId, warehouseId);
        }
        
        List<Inventory> list = inventoryRepository.selectList(wrapper);
        return list.stream()
                .map(Inventory::getQuantity)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
    }
}