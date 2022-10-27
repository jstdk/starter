import 'package:flutter/foundation.dart';
import 'package:supabase/supabase.dart';

class UserProvider extends ChangeNotifier {
  late final Session? session;
  late final User? user;

  // // Sign up user with email and password
  // Future signUpUsingEmailAndPassword({email, password}) async {
  //   try {
  //     final response =
  //         await supabase.auth.signUp(email: email, password: password);
  //     user = response.user;
  //     return user;
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  // Future signInUsingEmailAndPassword(email, password) async {
  //   try {
  //     final response = await supabase.auth
  //         .signInWithPassword(email: email, password: password);
  //     getCurrentUser();
  //     session = response.session;
  //     user = response.user;
  //     return user;
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  // Future resetPassword(email) async {
  //   try {
  //     // final response = await supabase.auth
  //     //     .signInWithPassword(email: email, password: password);
  //     // print(response);
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  //final FirebaseAuth _auth = FirebaseAuth.instance;

  // UserProvider? _userFromFirebaseUser(User? user) {
  //   if (kDebugMode && user != null) {
  //     if (kDebugMode) {
  //       print('Firebase UID is: ${user.uid}');
  //     }
  //   }
  //   return UserProvider(uid: user?.uid);
  // }

  // Stream<UserProvider?> get user {
  //   //return _auth.userChanges().map(_userFromFirebaseUser);
  // }

  // Future signUpUsingEmailAndPassword({String? email, String? password}) async {
  //   try {
  //     await _auth.createUserWithEmailAndPassword(
  //         email: email!, password: password!);
  //   } on FirebaseAuthException catch (e) {
  //     return e.message;
  //   }
  // }

  // //SIGN IN METHOD
  // Future signInUsingEmailAndPassword(String? email, String? password) async {
  //   try {
  //     await _auth.signInWithEmailAndPassword(
  //         email: email!, password: password!);

  //     return null;
  //   } on FirebaseAuthException catch (e) {
  //     return e.message;
  //   }
  // }

  // Future resetPassword(String? email) async {
  //   if (kDebugMode) {
  //     print(email);
  //   }
  //   try {
  //     await _auth.sendPasswordResetEmail(email: email!);
  //     return null;
  //   } on FirebaseAuthException catch (e) {
  //     return e.message;
  //   }
  // }

  // Future signOut() async {
  //   try {
  //     await _auth.signOut();
  //     if (kDebugMode) {
  //       print('Signing out user');
  //     }
  //     return null;
  //   } on FirebaseAuthException catch (e) {
  //     return e.message;
  //   }
  // }

  // Future<UserCredential> signInWithGoogle() async {
  //   // Trigger the authentication flow
  //   final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  //   // Obtain the auth details from the request
  //   final GoogleSignInAuthentication googleAuth =
  //       await googleUser!.authentication;

  //   // Create a new credential
  //   final credential = GoogleAuthProvider.credential(
  //     accessToken: googleAuth.accessToken,
  //     idToken: googleAuth.idToken,
  //   );

  //   // Once signed in, return the UserCredential
  //   return await FirebaseAuth.instance.signInWithCredential(credential);
  // }

  // Future<UserCredential?> signInWithFacebook() async {
  //   final LoginResult result = await FacebookAuth.instance.login();
  //   if (result.status == LoginStatus.success) {
  //     if (kDebugMode) {
  //       print('User login using Facebook');
  //     }
  //     final OAuthCredential credential =
  //         FacebookAuthProvider.credential(result.accessToken!.token);
  //     return await FirebaseAuth.instance.signInWithCredential(credential);
  //   }
  //   return null;
  // }

  // String generateNonce([int length = 32]) {
  //   const charset =
  //       '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
  //   final random = Random.secure();
  //   return List.generate(length, (_) => charset[random.nextInt(charset.length)])
  //       .join();
  // }

  // String sha256ofString(String input) {
  //   final bytes = utf8.encode(input);
  //   final digest = sha256.convert(bytes);
  //   return digest.toString();
  // }

  // Future<UserCredential> signInWithApple() async {
  //   final rawNonce = generateNonce();
  //   final nonce = sha256ofString(rawNonce);

  //   final appleCredential = await SignInWithApple.getAppleIDCredential(
  //     scopes: [
  //       AppleIDAuthorizationScopes.email,
  //       AppleIDAuthorizationScopes.fullName,
  //     ],
  //     nonce: nonce,
  //   );

  //   final oauthCredential = OAuthProvider("apple.com").credential(
  //     idToken: appleCredential.identityToken,
  //     rawNonce: rawNonce,
  //   );

  //   return await FirebaseAuth.instance.signInWithCredential(oauthCredential);
  // }
}
