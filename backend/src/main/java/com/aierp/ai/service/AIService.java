package com.aierp.ai.service;

import com.aierp.ai.config.AIConfig;
import com.aierp.ai.dto.AIParsedOrderDTO;
import com.aierp.ai.dto.AIResponse;
import com.aierp.ai.entity.AIMessage;
import com.aierp.ai.entity.AIOrderDraft;
import com.aierp.ai.entity.AISession;
import com.aierp.ai.repository.AIMessageRepository;
import com.aierp.ai.repository.AIOrderDraftRepository;
import com.aierp.ai.repository.AISessionRepository;
import com.aierp.common.util.TenantContext;
import com.alibaba.fastjson2.JSON;
import com.alibaba.fastjson2.JSONArray;
import com.alibaba.fastjson2.JSONObject;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.*;

/**
 * AI智能录入服务 - 支持智谱 GLM-4 或规则引擎
 */
@Service
public class AIService {
    
    private final AISessionRepository sessionRepository;
    private final AIMessageRepository messageRepository;
    private final AIOrderDraftRepository draftRepository;
    private final GLMService glmService;
    private final AIConfig aiConfig;
    
    public AIService(AISessionRepository sessionRepository,
                     AIMessageRepository messageRepository,
                     AIOrderDraftRepository draftRepository,
                     GLMService glmService,
                     AIConfig aiConfig) {
        this.sessionRepository = sessionRepository;
        this.messageRepository = messageRepository;
        this.draftRepository = draftRepository;
        this.glmService = glmService;
        this.aiConfig = aiConfig;
    }
    
    @Transactional
    public AIResponse parseTextInput(String content, String orderType) {
        AISession session = createSession("TEXT");
        
        AIMessage userMessage = new AIMessage();
        userMessage.setSessionId(session.getId());
        userMessage.setTenantId(TenantContext.getTenantId());
        userMessage.setRole("USER");
        userMessage.setContent(content);
        userMessage.setContentType("TEXT");
        messageRepository.insert(userMessage);
        
        AIParsedOrderDTO parsedOrder = doParseText(content, orderType);
        
        AIMessage aiMessage = new AIMessage();
        aiMessage.setSessionId(session.getId());
        aiMessage.setTenantId(TenantContext.getTenantId());
        aiMessage.setRole("ASSISTANT");
        aiMessage.setContent("已识别订单，请确认");
        aiMessage.setIntent("CREATE_ORDER");
        aiMessage.setParsedData(JSON.toJSONString(parsedOrder));
        messageRepository.insert(aiMessage);
        
        AIOrderDraft draft = createDraft(session.getId(), parsedOrder);
        
        AIResponse response = new AIResponse();
        response.setSessionId(session.getId());
        response.setDraftId(draft.getId());
        response.setParsedOrder(parsedOrder);
        response.setReplyMessage(buildReplyMessage(parsedOrder));
        response.setNeedConfirm(true);
        
        session.setStatus("COMPLETED");
        session.setEndTime(LocalDateTime.now());
        sessionRepository.updateById(session);
        
        return response;
    }
    
    @Transactional
    public Long confirmDraft(Long draftId) {
        AIOrderDraft draft = draftRepository.selectById(draftId);
        if (draft == null) {
            throw new RuntimeException("草稿不存在");
        }
        
        draft.setStatus("CONFIRMED");
        draft.setConfirmTime(LocalDateTime.now());
        draftRepository.updateById(draft);
        
        return draft.getConfirmedOrderId();
    }
    
    public void rejectDraft(Long draftId, String reason) {
        AIOrderDraft draft = draftRepository.selectById(draftId);
        if (draft == null) {
            throw new RuntimeException("草稿不存在");
        }
        
        draft.setStatus("REJECTED");
        draft.setRemark(reason);
        draftRepository.updateById(draft);
    }
    
    private AISession createSession(String sessionType) {
        AISession session = new AISession();
        session.setTenantId(TenantContext.getTenantId());
        session.setCompanyId(TenantContext.getCompanyId());
        session.setUserId(TenantContext.getUserId());
        session.setSessionType(sessionType);
        session.setStatus("ACTIVE");
        sessionRepository.insert(session);
        return session;
    }
    
    private AIOrderDraft createDraft(Long sessionId, AIParsedOrderDTO parsedOrder) {
        AIOrderDraft draft = new AIOrderDraft();
        draft.setTenantId(TenantContext.getTenantId());
        draft.setCompanyId(TenantContext.getCompanyId());
        draft.setUserId(TenantContext.getUserId());
        draft.setSessionId(sessionId);
        draft.setOrderType(parsedOrder.getOrderType());
        draft.setDraftData(JSON.toJSONString(parsedOrder));
        draft.setConfidence(BigDecimal.valueOf(parsedOrder.getConfidence()));
        draft.setStatus("DRAFT");
        draftRepository.insert(draft);
        return draft;
    }
    
