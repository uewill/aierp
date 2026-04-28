package com.aierp.business.repository;

import com.aierp.business.entity.Inventory;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Mapper;

/**
 * 库存Repository
 */
@Mapper
public interface InventoryRepository extends BaseMapper<Inventory> {
}