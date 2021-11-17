import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sim_chefe_2021/helpers/validators.dart';
import 'package:sim_chefe_2021/models/user_data.dart';
import 'package:sim_chefe_2021/models/user_manager.dart';

class ForgotPassword extends StatelessWidget {

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final UserData user = UserData(email: '',name: '',id: '',password: '');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('Redefinir Senha'),
        centerTitle: true,
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
              key: formKey,
              child: Consumer<UserManager>(
                builder: (_, userManager,__){
                  return ListView(
                    padding: const EdgeInsets.all(16),
                    shrinkWrap: true,
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(hintText: 'E-mail'),
                        keyboardType: TextInputType.emailAddress,
                        enabled: !userManager.loading,
                        validator: (email) {
                          if(email!.isEmpty)
                            return 'Campo obrigatório';
                          else if (!emailValid(email))
                            return 'E-mail inválido';
                          return null;
                        },
                        onSaved: (email) => user.email = email!,
                      ),
                      const SizedBox(height: 16,),
                      SizedBox(
                        height:44,
                        child: ElevatedButton(
                          onPressed: userManager.loading ? null :() {
                            if(formKey.currentState!.validate()) {
                              formKey.currentState!.save();
                              userManager.recoveryPass(user: user,);
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Email de Recuperação Enviado!'),
                                    backgroundColor: Colors.red,
                                  )
                              );
                              Future.delayed(const Duration(seconds: 4), () {
                                Navigator.of(context).pop();
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            onSurface: Theme.of(context).primaryColor,
                            primary: Theme.of(context).primaryColor
                          ),
                          child: userManager.loading ?
                          CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          )
                              : const Text('Redefinir Senha',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              )
          ),
        ),
      ),
    );
  }
}