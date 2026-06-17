import 'dart:async';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'home_page.dart';
import 'login_page.dart';

class SplashScreen
    extends StatefulWidget {

  const SplashScreen({super.key});

  @override
  State<SplashScreen>
  createState() =>
      _SplashScreenState();
}

class _SplashScreenState
    extends State<SplashScreen>

    with TickerProviderStateMixin {

  ////////////////////////////////////////////////////////////
  /// ANIMATION
  ////////////////////////////////////////////////////////////

  late AnimationController
  progressController;

  double progress = 0;

  ////////////////////////////////////////////////////////////

  @override
  void initState() {

    super.initState();

    ////////////////////////////////////////////////////////////
    /// PROGRESS
    ////////////////////////////////////////////////////////////

    progressController =
    AnimationController(

      vsync: this,

      duration:
      const Duration(
          seconds: 3),
    );

    progressController
        .addListener(() {

      setState(() {

        progress =
            progressController
                .value;
      });
    });

    progressController
        .forward();

    ////////////////////////////////////////////////////////////
    /// NAVIGATION
    ////////////////////////////////////////////////////////////

    Timer(

      const Duration(
          seconds: 3),

          () {

        ////////////////////////////////////////////////////////////
        /// CHECK SESSION
        ////////////////////////////////////////////////////////////

        final session = Supabase
            .instance
            .client
            .auth
            .currentSession;

        ////////////////////////////////////////////////////////////
        /// USER LOGGED IN
        ////////////////////////////////////////////////////////////

        if (session != null) {

          Navigator.pushReplacement(

            context,

            MaterialPageRoute(

              builder: (context) =>

              const HomePage(),
            ),
          );
        }

        ////////////////////////////////////////////////////////////
        /// USER NOT LOGGED IN
        ////////////////////////////////////////////////////////////

        else {

          Navigator.pushReplacement(

            context,

            MaterialPageRoute(

              builder: (context) =>

              const LoginPage(),
            ),
          );
        }
      },
    );
  }

  ////////////////////////////////////////////////////////////

  @override
  void dispose() {

    progressController.dispose();

    super.dispose();
  }

  ////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
      Colors.white,

      body: Stack(

        children: [

          //////////////////////////////////////////////////////
          /// TOP LEFT BOX DESIGN
          //////////////////////////////////////////////////////

          Positioned(

            top: 0,

            left: 0,

            child: Container(

              height: 220,

              width: 120,

              decoration:
              const BoxDecoration(

                color:
                Color(0xFFB58AD8),

                borderRadius:
                BorderRadius.only(

                  bottomRight:
                  Radius.circular(
                      80),
                ),
              ),
            ),
          ),

          //////////////////////////////////////////////////////
          /// TOP LEFT LIGHT CIRCLE
          //////////////////////////////////////////////////////

          Positioned(

            top: -60,

            left: -60,

            child: Container(

              height: 180,

              width: 180,

              decoration:
              BoxDecoration(

                color:
                Colors.white
                    .withOpacity(
                    0.15),

                shape:
                BoxShape.circle,
              ),
            ),
          ),

          //////////////////////////////////////////////////////
          /// BOTTOM RIGHT BIG CIRCLE
          //////////////////////////////////////////////////////

          Positioned(

            bottom: -60,

            right: -50,

            child: Container(

              height: 220,

              width: 220,

              decoration:
              const BoxDecoration(

                color:
                Colors.deepPurple,

                shape:
                BoxShape.circle,
              ),
            ),
          ),

          //////////////////////////////////////////////////////
          /// BOTTOM LEFT SMALL CIRCLE
          //////////////////////////////////////////////////////

          Positioned(

            bottom: -20,

            left: 40,

            child: Container(

              height: 120,

              width: 120,

              decoration:
              BoxDecoration(

                color:
                Colors.purple
                    .shade100,

                shape:
                BoxShape.circle,
              ),
            ),
          ),

          //////////////////////////////////////////////////////
          /// EXTRA LIGHT CIRCLE
          //////////////////////////////////////////////////////

          Positioned(

            bottom: 140,

            right: 50,

            child: Container(

              height: 70,

              width: 70,

              decoration:
              BoxDecoration(

                color:
                Colors.deepPurple
                    .withOpacity(
                    0.08),

                shape:
                BoxShape.circle,
              ),
            ),
          ),

          //////////////////////////////////////////////////////
          /// MAIN CONTENT
          //////////////////////////////////////////////////////

          SafeArea(

            child: Center(

              child: Padding(

                padding:
                const EdgeInsets
                    .symmetric(
                    horizontal: 30),

                child: Column(

                  mainAxisAlignment:
                  MainAxisAlignment
                      .center,

                  children: [

                    //////////////////////////////////////////////////
                    /// LOGO
                    //////////////////////////////////////////////////

                    Image.asset(

                      'assets/logo.png',

                      height: 140,

                      errorBuilder:

                          (context,
                          error,
                          stackTrace) {

                        return Container(

                          height: 140,

                          width: 140,

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
                                35),
                          ),

                          child:
                          const Icon(

                            Icons
                                .analytics_rounded,

                            size: 70,

                            color:
                            Colors.white,
                          ),
                        );
                      },
                    ),

                    const SizedBox(
                        height: 22),

                    //////////////////////////////////////////////////
                    /// APP NAME
                    //////////////////////////////////////////////////

                    ShaderMask(

                      shaderCallback:
                          (bounds) {

                        return const LinearGradient(

                          colors: [

                            Color(
                                0xFF6C63FF),

                            Color(
                                0xFFD946EF),
                          ],
                        ).createShader(
                            bounds);
                      },

                      child: const Text(

                        "Focuslytics",

                        style: TextStyle(

                          fontSize: 34,

                          fontWeight:
                          FontWeight.bold,

                          color:
                          Colors.white,
                        ),
                      ),
                    ),

                    const SizedBox(
                        height: 10),

                    //////////////////////////////////////////////////
                    /// TAGLINE
                    //////////////////////////////////////////////////

                    const Text(

                      "Track. Analyze. Improve.",

                      style: TextStyle(

                        fontSize: 16,

                        color:
                        Colors.grey,

                        letterSpacing:
                        0.5,
                      ),
                    ),

                    const SizedBox(
                        height: 60),

                    //////////////////////////////////////////////////
                    /// LOADING BAR
                    //////////////////////////////////////////////////

                    Column(

                      children: [

                        Container(

                          width: 220,

                          height: 6,

                          decoration:
                          BoxDecoration(

                            color:
                            Colors.grey
                                .shade300,

                            borderRadius:
                            BorderRadius.circular(
                                20),
                          ),

                          child: Align(

                            alignment:
                            Alignment
                                .centerLeft,

                            child:
                            AnimatedContainer(

                              duration:
                              const Duration(
                                  milliseconds:
                                  200),

                              width:
                              220 *
                                  progress,

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
                                    20),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(
                            height: 18),

                        Text(

                          "Loading your productivity...",

                          style: TextStyle(

                            color:
                            Colors.grey
                                .shade700,

                            fontSize: 14,

                            fontWeight:
                            FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}