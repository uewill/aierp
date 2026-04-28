package com.aierp;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
@MapperScan("com.aierp.*.repository")
public class AierpApplication {
    public static void main(String[] args) {
        SpringApplication.run(AierpApplication.class, args);
        System.out.println("=== aierp 后端启动成功 ===");
        System.out.println("API文档: http://localhost:8090/doc.html");
    }
}