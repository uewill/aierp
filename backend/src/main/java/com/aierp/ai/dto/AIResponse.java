package com.aierp.ai.dto;

/**
 * AI响应结果
 */
public class AIResponse {
    
    private Long sessionId;
    private Long draftId;
    private AIParsedOrderDTO parsedOrder;
    private String replyMessage;
    private Boolean needConfirm;
    
    public Long getSessionId() { return sessionId; }
    public void setSessionId(Long sessionId) { this.sessionId = sessionId; }
    
    public Long getDraftId() { return draftId; }
    public void setDraftId(Long draftId) { this.draftId = draftId; }
    
    public AIParsedOrderDTO getParsedOrder() { return parsedOrder; }
    public void setParsedOrder(AIParsedOrderDTO parsedOrder) { this.parsedOrder = parsedOrder; }
    
    public String getReplyMessage() { return replyMessage; }
    public void setReplyMessage(String replyMessage) { this.replyMessage = replyMessage; }
    
    public Boolean getNeedConfirm() { return needConfirm; }
    public void setNeedConfirm(Boolean needConfirm) { this.needConfirm = needConfirm; }
}