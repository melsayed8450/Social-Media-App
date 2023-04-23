import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'package:social_media_app/app/presentation/manager/login_controller.dart';
import 'package:social_media_app/app/presentation/pages/home.dart';
import 'package:social_media_app/app/presentation/utils/assets.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  final controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 42, 56, 72),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Welcome!',
                  style: GoogleFonts.sacramento(
                    fontSize: 20.w,
                    fontStyle: FontStyle.italic,
                    color: Color.fromARGB(255, 215, 35, 135),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  child: Image.asset(
                    AppAssets.handInHand,
                  ),
                ),
                FutureBuilder(
                  future: LoginController.initializeFirebase(context: context),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error initializing Firebase');
                    } else if (snapshot.connectionState ==
                        ConnectionState.done) {
                      return Obx(
                         () {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: controller.isSigningIn.value
                                ? CircularProgressIndicator(
                                    valueColor:
                                        AlwaysStoppedAnimation<Color>(Colors.white),
                                  )
                                : OutlinedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(Colors.white),
                                      shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(40),
                                        ),
                                      ),
                                    ),
                                    onPressed: () async {
                                      controller.isSigningIn.value = true;

                                      User? user = await LoginController
                                          .signInWithGoogle(context: context);

                                      controller.isSigningIn.value = false;

                                      if (user != null) {
                                        Get.to(HomePage(user: user));
                                      }
                                    },
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Image(
                                            image: AssetImage(AppAssets.googleIcon),
                                            height: 35.0,
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: Text(
                                              'Sign in with Google',
                                              style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.black54,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                          );
                        }
                      );
                      ;
                    }
                    return CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.orange,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
