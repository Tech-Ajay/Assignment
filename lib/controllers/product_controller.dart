import 'package:get/get.dart';
import 'package:supertails/model/product_model.dart';
import 'package:supertails/services/product_service.dart';

class ProductController extends GetxController {
  RxList<ProductModel> productList = RxList<ProductModel>();
  ProductService productService = ProductService();

  Future<void> getListOfProducts() async {
    productList.value = await productService.getListOfProducts();
  }
}
