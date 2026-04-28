package com.aierp.business.repository;

import com.aierp.business.entity.Batch;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import java.util.List;

@Mapper
public interface BatchRepository extends BaseMapper<Batch> {
    @Select("SELECT * FROM biz_batch WHERE product_id = #{productId} AND warehouse_id = #{warehouseId} AND quantity > 0 AND deleted = 0 ORDER BY expiry_date ASC")
    List<Batch> findAvailableBatches(@Param("productId") Long productId, @Param("warehouseId") Long warehouseId);
}