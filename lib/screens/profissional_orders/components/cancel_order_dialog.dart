import 'package:flutter/material.dart';
import 'package:sim_chefe_2021/models/order.dart';

class CancelOrderDialog extends StatefulWidget {

  CancelOrderDialog(this.order);

  final Order order;

  @override
  State<CancelOrderDialog> createState() => _CancelOrderDialogState();
}

class _CancelOrderDialogState extends State<CancelOrderDialog> {

  bool loading = false;
  String? error;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: AlertDialog(
        title: Text('Cancelar ${widget.order.formattedId}?'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
                loading
                    ? 'Cancelando...'
                    : 'Esta ação não poderá ser desfeita!'
            ),
            if(error != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                    error!,
                  style: TextStyle(
                    color: Colors.red
                  ),
                ),
              )
          ],
        ),
        actions: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: !loading ? (){
                      Navigator.of(context).pop();
                    } : null,
                    style: ElevatedButton.styleFrom(
                        onPrimary: Colors.black,
                        primary: Colors.transparent,
                        shadowColor: Colors.transparent
                    ),
                    child: const Text('Fechar'),
                  ),
                ),
                ElevatedButton(
                  onPressed: !loading ? () async{
                    setState(() {
                      loading = true;
                    });
                    try {
                      await widget.order.cancel();
                      Navigator.of(context).pop();
                    } catch (e) {
                      setState(() {
                        loading = false;
                        error = e.toString();
                      });
                    }

                  } : null,
                  style: ElevatedButton.styleFrom(
                      onPrimary: Colors.red,
                      primary: Colors.transparent,
                      shadowColor: Colors.transparent
                  ),
                  child: const Text('Cancelar Pedido'),
                )
              ],
            ),
        ],
      ),
    );
  }
}
