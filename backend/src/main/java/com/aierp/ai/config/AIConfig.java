package com.aierp.ai.config;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Configuration;

/**
 * AI 服务聚合配置
 */
@Configuration
@ConfigurationProperties(prefix = "ai")
public class AIConfig {
    
    private String zhipuApiKey;
    private String zhipuApiUrl = "https://open.bigmodel.cn/api/paas/v4/chat/completions";
    private String model = "glm-4-flash";
    private boolean enabled = false;
    
    private VoiceConfig voice = new VoiceConfig();
    
    // Getter/Setter
    public String getZhipuApiKey() { return zhipuApiKey; }
    public void setZhipuApiKey(String zhipuApiKey) { this.zhipuApiKey = zhipuApiKey; }
    
    public String getZhipuApiUrl() { return zhipuApiUrl; }
    public void setZhipuApiUrl(String zhipuApiUrl) { this.zhipuApiUrl = zhipuApiUrl; }
    
    public String getModel() { return model; }
    public void setModel(String model) { this.model = model; }
    
    public boolean isEnabled() { return enabled; }
    public void setEnabled(boolean enabled) { this.enabled = enabled; }
    
    public VoiceConfig getVoice() { return voice; }
    public void setVoice(VoiceConfig voice) { this.voice = voice; }
    
    // 支持 yml 中的 kebab-case
    public String getZhipu_api_key() { return zhipuApiKey; }
    public void setZhipu_api_key(String key) { this.zhipuApiKey = key; }
    
    /**
     * 语音识别配置（内部类）
     */
    public static class VoiceConfig {
        
        private boolean enabled = false;
        private String provider = "local";
        private String tencentAppId;
        private String tencentSecretId;
        private String tencentSecretKey;
        
        public boolean isEnabled() { return enabled; }
        public void setEnabled(boolean enabled) { this.enabled = enabled; }
        
        public String getProvider() { return provider; }
        public void setProvider(String provider) { this.provider = provider; }
        
        public String getTencentAppId() { return tencentAppId; }
        public void setTencentAppId(String appId) { this.tencentAppId = appId; }
        
        public String getTencentSecretId() { return tencentSecretId; }
        public void setTencentSecretId(String id) { this.tencentSecretId = id; }
        
        public String getTencentSecretKey() { return tencentSecretKey; }
        public void setTencentSecretKey(String key) { this.tencentSecretKey = key; }
        
        // kebab-case
        public String getTencent_app_id() { return tencentAppId; }
        public void setTencent_app_id(String id) { this.tencentAppId = id; }
        
        public String getTencent_secret_id() { return tencentSecretId; }
        public void setTencent_secret_id(String id) { this.tencentSecretId = id; }
        
        public String getTencent_secret_key() { return tencentSecretKey; }
        public void setTencent_secret_key(String key) { this.tencentSecretKey = key; }
    }
}