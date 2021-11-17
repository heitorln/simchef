import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sim_chefe_2021/common/custom_drawer/custor_drawer.dart';
import 'package:sim_chefe_2021/common/empty_card.dart';
import 'package:sim_chefe_2021/models/order.dart';
import 'package:sim_chefe_2021/models/profissional_orders_manager.dart';
import 'package:sim_chefe_2021/models/user_manager.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'components/order_tile_profissional.dart';

class ProfissionalOrdersScreen extends StatefulWidget {

  @override
  _ProfissionalOrdersScreenState createState() => _ProfissionalOrdersScreenState();
}

class _ProfissionalOrdersScreenState extends State<ProfissionalOrdersScreen> {
  final PanelController panelController = PanelController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('Todos Pedidos'),
        centerTitle: true,
      ),
      body: Consumer2<ProfissionalOrdersManager,UserManager>(
        builder: (_, ordersManager,userManager, __) {
          final filteredOrders = ordersManager.filteredOrders;

          return SlidingUpPanel(
            controller: panelController,
            body: Column(
              children: [
                if(filteredOrders.isEmpty)
                  Expanded(
                    child: EmptyCard(
                      title: 'Nenhuma venda realizada!',
                      iconData: Icons.border_clear,
                    ),
                  )
                  else
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredOrders.length,
                      itemBuilder: (_, index) {
                        return OrderTileProfissional(
                          filteredOrders[index],userManager
                        );
                      }
                    ),
                  ),
                const SizedBox(height: 120,)
              ],
            ),
            minHeight: 40,
            maxHeight: 250,
            panel: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GestureDetector(
                  onTap: (){
                    if(panelController.isPanelClosed) {
                      panelController.open();
                    } else {
                      panelController.close();
                    }
                  },
                  child: Container(
                    height: 40,
                    color: Colors.white,
                    alignment: Alignment.center,
                    child: Text(
                      'Filtros',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w800,
                        fontSize: 16
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: Status.values.map((s) {
                        return CheckboxListTile(
                          title: Text(Order.getStatusText(s)),
                          dense: true,
                          value: ordersManager.statusFilter.contains(s),
                          onChanged: (v) {
                            ordersManager.setStatusFilter(
                              status: s,
                              enabled: v!
                            );
                          }
                        );
                      }).toList(),
                  ),
                )
              ],
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.0),
              topRight: Radius.circular(24.0),
            ),
          );
        },
      ),
    );
  }
}
