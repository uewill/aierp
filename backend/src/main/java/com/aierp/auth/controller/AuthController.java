package com.aierp.auth.controller;

import com.aierp.auth.dto.*;
import com.aierp.auth.service.AuthService;
import com.aierp.common.dto.ApiResponse;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

/**
 * 认证API - 手机号注册/登录
 */
@Tag(name = "认证API", description = "手机号验证码登录/注册")
@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
public class AuthController {
    
    private final AuthService authService;
    
    /**
     * 发送验证码
     */
    @Operation(summary = "发送验证码")
    @PostMapping("/send-code")
    public ApiResponse<Void> sendCode(@Valid @RequestBody SendCodeRequest request) {
        authService.sendCode(request.getPhone(), request.getType());
        return ApiResponse.success();
    }
    
    /**
     * 手机号验证码登录（自动注册）
     */
    @Operation(summary = "手机号登录")
    @PostMapping("/login")
    public ApiResponse<LoginResponse> login(@Valid @RequestBody LoginRequest request) {
        LoginResponse response = authService.login(request.getPhone(), request.getCode());
        return ApiResponse.success(response);
    }
    
    /**
     * 切换公司
     */
    @Operation(summary = "切换公司")
    @PostMapping("/switch-company")
    public ApiResponse<LoginResponse> switchCompany(
            @RequestParam Long userId,
            @RequestParam Long companyId) {
        LoginResponse response = authService.switchCompany(userId, companyId);
        return ApiResponse.success(response);
    }
}