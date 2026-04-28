package com.aierp.business.repository;

import com.aierp.business.entity.PurchaseOrder;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Mapper;

/**
 * 采购单Repository
 */
@Mapper
public interface PurchaseOrderRepository extends BaseMapper<PurchaseOrder> {
}