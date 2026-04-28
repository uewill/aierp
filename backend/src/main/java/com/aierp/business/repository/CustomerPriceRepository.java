package com.aierp.business.repository;

import com.aierp.business.entity.CustomerPrice;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

@Mapper
public interface CustomerPriceRepository extends BaseMapper<CustomerPrice> {
    @Select("SELECT * FROM bas_customer_price WHERE customer_id = #{customerId} AND product_id = #{productId} AND deleted = 0")
    CustomerPrice findByCustomerAndProduct(@Param("customerId") Long customerId, @Param("productId") Long productId);
}