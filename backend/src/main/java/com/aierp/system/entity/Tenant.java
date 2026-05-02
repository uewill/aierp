package com.aierp.system.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 租户实体
 */
@Data
@TableName("sys_tenant")
public class Tenant {
    
    @TableId(type = IdType.AUTO)
    private Long id;
    
    private String name;           // 租户名称
    private String contactName;    // 联系人
    private String contactPhone;   // 联系电话
    private String contactEmail;   // 联系邮箱
    private String address;        // 地址
    
    private String subscriptionPlan; // 订阅套餐: basic/standard/premium
    private LocalDateTime expireTime; // 到期时间
    
    private Integer status;        // 状态: 0-禁用 1-正常 2-欠费
    private Integer autoRenew;     // 自动续费: 0-否 1-是
    
    private LocalDateTime createTime;
    private LocalDateTime updateTime;
}