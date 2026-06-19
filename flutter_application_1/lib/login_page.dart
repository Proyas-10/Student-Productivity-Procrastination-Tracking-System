import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'home_page.dart';
import 'reset_password_page.dart';
import 'signup_page.dart';

class LoginPage extends StatefulWidget {

  const LoginPage({super.key});

  @override
  State<LoginPage> createState() =>
      _LoginPageState();
}

class _LoginPageState
    extends State<LoginPage> {

  /////////////////////////////////
  /// CONTROLLERS
  ///////////////////////////

  final TextEditingController
  emailController =
  TextEditingController();

  final TextEditingController
  passwordController =
  TextEditingController();

  bool isLoading = false;

  ////////////////////////////////////////////////////////////
  /// INIT
  //////////////////////

  @override
  void initState() {

    super.initState();

    ////////////////////////////////////////////////////////////
    /// PASSWORD RECOVERY 
    ////////////////////////////////////////////////////////////

    Supabase.instance.client.auth
        .onAuthStateChange
        .listen((data) {

      final event = data.event;

      if (event ==
          AuthChangeEvent
              .passwordRecovery) {

        Navigator.push(

          context,

          MaterialPageRoute(

            builder: (context) =>

            const ResetPasswordPage(),
          ),
        );
      }
    });
  }

  ////////////////////////////////////////////////////////////
  /// LOGIN FUNCTION
  ////////////////////////////////////////////////////////////

  Future<void> login() async {

    try {

      setState(() {

        isLoading = true;
      });

      ////////////////////////////////////////////////////////////
      /// LOGIN
      ////////////////////////////////////////////////////////////

      final response =

      await Supabase.instance.client.auth

          .signInWithPassword(

        email:
        emailController.text.trim(),

        password:
        passwordController.text.trim(),
      );

      final user =
          response.user;

      ////////////////////////////////////////////////////////////
      /// EMAIL VERIFICATION
      ////////////////////////////////////////////////////////////

      if (user != null &&
          user.emailConfirmedAt == null) {

        await Supabase.instance.client
            .auth
            .signOut();

        ScaffoldMessenger.of(context)
            .showSnackBar(

          const SnackBar(

            content: Text(
              "Email not confirmed",
            ),
          ),
        );

        return;
      }

      ////////////////////////////////////////////////////////////
      /// SUCCESS
      ////////////////////////////////////////////////////////////

      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(

          content: Text(
            "Login Successful",
          ),
        ),
      );

      Navigator.pushReplacement(

        context,

        MaterialPageRoute(

          builder: (context) =>
          const HomePage(),
        ),
      );
    }

    on AuthException catch (e) {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(

          content:
          Text(e.message),
        ),
      );
    }

    catch (e) {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(

          content:
          Text(e.toString()),
        ),
      );
    }

    finally {

      setState(() {

        isLoading = false;
      });
    }
  }

  ////////////////////////////////////////////////////////////
  /// RESET PASSWORD
  ////////////////////////////////////////////////////////////

  Future<void> resetPassword(
      String email,
      ) async {

    try {

      await Supabase.instance.client
          .auth
          .resetPasswordForEmail(

        email,

        redirectTo:
        'io.supabase.flutter://reset-callback',
      );

      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(

          content: Text(

            "Password reset email sent",
          ),
        ),
      );
    }

    catch (e) {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(

          content:
          Text(e.toString()),
        ),
      );
    }
  }

  ////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
      const Color(0xFFF8F8F8),

      body: SafeArea(

        child: Stack(

          children: [

            ////////////////////////////////////////////////////////////
            /// BOTTOM DESIGN
            ////////////////////////////////////////////////////////////

            Align(

              alignment:
              Alignment.bottomCenter,

              child: Container(

                height: 100,

                decoration:
                const BoxDecoration(

                  color:
                  Color(0xFF6F2C91),

                  borderRadius:
                  BorderRadius.only(

                    topLeft:
                    Radius.circular(
                        40),

                    topRight:
                    Radius.circular(
                        40),
                  ),
                ),
              ),
            ),

            ////////////////////////////////////////////////////////////
            /// MAIN CONTENT
            ////////////////////////////////////////////////////////////

            Padding(

              padding:
              const EdgeInsets.symmetric(
                horizontal: 30,
              ),

              child:
              SingleChildScrollView(

                child: Column(

                  children: [

                    const SizedBox(
                        height: 80),

                    ////////////////////////////////////////////////////////////
                    /// LOGO
                    ////////////////////////////////////////////////////////////

                    Image.asset(

                      'assets/logo.png',

                      height: 100,

                      errorBuilder:

                          (context,
                          error,
                          stackTrace) {

                        return Container(

                          height: 100,

                          width: 100,

                          decoration:
                          BoxDecoration(

                            gradient:
                            const LinearGradient(

                              colors: [

                                Color(
                                    0xFF6C63FF),

                                Color(
                                    0xFFD946EF),
                              ],
                            ),

                            borderRadius:
                            BorderRadius.circular(
                                25),
                          ),

                          child:
                          const Icon(

                            Icons
                                .analytics_rounded,

                            color:
                            Colors.white,

                            size: 50,
                          ),
                        );
                      },
                    ),

                    const SizedBox(
                        height: 20),

                    ////////////////////////////////////////////////////////////
                    /// TITLE
                    ////////////////////////////////////////////////////////////

                    const Text(

                      "Login",

                      style: TextStyle(

                        fontSize: 38,

                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),

                    const SizedBox(
                        height: 5),

                    const Text(

                      "Sign in to continue",

                      style: TextStyle(

                        color:
                        Colors.grey,

                        fontSize: 15,
                      ),
                    ),

                    const SizedBox(
                        height: 40),

                    ////////////////////////////////////////////////////////////
                    /// EMAIL
                    ////////////////////////////////////////////////////////////

                    buildText("EMAIL"),

                    buildField(

                      controller:
                      emailController,

                      hint:
                      "Enter your email",
                    ),

                    const SizedBox(
                        height: 22),

                    ////////////////////////////////////////////////////////////
                    /// PASSWORD
                    ////////////////////////////////////////////////////////////

                    buildText("PASSWORD"),

                    buildField(

                      controller:
                      passwordController,

                      hint:
                      "******",

                      isPassword:
                      true,
                    ),

                    const SizedBox(
                        height: 12),

                    ////////////////////////////////////////////////////////////
                    /// FORGOT PASSWORD
                    ////////////////////////////////////////////////////////////

                    Align(

                      alignment:
                      Alignment.centerRight,

                      child:
                      GestureDetector(

                        onTap: () {

                          TextEditingController
                          resetController =

                          TextEditingController();

                          showDialog(

                            context: context,

                            builder: (context) {

                              return AlertDialog(

                                title:
                                const Text(
                                  "Forgot Password",
                                ),

                                content:
                                TextField(

                                  controller:
                                  resetController,

                                  decoration:
                                  const InputDecoration(

                                    hintText:
                                    "Enter your email",
                                  ),
                                ),

                                actions: [

                                  TextButton(

                                    onPressed: () {

                                      Navigator.pop(
                                          context);
                                    },

                                    child:
                                    const Text(
                                        "Cancel"),
                                  ),

                                  ElevatedButton(

                                    onPressed:
                                        () async {

                                      await resetPassword(

                                        resetController
                                            .text
                                            .trim(),
                                      );

                                      Navigator.pop(
                                          context);
                                    },

                                    child:
                                    const Text(
                                        "Submit"),
                                  ),
                                ],
                              );
                            },
                          );
                        },

                        child:
                        const Text(

                          "Forgot Password?",

                          style: TextStyle(

                            color:
                            Colors.deepPurple,

                            fontWeight:
                            FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(
                        height: 30),

                    ////////////////////////////////////////////////////////////
                    /// LOGIN BUTTON
                    ////////////////////////////////////////////////////////////

                    SizedBox(

                      width:
                      double.infinity,

                      height: 55,

                      child:
                      ElevatedButton(

                        style:
                        ElevatedButton.styleFrom(

                          backgroundColor:
                          const Color(
                              0xFFD6A4F3),

                          shape:
                          RoundedRectangleBorder(

                            borderRadius:
                            BorderRadius
                                .circular(14),
                          ),
                        ),

                        onPressed:

                        isLoading

                            ? null

                            : login,

                        child:

                        isLoading

                            ? const CircularProgressIndicator(

                          color:
                          Colors.black,
                        )

                            : const Text(

                          "Log In",

                          style:
                          TextStyle(

                            color:
                            Colors.black,

                            fontWeight:
                            FontWeight
                                .bold,

                            fontSize:
                            16,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(
                        height: 25),

                    ////////////////////////////////////////////////////////////
                    /// SIGNUP OPTION
                    ////////////////////////////////////////////////////////////

                    Row(

                      mainAxisAlignment:
                      MainAxisAlignment
                          .center,

                      children: [

                        const Text(

                          "Don't have an account? ",

                          style: TextStyle(
                            color:
                            Colors.grey,
                          ),
                        ),

                        GestureDetector(

                          onTap: () {

                            Navigator.push(

                              context,

                              MaterialPageRoute(

                                builder: (context) =>

                                const SignupPage(),
                              ),
                            );
                          },

                          child:
                          const Text(

                            "Sign Up",

                            style: TextStyle(

                              color:
                              Colors.deepPurple,

                              fontWeight:
                              FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ////////////////////////////////////////////////////////////
  /// TEXT
  ////////////////////////////////////////////////////////////

  Widget buildText(
      String title,
      ) {

    return Align(

      alignment:
      Alignment.centerLeft,

      child: Text(

        title,

        style:
        const TextStyle(

          fontSize: 12,

          color: Colors.grey,

          fontWeight:
          FontWeight.bold,
        ),
      ),
    );
  }

  ////////////////////////////////////////////////////////////
  /// FIELD
  ////////////////////////////////////////////////////////////

  Widget buildField({

    required TextEditingController
    controller,

    required String hint,

    bool isPassword = false,
  }) {

    return Padding(

      padding:
      const EdgeInsets.only(
          top: 8),

      child: TextField(

        controller:
        controller,

        obscureText:
        isPassword,

        decoration:
        InputDecoration(

          hintText:
          hint,

          filled: true,

          fillColor:
          Colors.grey.shade300,

          border:
          OutlineInputBorder(

            borderRadius:
            BorderRadius.circular(
                14),

            borderSide:
            BorderSide.none,
          ),
        ),
      ),
    );
  }
}