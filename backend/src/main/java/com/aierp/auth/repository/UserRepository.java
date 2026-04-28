package com.aierp.auth.repository;

import com.aierp.auth.entity.User;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

/**
 * 用户Repository
 */
@Mapper
public interface UserRepository extends BaseMapper<User> {
    
    /**
     * 根据租户ID和手机号查询用户
     */
    @Select("SELECT * FROM sys_user WHERE tenant_id = #{tenantId} AND phone = #{phone} AND deleted = 0")
    User findByTenantIdAndPhone(@Param("tenantId") Long tenantId, @Param("phone") String phone);
    
    /**
     * 根据手机号查询用户（不限租户，用于登录）
     */
    @Select("SELECT * FROM sys_user WHERE phone = #{phone} AND deleted = 0 LIMIT 1")
    User findByPhone(@Param("phone") String phone);
}