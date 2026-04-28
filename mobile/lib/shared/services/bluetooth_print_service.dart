import 'dart:async';
import 'dart:typed_data';

/// 蓝牙打印服务
/// 用于连接蓝牙打印机并发送打印指令
class BluetoothPrintService {
  static final BluetoothPrintService _instance = BluetoothPrintService._internal();
  factory BluetoothPrintService() => _instance;
  BluetoothPrintService._internal();

  bool _isConnected = false;
  String? _connectedDeviceId;
  String? _connectedDeviceName;

  /// 是否已连接
  bool get isConnected => _isConnected;

  /// 已连接设备名称
  String? get connectedDeviceName => _connectedDeviceName;

  /// 扫描蓝牙设备
  Future<List<BluetoothDevice>> scanDevices({Duration timeout = const Duration(seconds: 10)}) async {
    // TODO: 实际实现需要使用 flutter_blue 或 bluetooth_print 等插件
    // 这里返回模拟数据
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      BluetoothDevice(id: '00:11:22:33:44:55', name: 'Printer-001', type: DeviceType.thermal),
      BluetoothDevice(id: '00:11:22:33:44:56', name: 'Label-Printer', type: DeviceType.label),
    ];
  }

  /// 连接设备
  Future<bool> connect(String deviceId, {String? deviceName}) async {
    // TODO: 实际实现蓝牙连接
    await Future.delayed(const Duration(seconds: 1));
    _isConnected = true;
    _connectedDeviceId = deviceId;
    _connectedDeviceName = deviceName ?? 'Printer';
    return true;
  }

  /// 断开连接
  Future<void> disconnect() async {
    // TODO: 实际实现断开连接
    await Future.delayed(const Duration(milliseconds: 300));
    _isConnected = false;
    _connectedDeviceId = null;
    _connectedDeviceName = null;
  }

  /// 发送ESC指令打印
  Future<bool> printEscCommand(Uint8List bytes) async {
    if (!_isConnected) {
      throw Exception('打印机未连接');
    }
    // TODO: 实际发送数据到蓝牙打印机
    await Future.delayed(const Duration(milliseconds: 500));
    return true;
  }

  /// 发送TSPL指令打印
  Future<bool> printTsplCommand(String command) async {
    if (!_isConnected) {
      throw Exception('打印机未连接');
    }
    // TODO: 实际发送TSPL指令
    await Future.delayed(const Duration(milliseconds: 500));
    return true;
  }

  /// 打印小票
  Future<bool> printReceipt({
    required String companyName,
    required String billType,
    required String billNo,
    required String billDate,
    String? partnerName,
    required List<ReceiptItem> items,
    required double totalAmount,
    double? discountAmount,
    String? remark,
  }) async {
    if (!_isConnected) {
      throw Exception('打印机未连接');
    }

    // 生成ESC指令
    final bytes = _generateEscBytes(
      companyName: companyName,
      billType: billType,
      billNo: billNo,
      billDate: billDate,
      partnerName: partnerName,
      items: items,
      totalAmount: totalAmount,
      discountAmount: discountAmount,
      remark: remark,
    );

    return printEscCommand(bytes);
  }

  /// 打印标签
  Future<bool> printLabel({
    required String productName,
    String? barcode,
    required double price,
    String? unit,
    double? quantity,
  }) async {
    if (!_isConnected) {
      throw Exception('打印机未连接');
    }

    // 生成TSPL指令
    final command = _generateTsplCommand(
      productName: productName,
      barcode: barcode,
      price: price,
      unit: unit,
      quantity: quantity,
    );

    return printTsplCommand(command);
  }

  /// 生成ESC打印字节
  Uint8List _generateEscBytes({
    required String companyName,
    required String billType,
    required String billNo,
    required String billDate,
    String? partnerName,
    required List<ReceiptItem> items,
    required double totalAmount,
    double? discountAmount,
    String? remark,
  }) {
    final buffer = StringBuffer();
    
    // 初始化
    buffer.write('\x1B@');
    
    // 居中 + 加粗 + 大字
    buffer.write('\x1Ba\x01\x1BE\x01\x1B!\x20');
    buffer.writeln(companyName);
    
    // 正常字体
    buffer.write('\x1BE\x00\x1B!\x00');
    buffer.writeln(billType);
    buffer.write('\x1Ba\x00'); // 左对齐
    
    // 单据信息
    buffer.writeln('单号: $billNo');
    buffer.writeln('日期: $billDate');
    if (partnerName != null && partnerName.isNotEmpty) {
      buffer.writeln('客户: $partnerName');
    }
    
    // 分隔线
    buffer.writeln('--------------------------------');
    
    // 表头
    buffer.writeln('商品          数量    单价    金额');
    buffer.writeln('--------------------------------');
    
    // 明细
    for (final item in items) {
      final name = item.name.length > 8 ? item.name.substring(0, 8) : item.name;
      buffer.write(name.padRight(10));
      buffer.write(item.quantity.toString().padLeft(6));
      buffer.write(item.price.toStringAsFixed(2).padLeft(8));
      buffer.writeln(item.amount.toStringAsFixed(2).padLeft(8));
    }
    
    // 分隔线
    buffer.writeln('--------------------------------');
    
    // 合计
    buffer.writeln('合计金额: ${totalAmount.toStringAsFixed(2)}');
    if (discountAmount != null && discountAmount > 0) {
      final paid = totalAmount - discountAmount;
      buffer.writeln('优惠金额: ${discountAmount.toStringAsFixed(2)}');
      buffer.writeln('实收金额: ${paid.toStringAsFixed(2)}');
    }
    
    // 备注
    if (remark != null && remark.isNotEmpty) {
      buffer.writeln('备注: $remark');
    }
    
    // 底部
    buffer.writeln('');
    buffer.write('\x1Ba\x01'); // 居中
    buffer.writeln('谢谢惠顾，欢迎再次光临！');
    buffer.writeln('');
    buffer.writeln('');
    buffer.writeln('');
    
    // 切纸
    buffer.write('\x1DVA\x00');
    
    return Uint8List.fromList(buffer.toString().codeUnits);
  }

  /// 生成TSPL指令
  String _generateTsplCommand({
    required String productName,
    String? barcode,
    required double price,
    String? unit,
    double? quantity,
  }) {
    final buffer = StringBuffer();
    
    buffer.writeln('SIZE 50 mm, 30 mm');
    buffer.writeln('GAP 2 mm, 0 mm');
    buffer.writeln('CLS');
    
    // 商品名称
    buffer.writeln('TEXT 10,10,"3",0,1,1,"$productName"');
    
    // 条码
    if (barcode != null && barcode.isNotEmpty) {
      buffer.writeln('BARCODE 10,40,"128",50,1,0,2,2,"$barcode"');
    }
    
    // 价格
    buffer.write('TEXT 10,100,"3",0,1,1,"¥${price.toStringAsFixed(2)}"');
    if (unit != null && unit.isNotEmpty) {
      buffer.write('/$unit');
    }
    buffer.writeln('"');
    
    // 数量
    if (quantity != null && quantity > 0) {
      buffer.writeln('TEXT 150,100,"3",0,1,1,"x${quantity.toStringAsFixed(0)}"');
    }
    
    buffer.writeln('PRINT 1,1');
    
    return buffer.toString();
  }
}

/// 蓝牙设备
class BluetoothDevice {
  final String id;
  final String name;
  final DeviceType type;
  final int? rssi;

  BluetoothDevice({
    required this.id,
    required this.name,
    required this.type,
    this.rssi,
  });
}

/// 设备类型
enum DeviceType {
  thermal, // 热敏小票打印机
  label,   // 标签打印机
}

/// 小票明细项
class ReceiptItem {
  final String name;
  final double quantity;
  final double price;
  final double amount;

  ReceiptItem({
    required this.name,
    required this.quantity,
    required this.price,
    required this.amount,
  });
}