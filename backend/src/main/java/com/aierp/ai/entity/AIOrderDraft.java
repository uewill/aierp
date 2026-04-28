package com.aierp.ai.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * AI订单草稿
 */
@TableName("ai_order_draft")
public class AIOrderDraft {
    
    private Long id;
    private Long tenantId;
    private Long companyId;
    private Long userId;
    private Long sessionId;
    private String orderType;
    private String draftData;
    private BigDecimal confidence;
    private String status;
    private Long confirmedOrderId;
    private String remark;
    private LocalDateTime createTime;
    private LocalDateTime confirmTime;
    
    // Getter/Setter
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    
    public Long getTenantId() { return tenantId; }
    public void setTenantId(Long tenantId) { this.tenantId = tenantId; }
    
    public Long getCompanyId() { return companyId; }
    public void setCompanyId(Long companyId) { this.companyId = companyId; }
    
    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }
    
    public Long getSessionId() { return sessionId; }
    public void setSessionId(Long sessionId) { this.sessionId = sessionId; }
    
    public String getOrderType() { return orderType; }
    public void setOrderType(String orderType) { this.orderType = orderType; }
    
    public String getDraftData() { return draftData; }
    public void setDraftData(String draftData) { this.draftData = draftData; }
    
    public BigDecimal getConfidence() { return confidence; }
    public void setConfidence(BigDecimal confidence) { this.confidence = confidence; }
    
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    
    public Long getConfirmedOrderId() { return confirmedOrderId; }
    public void setConfirmedOrderId(Long confirmedOrderId) { this.confirmedOrderId = confirmedOrderId; }
    
    public String getRemark() { return remark; }
    public void setRemark(String remark) { this.remark = remark; }
    
    public LocalDateTime getCreateTime() { return createTime; }
    public void setCreateTime(LocalDateTime createTime) { this.createTime = createTime; }
    
    public LocalDateTime getConfirmTime() { return confirmTime; }
    public void setConfirmTime(LocalDateTime confirmTime) { this.confirmTime = confirmTime; }
}