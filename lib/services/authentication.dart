import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Authentication {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<String> signInWithGoogle() async{
    try{
      final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential authResult = await _auth.signInWithCredential(credential);
      final User? user = authResult.user;
      print("Signed in with Google: ${user!.displayName}");
      return user.uid;

    } catch(e){
      print(e.toString());
      return "";
    }
  }

  // Login with Google Play Games
  Future<User?> signInWithGooglePlayGames() async {
    return null;
  

  }

  // Login with Apple Game Center
  Future<User?> signInWithAppleGameCenter() async {
    return null;
  

  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
    if (await _googleSignIn.isSignedIn()) {
      await _googleSignIn.signOut();
    }
  }

  Future<String> getCurrentUser() async {
    final User? user = _auth.currentUser;
    // print("User Name: ${user!.displayName}");
    return user!.uid;
  }

}