part of 'product_bloc.dart';

abstract class ProductEvent {}

class ProductEventAddProduct extends ProductEvent {
  final String code;
  final String name;
  final int quantity;

  ProductEventAddProduct({
    required this.name,
    required this.code,
    required this.quantity,
  });
}

class ProductEventEditProduct extends ProductEvent {
  final String id;
  final String name;
  final int quantity;

  ProductEventEditProduct({
    required this.name,
    required this.id,
    required this.quantity,
  });
}

class ProductEventDeleteProduct extends ProductEvent {
  final String id;

  ProductEventDeleteProduct(this.id);
}

class ProductEventExportPdf extends ProductEvent {}
