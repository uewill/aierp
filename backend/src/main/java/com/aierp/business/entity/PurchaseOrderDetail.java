package com.aierp.business.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * 采购单明细实体
 */
@TableName("biz_purchase_order_detail")
public class PurchaseOrderDetail {
    
    private Long id;
    private Long tenantId;
    private Long orderId;
    private Long productId;
    private String productName;
    private Long skuId;
    private String skuName;
    private String barcode;
    private BigDecimal quantity;
    private String unit;
    private BigDecimal unitRatio;
    private BigDecimal price;
    private BigDecimal amount;
    private String remark;
    private LocalDateTime createTime;
    
    // Getter/Setter
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    
    public Long getTenantId() { return tenantId; }
    public void setTenantId(Long tenantId) { this.tenantId = tenantId; }
    
    public Long getOrderId() { return orderId; }
    public void setOrderId(Long orderId) { this.orderId = orderId; }
    
    public Long getProductId() { return productId; }
    public void setProductId(Long productId) { this.productId = productId; }
    
    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }
    
    public Long getSkuId() { return skuId; }
    public void setSkuId(Long skuId) { this.skuId = skuId; }
    
    public String getSkuName() { return skuName; }
    public void setSkuName(String skuName) { this.skuName = skuName; }
    
    public String getBarcode() { return barcode; }
    public void setBarcode(String barcode) { this.barcode = barcode; }
    
    public BigDecimal getQuantity() { return quantity; }
    public void setQuantity(BigDecimal quantity) { this.quantity = quantity; }
    
    public String getUnit() { return unit; }
    public void setUnit(String unit) { this.unit = unit; }
    
    public BigDecimal getUnitRatio() { return unitRatio; }
    public void setUnitRatio(BigDecimal unitRatio) { this.unitRatio = unitRatio; }
    
    public BigDecimal getPrice() { return price; }
    public void setPrice(BigDecimal price) { this.price = price; }
    
    public BigDecimal getAmount() { return amount; }
    public void setAmount(BigDecimal amount) { this.amount = amount; }
    
    public String getRemark() { return remark; }
    public void setRemark(String remark) { this.remark = remark; }
    
    public LocalDateTime getCreateTime() { return createTime; }
    public void setCreateTime(LocalDateTime createTime) { this.createTime = createTime; }
}