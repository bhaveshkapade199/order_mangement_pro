import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/theme/app_theme.dart';
import 'core/constants/app_constants.dart';

import 'repositories/auth_repository.dart';
import 'repositories/product_repository.dart';
import 'repositories/order_repository.dart';
import 'repositories/plumber_repository.dart';
import 'repositories/admin_repository.dart';

import 'blocs/auth/auth_bloc.dart';
import 'blocs/auth/auth_event.dart';
import 'blocs/product/product_bloc.dart';
import 'blocs/cart/cart_bloc.dart';
import 'blocs/order/order_bloc.dart';
import 'blocs/plumber/plumber_bloc.dart';
import 'blocs/admin/admin_bloc.dart';

import 'core/constants/api_endpoints.dart';
import 'core/network/api_client.dart';
import 'core/storage/token_storage.dart';

// Views
import 'views/auth/role_selection_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final savedUrl = await TokenStorage.getServerUrl();
  if (savedUrl != null && savedUrl.isNotEmpty) {
    ApiEndpoints.setBaseUrl(savedUrl);
    ApiClient().updateBaseUrl(ApiEndpoints.baseUrl);
  }
  runApp(const FlowProCommerceApp());
}

class FlowProCommerceApp extends StatelessWidget {
  const FlowProCommerceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => AuthRepository()),
        RepositoryProvider(create: (_) => ProductRepository()),
        RepositoryProvider(create: (_) => OrderRepository()),
        RepositoryProvider(create: (_) => PlumberRepository()),
        RepositoryProvider(create: (_) => AdminRepository()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                AuthBloc(authRepository: context.read<AuthRepository>())
                  ..add(AuthCheckRequested()),
          ),
          BlocProvider(
            create: (context) => ProductBloc(
              productRepository: context.read<ProductRepository>(),
            ),
          ),
          BlocProvider(create: (_) => CartBloc()),
          BlocProvider(
            create: (context) =>
                OrderBloc(orderRepository: context.read<OrderRepository>()),
          ),
          BlocProvider(
            create: (context) => PlumberBloc(
              plumberRepository: context.read<PlumberRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) =>
                AdminBloc(adminRepository: context.read<AdminRepository>()),
          ),
        ],
        child: MaterialApp(
          title: AppConstants.appName,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          home: const RoleSelectionView(),
        ),
      ),
    );
  }
}
