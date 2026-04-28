package com.aierp.business.repository;

import com.aierp.business.entity.ProductBarcode;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import java.util.List;

@Mapper
public interface ProductBarcodeRepository extends BaseMapper<ProductBarcode> {
    @Select("SELECT * FROM bas_product_barcode WHERE barcode = #{barcode} AND deleted = 0")
    ProductBarcode findByBarcode(@Param("barcode") String barcode);
    
    @Select("SELECT * FROM bas_product_barcode WHERE product_id = #{productId} AND deleted = 0")
    List<ProductBarcode> findByProductId(@Param("productId") Long productId);
}