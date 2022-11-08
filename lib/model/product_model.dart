class ProductModel {
  final String? SKUid;
  final String? Name;
  final String? Description;
  final String? Brand;
  final String? Variants;
  final DateTime? CreatedAt;
  final String? CreatedBy;
  final num? MRP;
  final num? SalePrice;
  final num? InventoryQuantity;

  const ProductModel({
    required this.CreatedBy,
    required this.SKUid,
    required this.Name,
    required this.Description,
    required this.Brand,
    required this.Variants,
    required this.CreatedAt,
    required this.MRP,
    required this.SalePrice,
    required this.InventoryQuantity,
  });

  factory ProductModel.fromHasura(Map<String, dynamic> map) {
    return ProductModel(
      CreatedBy: map.containsKey('CreatedBy') ? map['CreatedBy'] : null,
      SKUid: map.containsKey('SKUid') ? map['SKUid'] : null,
      Name: map.containsKey('Name') ? map['Name'] : null,
      Description: map.containsKey('Description') ? map['Description'] : null,
      Brand: map.containsKey('Brand') ? map['Brand'] : null,
      Variants: map.containsKey('Variants') ? map['Variants'] : null,
      InventoryQuantity: map.containsKey('InventoryQuantity')
          ? map['InventoryQuantity']
          : null,
      SalePrice: map.containsKey('SalePrice') ? map['SalePrice'] : null,
      MRP: map.containsKey('MRP') ? map['MRP'] : null,
      CreatedAt: map.containsKey('CreatedAt')
          ? DateTime.parse(map['CreatedAt'])
          : null,
    );
  }

  ProductModel copyWith({
    String? CreatedBy,
    String? SKUid,
    String? Name,
    String? Description,
    String? Brand,
    String? Variants,
    DateTime? CreatedAt,
    num? MRP,
    num? SalePrice,
    num? InventoryQuantity,
  }) {
    return ProductModel(
      CreatedBy: CreatedBy ?? this.CreatedBy,
      SKUid: SKUid ?? this.SKUid,
      Name: Name ?? this.Name,
      Description: Description ?? this.Description,
      Brand: Brand ?? this.Brand,
      Variants: Variants ?? this.Variants,
      CreatedAt: CreatedAt ?? this.CreatedAt,
      MRP: MRP ?? this.MRP,
      SalePrice: SalePrice ?? this.SalePrice,
      InventoryQuantity: InventoryQuantity ?? this.InventoryQuantity,
    );
  }

  Map<String, Object?> toMap() {
    Map<String, Object?> map = {};

    if (CreatedBy != null && CreatedBy!.isNotEmpty) {
      map['CreatedBy'] = CreatedBy;
    }
    if (SKUid != null && SKUid!.isNotEmpty) {
      map['SKUid'] = SKUid;
    }
    if (Name != null && Name!.isNotEmpty) {
      map['Name'] = Name;
    }
    if (Description != null && Description!.isNotEmpty) {
      map['Description'] = Description;
    }
    if (Brand != null && Brand!.isNotEmpty) {
      map['Brand'] = Brand;
    }
    if (Variants != null && Variants!.isNotEmpty) {
      map['Variants'] = Variants;
    }

    if (CreatedAt != null) {
      map['CreatedAt'] = CreatedAt;
    }
    if (MRP != null) {
      map['MRP'] = MRP;
    }
    if (InventoryQuantity != null) {
      map['InventoryQuantity'] = InventoryQuantity;
    }
    if (SalePrice != null) {
      map['SalePrice'] = SalePrice;
    }
    return map;
  }
}
