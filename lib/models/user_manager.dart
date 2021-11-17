import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:sim_chefe_2021/helpers/firebase_errors.dart';
import 'package:sim_chefe_2021/models/user_data.dart';

class UserManager extends ChangeNotifier{

  UserManager() {
    _loadCurrentUser();
  }

  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  UserData? user;

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  bool _loadingFace = false;
  bool get loadingFace => _loadingFace;
  set loadingFace(bool value) {
    _loadingFace = value;
    notifyListeners();
  }

  bool get isLoggedIn => user != null;

  bool get profissionalEnabled => user?.profile == 'Profissional';

  Future<void> signIn({required UserData user, required Function onFail, required Function onSuccess }) async {
    loading = true;
    try {
      final UserCredential result = await auth.signInWithEmailAndPassword(
          email: user.email, password: user.password!);

      // await _loadCurrentUser(firebaseUser: result.user);

      if(result.user!.emailVerified) {
        await _loadCurrentUser(firebaseUser: result.user);
      } else {
        await result.user!.sendEmailVerification();
        onFail('Email de verificação enviado');
        loading = false;
        return;
      }


     onSuccess();
    } on FirebaseAuthException catch (e){
      onFail(getErrorString(e.code));
    }
    loading = false;
  }

  Future<void> facebookLogin({ required Function onFail, required Function onSuccess }) async{
    loadingFace = true;

    final result = await FacebookLogin().logIn(['email', 'public_profile']);

    switch(result.status){

      case FacebookLoginStatus.loggedIn:
        final credential = FacebookAuthProvider.credential(
            result.accessToken.token
        );

        final authResult = await auth.signInWithCredential(credential);

        if(authResult.user != null) {
          final firebaseUser = authResult.user;

          user = UserData(
            id: firebaseUser!.uid,
            name: firebaseUser.displayName!,
            email: firebaseUser.email!
          );
          user!.profile = 'Amador';

          await user!.saveData();

          user!.saveToken();

          onSuccess();
        }

        break;
      case FacebookLoginStatus.cancelledByUser:
        // TODO: Handle this case.
        break;
      case FacebookLoginStatus.error:
        onFail(result.errorMessage);
        break;
    }

    loadingFace = false;
  }

  // metodo para cadastrar ....
  Future<void> signUp({required UserData user, required Function onFail, required Function onSucess}) async{

    loading = true;
    try {
      final UserCredential result = await auth.createUserWithEmailAndPassword(
          email: user.email, password: user.password!);

      // user.id = result.user!.uid;
      // this.user = user;
      //
      // await user.saveData();

      if(!result.user!.emailVerified) {
        user.id = result.user!.uid;
        this.user = user;
        await user.saveData();
        // user.saveToken();
        this.user = null;
        notifyListeners();
      }

      user.saveToken();

      onSucess();
    } on FirebaseAuthException catch(e) {
      onFail(getErrorString(e.code));
    }
    loading = false;
  }

  void recoveryPass({required UserData user}) {
    auth.sendPasswordResetEmail(email: user.email);
    notifyListeners();
  }

  void signOut() {
    auth.signOut();
    user = null;
    notifyListeners();
  }

  Future<void> _loadCurrentUser({ User? firebaseUser}) async{

    final User? currentUser = firebaseUser ?? await auth.currentUser;
    if(currentUser != null){
      final DocumentSnapshot docUser = await firestore.collection('users')
          .doc(currentUser.uid).get();
      user = UserData.fromDocument(docUser);

      user!.saveToken();

      notifyListeners();
    }
  }


}