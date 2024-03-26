import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qrcode_bloc/bloc/bloc.dart';
import 'package:qrcode_bloc/models/product.dart';

class DetailProductPage extends StatelessWidget {
  DetailProductPage(this.id, this.product, {super.key});

  final String id;
  final Product product;

  final TextEditingController codeC = TextEditingController();
  final TextEditingController nameC = TextEditingController();
  final TextEditingController quantityC = TextEditingController();
  @override
  Widget build(BuildContext context) {
    codeC.text = product.code!;
    nameC.text = product.name!;
    quantityC.text = product.quantity.toString();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Product'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 200,
                width: 200,
                child: QrImageView(
                  data: product.code!,
                  size: 200,
                  version: QrVersions.auto,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            controller: codeC,
            readOnly: true,
            autocorrect: false,
            maxLength: 10,
            decoration: InputDecoration(
              labelText: 'Kode Barang',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            controller: nameC,
            autocorrect: false,
            decoration: InputDecoration(
              labelText: 'Nama Barang',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            controller: quantityC,
            autocorrect: false,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Jumlah Barang',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(5),
              backgroundColor: Colors.green,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
            ),
            onPressed: () {
              context.read<ProductBloc>().add(ProductEventEditProduct(
                    id: product.productId!,
                    name: nameC.text,
                    quantity: int.tryParse(quantityC.text) ?? 0,
                  ));
            },
            child: BlocConsumer<ProductBloc, ProductState>(
              listener: (context, state) {
                if (state is ProductStateError) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(state.message)));
                }

                if (state is ProductStateComplateEdit) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      duration: Duration(seconds: 2),
                      content: Text('berhasil update product'),
                    ),
                  );
                  context.pop();
                }
              },
              builder: (context, state) {
                return Text(
                  state is ProductStateLoading ? 'Loading...' : 'Update Barang',
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                );
              },
            ),
          ),
          TextButton(
            onPressed: () {
              context
                  .read<ProductBloc>()
                  .add(ProductEventDeleteProduct(product.productId!));
            },
            child: BlocConsumer<ProductBloc, ProductState>(
              listener: (context, state) {
                if (state is ProductStateError) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(state.message)));
                }

                if (state is ProductStateComplateDelete) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      duration: Duration(seconds: 2),
                      content: Text('berhasil menghapus product'),
                    ),
                  );
                  context.pop();
                }
              },
              builder: (context, state) {
                return Text(
                  'Hapus Barang',
                  style: TextStyle(fontSize: 15, color: Colors.red[900]),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