    private AIParsedOrderDTO doParseText(String content, String orderType) {
        AIParsedOrderDTO result = new AIParsedOrderDTO();
        
        // 先尝试调用智谱 GLM-4
        if (aiConfig.isEnabled()) {
            String glmResult = glmService.parseOrderContent(content, orderType);
            if (glmResult != null) {
                try {
                    // 解析 GLM 返回的 JSON
                    JSONObject json = JSON.parseObject(glmResult);
                    result.setOrderType(json.getString("orderType"));
                    result.setPartnerName(json.getString("partnerName"));
                    result.setRemark(json.getString("remark"));
                    result.setConfidence(json.getDouble("confidence"));
                    
                    // 解析商品明细
                    List<AIParsedOrderDTO.ParsedItem> items = new ArrayList<>();
                    JSONArray itemsArray = json.getJSONArray("items");
                    if (itemsArray != null) {
                        for (int i = 0; i < itemsArray.size(); i++) {
                            JSONObject itemJson = itemsArray.getJSONObject(i);
                            AIParsedOrderDTO.ParsedItem item = new AIParsedOrderDTO.ParsedItem();
                            item.setProductName(itemJson.getString("productName"));
                            item.setQuantity(itemJson.getDouble("quantity"));
                            item.setUnit(itemJson.getString("unit"));
                            item.setPrice(itemJson.getDouble("price"));
                            items.add(item);
                        }
                    }
                    result.setItems(items);
                    result.setParseMessage("GLM-4 智能解析成功");
                    return result;
                } catch (Exception e) {
                    System.err.println("解析 GLM 结果失败: " + e.getMessage());
                }
            }
        }
        
        // GLM 未启用或失败，使用规则引擎
        List<AIParsedOrderDTO.ParsedItem> items = new ArrayList<>();
        
        if (orderType == null) {
            if (content.contains("销售") || content.contains("卖给") || content.contains("客户")) {
                orderType = "SALES";
            } else if (content.contains("采购") || content.contains("进货") || content.contains("供应商")) {
                orderType = "PURCHASE";
            } else {
                orderType = "SALES";
            }
        }
        result.setOrderType(orderType);
        
        String partnerName = extractPartnerName(content, orderType);
        result.setPartnerName(partnerName);
        
        items = extractItems(content);
        result.setItems(items);
        
        result.setConfidence(items.isEmpty() ? 30.0 : 85.0);
        result.setParseMessage(items.isEmpty() ? "未识别到商品信息" : "规则引擎解析成功");
        
        return result;
    }
    
    private String extractPartnerName(String content, String orderType) {
        if (orderType.equals("SALES")) {
            if (content.contains("卖给")) {
                int idx = content.indexOf("卖给");
                String after = content.substring(idx + 2);
                int end = Math.min(
                    after.indexOf("：") > 0 ? after.indexOf("：") : 999,
                    after.indexOf(":") > 0 ? after.indexOf(":") : 999
                );
                if (end > 0 && end < 10) {
                    return after.substring(0, end).trim();
                }
            }
        }
        return null;
    }
    
    private List<AIParsedOrderDTO.ParsedItem> extractItems(String content) {
        List<AIParsedOrderDTO.ParsedItem> items = new ArrayList<>();
        String[] parts = content.split("[，,;；]");
        
        for (String part : parts) {
            AIParsedOrderDTO.ParsedItem item = parseItemPart(part);
            if (item != null) {
                items.add(item);
            }
        }
        
        return items;
    }
    
    private AIParsedOrderDTO.ParsedItem parseItemPart(String part) {
        if (part.contains("卖给") || part.contains("来自") || part.contains("供应商") || part.contains("客户")) {
            return null;
        }
        
        AIParsedOrderDTO.ParsedItem item = new AIParsedOrderDTO.ParsedItem();
        
        java.util.regex.Pattern p1 = java.util.regex.Pattern.compile(
            "(.+?)(\\d+)(箱|瓶|件|袋|盒|个|公斤|斤|克|吨)(@|单价)?(\\d+\\.?\\d*)?(元)?"
        );
        java.util.regex.Matcher m1 = p1.matcher(part);
        
        if (m1.find()) {
            item.setProductName(m1.group(1).trim());
            item.setQuantity(Double.parseDouble(m1.group(2)));
            item.setUnit(m1.group(3));
            if (m1.group(5) != null) {
                item.setPrice(Double.parseDouble(m1.group(5)));
            }
            return item;
        }
        
        return null;
    }
    
    private String buildReplyMessage(AIParsedOrderDTO parsedOrder) {
        StringBuilder sb = new StringBuilder();
        sb.append("已识别").append(parsedOrder.getOrderType().equals("SALES") ? "销售单" : "采购单").append("：\n");
        
        if (parsedOrder.getPartnerName() != null) {
            sb.append("客户/供应商：").append(parsedOrder.getPartnerName()).append("\n");
        }
        
        sb.append("商品明细：\n");
        for (AIParsedOrderDTO.ParsedItem item : parsedOrder.getItems()) {
            sb.append("- ").append(item.getProductName())
              .append(" ").append(item.getQuantity()).append(item.getUnit());
            if (item.getPrice() != null) {
                sb.append(" @").append(item.getPrice()).append("元");
            }
            sb.append("\n");
        }
        
        sb.append("置信度：").append(parsedOrder.getConfidence()).append("%\n");
        sb.append("请确认后生成订单");
        
        return sb.toString();
    }
}