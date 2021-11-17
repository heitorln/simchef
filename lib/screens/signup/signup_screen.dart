import 'package:flutter/material.dart';
import 'package:sim_chefe_2021/helpers/validators.dart';
import 'package:sim_chefe_2021/models/user_data.dart';
import 'package:provider/provider.dart';
import 'package:sim_chefe_2021/models/user_manager.dart';

class SignUpScreen extends StatelessWidget {

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final UserData user = UserData(email: '', password: '', name: '', id: '');

  final List<String> profiles = ['Amador','Profissional'];

  String _dropDownValue = 'Amador';

  String get dropDownValue => _dropDownValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('Criar Conta'),
        centerTitle: true,
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: formKey,
            child: Consumer<UserManager>(
              builder: (_,userManager,__) {
                return ListView(
                  padding: const EdgeInsets.all(16),
                  shrinkWrap: true,
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(hintText: 'Nome Completo'),
                      enabled: !userManager.loading,
                      validator: (name) {
                        if(name!.isEmpty)
                          return 'Campo Obrigatório';
                        else if(name.trim().split(' ').length <= 1)
                          return 'Preencha seu nome completo';
                        return null;
                      },
                      onSaved: (name) => user.name = name!,
                    ),
                    const SizedBox(height: 16,),
                    TextFormField(
                      decoration: const InputDecoration(hintText: 'Email'),
                      enabled: !userManager.loading,
                      keyboardType: TextInputType.emailAddress,
                      validator: (email) {
                        if(email!.isEmpty)
                          return 'Campo Obrigatório';
                        else if(!emailValid(email))
                          return 'E-mail inválido';
                        return null;
                      } ,
                      onSaved: (email) => user.email = email!,
                    ),
                    const SizedBox(height: 16,),
                    TextFormField(
                      decoration: const InputDecoration(hintText: 'Senha'),
                      enabled: !userManager.loading,
                      obscureText: true,
                      validator: (pass) {
                        if(pass!.isEmpty)
                          return 'Campo Obrigatório';
                        else if(pass.length < 6)
                          return 'Senha muito curta';
                        return null;
                      },
                      onSaved: (pass) => user.password = pass!,
                    ),
                    const SizedBox(height: 16,),
                    TextFormField(
                      decoration: const InputDecoration(hintText: 'Repita a Senha'),
                      enabled: !userManager.loading,
                      obscureText: true,
                      validator: (pass) {
                        if(pass!.isEmpty)
                          return 'Campo Obrigatório';
                        else if(pass.length < 6)
                          return 'Senha muito curta';
                        return null;
                      },
                      onSaved: (pass) => user.confirmPassword = pass!,
                    ),
                    const SizedBox(height: 16,),

                    DropdownButtonFormField<String>(
                      value: _dropDownValue,
                      hint: Text("Type of business"),
                      onChanged: (newValue) {
                        setState(() {
                          _dropDownValue = user.profile;
                        });
                      },
                      items: profiles
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onSaved: (val) =>user.profile = val!,
                    ),

                    const SizedBox(height: 16,),
                    TextButton(

                      style: TextButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        primary: Colors.white,

                      ),
                      onPressed: userManager.loading ? null : () {
                        if(formKey.currentState!.validate()) {
                          formKey.currentState!.save();
                          print(user.profile);

                          if(user.password != user.confirmPassword) {

                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text('Senhas não coincidem!'),
                                  backgroundColor: Colors.red,
                                )
                            );

                            return;
                          }

                          userManager.signUp(
                              user: user,
                              onSucess: () {
                                Navigator.of(context).pop();
                              },
                              onFail: (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Falha ao cadastrar: $e'),
                                      backgroundColor: Colors.red,
                                    )
                                );
                              }

                          );

                        }

                      },
                      child: userManager.loading ?
                      CircularProgressIndicator(
                       valueColor: AlwaysStoppedAnimation(Colors.white),
                      )
                      : const Text(
                        'Criar Conta',
                        style: TextStyle(
                          fontSize: 15 ,
                        ),
                      ),
                    )
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void setState(Null Function() param0) {}
}
