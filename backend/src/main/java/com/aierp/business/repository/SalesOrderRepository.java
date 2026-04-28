package com.aierp.business.repository;

import com.aierp.business.entity.SalesOrder;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface SalesOrderRepository extends BaseMapper<SalesOrder> {}