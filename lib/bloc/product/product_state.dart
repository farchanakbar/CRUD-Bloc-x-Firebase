part of 'product_bloc.dart';

abstract class ProductState {}

final class ProductStateInitial extends ProductState {}

final class ProductStateLoading extends ProductState {}

final class ProductStateLoadingExport extends ProductState {}

final class ProductStateComplateAdd extends ProductState {}

final class ProductStateComplateEdit extends ProductState {}

final class ProductStateComplateDelete extends ProductState {}

final class ProductStateComplateExport extends ProductState {}

final class ProductStateError extends ProductState {
  final String message;

  ProductStateError(this.message);
}
