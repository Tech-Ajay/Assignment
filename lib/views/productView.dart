import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:supertails/controllers/product_controller.dart';
import 'package:supertails/model/product_model.dart';
import 'package:supertails/views/addProduct.dart';
import 'package:supertails/views/widgets/QContainer.dart';
import 'package:supertails/views/widgets/QDialog.dart';
import 'package:supertails/views/widgets/QPAgination.dart';
import 'package:supertails/views/widgets/QText.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ProductController controller = Get.put(ProductController());
  TextEditingController _typeAheadController = TextEditingController();

  @override
  void initState() {
    controller.pagingController = PagingController(firstPageKey: 0);
    controller.initializePagination();
    onInit();
    super.initState();
  }

  void onInit() async {
    controller.isLoading.value = true;
    await controller.getListOfProducts();
    controller.isLoading.value = false;
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
        body: Column(
          children: [
            Row(
              children: [
                InkWell(
                  onTap: () {
                    QDialog.show(
                      context: context,
                      enableScroll: true,
                      title: '',
                      content: _buildFilter(),
                      enableCancel: false,
                    );
                  },
                  child: QContainer(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: Colors.black,
                    ),
                    padding: EdgeInsets.all(4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.filter_list_rounded,
                          color: Colors.black,
                        ),
                        SizedBox(width: 5),
                        QText(
                          text: 'Filter',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          isHeader: true,
                          color: Colors.black,
                        ),
                        SizedBox(width: 5),
                        Icon(
                          Icons.keyboard_arrow_down_outlined,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TypeAheadField(
                      textFieldConfiguration: TextFieldConfiguration(
                          autofocus: false,
                          decoration: InputDecoration(
                              hintText: "Search", border: OutlineInputBorder()),
                          controller: _typeAheadController),
                      suggestionsCallback: (pattern) async {
                        Completer<List<String>> completer = new Completer();
                        var sugg = controller.NameList.where(
                            (p0) => p0.contains(pattern)).toList();

                        if (sugg.isEmpty) {
                          controller.similarName.value = pattern;
                        } else {
                          controller.similarName.value = '';
                        }
                        completer.complete(sugg);
                        return completer.future;
                      },
                      itemBuilder: (context, suggestion) {
                        return ListTile(title: Text(suggestion));
                      },
                      onSuggestionSelected: (suggestion) {
                        _typeAheadController.text = suggestion;
                        controller.slectedName.value = suggestion;
                        controller.filterList.add(suggestion);
                        controller.ExcludeIdList.clear();
                        controller.refreshProducts();
                      }),
                ))
              ],
            ),
            Obx(() {
              return Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Row(
                  children: [
                    ...List.generate(
                        controller.filterList.length,
                        (index) => QContainer(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 4, vertical: 5),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: Colors.black,
                              ),
                              padding: EdgeInsets.all(4),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(width: 5),
                                  QText(
                                    text: controller.filterList[index],
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    isHeader: true,
                                    color: Colors.black,
                                  ),
                                  SizedBox(width: 2),
                                  InkWell(
                                    onTap: () {
                                      if (controller.filterList[index]
                                          .contains("Price Less Than")) {
                                        controller.sliderValue.value = 0;
                                      } else {
                                        // controller.variantSelectedFilter.remove(
                                        //     controller.filterList[index]);
                                        if (controller
                                                .BrandSelectedFilter.value ==
                                            controller.filterList[index]) {
                                          controller.BrandSelectedFilter.value =
                                              "";
                                        } else if (controller
                                                .SortBySelectedFilter.value ==
                                            controller.filterList[index]) {
                                          controller
                                              .SortBySelectedFilter.value = "";
                                        } else if (controller.SelectedTypeFilter
                                            .contains(
                                                controller.filterList[index])) {
                                          controller.SelectedTypeFilter.remove(
                                              controller.filterList[index]);
                                        } else
                                          controller
                                              .variantSelectedFilter.value = '';
                                      }
                                      controller.filterList.removeAt(index);
                                      controller.ExcludeIdList.clear();
                                      controller.refreshProducts();
                                    },
                                    child: Icon(
                                      Icons.close,
                                      size: 14,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ))
                  ],
                ),
              );
            }),
            Container(
                child: controller.isLoading.value == true
                    ? Container(
                        height: MediaQuery.of(context).size.height - 200,
                        width: MediaQuery.of(context).size.width,
                        child: Center(child: CircularProgressIndicator()))
                    : Container(
                        height: MediaQuery.of(context).size.height - 200,
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: QListBuilder<ProductModel>(
                            pageingController: controller.pagingController,
                            emptyBuilder: (context) => _buildEmptyData(),
                            itemBuilder: (context, product, index) {
                              return Card(
                                color: Colors.white,
                                elevation: 8,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        // Text("Name : ",
                                        //     style: TextStyle(
                                        //         fontSize: 20,
                                        //         fontWeight: FontWeight.bold)),
                                        Expanded(
                                          child: Text(product.Name!,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          "Rs.${product.SalePrice.toString()}",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 2,
                                        ),
                                        Text(
                                          "Rs.${product.MRP.toString()}",
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.red,
                                              decoration:
                                                  TextDecoration.lineThrough),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text("Variants : ",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold)),
                                        Text(
                                          "${product.Variants}",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            // color: Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text("Brand : ",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold)),
                                        Text(
                                          "${product.Brand}",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            // color: Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text("Type : ",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold)),
                                        Text(
                                          "${product.Type}",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            // color: Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ]),
                                ),
                              );
                            },
                          ),
                          // ListView.builder(
                          //     physics: NeverScrollableScrollPhysics(),
                          //     shrinkWrap: true,
                          //     itemCount: controller.productList.length,
                          //     itemBuilder: (BuildContext context, int index) {
                          //       return
                          //     }),
                        ))),
          ],
        ));
  }

  Widget _buildFilter() {
    return Obx(() {
      return QContainer(
        height: 300,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              QText(
                text: 'Variant',
                fontSize: 18,
                color: Colors.redAccent,
                fontWeight: FontWeight.w500,
              ),
              Wrap(
                children: List.generate(
                  controller.variantFilterList.length,
                  (index) => Obx(() {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 26.0, vertical: 16.0),
                      child: InkWell(
                        onTap: () {
                          if (controller.variantSelectedFilter ==
                              controller.variantFilterList[index]) {
                            // controller.variantSelectedFilter
                            //     .remove(controller.variantFilterList[index]);
                            controller.variantSelectedFilter.value = '';
                            controller.filterList
                                .remove(controller.variantFilterList[index]);
                          } else {
                            controller.filterList
                                .remove(controller.variantSelectedFilter.value);
                            controller.variantSelectedFilter.value =
                                (controller.variantFilterList[index]);
                            controller.filterList
                                .add(controller.variantFilterList[index]);
                          }
                          controller.ExcludeIdList.clear();
                          controller.refreshProducts();
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            QContainer(
                              height: 12,
                              width: 12,
                              border: Border.all(),
                              shape: BoxShape.circle,
                              color: controller.variantSelectedFilter.value ==
                                      controller.variantFilterList[index]
                                  // .contains(
                                  // controller.variantFilterList[index])
                                  ? Colors.redAccent
                                  : Colors.white,
                            ),
                            SizedBox(width: 5),
                            QText(
                              text: controller.variantFilterList[index],
                              fontSize: 14,
                              color: Colors.black,
                            ),
                            SizedBox(width: 5),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
              QText(
                text: 'Type',
                fontSize: 18,
                color: Colors.redAccent,
                fontWeight: FontWeight.w500,
              ),
              Wrap(
                children: List.generate(
                  controller.TypeFilter.length,
                  (index) => Obx(() {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 26.0, vertical: 16.0),
                      child: InkWell(
                        onTap: () {
                          if (controller.SelectedTypeFilter.contains(
                              controller.TypeFilter[index])) {
                            controller.SelectedTypeFilter.remove(
                                controller.TypeFilter[index]);
                            controller.filterList
                                .remove(controller.TypeFilter[index]);
                          } else {
                            controller.SelectedTypeFilter.add(
                                controller.TypeFilter[index]);
                            controller.filterList
                                .add(controller.TypeFilter[index]);
                          }
                          controller.ExcludeIdList.clear();
                          controller.refreshProducts();
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            QContainer(
                              height: 12,
                              width: 12,
                              border: Border.all(),
                              shape: BoxShape.circle,
                              color: controller.SelectedTypeFilter.contains(
                                      controller.TypeFilter[index])
                                  ? Colors.redAccent
                                  : Colors.white,
                            ),
                            SizedBox(width: 5),
                            QText(
                              text: controller.TypeFilter[index],
                              fontSize: 14,
                              color: Colors.black,
                            ),
                            SizedBox(width: 5),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
              QText(
                text: 'Price',
                fontSize: 18,
                color: Colors.redAccent,
                fontWeight: FontWeight.w500,
              ),
              Obx(() {
                return Column(
                  children: [
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                          showValueIndicator: ShowValueIndicator.always,
                          valueIndicatorShape:
                              PaddleSliderValueIndicatorShape(),
                          valueIndicatorColor: Colors.black,
                          valueIndicatorTextStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                          )),
                      child: Slider(
                        value: controller.sliderValue.value,
                        activeColor: Colors.redAccent,
                        inactiveColor: Colors.grey,
                        thumbColor: Colors.white,
                        label: '${controller.sliderValue.value.ceil()}',
                        min: 0,
                        max: 10000,
                        onChanged: (value) {
                          controller.sliderValue.value = value;
                        },
                        onChangeEnd: (value) {
                          controller.filterList.removeWhere(
                            (element) => element.contains("Price Less Than"),
                          );
                          controller.filterList.add(
                              "Price Less Than ${controller.sliderValue.value.round()}");
                          controller.ExcludeIdList.clear();

                          controller.refreshProducts();
                        },
                      ),
                    ),
                    if (controller.sliderValue.value.round() > 0)
                      QText(
                        text:
                            "Price Less Than Rs.${controller.sliderValue.value.round()}",
                        color: Colors.redAccent,
                        isHeader: true,
                        fontSize: 14,
                      ),
                  ],
                );
              }),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      QText(
                        text: 'Brand',
                        fontSize: 18,
                        color: Colors.redAccent,
                        fontWeight: FontWeight.w500,
                      ),
                      DropdownButton<String>(
                        // Initial Value
                        value: controller.BrandSelectedFilter.value == ""
                            ? null
                            : controller.BrandSelectedFilter.value,
                        hint: Text("Select Brand"),
                        // Down Arrow Icon
                        icon: const Icon(Icons.keyboard_arrow_down),

                        // Array list of items
                        items: controller.BrandFilter.map((String items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Text(items),
                          );
                        }).toList(),
                        // After selecting the desired option,it will
                        // change button value to selected value
                        onChanged: (String? newValue) {
                          setState(() {
                            controller.filterList
                                .remove(controller.BrandSelectedFilter.value);
                            controller.BrandSelectedFilter.value = newValue!;
                            controller.filterList.add(newValue);
                            controller.ExcludeIdList.clear();
                            controller.refreshProducts();
                          });
                        },
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      QText(
                        text: 'SortBy',
                        fontSize: 18,
                        color: Colors.redAccent,
                        fontWeight: FontWeight.w500,
                      ),
                      DropdownButton<String>(
                        // Initial Value
                        value: controller.SortBySelectedFilter.value == ""
                            ? null
                            : controller.SortBySelectedFilter.value,
                        hint: Text("SortBy"),
                        // Down Arrow Icon
                        icon: const Icon(Icons.keyboard_arrow_down),

                        // Array list of items
                        items: controller.SortByFilter.map((String items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Text(items),
                          );
                        }).toList(),
                        // After selecting the desired option,it will
                        // change button value to selected value
                        onChanged: (String? newValue) {
                          setState(() {
                            controller.filterList
                                .remove(controller.SortBySelectedFilter.value);
                            controller.SortBySelectedFilter.value = newValue!;
                            controller.filterList.add(newValue);
                            controller.ExcludeIdList.clear();
                            controller.refreshProducts();
                          });
                        },
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildEmptyData() {
    return Center(
      child: Text("No Batches available",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
    );
  }
}
