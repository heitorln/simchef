import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sim_chefe_2021/common/custom_icon_button.dart';
import 'package:sim_chefe_2021/models/cart_product.dart';

class CartTile extends StatelessWidget {
  
  const CartTile(this.cartProduct);
  
  final CartProduct cartProduct;
  
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: cartProduct,
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed(
              '/product',
          arguments: cartProduct.product);
        },
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 16,vertical: 4),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                SizedBox(
                  height: 80,
                  width: 80,
                  child: Image.network(cartProduct.product?.images!.first ?? 'https://firebasestorage.googleapis.com/v0/b/sim-chefe-2021.appspot.com/o/placeholder-1.png?alt=media&token=d3cfc2c2-bb7a-4011-9f2b-a5a28ab9df3c'),
                ),
                Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            cartProduct.product?.name ?? '',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 17
                            ),
                          ),
                          Consumer<CartProduct>(
                            builder: (_,cartProduct,__) {
                              if(cartProduct.hasStock)
                              return Text(
                                'R\$ ${cartProduct.product!.price}',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold
                                ),
                              );
                              else
                                return Text(
                              'Sem estoque disponível',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 12,
                                  ),
                                );
                            },
                          ),
                        ],
                      ),
                    )
                ),
                Consumer<CartProduct>(
                    builder: (_,cartProduct,__) {
                      return Column(
                        children: [
                          CustomIconButton(
                            iconData: Icons.add,
                            color: Colors.black,
                            onTap: cartProduct.increment,
                            size: 24,
                          ),
                          Text(
                            '${cartProduct.quantity}',
                            style: const TextStyle(fontSize: 20),
                          ),
                          CustomIconButton(
                            iconData: cartProduct.quantity > 1 ?
                            Icons.remove : Icons.delete,
                            color: cartProduct.quantity > 1 ?
                            Colors.black : Colors.red,
                            onTap: cartProduct.decrement,
                            size: 24,
                          ),
                        ],
                      );
                    }
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
