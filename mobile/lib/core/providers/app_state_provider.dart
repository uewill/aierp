import 'package:flutter/foundation.dart';
import 'package:aierp_mobile/models/company.dart';
import 'package:aierp_mobile/models/category.dart' as model;

/// 应用全局状态管理
class AppStateProvider extends ChangeNotifier {
  // 用户信息
  String? _userId;
  String? _username;
  String? _token;
  
  // 公司信息
  Company? _selectedCompany;
  List<Company> _companyList = [];
  
  // 商品分类
  List<model.Category> _categories = [];
  
  // 登录状态
  bool get isLoggedIn => _token != null && _token!.isNotEmpty;
  
  // Getter
  String? get userId => _userId;
  String? get username => _username;
  String? get token => _token;
  Company? get selectedCompany => _selectedCompany;
  List<Company> get companyList => _companyList;
  List<model.Category> get categories => _categories;
  
  // Setter
  void setUserInfo({required String userId, required String username, required String token}) {
    _userId = userId;
    _username = username;
    _token = token;
    notifyListeners();
  }
  
  void clearUserInfo() {
    _userId = null;
    _username = null;
    _token = null;
    _selectedCompany = null;
    notifyListeners();
  }
  
  void setSelectedCompany(Company company) {
    _selectedCompany = company;
    notifyListeners();
  }
  
  void setCompanyList(List<Company> companies) {
    _companyList = companies;
    notifyListeners();
  }
  
  void setCategories(List<model.Category> categories) {
    _categories = categories;
    notifyListeners();
  }
  
  void addCategory(model.Category category) {
    _categories.add(category);
    notifyListeners();
  }
}