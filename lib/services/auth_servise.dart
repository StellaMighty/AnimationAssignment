import 'package:firebase_auth/firebase_auth.dart';
import 'package:AnimationAssignment/models/customer.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // this func below converts firebase user to customer our own user
  Customer _customerFromFirebase(User user) {
    return user != null ? Customer(uid: user.uid, email: user.email) : null;
  }

  // this function gets the stream of the STATUS of a customer per time(such as SIGN-IN and or SIGN OUT)
  Stream<Customer> get customer {
    return _auth.authStateChanges().map((user) => _customerFromFirebase(user));
  }

  Future<Customer> registerUser({String email, String password}) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      return _customerFromFirebase(userCredential.user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<Customer> loginCustomer({String email, String password}) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return _customerFromFirebase(userCredential.user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signOut() async {
    _auth.signOut();
    return null;
  }

  // Customer get customer {
  //   if (_auth.currentUser != null) {
  //     return _customerFromFirebase(_auth.currentUser);
  //   } else {
  //     return null;
  //   }
  // }

}
