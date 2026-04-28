package com.aierp.ai.dto;

import java.util.List;
import java.util.ArrayList;

/**
 * AI订单解析结果DTO
 */
public class AIParsedOrderDTO {
    
    private String orderType;
    private String partnerName;
    private String warehouseName;
    private List<ParsedItem> items;
    private String remark;
    private Double confidence;
    private String parseMessage;
    
    public String getOrderType() { return orderType; }
    public void setOrderType(String orderType) { this.orderType = orderType; }
    
    public String getPartnerName() { return partnerName; }
    public void setPartnerName(String partnerName) { this.partnerName = partnerName; }
    
    public String getWarehouseName() { return warehouseName; }
    public void setWarehouseName(String warehouseName) { this.warehouseName = warehouseName; }
    
    public List<ParsedItem> getItems() { return items; }
    public void setItems(List<ParsedItem> items) { this.items = items; }
    
    public String getRemark() { return remark; }
    public void setRemark(String remark) { this.remark = remark; }
    
    public Double getConfidence() { return confidence; }
    public void setConfidence(Double confidence) { this.confidence = confidence; }
    
    public String getParseMessage() { return parseMessage; }
    public void setParseMessage(String parseMessage) { this.parseMessage = parseMessage; }
    
    /**
     * 解析的商品明细项
     */
    public static class ParsedItem {
        private String productName;
        private String barcode;
        private Double quantity;
        private String unit;
        private Double price;
        
        // 扩展字段：批次和序列号
        private String batchNo;      // 批次号
        private String serialNo;     // 序列号
        private String productionDate; // 生产日期
        private String expiryDate;   // 过期日期
        
        public String getProductName() { return productName; }
        public void setProductName(String productName) { this.productName = productName; }
        
        public String getBarcode() { return barcode; }
        public void setBarcode(String barcode) { this.barcode = barcode; }
        
        public Double getQuantity() { return quantity; }
        public void setQuantity(Double quantity) { this.quantity = quantity; }
        
        public String getUnit() { return unit; }
        public void setUnit(String unit) { this.unit = unit; }
        
        public Double getPrice() { return price; }
        public void setPrice(Double price) { this.price = price; }
        
        public String getBatchNo() { return batchNo; }
        public void setBatchNo(String batchNo) { this.batchNo = batchNo; }
        
        public String getSerialNo() { return serialNo; }
        public void setSerialNo(String serialNo) { this.serialNo = serialNo; }
        
        public String getProductionDate() { return productionDate; }
        public void setProductionDate(String productionDate) { this.productionDate = productionDate; }
        
        public String getExpiryDate() { return expiryDate; }
        public void setExpiryDate(String expiryDate) { this.expiryDate = expiryDate; }
    }
}