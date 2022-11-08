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

  Future<List<ProductModel>> getListOfProducts() async {
    String query = """
query MyQuery {
  product {
    Variants
    Tags
    SKUid
    SalePrice
    Name
    MRP
    InventoryQuantity
    Description
    Brand
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
}
