package com.aierp.business.repository;

import com.aierp.business.entity.PurchaseOrderDetail;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Mapper;

/**
 * 采购单明细Repository
 */
@Mapper
public interface PurchaseOrderDetailRepository extends BaseMapper<PurchaseOrderDetail> {
}