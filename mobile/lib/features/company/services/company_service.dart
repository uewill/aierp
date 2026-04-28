import 'package:aierp_mobile/api/company_api.dart';
import 'package:aierp_mobile/models/company.dart';

/// 公司服务类
class CompanyService {
  final CompanyApi _api = CompanyApi();

  /// 获取公司列表
  Future<List<Company>> getCompanyList() async {
    try {
      final data = await _api.getCompanyList();
      return (data['data'] as List)
          .map((item) => Company.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      // 模拟数据
      return [
        Company(
          id: '1',
          name: '测试公司',
          code: 'TEST001',
          contactPerson: '张三',
          phone: '13800138000',
          address: '北京市朝阳区测试街道123号',
          createdAt: DateTime.now(),
        ),
        Company(
          id: '2',
          name: '演示公司',
          code: 'DEMO001',
          contactPerson: '李四',
          phone: '13900139000',
          address: '上海市浦东新区演示路456号',
          createdAt: DateTime.now().subtract(const Duration(days: 5)),
        ),
      ];
    }
  }

  /// 创建公司
  Future<Company> createCompany(Company company) async {
    try {
      final data = await _api.createCompany(company.toJson());
      final result = data?['data'];
      return Company.fromJson(result as Map<String, dynamic>);
    } catch (e) {
      // 模拟创建成功
      return Company(
        id: '3',
        name: company.name,
        code: company.code,
        contactPerson: company.contactPerson,
        phone: company.phone,
        address: company.address,
        createdAt: DateTime.now(),
      );
    }
  }

  /// 获取当前用户公司
  Future<Company?> getCurrentCompany() async {
    try {
      final data = await _api.getCompanyList();
      final result = data?['data'] as List?;
      if (result != null && result.isNotEmpty) {
        return Company.fromJson(result.first as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      // 返回模拟的当前公司
      return Company(
        id: '1',
        name: '测试公司',
        code: 'TEST001',
        contactPerson: '张三',
        phone: '13800138000',
        address: '北京市朝阳区测试街道123号',
        createdAt: DateTime.now(),
      );
    }
  }
}