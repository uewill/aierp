package com.aierp.business.repository;

import com.aierp.business.entity.UnitGroup;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

@Mapper
public interface UnitGroupRepository extends BaseMapper<UnitGroup> {
    @Select("SELECT * FROM bas_unit_group WHERE product_id = #{productId} AND deleted = 0")
    UnitGroup findByProductId(@Param("productId") Long productId);
}