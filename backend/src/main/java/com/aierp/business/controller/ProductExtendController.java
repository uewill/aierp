package com.aierp.business.controller;

import com.aierp.business.entity.*;
import com.aierp.business.service.ProductExtendService;
import com.aierp.common.dto.ApiResponse;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.util.List;

/**
 * 商品扩展功能 API
 * - 多单位管理
 * - 批次管理
 * - 客户价格本
 * - 条码管理
 */
@Tag(name = "商品扩展功能", description = "多单位/批次/保质期/序列号/条码/客户价格本")
@RestController
@RequestMapping("/api/product/extend")
public class ProductExtendController {
    
    private final ProductExtendService productExtendService;
    
    public ProductExtendController(ProductExtendService productExtendService) {
        this.productExtendService = productExtendService;
    }
    
    // ========== 多单位管理 ==========
    
    @Operation(summary = "获取商品可用单位列表")
    @GetMapping("/units/{productId}")
    public ApiResponse<List<UnitConversion>> getProductUnits(@PathVariable Long productId) {
        List<UnitConversion> units = productExtendService.getProductUnits(productId);
        return ApiResponse.success(units);
    }
    
    @Operation(summary = "单位换算计算")
    @PostMapping("/unit/convert")
    public ApiResponse<BigDecimal> convertUnit(
            @RequestParam Long productId,
            @RequestParam String fromUnit,
            @RequestParam String toUnit,
            @RequestParam BigDecimal quantity) {
        BigDecimal result = productExtendService.convertUnit(productId, fromUnit, toUnit, quantity);
        return ApiResponse.success(result);
    }
    
    // ========== 批次管理 ==========
    
    @Operation(summary = "获取商品可用批次（先进先出）")
    @GetMapping("/batches/{productId}/{warehouseId}")
    public ApiResponse<List<Batch>> getAvailableBatches(
            @PathVariable Long productId,
            @PathVariable Long warehouseId) {
        List<Batch> batches = productExtendService.getAvailableBatches(productId, warehouseId);
        return ApiResponse.success(batches);
    }
    
    @Operation(summary = "创建新批次")
    @PostMapping("/batch")
    public ApiResponse<Batch> createBatch(@RequestBody Batch batch) {
        Batch created = productExtendService.createBatch(batch);
        return ApiResponse.success(created);
    }
    
    // ========== 客户价格本 ==========
    
    @Operation(summary = "获取客户商品价格")
    @GetMapping("/customer-price/{customerId}/{productId}")
    public ApiResponse<CustomerPrice> getCustomerPrice(
            @PathVariable Long customerId,
            @PathVariable Long productId) {
        CustomerPrice price = productExtendService.getCustomerPrice(customerId, productId);
        return ApiResponse.success(price);
    }
    
    @Operation(summary = "更新客户价格（订单完成后调用）")
    @PostMapping("/customer-price/update")
    public ApiResponse<Void> updateCustomerPrice(
            @RequestParam Long customerId,
            @RequestParam Long productId,
            @RequestParam(required = false) Long skuId,
            @RequestParam String unit,
            @RequestParam BigDecimal price,
            @RequestParam BigDecimal discount,
            @RequestParam Long orderId,
            @RequestParam String orderNo) {
        productExtendService.updateCustomerPrice(customerId, productId, skuId, unit, price, discount, orderId, orderNo);
        return ApiResponse.success();
    }
    
    // ========== 条码管理 ==========
    
    @Operation(summary = "根据条码获取商品信息")
    @GetMapping("/barcode/{barcode}")
    public ApiResponse<ProductBarcode> getBarcodeInfo(@PathVariable String barcode) {
        ProductBarcode info = productExtendService.getBarcodeInfo(barcode);
        return ApiResponse.success(info);
    }
    
    @Operation(summary = "获取商品所有条码")
    @GetMapping("/barcodes/{productId}")
    public ApiResponse<List<ProductBarcode>> getProductBarcodes(@PathVariable Long productId) {
        List<ProductBarcode> barcodes = productExtendService.getProductBarcodes(productId);
        return ApiResponse.success(barcodes);
    }
    
    @Operation(summary = "添加商品条码")
    @PostMapping("/barcode")
    public ApiResponse<ProductBarcode> addBarcode(@RequestBody ProductBarcode barcode) {
        // TODO: 完整实现
        return ApiResponse.success(barcode);
    }
}