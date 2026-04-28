package com.aierp.business.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * 单位换算表 - 多单位换算比率
 */
@TableName("bas_unit_conversion")
public class UnitConversion {
    
    private Long id;
    private Long tenantId;
    private Long companyId;
    private Long groupId;
    private String unitName;
    private String unitCode;
    private BigDecimal ratio; // 换算比率
    private Integer isBase;   // 是否基本单位
    private BigDecimal purchasePrice;
    private BigDecimal salePrice;
    private BigDecimal minPrice;
    private Integer status;
    private LocalDateTime createTime;
    private LocalDateTime updateTime;
    private Integer deleted;
    
    // Getter/Setter
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    
    public Long getGroupId() { return groupId; }
    public void setGroupId(Long groupId) { this.groupId = groupId; }
    
    public String getUnitName() { return unitName; }
    public void setUnitName(String unitName) { this.unitName = unitName; }
    
    public BigDecimal getRatio() { return ratio; }
    public void setRatio(BigDecimal ratio) { this.ratio = ratio; }
    
    public Integer getIsBase() { return isBase; }
    public void setIsBase(Integer isBase) { this.isBase = isBase; }
    
    public BigDecimal getSalePrice() { return salePrice; }
    public void setSalePrice(BigDecimal salePrice) { this.salePrice = salePrice; }
}