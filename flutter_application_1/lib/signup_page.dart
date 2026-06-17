import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignupPage extends StatefulWidget {

  const SignupPage({super.key});

  @override
  State<SignupPage> createState() =>
      _SignupPageState();
}

class _SignupPageState
    extends State<SignupPage> {

  ////////////////////////////////////////////////////////////
  /// CONTROLLERS
  ////////////////////////////////////////////////////////////

  final TextEditingController nameController =
      TextEditingController();

  final TextEditingController emailController =
      TextEditingController();

  final TextEditingController passwordController =
      TextEditingController();

  bool isLoading = false;

  ////////////////////////////////////////////////////////////
  /// SIGNUP FUNCTION
  ////////////////////////////////////////////////////////////

  Future<void> signup() async {

    try {

      setState(() {
        isLoading = true;
      });

      ////////////////////////////////////////////////////////////
      /// CREATE ACCOUNT
      ////////////////////////////////////////////////////////////

      final response =
          await Supabase.instance.client.auth
              .signUp(

        email: emailController.text.trim(),

        password:
            passwordController.text.trim(),
      );

      final user = response.user;

      ////////////////////////////////////////////////////////////
      /// STORE USER DATA
      ////////////////////////////////////////////////////////////

      if (user != null) {

        await Supabase.instance.client
            .from('users')
            .insert({

          'id': user.id,

          'name':
              nameController.text.trim(),

          'email':
              emailController.text.trim(),
        });
      }

      ////////////////////////////////////////////////////////////
      /// SUCCESS
      ////////////////////////////////////////////////////////////

      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(

          content: Text(
            "Account created successfully",
          ),
        ),
      );

      Navigator.pop(context);

    }

    on AuthException catch (e) {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(
          content: Text(e.message),
        ),
      );
    }

    catch (e) {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(
          content: Text(e.toString()),
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

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.white,

      body: SafeArea(

        child: Stack(

          children: [

            ////////////////////////////////////////////////////////////
            /// BOTTOM DESIGN
            ////////////////////////////////////////////////////////////

            Align(

              alignment: Alignment.bottomCenter,

              child: Container(

                height: 90,

                decoration: const BoxDecoration(

                  color: Color(0xFF6F2C91),

                  borderRadius: BorderRadius.only(

                    topLeft: Radius.circular(40),

                    topRight: Radius.circular(40),
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

              child: SingleChildScrollView(

                child: Column(

                  children: [

                    const SizedBox(height: 80),

                    ////////////////////////////////////////////////////////////
                    /// LOGO
                    ////////////////////////////////////////////////////////////

                    Image.asset(

                      'assets/logo.png',

                      height: 90,

                      errorBuilder:

                          (context,
                          error,
                          stackTrace) {

                        return Container(

                          height: 90,

                          width: 90,

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
                                22),
                          ),

                          child:
                          const Icon(

                            Icons
                                .analytics_rounded,

                            color:
                            Colors.white,

                            size: 45,
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 20),

                    const Text(

                      "Create new\nAccount",

                      textAlign: TextAlign.center,

                      style: TextStyle(

                        fontSize: 34,

                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(

                      "Already Registered? Log in here.",

                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),

                    const SizedBox(height: 30),

                    ////////////////////////////////////////////////////////////
                    /// NAME
                    ////////////////////////////////////////////////////////////

                    buildText("NAME"),

                    buildField(

                      controller: nameController,

                      hint: "Enter Name",
                    ),

                    const SizedBox(height: 18),

                    ////////////////////////////////////////////////////////////
                    /// EMAIL
                    ////////////////////////////////////////////////////////////

                    buildText("EMAIL"),

                    buildField(

                      controller:
                          emailController,

                      hint:
                          "example@gmail.com",
                    ),

                    const SizedBox(height: 18),

                    ////////////////////////////////////////////////////////////
                    /// PASSWORD
                    ////////////////////////////////////////////////////////////

                    buildText("PASSWORD"),

                    buildField(

                      controller:
                          passwordController,

                      hint: "******",

                      isPassword: true,
                    ),

                    const SizedBox(height: 30),

                    ////////////////////////////////////////////////////////////
                    /// SIGNUP BUTTON
                    ////////////////////////////////////////////////////////////

                    SizedBox(

                      width: double.infinity,

                      height: 50,

                      child: ElevatedButton(

                        style:
                            ElevatedButton.styleFrom(

                          backgroundColor:
                              const Color(
                                  0xFFD6A4F3),

                          shape:
                              RoundedRectangleBorder(

                            borderRadius:
                                BorderRadius
                                    .circular(12),
                          ),
                        ),

                        onPressed:
                            isLoading
                                ? null
                                : signup,

                        child:
                            isLoading

                                ? const CircularProgressIndicator(
                                    color:
                                        Colors.black,
                                  )

                                : const Text(

                                    "Sign up",

                                    style:
                                        TextStyle(

                                      color:
                                          Colors.black,

                                      fontWeight:
                                          FontWeight
                                              .bold,
                                    ),
                                  ),
                      ),
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

  Widget buildText(String title) {

    return Align(

      alignment: Alignment.centerLeft,

      child: Text(

        title,

        style: const TextStyle(

          fontSize: 12,

          color: Colors.grey,

          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  ////////////////////////////////////////////////////////////
  /// FIELD
  ////////////////////////////////////////////////////////////

  Widget buildField({

    required TextEditingController controller,

    required String hint,

    bool isPassword = false,
  }) {

    return Padding(

      padding: const EdgeInsets.only(top: 8),

      child: TextField(

        controller: controller,

        obscureText: isPassword,

        decoration: InputDecoration(

          hintText: hint,

          filled: true,

          fillColor: Colors.grey.shade300,

          border: OutlineInputBorder(

            borderRadius:
                BorderRadius.circular(12),

            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}