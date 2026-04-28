package com.aierp.ai.controller;

import com.aierp.ai.dto.*;
import com.aierp.ai.service.AIService;
import com.aierp.common.dto.ApiResponse;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

/**
 * AI智能录入API - 核心特色功能
 */
@Tag(name = "AI智能录入", description = "语音/文字/图片智能识别生成订单")
@RestController
@RequestMapping("/api/ai")
@RequiredArgsConstructor
public class AIController {
    
    private final AIService aiService;
    
    /**
     * 文字输入解析订单
     * 
     * 示例输入：
     * - "销售给张三：可乐10箱@50元，矿泉水5瓶@3元"
     * - "采购：可乐20箱@45元，来自李四供应商"
     */
    @Operation(summary = "文字输入解析订单")
    @PostMapping("/text-input")
    public ApiResponse<AIResponse> textInput(@Valid @RequestBody AITextInputRequest request) {
        AIResponse response = aiService.parseTextInput(request.getContent(), request.getOrderType());
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
    
    /**
     * 语音识别录入（待对接语音服务）
     * TODO: 对接腾讯云/阿里云语音识别
     */
    @Operation(summary = "语音识别录入（待开发）")
    @PostMapping("/voice-input")
    public ApiResponse<AIResponse> voiceInput() {
        // TODO: 接收音频文件，调用语音识别API，解析文本
        return ApiResponse.error("语音识别功能待对接");
    }
    
    /**
     * 图片识别录入（待对接OCR服务）
     * TODO: 对接腾讯云/阿里云OCR
     */
    @Operation(summary = "图片识别录入（待开发）")
    @PostMapping("/image-input")
    public ApiResponse<AIResponse> imageInput() {
        // TODO: 接收图片文件，调用OCR API，识别单据内容
        return ApiResponse.error("图片识别功能待对接");
    }
}