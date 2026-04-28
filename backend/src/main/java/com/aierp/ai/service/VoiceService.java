package com.aierp.ai.service;

import com.aierp.ai.config.AIConfig;
import org.springframework.stereotype.Service;

/**
 * 语音识别服务 - 对接腾讯云/阿里云语音识别 API
 */
@Service
public class VoiceService {
    
    private final AIConfig aiConfig;
    
    public VoiceService(AIConfig aiConfig) {
        this.aiConfig = aiConfig;
    }
    
    /**
     * 识别语音文件
     */
    public String recognize(String audioUrl) {
        AIConfig.VoiceConfig voiceConfig = aiConfig.getVoice();
        
        if (!voiceConfig.isEnabled()) {
            return simulateRecognition(audioUrl);
        }
        
        switch (voiceConfig.getProvider()) {
            case "tencent":
                return tencentRecognition(audioUrl, voiceConfig);
            default:
                return simulateRecognition(audioUrl);
        }
    }
    
    private String tencentRecognition(String audioUrl, AIConfig.VoiceConfig config) {
        System.out.println("=== 腾讯云语音识别（待对接）: " + audioUrl + " ===");
        return "腾讯云语音识别结果（待对接）";
    }
    
    private String simulateRecognition(String audioUrl) {
        System.out.println("=== 模拟语音识别: " + audioUrl + " ===");
        return "销售可乐10箱@50元";
    }
}