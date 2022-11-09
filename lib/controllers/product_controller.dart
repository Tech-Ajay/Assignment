import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:supertails/model/product_model.dart';
import 'package:supertails/services/product_service.dart';
import 'package:uuid/uuid.dart';

class ProductController extends GetxController {
  RxBool isLoading = false.obs;
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController MRPController = TextEditingController();
  TextEditingController SalePriceController = TextEditingController();
  TextEditingController TypeController = TextEditingController();
  TextEditingController BrandController = TextEditingController();
  TextEditingController VariantController = TextEditingController();
  TextEditingController InventoryQuantityController = TextEditingController();

  RxDouble sliderValue = RxDouble(0);

  RxList<ProductModel> productList = RxList<ProductModel>();
  ProductService productService = ProductService();

  RxList<String> SelectedTagList = RxList<String>();
  RxList<String> ExcludeIdList = RxList<String>();

  RxList<String> variantFilterList =
      RxList<String>(["XS", "S", "M", "L", "XL"]);
  RxString variantSelectedFilter = RxString('');
  RxString BrandSelectedFilter = RxString('');
  RxString SortBySelectedFilter = RxString('');
  RxList<String> SortByFilter = RxList<String>(
      ['Name Asc', 'Name Dsc', "Price High to Low", "Price Low to High"]);
  RxList<String> BrandFilter = RxList<String>();
  RxList<String> TypeFilter = RxList<String>();
  RxList<String> SelectedTypeFilter = RxList<String>();
  RxList<String> filterList = RxList<String>();
  RxList<String> NameList = RxList<String>();
  RxString slectedName = RxString('');
  RxString similarName = RxString('');

  late PagingController<int, ProductModel> pagingController;

  void initializePagination() {
    pagingController.addPageRequestListener((pageKey) async {
      fetchProduct(pageKey: pageKey);
    });
  }

  void fetchProduct({int pageSize = 10, required int pageKey}) async {
    try {
      List<ProductModel> products = await productService.getListOfProducts(
          ExcludeIds: ExcludeIdList,
          Type: SelectedTypeFilter.isNotEmpty ? SelectedTypeFilter : null,
          // Variant: variantSelectedFilter,
          SalePrice: sliderValue.value == 0 ? null : sliderValue.value,
          Name: slectedName.value == "" ? null : slectedName.value,
          SortBy: SortBySelectedFilter.value == ""
              ? null
              : SortBySelectedFilter.value,
          Brand: BrandSelectedFilter.value == ""
              ? null
              : BrandSelectedFilter.value);

      List<ProductModel> newProducts = [];

      if (variantSelectedFilter.value != '') {
        for (var i = 0; i < products.length; i++) {
          var variantList = products[i].Variants!.split(',');
          int b = 0;
          for (var element in variantList) {
            if (element == variantSelectedFilter.value) {
              b = b + 1;
            }
          }
          b > 0 ? newProducts.add(products[i]) : products.remove(products[i]);
        }
      } else {
        newProducts = products;
      }

      for (var product in newProducts) {
        ExcludeIdList.add(product.SKUid!);
      }

      final isLastPage = newProducts.length < pageSize;
      if (isLastPage) {
        pagingController.appendLastPage(newProducts);
      } else {
        final nextPageKey = pageKey + newProducts.length;
        pagingController.appendPage(newProducts, nextPageKey);
      }
    } catch (error) {
      pagingController.error = error;
    }
  }

  void refreshProducts() {
    pagingController.refresh();
  }

  Future<void> getListOfProducts() async {
    productList.value = await productService.getListOfProducts();
    BrandFilter.clear();
    TypeFilter.clear();
    if (productList.isNotEmpty) {
      for (var element in productList) {
        BrandFilter.add(element.Brand!);
        NameList.add(element.Name!);
        TypeFilter.add(element.Type!);
        TypeFilter.value = TypeFilter.toSet().toList();
      }
    }
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
        Type: TypeController.text,
        Variants: VariantController.text,
        CreatedAt: DateTime.now(),
        MRP: double.parse(MRPController.text),
        SalePrice: double.parse(SalePriceController.text),
        InventoryQuantity: int.parse(InventoryQuantityController.text));
    return await productService.createProduct(productModel);
  }
}
