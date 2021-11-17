import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sim_chefe_2021/common/custom_drawer/custor_drawer.dart';
import 'package:sim_chefe_2021/models/home_manager.dart';

import 'components/section_list.dart';
import 'components/section_staggered.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      body: Stack(
        children:[
          // Container(
          //   decoration: BoxDecoration(
          //     gradient: LinearGradient(
          //       colors: [
          //
          //       ]
          //     )
          //   ),
          // ),
          CustomScrollView(
          slivers: [
            SliverAppBar(
              snap: true,
              floating: true,
              backgroundColor: Colors.transparent,
              flexibleSpace: const FlexibleSpaceBar(
                title: Text('Sim Chefe'),
                centerTitle: true,

              ),
              actions: [
                IconButton(
                  onPressed: () => Navigator.of(context).pushNamed('/cart'),
                  icon: Icon(Icons.shopping_cart),
                  color: Colors.white,
                ),
              ],
            ),
            Consumer<HomeManager>(
              builder: (_, homeManager, __) {
                final List<Widget> children = homeManager.sections.map<Widget>(
                  (section) {
                    switch(section.type){
                      case 'List':
                        return SectionList(section);
                      case 'Staggered':
                        return SectionStaggered(section);
                      default:
                        return Container();

                    }
                }
                ).toList();

                return SliverList(
                    delegate: SliverChildListDelegate(children),
                );
              },
            )
          ],
        ),
        ]
      ),
    );
  }
}
