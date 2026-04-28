package com.aierp.ai.controller;

import com.aierp.ai.dto.AIResponse;
import com.aierp.ai.dto.AITextInputRequest;
import com.aierp.ai.service.AIService;
import com.aierp.ai.service.VoiceService;
import com.aierp.common.dto.ApiResponse;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.web.bind.annotation.*;

/**
 * AI智能录入API
 */
@Tag(name = "AI智能录入", description = "语音/文字/图片智能识别生成订单")
@RestController
@RequestMapping("/api/ai")
public class AIController {
    
    private final AIService aiService;
    private final VoiceService voiceService;
    
    public AIController(AIService aiService, VoiceService voiceService) {
        this.aiService = aiService;
        this.voiceService = voiceService;
    }
    
    /**
     * 文字输入解析订单
     */
    @Operation(summary = "文字输入解析订单")
    @PostMapping("/text-input")
    public ApiResponse<AIResponse> textInput(@RequestBody AITextInputRequest request) {
        AIResponse response = aiService.parseTextInput(request.getContent(), request.getOrderType());
        return ApiResponse.success(response);
    }
    
    /**
     * 语音识别录入
     * 
     * 接收音频文件URL，调用语音识别服务，返回解析结果
     */
    @Operation(summary = "语音识别录入")
    @PostMapping("/voice-input")
    public ApiResponse<AIResponse> voiceInput(
            @RequestParam String audioUrl) {
        
        // 1. 调用语音识别服务
        String recognizedText = voiceService.recognize(audioUrl);
        
        // 2. 调用 AI 解析服务
        AIResponse response = aiService.parseTextInput(recognizedText, null);
        
        return ApiResponse.success(response);
    }
    
    /**
     * 确认订单草稿
     */
    @Operation(summary = "确认订单草稿")
    @PostMapping("/draft/{id}/confirm")
    public ApiResponse<Long> confirmDraft(@PathVariable Long id) {
        Long orderId = aiService.confirmDraft(id);
        return ApiResponse.success(orderId);
    }
    
    /**
     * 拒绝订单草稿
     */
    @Operation(summary = "拒绝订单草稿")
    @PostMapping("/draft/{id}/reject")
    public ApiResponse<Void> rejectDraft(
            @PathVariable Long id,
            @RequestParam(required = false) String reason) {
        aiService.rejectDraft(id, reason);
        return ApiResponse.success();
    }
}