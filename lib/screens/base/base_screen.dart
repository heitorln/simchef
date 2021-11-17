import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quick_actions/quick_actions.dart';
import 'package:sim_chefe_2021/models/page_manager.dart';
import 'package:provider/provider.dart';
import 'package:sim_chefe_2021/models/user_manager.dart';
import 'package:sim_chefe_2021/screens/cart/cart_screen.dart';
import 'package:sim_chefe_2021/screens/home/home_screen.dart';
import 'package:sim_chefe_2021/screens/orders/orders_screen.dart';
import 'package:sim_chefe_2021/screens/products/products_screen.dart';
import 'package:sim_chefe_2021/screens/profissional_orders/profissional_orders_screen.dart';

class BaseScreen extends StatefulWidget {

  @override
  _BaseScreenState createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  final PageController pageController = PageController();

  final QuickActions quickActions = QuickActions();

  @override
  void initState() {
    super.initState();

    // quickActions.setShortcutItems([
    //   ShortcutItem(type: 'product', localizedTitle: 'Receitas', icon: 'outline_menu_book_black_24dp'),
    //   ShortcutItem(type: 'order',localizedTitle: 'Meus Pedidos', icon: 'outline_playlist_add_check_black_24dp'),
    //   ShortcutItem(type: 'cart',localizedTitle: 'Carrinho', icon: 'baseline_shopping_cart_black_24dp'),
    // ]);
    //
    // quickActions.initialize((type) {
    //   if(type == 'product') {
    //     Navigator.of(context).pushNamed('/product');
    //   } else if(type == 'order') {
    //     Navigator.of(context).push(MaterialPageRoute(builder: (context) => OrdersScreen()));
    //   } else if(type == 'cart') {
    //     Navigator.of(context).push(MaterialPageRoute(builder: (context) => CartScreen()));
    //   }
    // });


    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp
    ]);

    configFCM();

  }

  void configFCM() {
    final fcm = FirebaseMessaging.instance;

    if(Platform.isIOS) {
      fcm.requestPermission(provisional: true);
    }

    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      showNotification(
          event.notification!.title,
          event.notification!.body
      );
    });

    FirebaseMessaging.onMessage.listen((event) {
      showNotification(
        event.notification!.title,
        event.notification!.body
      );
    });

  }

  void showNotification(String? title, String? message){
    Flushbar(
      title: title,
      message: message,
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.GROUNDED,
      isDismissible: true,
      backgroundColor: Colors.white,
      duration: const Duration(seconds: 5),
      icon: Icon(Icons.shopping_cart, color: Colors.black,),
      messageColor: Colors.black,
      titleColor: Colors.black,
    ).show(context);
  }

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => PageManager(pageController),
      child: Consumer<UserManager>(
        builder: (_, userManager, __) {
          return PageView(
            controller: pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              HomeScreen(),
              ProductsScreen(),
              OrdersScreen(),
              if(userManager.profissionalEnabled)
                ... [
                  ProfissionalOrdersScreen()
                ]
            ],
          );
        },
      ),
    );
  }
}
