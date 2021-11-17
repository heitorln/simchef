import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:sim_chefe_2021/helpers/validators.dart';
import 'package:sim_chefe_2021/models/user_data.dart';
import 'package:sim_chefe_2021/models/user_manager.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class LoginScreen extends StatelessWidget {

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('Entrar'),
        centerTitle: true,
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/signup');
              },
              style: TextButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                primary: Colors.white,
              ),
              child: const Text(
                'CRIAR CONTA',
                style: TextStyle(fontSize: 14),
              )
          ),
        ],
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: formKey,
            child: Consumer<UserManager>(
              builder: (_, userManager,__) {
                if(userManager.loadingFace) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.blue),
                    ),
                  );
                }

                return ListView(
                  padding: const EdgeInsets.all(16),
                  shrinkWrap: true,
                  children: [
                    TextFormField(
                      controller: emailController,
                      enabled:  !userManager.loading,
                      decoration: const InputDecoration(hintText: 'Email'),
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      validator: (email){
                        if(!emailValid(email!))
                          return 'E-mail inválido';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16,),
                    TextFormField(
                      controller: passController,
                      enabled:  !userManager.loading,
                      decoration: const InputDecoration(hintText: 'Senha'),
                      autocorrect: false,
                      obscureText: true,
                      validator: (pass){
                        if(pass!.isEmpty || pass.length < 6)
                          return 'Senha Inválida';
                        return null;
                      },
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacementNamed('/forgotpassword');
                        },
                        style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            primary: Colors.black
                        ),
                        child: Text(
                            'Esqueci minha senha'
                        ),
                      ),
                    ),
                    const SizedBox(height: 16,),
                    TextButton(
                        onPressed: userManager.loading ? null : () {
                          if(formKey.currentState!.validate()) {
                            userManager.signIn(
                                user: UserData(
                                    email: emailController.text,
                                    password: passController.text, name: '', id: ''
                                ),
                              onFail: (e){
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Falha ao entrar: $e'),
                                      backgroundColor: Colors.red,
                                    )
                                );
                              },
                              onSuccess: () {
                                Navigator.of(context).pop();
                              },
                            );

                          }
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                            backgroundColor: Theme.of(context).primaryColor,
                            primary: Colors.white,

                        ),
                        child: userManager.loading ? CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        ) : const Text(
                          'Entrar',
                          style: TextStyle(
                              fontSize: 15,
                          ),
                        )
                    ),
                    SignInButton(
                      Buttons.Facebook,
                      padding: EdgeInsets.zero,
                      text: 'Entrar com Facebook',
                      onPressed: (){
                        userManager.facebookLogin(
                            onFail: (e){
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Falha ao entrar: $e'),
                                    backgroundColor: Colors.red,
                                  )
                              );
                            },
                            onSuccess: (){
                          Navigator.of(context).pop();
                        });
                      },
                    )
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
