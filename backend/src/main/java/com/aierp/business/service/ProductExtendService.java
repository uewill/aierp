package com.aierp.business.service;

import com.aierp.business.entity.*;
import com.aierp.business.repository.*;
import com.aierp.common.util.TenantContext;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.util.List;

/**
 * 商品扩展功能服务
 * - 多单位换算
 * - 批次管理
 * - 客户价格本
 * - 条码管理
 */
@Service
public class ProductExtendService {
    
    private final UnitGroupRepository unitGroupRepository;
    private final UnitConversionRepository unitConversionRepository;
    private final BatchRepository batchRepository;
    private final CustomerPriceRepository customerPriceRepository;
    private final ProductBarcodeRepository productBarcodeRepository;
    
    public ProductExtendService(
            UnitGroupRepository unitGroupRepository,
            UnitConversionRepository unitConversionRepository,
            BatchRepository batchRepository,
            CustomerPriceRepository customerPriceRepository,
            ProductBarcodeRepository productBarcodeRepository) {
        this.unitGroupRepository = unitGroupRepository;
        this.unitConversionRepository = unitConversionRepository;
        this.batchRepository = batchRepository;
        this.customerPriceRepository = customerPriceRepository;
        this.productBarcodeRepository = productBarcodeRepository;
    }
    
    /**
     * 获取商品所有可用单位
     */
    public List<UnitConversion> getProductUnits(Long productId) {
        UnitGroup group = unitGroupRepository.findByProductId(productId);
        if (group == null) return List.of();
        
        return unitConversionRepository.findByGroupId(group.getId());
    }
    
    /**
     * 单位换算计算
     * 
     * @param productId 商品ID
     * @param fromUnit 源单位
     * @param toUnit 目标单位
     * @param quantity 数量
     * @return 换算后数量
     */
    public BigDecimal convertUnit(Long productId, String fromUnit, String toUnit, BigDecimal quantity) {
        List<UnitConversion> units = getProductUnits(productId);
        
        BigDecimal fromRatio = null;
        BigDecimal toRatio = null;
        
        for (UnitConversion uc : units) {
            if (uc.getUnitName().equals(fromUnit)) fromRatio = uc.getRatio();
            if (uc.getUnitName().equals(toUnit)) toRatio = uc.getRatio();
        }
        
        if (fromRatio == null || toRatio == null) {
            return quantity; // 无法换算，返回原数量
        }
        
        // 换算公式：数量 * 源比率 / 目标比率
        return quantity.multiply(fromRatio).divide(toRatio, 4, RoundingMode.HALF_UP);
    }
    
    /**
     * 获取可用批次（先进先出）
     */
    public List<Batch> getAvailableBatches(Long productId, Long warehouseId) {
        return batchRepository.findAvailableBatches(productId, warehouseId);
    }
    
    /**
     * 创建新批次
     */
    @Transactional
    public Batch createBatch(Batch batch) {
        batch.setTenantId(TenantContext.getTenantId());
        batch.setCompanyId(TenantContext.getCompanyId());
        
        // 计算状态
        if (batch.getExpiryDate() != null) {
            if (batch.getExpiryDate().isBefore(LocalDate.now())) {
                batch.setStatus("EXPIRED");
            } else if (batch.getExpiryDate().minusDays(30).isBefore(LocalDate.now())) {
                batch.setStatus("WARN");
            } else {
                batch.setStatus("NORMAL");
            }
        }
        
        batchRepository.insert(batch);
        return batch;
    }
    
    /**
     * 获取客户商品价格（客户价格本）
     */
    public CustomerPrice getCustomerPrice(Long customerId, Long productId) {
        return customerPriceRepository.findByCustomerAndProduct(customerId, productId);
    }
    
    /**
     * 更新客户价格（订单完成后调用）
     */
    @Transactional
    public void updateCustomerPrice(Long customerId, Long productId, Long skuId,
                                     String unit, BigDecimal price, BigDecimal discount,
                                     Long orderId, String orderNo) {
        CustomerPrice cp = customerPriceRepository.findByCustomerAndProduct(customerId, productId);
        
        BigDecimal actualPrice = price.multiply(discount.divide(BigDecimal.valueOf(100), 4, RoundingMode.HALF_UP));
        
        if (cp == null) {
            // 新增客户价格记录
            cp = new CustomerPrice();
            cp.setTenantId(TenantContext.getTenantId());
            cp.setCompanyId(TenantContext.getCompanyId());
            cp.setCustomerId(customerId);
            cp.setProductId(productId);
            cp.setSkuId(skuId);
            cp.setUnitName(unit);
            cp.setPrice(price);
            cp.setDiscount(discount);
            cp.setActualPrice(actualPrice);
            cp.setLastOrderId(orderId);
            cp.setLastOrderNo(orderNo);
            cp.setLastOrderDate(LocalDate.now());
            cp.setAvgPrice(price);
            cp.setMinPrice(price);
            cp.setMaxPrice(price);
            cp.setOrderCount(1);
            customerPriceRepository.insert(cp);
        } else {
            // 更新客户价格记录
            cp.setPrice(price);
            cp.setDiscount(discount);
            cp.setActualPrice(actualPrice);
            cp.setLastOrderId(orderId);
            cp.setLastOrderNo(orderNo);
            cp.setLastOrderDate(LocalDate.now());
            cp.setOrderCount(cp.getOrderCount() + 1);
            
            // 更新统计价格
            BigDecimal newAvg = cp.getAvgPrice().multiply(BigDecimal.valueOf(cp.getOrderCount() - 1))
                                  .add(price).divide(BigDecimal.valueOf(cp.getOrderCount()), 2, RoundingMode.HALF_UP);
            cp.setAvgPrice(newAvg);
            
            if (price.compareTo(cp.getMinPrice()) < 0) cp.setMinPrice(price);
            if (price.compareTo(cp.getMaxPrice()) > 0) cp.setMaxPrice(price);
            
            customerPriceRepository.updateById(cp);
        }
    }
    
    /**
     * 根据条码获取商品信息
     */
    public ProductBarcode getBarcodeInfo(String barcode) {
        return productBarcodeRepository.findByBarcode(barcode);
    }
    
    /**
     * 获取商品所有条码
     */
    public List<ProductBarcode> getProductBarcodes(Long productId) {
        return productBarcodeRepository.findByProductId(productId);
    }
}