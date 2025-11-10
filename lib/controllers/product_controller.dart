import 'package:get/get.dart';
import '../services/api_service.dart';
import '../models/product_model.dart';

class ProductController extends GetxController {
  final ApiService _apiService = ApiService();

  var isLoading = false.obs;
  var product =
      Product(id: 0, name: '', description: '', price: 0.0, categoryId: 0).obs;
  var errorMessage = ''.obs;

  Future<void> loadProductDetail(int productId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final productDetail = await _apiService.getProductDetail(productId);
      product.value = productDetail;
    } catch (e) {
      errorMessage.value = 'Failed to load product details: $e';
    } finally {
      isLoading.value = false;
    }
  }
}
