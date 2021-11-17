import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sim_chefe_2021/common/custom_drawer/drawer_tile.dart';
import 'package:sim_chefe_2021/models/user_manager.dart';

import 'custom_drawer_header.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white,
                    Colors.white,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                )
              ),
            ),
        ListView(
          children: [
            CustomDrawerHeader(),
            const Divider(),
            DrawerTile(
              iconData: Icons.home,
              title: 'Início',
              page: 0,
            ),
            DrawerTile(
              iconData: Icons.menu_book_outlined,
              title: 'Receitas',
              page: 1,
            ),
            DrawerTile(
              iconData: Icons.playlist_add_check,
              title: 'Meus Pedidos',
              page: 2,
            ),
            Consumer<UserManager>(
              builder: (_, userManager, __) {
                if(userManager.profissionalEnabled) {
                  return Column(
                    children: [
                      const Divider(),
                      DrawerTile(
                        iconData: Icons.settings,
                        title: 'Pedidos',
                        page: 3,
                      ),
                    ],
                  );
                } else {
                  return Container();
                }
              },
            ),
          ],
        ),
          ],
      ),
    );
  }
}
