import 'dart:convert';

import 'package:hasura_connect/hasura_connect.dart';
import 'package:supertails/model/product_model.dart';
import 'package:supertails/utils/constants.dart';
import 'package:supertails/utils/environment.dart';

class ProductService {
  final HasuraConnect hasura;
  ProductService()
      : this.hasura = HasuraConnect(
          Environment.HASURA_URL,
          headers: Constants.HASURA_HEADER,
        );

  Future<ProductModel?> getStudentDetails({required String id}) async {
    String query = """
query MyQuery {
  product_by_pk(SKUid: "$id") {
    Variants
    Tags
    SalePrice
    SKUid
    MRP
    Name
    InventoryQuantity
    Description
    Brand
  }
}
  """;
    Map<String, dynamic> responseMap;
    try {
      responseMap = Map.castFrom(await hasura.query(query));
    } catch (error) {
      throw error;
    }
    Map<String, dynamic> dataMap = {};
    if (!responseMap.containsKey('data')) {
      return null;
    } else {
      dataMap = responseMap['data'];
    }

    dynamic dMap = dataMap['product_by_pk'];
    if (dMap != null) {
      ProductModel user = ProductModel.fromHasura(dMap);
      if (user != null) {
        return user;
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  Future<List<ProductModel>> getListOfProducts({
    String? SKUid,
    List<String>? Variant,
    num? SalePrice,
    String? Name,
    num? InventoryQuantity,
    String? Brand,
    List<String>? ExcludeIds,
    String? SortBy,
  }) async {
    String SortByFilter = '';
    if (SortBy == "Name Asc") {
      SortByFilter = 'order_by: {Name: asc},';
    } else if (SortBy == "Name Dsc") {
      SortByFilter = 'order_by: {Name: desc},';
    } else if (SortBy == "Price Low to High") {
      SortByFilter = 'order_by: {SalePrice: desc},';
    } else if (SortBy == "Price High to Low") {
      SortByFilter = 'order_by: {SalePrice: asc},';
    }

    String SKUidFilter = SKUid != null ? 'SKUid: {_eq: "$SKUid"}, ' : '';
    String SalePriceFilter =
        SalePrice != null ? 'SalePrice: {_lt: "$SalePrice"}, ' : '';
    String VariantFilter = (Variant != null && Variant.length > 0)
        ? 'Variants: {_in: ${jsonEncode(Variant)}}, '
        : '';
    String NameFilter = Name != null ? 'Name: {_eq: "$Name"}, ' : '';
    String BrandFilter = Brand != null ? 'Brand: {_eq: "$Brand"}, ' : '';
    String ExcludeIdsFilter = (ExcludeIds != null && ExcludeIds.length > 0)
        ? 'SKUid: {_nin: ${jsonEncode(ExcludeIds)},} '
        : '';

    String query = """
query MyQuery {
  product ($SortByFilter where: {$SKUidFilter $VariantFilter $NameFilter $BrandFilter $ExcludeIdsFilter $SalePriceFilter}){
    Variants
    SKUid
    SalePrice
    Name
    MRP
    InventoryQuantity
    Description
    Brand
    Tags
  }
}
""";

    Map<String, dynamic> responseMap;
    try {
      responseMap = Map.castFrom(await hasura.query(query));
      Map<String, dynamic> dataMap = {};
      if (!responseMap.containsKey('data')) {
        return [];
      } else {
        dataMap = responseMap['data'];
      }
      List<dynamic> list = (dataMap['product']);
      List<ProductModel> topics =
          list.map((e) => ProductModel.fromHasura(e)).toList();
      return topics;
    } catch (error) {
      throw error;
    }
  }

  Future<bool> createProduct(ProductModel productModel) async {
    var tag = jsonEncode(productModel.Tags);

    String query = """
mutation MyMutation {
  insert_product(objects: {Brand: "${productModel.Brand}", Description: "${productModel.Description}", Variants: "${productModel.Variants}", Tags: ${tag}, SalePrice: ${productModel.SalePrice}, SKUid: "${productModel.SKUid}", Name: "${productModel.Name}", MRP: ${productModel.MRP}, InventoryQuantity: ${productModel.InventoryQuantity}}) {
    affected_rows
  }
}

      """;
    try {
      Map<String, dynamic> responseMap;
      try {
        responseMap = Map.castFrom(await hasura.mutation(query));
        print('$responseMap');
      } catch (error) {
        print('saveProductDetails: error $error');
        throw error;
      }
      Map<String, Map> dataMap;
      if (!responseMap.containsKey('data')) {
        return false;
      }
      dataMap = Map.castFrom(responseMap['data']);
      if (dataMap.entries.first.value.values.first == 1) {
        print("saveProductDetails: Success");
        return true;
      }
    } catch (e) {
      print(e);
      return false;
    }
    return false;
  }
}
