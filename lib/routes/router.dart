import 'package:go_router/go_router.dart';
import 'package:qrcode_bloc/models/product.dart';
import 'package:qrcode_bloc/pages/add_product.dart';
import 'package:qrcode_bloc/pages/detail_product.dart';
import 'package:qrcode_bloc/pages/error.dart';
import 'package:qrcode_bloc/pages/pdf_view.dart';
import 'package:qrcode_bloc/pages/products.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../pages/home.dart';
import '../pages/login.dart';
part 'route_name.dart';

// GoRouter configuration
final router = GoRouter(
  redirect: (context, state) {
    FirebaseAuth auth = FirebaseAuth.instance;
    if (auth.currentUser == null) {
      return '/login';
    } else {
      return null;
    }
  },
  errorBuilder: (context, state) => const ErrorPage(),
  routes: [
    GoRoute(
      path: '/',
      name: Routes.home,
      builder: (context, state) => const HomePage(),
      routes: [
        GoRoute(
          path: 'products',
          name: Routes.products,
          builder: (context, state) => const ProductsPage(),
          routes: [
            GoRoute(
              path: ':id',
              name: Routes.detailProduct,
              builder: (context, state) => DetailProductPage(
                  state.pathParameters['id'].toString(),
                  state.extra as Product),
            ),
          ],
        ),
        GoRoute(
          path: 'add-product',
          name: Routes.addProduct,
          builder: (context, state) => AddProductPage(),
        ),
        GoRoute(
          path: 'pdf-view',
          name: Routes.pdfView,
          builder: (context, state) =>
              PdfView(path: state.uri.queryParameters['link'].toString()),
        ),
      ],
    ),
    GoRoute(
      path: '/login',
      name: Routes.login,
      builder: (context, state) => LoginPage(),
    ),
  ],
);
