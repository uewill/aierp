package com.aierp.system.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * 订阅记录实体
 */
@Data
@TableName("sys_subscription")
public class Subscription {
    
    @TableId(type = IdType.AUTO)
    private Long id;
    
    private Long tenantId;         // 租户ID
    private String plan;           // 套餐: basic/standard/premium
    private Integer months;        // 续费月数
    private BigDecimal amount;     // 支付金额
    
    private LocalDateTime startTime;  // 开始时间
    private LocalDateTime endTime;    // 结束时间
    
    private Integer payStatus;     // 支付状态: 0-待支付 1-已支付
    private String payMethod;      // 支付方式: wechat/alipay/bank/manual
    
    private String operator;       // 操作人
    private LocalDateTime createTime;
}