package com.aierp.common.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.LocalDateTime;

/**
 * 实体基类 - 所有业务表继承
 */
@Data
public abstract class BaseEntity {
    
    @TableId(type = IdType.ASSIGN_ID)
    private Long id;
    
    /** 租户ID（多租户核心字段） */
    private Long tenantId;
    
    /** 公司ID */
    private Long companyId;
    
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;
    
    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;
    
    @TableLogic
    private Integer deleted;
}