import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:min_id/min_id.dart';
import 'package:provider/provider.dart';
import 'package:sim_chefe_2021/models/cart_manager.dart';
import 'package:sim_chefe_2021/models/home_manager.dart';
import 'package:sim_chefe_2021/models/order.dart';
import 'package:sim_chefe_2021/models/orders_manager.dart';
import 'package:sim_chefe_2021/models/product_manager.dart';
import 'package:sim_chefe_2021/models/profissional_orders_manager.dart';
import 'package:sim_chefe_2021/models/user_manager.dart';
import 'package:sim_chefe_2021/screens/address/address_screen.dart';
import 'package:sim_chefe_2021/screens/base/base_screen.dart';
import 'package:sim_chefe_2021/screens/cart/cart_screen.dart';
import 'package:sim_chefe_2021/screens/checkout/checkout_screen.dart';
import 'package:sim_chefe_2021/screens/confirmation/confirmation_screen.dart';
import 'package:sim_chefe_2021/screens/edit_product/edit_product_screen.dart';
import 'package:sim_chefe_2021/screens/forgot_password/forgot_password.dart';
import 'package:sim_chefe_2021/screens/login/login_screen.dart';
import 'package:sim_chefe_2021/screens/product/product_screen.dart';
import 'package:sim_chefe_2021/screens/signup/signup_screen.dart';

import 'models/product.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserManager(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => ProductManager(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => HomeManager(),
          lazy: false,
        ),
        ChangeNotifierProxyProvider<UserManager,CartManager>(
          create: (_) => CartManager(),
          lazy: false,
          update: (_, userManager, cartManager) =>
          cartManager!..updateUser(userManager),
        ),
        ChangeNotifierProxyProvider<UserManager, OrdersManager>(
            create: (_) => OrdersManager(),
            lazy: false,
            update: (_, userManager, ordersManager) =>
             ordersManager!..updateUser(userManager.user),
        ),
        ChangeNotifierProxyProvider<UserManager, ProfissionalOrdersManager>(
          create: (_) => ProfissionalOrdersManager(),
          lazy: false,
          update: (_, userManager, profissionalOrdersManager) =>
          profissionalOrdersManager!..updateProfissional(
            profissionalEnabled: userManager.profissionalEnabled,
            user: userManager.user
          ),
        ),

      ],
      child: MaterialApp(
        title: 'Sim Chefe',
        color: Colors.white,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: const Color.fromARGB(255, 191, 52, 58),
          scaffoldBackgroundColor: const Color.fromARGB(255, 191, 52, 58),
          appBarTheme: const AppBarTheme(
            elevation: 0
          )
        ),
        onGenerateRoute: (settings) {
          switch(settings.name){
            case '/login' :
              return MaterialPageRoute(
                  builder: (_) => LoginScreen()
              );
            case '/signup' :
               return MaterialPageRoute(
                   builder: (_) => SignUpScreen()
               );
            case '/forgotpassword':
              return MaterialPageRoute(
                  builder: (_) => ForgotPassword()
              );
            case '/product' :
              return MaterialPageRoute(
                  builder: (_) => ProductScreen(
                      settings.arguments as Product,
                  )
              );
            case '/cart' :
              return MaterialPageRoute(
                builder: (_) => CartScreen(),
                settings: settings
              );
            case '/address' :
              return MaterialPageRoute(
                  builder: (_) => AddressScreen()
              );
            case '/checkout' :
              return MaterialPageRoute(
                  builder: (_) => CheckoutScreen()
              );
            case '/edit_product' :
              return MaterialPageRoute(
                  builder: (_) => EditProductScreen(
                    settings.arguments as Product
                  )
              );
            case '/confirmation' :
              return MaterialPageRoute(
                  builder: (_) => ConfirmationScreen(
                    settings.arguments as Order
                  )
              );
            case '/' :
            default:
              return MaterialPageRoute(
                builder: (_) => BaseScreen(),
                settings: settings
              );
          }
        },
      ),
    );
  }
}