import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qrcode_bloc/bloc/bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../models/product.dart';
import '../routes/router.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    ProductBloc productB = context.read<ProductBloc>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Semua Product'),
        centerTitle: true,
        backgroundColor: Colors.greenAccent,
      ),
      body: StreamBuilder<QuerySnapshot<Product>>(
        stream: productB.streamProduct(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: Text('Tidak ada data'),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text('Tidak dapat mengambil data'),
            );
          }

          List<Product> allProduct = [];

          for (var element in snapshot.data!.docs) {
            allProduct.add(element.data());
          }

          if (allProduct.isEmpty) {
            return const Center(
              child: Text('Tidak ada data'),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: allProduct.length,
            itemBuilder: (context, index) {
              Product product = allProduct[index];
              return Card(
                elevation: 10,
                margin: const EdgeInsets.only(bottom: 20),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    context.goNamed(
                      Routes.detailProduct,
                      pathParameters: {
                        'id': product.productId!,
                      },
                      extra: product,
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    height: 110,
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${product.code}'),
                              const SizedBox(
                                height: 5,
                              ),
                              Text('${product.name}'),
                              const SizedBox(
                                height: 5,
                              ),
                              Text('Jumlah : ${product.quantity}'),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 50,
                          width: 50,
                          child: QrImageView(
                            data: product.code!,
                            size: 200,
                            version: QrVersions.auto,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
