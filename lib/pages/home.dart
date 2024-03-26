import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qrcode_bloc/routes/router.dart';
import '../bloc/bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Halaman Utama'),
        centerTitle: true,
        backgroundColor: Colors.greenAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: GridView.builder(
          itemCount: 3,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, mainAxisSpacing: 20, crossAxisSpacing: 20),
          itemBuilder: (context, index) {
            late final String title;
            late final IconData icon;
            late VoidCallback onTap;

            switch (index) {
              case 0:
                title = 'Add Product';
                icon = Icons.post_add;
                onTap = () {
                  context.goNamed(Routes.addProduct);
                };
                break;
              case 1:
                title = 'Product';
                icon = Icons.list_alt;
                onTap = () {
                  context.goNamed(Routes.products);
                };
                break;
              case 2:
                title = 'Catalog';
                icon = Icons.document_scanner;
                onTap = () async {
                  String hasil = await context.read<ProductBloc>().getPath();
                  // ignore: use_build_context_synchronously
                  context.goNamed(Routes.pdfView,
                      queryParameters: {'link': hasil});
                };
                break;
            }
            return Material(
              color: const Color.fromARGB(255, 183, 191, 196),
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                onTap: onTap,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      icon,
                      size: 50,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(title),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<AuthBloc>().add(AuthEventLogout());
        },
        child: const Icon(Icons.logout),
      ),
    );
  }
}
