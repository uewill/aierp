package com.aierp.business.controller;

import com.aierp.business.entity.*;
import com.aierp.business.repository.*;
import com.aierp.business.service.*;
import com.aierp.common.dto.*;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 业务API - 商品/往来单位/仓库/销售单
 */
@Tag(name = "业务API", description = "商品/客户/供应商/仓库/销售单管理")
@RestController
@RequestMapping("/api/business")
@RequiredArgsConstructor
public class BusinessController {
    
    private final ProductRepository productRepository;
    private final PartnerRepository partnerRepository;
    private final WarehouseRepository warehouseRepository;
    private final SalesOrderService salesOrderService;
    
    // ========== 商品管理 ==========
    
    @Operation(summary = "商品列表")
    @GetMapping("/product/list")
    public ApiResponse<List<Product>> productList() {
        // TODO: 添加租户过滤
        List<Product> list = productRepository.selectList(null);
        return ApiResponse.success(list);
    }
    
    @Operation(summary = "新增商品")
    @PostMapping("/product")
    public ApiResponse<Product> createProduct(@RequestBody Product product) {
        // TODO: 设置租户ID、生成编码
        productRepository.insert(product);
        return ApiResponse.success(product);
    }
    
    // ========== 往来单位管理 ==========
    
    @Operation(summary = "客户列表")
    @GetMapping("/partner/customer/list")
    public ApiResponse<List<Partner>> customerList() {
        // TODO: 添加租户过滤 + type=CUSTOMER
        List<Partner> list = partnerRepository.selectList(null);
        return ApiResponse.success(list);
    }
    
    @Operation(summary = "供应商列表")
    @GetMapping("/partner/supplier/list")
    public ApiResponse<List<Partner>> supplierList() {
        // TODO: 添加租户过滤 + type=SUPPLIER
        List<Partner> list = partnerRepository.selectList(null);
        return ApiResponse.success(list);
    }
    
    // ========== 仓库管理 ==========
    
    @Operation(summary = "仓库列表")
    @GetMapping("/warehouse/list")
    public ApiResponse<List<Warehouse>> warehouseList() {
        // TODO: 添加租户过滤
        List<Warehouse> list = warehouseRepository.selectList(null);
        return ApiResponse.success(list);
    }
    
    // ========== 销售单管理 ==========
    
    @Operation(summary = "销售单分页查询")
    @GetMapping("/sales-order/page")
    public ApiResponse<PageResponse<SalesOrder>> salesOrderPage(
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "10") Integer pageSize,
            @RequestParam(required = false) String status,
            @RequestParam(required = false) String keyword) {
        Page<SalesOrder> page = salesOrderService.page(pageNum, pageSize, status, keyword);
        PageResponse<SalesOrder> response = PageResponse.of(
            page.getRecords(), 
            page.getTotal(), 
            pageNum, 
            pageSize
        );
        return ApiResponse.success(response);
    }
    
    @Operation(summary = "创建销售单")
    @PostMapping("/sales-order")
    public ApiResponse<SalesOrder> createSalesOrder(@RequestBody SalesOrder order) {
        SalesOrder created = salesOrderService.create(order);
        return ApiResponse.success(created);
    }
    
    @Operation(summary = "审核销售单")
    @PostMapping("/sales-order/{id}/approve")
    public ApiResponse<SalesOrder> approveSalesOrder(@PathVariable Long id) {
        SalesOrder order = salesOrderService.approve(id);
        return ApiResponse.success(order);
    }
}