package com.aierp.business.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import com.baomidou.mybatisplus.annotation.TableField;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

/**
 * 采购单实体
 */
@TableName("biz_purchase_order")
public class PurchaseOrder {
    
    private Long id;
    private Long tenantId;
    private Long companyId;
    private String orderNo;
    private Long supplierId;
    private String supplierName;
    private Long warehouseId;
    private String warehouseName;
    private BigDecimal totalAmount;
    private BigDecimal paidAmount;
    private String status;
    private LocalDate orderDate;
    private Long operatorId;
    private String operatorName;
    private String remark;
    private String aiSource;
    private Long aiSessionId;
    private LocalDateTime createTime;
    private LocalDateTime updateTime;
    private Integer deleted;
    
    /**
     * 采购单明细（非数据库字段）
     */
    @TableField(exist = false)
    private List<PurchaseOrderDetail> details;
    
    // Getter/Setter
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    
    public Long getTenantId() { return tenantId; }
    public void setTenantId(Long tenantId) { this.tenantId = tenantId; }
    
    public Long getCompanyId() { return companyId; }
    public void setCompanyId(Long companyId) { this.companyId = companyId; }
    
    public String getOrderNo() { return orderNo; }
    public void setOrderNo(String orderNo) { this.orderNo = orderNo; }
    
    public Long getSupplierId() { return supplierId; }
    public void setSupplierId(Long supplierId) { this.supplierId = supplierId; }
    
    public String getSupplierName() { return supplierName; }
    public void setSupplierName(String supplierName) { this.supplierName = supplierName; }
    
    public Long getWarehouseId() { return warehouseId; }
    public void setWarehouseId(Long warehouseId) { this.warehouseId = warehouseId; }
    
    public String getWarehouseName() { return warehouseName; }
    public void setWarehouseName(String warehouseName) { this.warehouseName = warehouseName; }
    
    public BigDecimal getTotalAmount() { return totalAmount; }
    public void setTotalAmount(BigDecimal totalAmount) { this.totalAmount = totalAmount; }
    
    public BigDecimal getPaidAmount() { return paidAmount; }
    public void setPaidAmount(BigDecimal paidAmount) { this.paidAmount = paidAmount; }
    
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    
    public LocalDate getOrderDate() { return orderDate; }
    public void setOrderDate(LocalDate orderDate) { this.orderDate = orderDate; }
    
    public Long getOperatorId() { return operatorId; }
    public void setOperatorId(Long operatorId) { this.operatorId = operatorId; }
    
    public String getOperatorName() { return operatorName; }
    public void setOperatorName(String operatorName) { this.operatorName = operatorName; }
    
    public String getRemark() { return remark; }
    public void setRemark(String remark) { this.remark = remark; }
    
    public String getAiSource() { return aiSource; }
    public void setAiSource(String aiSource) { this.aiSource = aiSource; }
    
    public Long getAiSessionId() { return aiSessionId; }
    public void setAiSessionId(Long aiSessionId) { this.aiSessionId = aiSessionId; }
    
    public LocalDateTime getCreateTime() { return createTime; }
    public void setCreateTime(LocalDateTime createTime) { this.createTime = createTime; }
    
    public LocalDateTime getUpdateTime() { return updateTime; }
    public void setUpdateTime(LocalDateTime updateTime) { this.updateTime = updateTime; }
    
    public Integer getDeleted() { return deleted; }
    public void setDeleted(Integer deleted) { this.deleted = deleted; }
    
    public List<PurchaseOrderDetail> getDetails() { return details; }
    public void setDetails(List<PurchaseOrderDetail> details) { this.details = details; }
}