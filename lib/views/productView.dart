import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supertails/controllers/product_controller.dart';
import 'package:supertails/views/addProduct.dart';

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
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(),
              Text("View Products Page"),
              InkWell(
                  onTap: () {
                    Get.to(AddProduct());
                  },
                  child: Icon(Icons.add)),
              SizedBox()
            ],
          ),
          backgroundColor: Colors.redAccent,
        ),
        body: controller.productList.length > 0
            ? Obx(() {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: controller.productList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(children: [
                              Row(
                                children: [
                                  Text("Name : ",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                  Text(controller.productList[index].Name!,
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                              Row(
                                children: [
                                  Text("Price : ",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                  Text(
                                    "Rs.${controller.productList[index].MRP.toString()}",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red,
                                        decoration: TextDecoration.lineThrough),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text(
                                      "Rs.${controller.productList[index].SalePrice.toString()}",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ]),
                          ),
                        );
                      }),
                );
              })
            : InkWell(
                onTap: () {
                  setState(() {});
                },
                child: Text("No Product")));
  }
}
