package com.aierp.auth.repository;

import com.aierp.auth.entity.VerifyCode;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

/**
 * 验证码Repository
 */
@Mapper
public interface VerifyCodeRepository extends BaseMapper<VerifyCode> {
    
    /**
     * 查询最新有效验证码
     */
    @Select("SELECT * FROM sys_verify_code WHERE phone = #{phone} AND type = #{type} AND used = 0 AND expire_time > NOW() ORDER BY create_time DESC LIMIT 1")
    VerifyCode findLatestValidCode(@Param("phone") String phone, @Param("type") String type);
}