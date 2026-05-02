package com.aierp.system.repository;

import com.aierp.system.entity.Subscription;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import java.util.List;

/**
 * 订阅Repository
 */
@Mapper
public interface SubscriptionRepository extends BaseMapper<Subscription> {
    
    /**
     * 查询租户的订阅记录
     */
    @Select("SELECT * FROM sys_subscription WHERE tenant_id = #{tenantId} ORDER BY create_time DESC")
    List<Subscription> findByTenantId(Long tenantId);
}