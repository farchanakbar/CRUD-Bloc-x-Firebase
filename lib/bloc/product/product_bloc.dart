import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:qrcode_bloc/bloc/bloc.dart';
import 'package:qrcode_bloc/models/product.dart';
import 'package:pdf/widgets.dart' as pw;

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Product>> streamProduct() async* {
    yield* firestore
        .collection('product')
        .withConverter<Product>(
          fromFirestore: (snapshot, _) => Product.fromJson(snapshot.data()!),
          toFirestore: (product, _) => product.toJson(),
        )
        .snapshots();
  }

  Future<String> getPath() async {
    try {
      //
      var querySnap = await firestore
          .collection('product')
          .withConverter<Product>(
            fromFirestore: (snapshot, _) => Product.fromJson(snapshot.data()!),
            toFirestore: (product, _) => product.toJson(),
          )
          .get();

      List<Product> allProduct = [];
      for (var element in querySnap.docs) {
        Product product = element.data();
        allProduct.add(product);
      }

      final pdf = pw.Document();

      var data =
          await rootBundle.load("assets/fonts/opensans/OpenSans-Regular.ttf");
      var myFont = Font.ttf(data);
      var myStyle =
          TextStyle(font: myFont, fontWeight: FontWeight.bold, fontSize: 18);

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          header: (context) {
            return Center(child: Text('Daptar Product', style: myStyle));
          },
          build: (context) {
            return [
              pw.Container(
                color: PdfColors.white,
                padding: const EdgeInsets.all(10),
                child: Table(
                  border: TableBorder.all(color: PdfColors.black),
                  children: [
                    TableRow(
                        verticalAlignment: TableCellVerticalAlignment.middle,
                        children: [
                          Center(
                            child: Text('Nama Barang', style: myStyle),
                          ),
                          Center(
                            child: Text('Kode Barang', style: myStyle),
                          ),
                          Center(
                            child: Text('Jumlah Barang', style: myStyle),
                          )
                        ]),
                    for (var i in allProduct.toList())
                      TableRow(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          children: [
                            Center(
                              child: Text('${i.name}', style: myStyle),
                            ),
                            Center(
                              child: Text('${i.code}', style: myStyle),
                            ),
                            Center(
                              child: Text('${i.quantity}', style: myStyle),
                            )
                          ])
                  ],
                ),
              )
            ];
          },
        ),
      );
      Uint8List bytes = await pdf.save();

      final dir = await getApplicationDocumentsDirectory();
      File file = File('${dir.path}/myproduct.pdf');

      await file.writeAsBytes(bytes);

      // await OpenFile.open(file.path);
      print(file.path);
      return file.path;

      // emit(ProductStateComplateExport());
    } catch (e) {
      print(e);
      return '';
    }
  }

  ProductBloc() : super(ProductStateInitial()) {
    on<ProductEventAddProduct>((event, emit) async {
      try {
        emit(ProductStateLoading());

        var hasil = await firestore.collection('product').add({
          'code': event.code,
          'name': event.name,
          'quantity': event.quantity
        });

        await firestore
            .collection('product')
            .doc(hasil.id)
            .update({'productId': hasil.id});

        emit(ProductStateComplateAdd());
      } on FirebaseException catch (e) {
        emit(ProductStateError(e.message ?? "Gagal menambah product"));
      } catch (e) {
        emit(ProductStateError("Gagal menambah product"));
      }
    });

    on<ProductEventEditProduct>((event, emit) async {
      try {
        emit(ProductStateLoading());
        await firestore
            .collection('product')
            .doc(event.id)
            .update({'name': event.name, 'quantity': event.quantity});
        emit(ProductStateComplateEdit());
      } on FirebaseException catch (e) {
        emit(ProductStateError(e.message ?? "Gagal update product"));
      } catch (e) {
        emit(ProductStateError("Gagal update product"));
      }
    });

    on<ProductEventDeleteProduct>((event, emit) async {
      try {
        await firestore.collection('product').doc(event.id).delete();
        emit(ProductStateComplateDelete());
      } on FirebaseException catch (e) {
        emit(ProductStateError(e.message ?? "Gagal menghapus product"));
      } catch (e) {
        emit(ProductStateError("Gagal menghapus product"));
      }
    });

    on<ProductEventExportPdf>((event, emit) async {
      try {
        emit(ProductStateLoadingExport());
        //
        var querySnap = await firestore
            .collection('product')
            .withConverter<Product>(
              fromFirestore: (snapshot, _) =>
                  Product.fromJson(snapshot.data()!),
              toFirestore: (product, _) => product.toJson(),
            )
            .get();

        List<Product> allProduct = [];
        for (var element in querySnap.docs) {
          Product product = element.data();
          allProduct.add(product);
        }

        final pdf = pw.Document();

        var data =
            await rootBundle.load("assets/fonts/opensans/OpenSans-Regular.ttf");
        var myFont = Font.ttf(data);
        var myStyle = TextStyle(font: myFont);

        pdf.addPage(
          pw.MultiPage(
            pageFormat: PdfPageFormat.a4,
            build: (context) {
              return [
                pw.Text('Test', style: myStyle),
              ];
            },
          ),
        );
        Uint8List bytes = await pdf.save();

        final dir = await getApplicationDocumentsDirectory();
        File file = File('${dir.path}/myproduct.pdf');

        await file.writeAsBytes(bytes);

        // await OpenFile.open(file.path);
        print(file.path);
        // return file.path.toString();

        // emit(ProductStateComplateExport());
      } on FirebaseException catch (e) {
        emit(ProductStateError(e.message ?? "Gagal export PDF product"));
      } catch (e) {
        emit(ProductStateError("Gagal export PDF product"));
      }
    });
  }
}
