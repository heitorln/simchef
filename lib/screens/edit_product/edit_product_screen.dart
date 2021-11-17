import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sim_chefe_2021/models/product.dart';
import 'package:sim_chefe_2021/models/product_manager.dart';
import 'package:sim_chefe_2021/models/user_manager.dart';
import 'package:sim_chefe_2021/screens/edit_product/components/ingredient_form2.dart';

import 'components/images_form.dart';
import 'components/preparation_form2.dart';

class EditProductScreen extends StatelessWidget {

  EditProductScreen(Product p) :
        editing = p != null,
        product = p != null ? p.clone() : Product(stock: 0);

  final Product product;
  final bool editing;
  
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: product,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text(editing ? 'Editar Receita' : 'Criar Receita'),
          centerTitle: true,
          actions: [
            if(editing)
              IconButton(
                onPressed: (){
                  context.read<ProductManager>().delete(product);
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.delete)
              )
          ],
        ),
        backgroundColor: Colors.white,
        body: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                ImagesForm(product),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        initialValue: product.name,
                        decoration: const InputDecoration(
                            hintText: 'Título',
                            border: InputBorder.none
                        ),
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600
                        ),
                        validator: (name) {
                          if(name!.length < 6)
                            return 'Título muito curto';
                          return null;
                        },
                        onSaved: (name) => product.name = name,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          'A partir de',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 13,
                          ),
                        ),
                      ),
                      TextFormField(
                        initialValue: product.price?.toStringAsFixed(2),
                        decoration: const InputDecoration(
                            hintText: 'Preço',
                            border: InputBorder.none,
                            prefixText: 'R\$'
                        ),
                        keyboardType: TextInputType.numberWithOptions(decimal: true,signed: true),
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                        validator: (price) {
                          if(num.tryParse(price!) == null)
                            return 'Inválido';
                          return null;
                        },
                        onSaved: (price) => product.price = num.tryParse(price!),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Text(
                          'Tempo de Preparo',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      TextFormField(
                        initialValue: product.preparationTime?.toString(),
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                        decoration: const InputDecoration(
                            hintText: 'Tempo de Preparo',
                            border: InputBorder.none,
                            suffixText: ' minutos'
                        ),
                        keyboardType: TextInputType.number,
                        validator: (preparationTime) {
                          if(int.tryParse(preparationTime!) == null)
                            return 'Inválido';
                          return null;
                        },
                        onSaved: (preparationTime) => product.preparationTime = int.tryParse(preparationTime!),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Text(
                          'Descrição',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      TextFormField(
                        initialValue: product.description,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                        decoration: const InputDecoration(
                          hintText: 'Descrição',
                          border: InputBorder.none,
                        ),
                        maxLines: null,
                        validator: (desc) {
                          if(desc!.length < 10)
                            return 'Descrição muito curta';
                          return null;
                        },
                        onSaved: (desc) => product.description = desc,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Text(
                          'Estoque',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      TextFormField(
                        initialValue: product.stock.toString(),
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                        decoration: const InputDecoration(
                          hintText: 'Estoque',
                          border: InputBorder.none,
                        ),
                        keyboardType: TextInputType.number,
                        validator: (stock) {
                          if(int.tryParse(stock!) == null)
                            return 'Inválido';
                          return null;
                        },
                        onSaved: (stock) => product.stock = int.tryParse(stock!)!,
                      ),
                      //PreparationForm1(product),
                      PreparationForm2(product),
                      IngredientForm2(product),
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Text(
                          'Url Video',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      TextFormField(
                        initialValue: product.urlVideo,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                        decoration: const InputDecoration(
                          hintText: 'Descrição',
                          border: InputBorder.none,
                        ),
                        maxLines: null,
                        validator: (url) {
                          if(url!.length < 0)
                            return 'Url Muito Curta';
                          return null;
                        },
                        onSaved: (url) => product.urlVideo = url,
                      ),
                      const SizedBox(height: 20,),
                      //IngredientsForm1(product),
                      Consumer2<UserManager,Product>(
                        builder: (_,userManager,product, __) {
                          return ElevatedButton(
                            onPressed: !product.loading ? () async{
                              if(formKey.currentState!.validate()) {
                                formKey.currentState!.save();
                                product.createBy = userManager.user!.name;
                                product.idUser = userManager.user!.id;
                                await product.save();

                                context.read<ProductManager>().update(product);

                                Navigator.of(context).pop();
                              }
                            } : null,
                            style: ElevatedButton.styleFrom(
                              primary: Theme.of(context).primaryColor,
                            ),
                            child: product.loading ?
                            CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                            ) : const Text(
                              'Salvar',
                              style: TextStyle(fontSize: 18),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),

          ),
        ),
      ),
    );
  }
}
