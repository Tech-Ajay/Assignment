import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supertails/controllers/product_controller.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ProductController controller = Get.put(ProductController());
  @override
  void initState() {
    onInit();
    super.initState();
  }

  void onInit() async {
    await controller.getListOfProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(child: Text("View Products Page")),
          backgroundColor: Colors.redAccent,
        ),
        body: controller.productList.length > 0
            ? ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: controller.productList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: Column(children: [
                      Row(
                        children: [
                          Text("Name "),
                          Text(controller.productList[index].Name!),
                        ],
                      ),
                      Row(
                        children: [
                          Text("MRP "),
                          Text(
                            controller.productList[index].MRP.toString(),
                            style: TextStyle(
                                decoration: TextDecoration.lineThrough),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text("Sale Price "),
                          Text(controller.productList[index].SalePrice
                              .toString()),
                        ],
                      ),
                    ]),
                  );
                })
            : InkWell(
                onTap: () {
                  setState(() {});
                },
                child: Text("No Product")));
  }
}
