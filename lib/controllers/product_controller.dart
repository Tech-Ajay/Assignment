// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supertails/model/product_model.dart';
import 'package:supertails/services/product_service.dart';
import 'package:uuid/uuid.dart';

class ProductController extends GetxController {
  RxBool isLoading = false.obs;
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController MRPController = TextEditingController();
  TextEditingController SalePriceController = TextEditingController();
  TextEditingController BrandController = TextEditingController();
  TextEditingController VariantController = TextEditingController();
  TextEditingController InventoryQuantityController = TextEditingController();

  RxList<ProductModel> productList = RxList<ProductModel>();
  ProductService productService = ProductService();

  RxList<String> SelectedTagList = RxList<String>();

  Future<void> getListOfProducts() async {
    productList.value = await productService.getListOfProducts();
  }

  bool validate() {
    if (nameController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        BrandController.text.isEmpty ||
        SelectedTagList.isEmpty ||
        VariantController.text.isEmpty ||
        SalePriceController.text.isEmpty ||
        InventoryQuantityController.text.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  Future<bool> AddProducts() async {
    ProductModel productModel = ProductModel(
        CreatedBy: "Ajay",
        SKUid: const Uuid().v1(),
        Name: nameController.text,
        Description: descriptionController.text,
        Brand: BrandController.text,
        Tags: SelectedTagList,
        Variants: VariantController.text,
        CreatedAt: DateTime.now(),
        MRP: double.parse(MRPController.text),
        SalePrice: double.parse(SalePriceController.text),
        InventoryQuantity: int.parse(InventoryQuantityController.text));
    return await productService.createProduct(productModel);
  }
}
