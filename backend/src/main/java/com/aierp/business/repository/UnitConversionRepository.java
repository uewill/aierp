package com.aierp.business.repository;

import com.aierp.business.entity.UnitConversion;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import java.util.List;

@Mapper
public interface UnitConversionRepository extends BaseMapper<UnitConversion> {
    @Select("SELECT * FROM bas_unit_conversion WHERE group_id = #{groupId} AND deleted = 0 ORDER BY is_base DESC")
    List<UnitConversion> findByGroupId(@Param("groupId") Long groupId);
}