package com.aierp.ai.config;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Configuration;

/**
 * AI 服务配置
 */
@Configuration
@ConfigurationProperties(prefix = "ai")
public class AIConfig {
    
    private String zhipuApiKey;
    private String zhipuApiUrl = "https://open.bigmodel.cn/api/paas/v4/chat/completions";
    private String model = "glm-4-flash";
    private boolean enabled = false;
    
    // Getter/Setter
    public String getZhipuApiKey() { return zhipuApiKey; }
    public void setZhipuApiKey(String zhipuApiKey) { this.zhipuApiKey = zhipuApiKey; }
    
    public String getZhipuApiUrl() { return zhipuApiUrl; }
    public void setZhipuApiUrl(String zhipuApiUrl) { this.zhipuApiUrl = zhipuApiUrl; }
    
    public String getModel() { return model; }
    public void setModel(String model) { this.model = model; }
    
    public boolean isEnabled() { return enabled; }
    public void setEnabled(boolean enabled) { this.enabled = enabled; }
    
    // 支持 yml 中的 zhipu-api-key 格式
    public String getZhipu_api_key() { return zhipuApiKey; }
    public void setZhipu_api_key(String zhipuApiKey) { this.zhipuApiKey = zhipuApiKey; }
    
    public String getZhipu_api_url() { return zhipuApiUrl; }
    public void setZhipu_api_url(String zhipuApiUrl) { this.zhipuApiUrl = zhipuApiUrl; }
}