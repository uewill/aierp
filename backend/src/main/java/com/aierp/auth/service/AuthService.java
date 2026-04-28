package com.aierp.auth.service;

import com.aierp.auth.dto.LoginResponse;
import com.aierp.auth.dto.LoginResponse.CompanyInfo;
import com.aierp.auth.entity.User;
import com.aierp.auth.entity.VerifyCode;
import com.aierp.auth.repository.UserRepository;
import com.aierp.auth.repository.VerifyCodeRepository;
import com.aierp.common.util.JwtUtil;
import com.aierp.common.util.TenantContext;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.Random;

/**
 * 认证服务
 */
@Service
public class AuthService {
    
    private final UserRepository userRepository;
    private final VerifyCodeRepository verifyCodeRepository;
    private final JwtUtil jwtUtil;
    
    public AuthService(UserRepository userRepository, 
                       VerifyCodeRepository verifyCodeRepository,
                       JwtUtil jwtUtil) {
        this.userRepository = userRepository;
        this.verifyCodeRepository = verifyCodeRepository;
        this.jwtUtil = jwtUtil;
    }
    
    /**
     * 发送验证码
     */
    public void sendCode(String phone, String type) {
        String code = String.format("%06d", new Random().nextInt(1000000));
        
        VerifyCode verifyCode = new VerifyCode();
        verifyCode.setPhone(phone);
        verifyCode.setCode(code);
        verifyCode.setType(type);
        verifyCode.setExpireTime(LocalDateTime.now().plusMinutes(5));
        verifyCode.setUsed(0);
        verifyCodeRepository.insert(verifyCode);
        
        System.out.println("=== 开发模式：验证码 = " + code + " ===");
    }
    
    /**
     * 手机号验证码登录
     */
    @Transactional
    public LoginResponse login(String phone, String code) {
        // 开发模式：支持固定验证码1234
        if ("1234".equals(code)) {
            System.out.println("=== 开发模式：使用固定验证码1234登录 ===");
        } else {
            VerifyCode verifyCode = verifyCodeRepository.findLatestValidCode(phone, "LOGIN");
            if (verifyCode == null || !verifyCode.getCode().equals(code)) {
                throw new RuntimeException("验证码无效或已过期");
            }
            
            verifyCode.setUsed(1);
            verifyCodeRepository.updateById(verifyCode);
        }
        
        User user = userRepository.findByPhone(phone);
        
        if (user == null) {
            user = registerNewUser(phone);
        }
        
        user.setLastLoginTime(LocalDateTime.now());
        userRepository.updateById(user);
        
        String token = jwtUtil.generateToken(
            user.getId(), 
            user.getTenantId(), 
            user.getCompanyId(), 
            user.getPhone()
        );
        
        LoginResponse response = new LoginResponse();
        response.setToken(token);
        response.setUserId(user.getId());
        response.setTenantId(user.getTenantId());
        response.setCompanyId(user.getCompanyId());
        response.setPhone(user.getPhone());
        response.setNickname(user.getNickname());
        response.setAvatar(user.getAvatar());
        response.setRole(user.getRole());
        
        return response;
    }
    
    private User registerNewUser(String phone) {
        Long tenantId = System.currentTimeMillis();
        Long companyId = tenantId + 1;
        
        User user = new User();
        user.setTenantId(tenantId);
        user.setCompanyId(companyId);
        user.setPhone(phone);
        user.setNickname("用户" + phone.substring(phone.length() - 4));
        user.setRole("ADMIN");
        user.setStatus(1);
        userRepository.insert(user);
        
        System.out.println("=== 自动注册新用户: phone=" + phone + " ===");
        
        return user;
    }
    
    public LoginResponse switchCompany(Long userId, Long companyId) {
        User user = userRepository.selectById(userId);
        if (user == null) {
            throw new RuntimeException("用户不存在");
        }
        
        user.setCompanyId(companyId);
        userRepository.updateById(user);
        
        String token = jwtUtil.generateToken(
            user.getId(), 
            user.getTenantId(), 
            companyId, 
            user.getPhone()
        );
        
        LoginResponse response = new LoginResponse();
        response.setToken(token);
        response.setUserId(user.getId());
        response.setTenantId(user.getTenantId());
        response.setCompanyId(companyId);
        response.setPhone(user.getPhone());
        response.setNickname(user.getNickname());
        response.setRole(user.getRole());
        
        return response;
    }
    
    /**
     * 获取当前登录用户信息（从JWT Token）
     */
    public LoginResponse getCurrentUserInfo() {
        Long userId = TenantContext.getUserId();
        if (userId == null) {
            throw new RuntimeException("未登录");
        }
        
        User user = userRepository.selectById(userId);
        if (user == null) {
            throw new RuntimeException("用户不存在");
        }
        
        LoginResponse response = new LoginResponse();
        response.setUserId(user.getId());
        response.setTenantId(user.getTenantId());
        response.setCompanyId(user.getCompanyId());
        response.setPhone(user.getPhone());
        response.setNickname(user.getNickname());
        response.setAvatar(user.getAvatar());
        response.setRole(user.getRole());
        
        return response;
    }
}