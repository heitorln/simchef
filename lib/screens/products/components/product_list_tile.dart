import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sim_chefe_2021/models/product.dart';
import 'package:transparent_image/transparent_image.dart';

class ProductListTile extends StatelessWidget {

  const ProductListTile(this.product);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed('/product',arguments: product);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        child: Container(
          height: 100,
          padding: EdgeInsets.all(8),
          child: Row(
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: FadeInImage.memoryNetwork(
                  placeholder: kTransparentImage,
                  image: product.images!.first,
                ),
              ),
              const SizedBox(width: 16,),
              Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name ?? '',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          'Receita do Chef: ${product.createBy}',
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Text(
                        'R\$ ${product.price}',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      if(!product.hasStock)
                        const Padding(
                          padding: EdgeInsets.only(top: 4),
                          child: Text(
                            'Sem estoque',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 10
                            ),
                          ),
                        )
                    ],
                  ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
