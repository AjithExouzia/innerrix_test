import 'package:get/get.dart';
import '../services/api_service.dart';
import '../models/home_data_model.dart';
import '../models/product_model.dart';

class HomeController extends GetxController {
  final ApiService _apiService = ApiService();

  var isLoading = true.obs;
  var homeData = HomeData(categories: [], featuredProducts: [], offers: []).obs;
  var products = <Product>[].obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadHomeData();
    loadProducts();
  }

  Future<void> loadHomeData() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final data = await _apiService.getHomeData();
      homeData.value = data;
    } catch (e) {
      errorMessage.value = 'Failed to load home data: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadProducts() async {
    try {
      errorMessage.value = '';

      final productList = await _apiService.getProducts();
      products.assignAll(productList);
    } catch (e) {
      errorMessage.value = 'Failed to load products: $e';
    }
  }
}
