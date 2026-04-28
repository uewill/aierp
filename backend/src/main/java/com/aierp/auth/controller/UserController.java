package com.aierp.auth.controller;

import com.aierp.auth.dto.LoginRequest;
import com.aierp.auth.dto.LoginResponse;
import com.aierp.common.dto.ApiResponse;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.web.bind.annotation.*;

/**
 * 用户API - 前端兼容接口
 */
@Tag(name = "用户API", description = "用户信息接口")
@RestController
@RequestMapping("/api/user")
public class UserController {
    
    /**
     * 获取用户信息（前端兼容）
     */
    @Operation(summary = "获取用户信息")
    @PostMapping("/info")
    public ApiResponse<LoginResponse> getUserInfo() {
        LoginResponse response = new LoginResponse();
        response.setUserId(1L);
        response.setNickname("测试用户");
        response.setPhone("18190780080");
        response.setRole("ADMIN");
        return ApiResponse.success(response);
    }
    
    /**
     * 登录（前端兼容）- 调用验证码登录
     */
    @PostMapping("/login")
    public ApiResponse<LoginResponse> login(@RequestBody LoginRequest request) {
        // 暂不实现，前端已改为验证码登录
        LoginResponse response = new LoginResponse();
        response.setNickname("请使用验证码登录");
        return ApiResponse.success(response);
    }
    
    /**
     * 登出（前端兼容）
     */
    @PostMapping("/logout")
    public ApiResponse<Void> logout() {
        return ApiResponse.success();
    }
    
    /**
     * 获取菜单（前端兼容）
     */
    @PostMapping("/menu")
    public ApiResponse<Object[]> getMenu() {
        return ApiResponse.success(new Object[0]);
    }
}