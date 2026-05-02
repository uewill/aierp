package com.aierp.system.repository;

import com.aierp.system.entity.Tenant;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import java.util.List;

/**
 * 租户Repository
 */
@Mapper
public interface TenantRepository extends BaseMapper<Tenant> {
    
    /**
     * 查询即将到期的租户（30天内）
     */
    @Select("SELECT * FROM sys_tenant WHERE expire_time <= NOW() + INTERVAL 30 DAY AND status = 1")
    List<Tenant> findExpiringTenants();
    
    /**
     * 查询已欠费的租户
     */
    @Select("SELECT * FROM sys_tenant WHERE expire_time < NOW() AND status = 2")
    List<Tenant> findOverdueTenants();
}