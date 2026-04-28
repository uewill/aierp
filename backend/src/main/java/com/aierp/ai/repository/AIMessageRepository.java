package com.aierp.ai.repository;

import com.aierp.ai.entity.AIMessage;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface AIMessageRepository extends BaseMapper<AIMessage> {}