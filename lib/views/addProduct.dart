import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:supertails/controllers/product_controller.dart';
import 'package:dropdown_search/dropdown_search.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  ProductController controller = Get.put(ProductController());

  List<String> tags = [
    "Pant",
    "Shirt",
    "sale",
    "Cheap",
    "Costly",
    "Electronics",
    "Flexible"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [SizedBox(), Text("Add Products Page"), SizedBox()],
        ),
        backgroundColor: Colors.redAccent,
      ),
      body: Obx(() {
        return controller.isLoading.value == true
            ? Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Center(child: CircularProgressIndicator()))
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                        margin: EdgeInsets.all(20),
                        child: TextField(
                          controller: controller.nameController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Name',
                          ),
                          onChanged: (text) {},
                        )),
                    Container(
                        margin: EdgeInsets.all(20),
                        child: TextField(
                          controller: controller.descriptionController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Description',
                          ),
                          onChanged: (text) {},
                        )),
                    Container(
                        margin: EdgeInsets.all(20),
                        child: TextField(
                          controller: controller.MRPController,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'MRP',
                          ),
                          onChanged: (text) {},
                        )),
                    Container(
                        margin: EdgeInsets.all(20),
                        child: TextField(
                          controller: controller.SalePriceController,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'SalePrice',
                          ),
                          onChanged: (text) {},
                        )),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: DropdownSearch<String>.multiSelection(
                        items: tags,
                        popupProps: PopupPropsMultiSelection.menu(
                          showSelectedItems: true,
                          disabledItemFn: (String s) => s.startsWith('I'),
                        ),
                        dropdownDecoratorProps: DropDownDecoratorProps(
                          dropdownSearchDecoration: InputDecoration(
                              hintText: "Select Tags",
                              border: OutlineInputBorder()),
                        ),
                        onChanged: (value) {
                          controller.SelectedTagList.clear();
                          controller.SelectedTagList.addAll(value);
                        },
                        selectedItems: controller.SelectedTagList,
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.all(20),
                        child: TextField(
                          controller: controller.BrandController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Brand',
                          ),
                        )),
                    Container(
                        margin: EdgeInsets.all(20),
                        child: TextField(
                          controller: controller.VariantController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Variant',
                          ),
                          onChanged: (text) {},
                        )),
                    Container(
                        margin: EdgeInsets.all(20),
                        child: TextField(
                          controller: controller.InventoryQuantityController,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ], // Only numbers can be entered
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'InventoryQuantity',
                          ),
                          onChanged: (text) {},
                        )),
                    ElevatedButton(
                        onPressed: () async {
                          controller.isLoading.value = true;
                          if (!controller.validate())
                            Get.defaultDialog(
                                title: "Alert",
                                content: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("Fill All The Field"),
                                    ),
                                    ElevatedButton(
                                        onPressed: () {
                                          Get.back();
                                        },
                                        child: Text("Close"))
                                  ],
                                ));
                          if (controller.validate()) {
                            bool added = await controller.AddProducts();
                            controller.isLoading.value = false;

                            added
                                ? {
                                    controller.ExcludeIdList.clear(),
                                    controller.refreshProducts(),
                                    Get.back()
                                  }
                                : Get.defaultDialog(
                                    title: "Error",
                                    content: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child:
                                              Text("Error Adding the Product"),
                                        ),
                                        ElevatedButton(
                                            onPressed: () {
                                              Get.back();
                                            },
                                            child: Text("Close"))
                                      ],
                                    ));
                          }
                        },
                        child: Text("Save"))
                  ],
                ),
              );
      }),
    );
  }
}
