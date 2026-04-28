package com.aierp.business.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * 商品条码表 - 多条码管理
 */
@TableName("bas_product_barcode")
public class ProductBarcode {
    
    private Long id;
    private Long tenantId;
    private Long companyId;
    private String barcode;
    private Long productId;
    private Long skuId;
    
    // 条码信息
    private String barcodeType; // STANDARD/INTERNAL/CUSTOM
    private Integer isMain;     // 是否主条码
    
    // 单位价格信息
    private String unitName;
    private BigDecimal unitRatio;
    private BigDecimal purchasePrice;
    private BigDecimal salePrice;
    
    // 包装信息
    private String packageSpec;
    private BigDecimal packageQuantity;
    
    private Integer status;
    private String remark;
    private LocalDateTime createTime;
    private LocalDateTime updateTime;
    private Integer deleted;
    
    // Getter/Setter
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    
    public String getBarcode() { return barcode; }
    public void setBarcode(String barcode) { this.barcode = barcode; }
    
    public Long getProductId() { return productId; }
    public void setProductId(Long productId) { this.productId = productId; }
    
    public BigDecimal getSalePrice() { return salePrice; }
    public void setSalePrice(BigDecimal salePrice) { this.salePrice = salePrice; }
    
    public Integer getIsMain() { return isMain; }
    public void setIsMain(Integer isMain) { this.isMain = isMain; }
}