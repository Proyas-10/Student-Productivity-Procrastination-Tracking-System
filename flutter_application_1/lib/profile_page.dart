import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/analytics_page.dart';
import 'package:flutter_application_1/home_page.dart';
import 'package:flutter_application_1/login_page.dart';
import 'package:flutter_application_1/settings_page.dart';
import 'package:flutter_application_1/tasks_page.dart';
import 'package:flutter_application_1/timer_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app_settings.dart';

class ProfilePage extends StatefulWidget {

  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() =>
      _ProfilePageState();
}

class _ProfilePageState
    extends State<ProfilePage> {

  ////////////////////////////////////////////////////////////
  /// PROFILE IMAGE
  ////////////////////////////////////////////////////////////

  File? profileImage;

  final ImagePicker picker =
  ImagePicker();

  @override
  void initState() {
    super.initState();
    loadImage();
  }

  Future<void> pickImage() async {

    final XFile? image =
    await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (image != null) {

      final prefs =
      await SharedPreferences.getInstance();

      await prefs.setString(
        'profile_image',
        image.path,
      );

      setState(() {

        profileImage =
        File(image.path);
      });
    }
  }

  ////////////////////////////////////////////////////////////
  /// LOAD IMAGE
  ////////////////////////////////////////////////////////////

  Future<void> loadImage() async {

    final prefs =
    await SharedPreferences.getInstance();

    String? path =
    prefs.getString(
        'profile_image');

    if (path != null) {

      setState(() {

        profileImage =
        File(path);
      });
    }
  }

  ////////////////////////////////////////////////////////////
  /// GET USER DATA
  ////////////////////////////////////////////////////////////

  Future<Map<String, dynamic>> getUserData() async {

    final user =
    Supabase.instance.client.auth.currentUser;

    if (user == null) {

      return {};
    }

    final data =
    await Supabase.instance.client
        .from('users')
        .select()
        .eq('id', user.id)
        .single();

    return data;
  }

  ////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {

    final settings =
    Provider.of<AppSettings>(context);

    return FutureBuilder(

      future: getUserData(),

      builder: (context, snapshot) {

        String name = "User";

        String email = "No Email";

        if (snapshot.hasData &&
            snapshot.data != null) {

          name =
              snapshot.data!['name'] ??
                  "User";

          email =
              snapshot.data!['email'] ??
                  "No Email";
        }

        return Scaffold(

          backgroundColor:
          settings.isDark
              ? const Color(0xFF121212)
              : const Color(0xFFF8F8F8),

          ////////////////////////////////////////////////////////////
          /// BOTTOM NAVIGATION
          ////////////////////////////////////////////////////////////

          bottomNavigationBar:
          BottomNavigationBar(

            currentIndex: 4,

            selectedItemColor:
            Colors.deepPurple,

            unselectedItemColor:
            Colors.grey,

            backgroundColor:
            settings.isDark
                ? Colors.black
                : Colors.white,

            showUnselectedLabels: true,

            type:
            BottomNavigationBarType
                .fixed,

            onTap: (index) {

              if (index == 0) {

                Navigator.pushReplacement(

                  context,

                  MaterialPageRoute(

                    builder: (context) =>
                    const HomePage(),
                  ),
                );
              }

              if (index == 1) {

                Navigator.pushReplacement(

                  context,

                  MaterialPageRoute(

                    builder: (context) =>
                    const TimerPage(),
                  ),
                );
              }

              if (index == 2) {

                Navigator.pushReplacement(

                  context,

                  MaterialPageRoute(

                    builder: (context) =>
                    const TasksPage(),
                  ),
                );
              }

              if (index == 3) {

                Navigator.pushReplacement(

                  context,

                  MaterialPageRoute(

                    builder: (context) =>
                    const AnalyticsPage(),
                  ),
                );
              }
            },

            items: [

              BottomNavigationBarItem(

                icon: Icon(Icons.home),

                label: settings.text(

                  english: "Home",

                  spanish: "Inicio",
                ),
              ),

              BottomNavigationBarItem(

                icon: Icon(Icons.timer),

                label: settings.text(

                  english: "Timer",

                  spanish: "Temporizador",
                ),
              ),

              BottomNavigationBarItem(

                icon: Icon(Icons.task),

                label: settings.text(

                  english: "Tasks",

                  spanish: "Tareas",
                ),
              ),

              BottomNavigationBarItem(

                icon: Icon(Icons.bar_chart),

                label: settings.text(

                  english: "Analytics",

                  spanish: "Analítica",
                ),
              ),

              BottomNavigationBarItem(

                icon: Icon(Icons.person),

                label: settings.text(

                  english: "Profile",

                  spanish: "Perfil",
                ),
              ),
            ],
          ),

          ////////////////////////////////////////////////////////////
          /// BODY
          ////////////////////////////////////////////////////////////

          body: SafeArea(

            child: Padding(

              padding:
              const EdgeInsets.all(18),

              child: SingleChildScrollView(

                child: Column(

                  children: [

                    //////////////////////////////////////////////////////
                    /// TOP BAR
                    //////////////////////////////////////////////////////

                    Container(

                      width:
                      double.infinity,

                      padding:
                      const EdgeInsets.symmetric(
                        horizontal: 6,
                      ),

                      child: Text(

                        settings.text(

                          english:
                          "Profile",

                          spanish:
                          "Perfil",
                        ),

                        style: TextStyle(

                          fontSize: 30,

                          fontWeight:
                          FontWeight.bold,

                          letterSpacing: 0.5,

                          color:
                          settings.isDark
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    //////////////////////////////////////////////////////
                    /// PROFILE CARD
                    //////////////////////////////////////////////////////

                    Container(

                      padding:
                      const EdgeInsets.all(20),

                      decoration: BoxDecoration(

                        color:
                        settings.isDark
                            ? Colors.grey.shade900
                            : Colors.white,

                        borderRadius:
                        BorderRadius.circular(
                            24),

                        boxShadow: [

                          BoxShadow(

                            color:
                            Colors.black.withOpacity(
                                0.05),

                            blurRadius: 12,

                            offset:
                            const Offset(0, 4),
                          ),
                        ],
                      ),

                      child: Row(

                        children: [

                          //////////////////////////////////////////////////
                          /// PROFILE IMAGE
                          //////////////////////////////////////////////////

                          GestureDetector(

                            onTap: () {

                              pickImage();
                            },

                            child: CircleAvatar(

                              radius: 38,

                              backgroundColor:
                              Colors.deepPurple
                                  .shade100,

                              backgroundImage:

                              profileImage != null

                                  ? FileImage(
                                  profileImage!)

                                  : null,

                              child:

                              profileImage == null

                                  ? const Icon(

                                Icons.camera_alt,

                                size: 32,

                                color:
                                Colors.deepPurple,
                              )

                                  : null,
                            ),
                          ),

                          const SizedBox(width: 18),

                          //////////////////////////////////////////////////
                          /// USER INFO
                          //////////////////////////////////////////////////

                          Expanded(

                            child: Column(

                              crossAxisAlignment:
                              CrossAxisAlignment.start,

                              children: [

                                Text(

                                  name,

                                  style:
                                  TextStyle(

                                    fontSize: 24,

                                    fontWeight:
                                    FontWeight.bold,

                                    color:
                                    settings.isDark
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),

                                const SizedBox(
                                    height: 6),

                                Text(

                                  email,

                                  overflow:
                                  TextOverflow.ellipsis,

                                  style:
                                  const TextStyle(

                                    color:
                                    Colors.grey,

                                    fontSize: 14,
                                  ),
                                ),

                                const SizedBox(
                                    height: 10),

                                Container(

                                  padding:
                                  const EdgeInsets.symmetric(

                                    horizontal: 12,

                                    vertical: 6,
                                  ),

                                  decoration:
                                  BoxDecoration(

                                    color:
                                    Colors.orange
                                        .withOpacity(
                                        0.15),

                                    borderRadius:
                                    BorderRadius.circular(
                                        20),
                                  ),

                                  child:
                                  Text(

                                    settings.text(

                                      english:
                                      "⭐ Premium User",

                                      spanish:
                                      "⭐ Usuario Premium",
                                    ),

                                    style: const TextStyle(

                                      color:
                                      Colors.orange,

                                      fontWeight:
                                      FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 25),

                    //////////////////////////////////////////////////////
                    /// OPTIONS
                    //////////////////////////////////////////////////////

                    buildTile(
                      context,

                      settings.text(

                        english:
                        "Personal Information",

                        spanish:
                        "Información Personal",
                      ),
                    ),

                    buildTile(
                      context,

                      settings.text(

                        english:
                        "Study Goals",

                        spanish:
                        "Metas de Estudio",
                      ),
                    ),

                    buildTile(
                      context,

                      settings.text(

                        english:
                        "Achievements",

                        spanish:
                        "Logros",
                      ),
                    ),

                    buildTile(
                      context,

                      settings.text(

                        english:
                        "Settings",

                        spanish:
                        "Configuración",
                      ),
                    ),

                    buildTile(
                      context,

                      settings.text(

                        english:
                        "Help & Support",

                        spanish:
                        "Ayuda y Soporte",
                      ),
                    ),

                    buildTile(
                      context,

                      settings.text(

                        english:
                        "Logout",

                        spanish:
                        "Cerrar Sesión",
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  ////////////////////////////////////////////////////////////
  /// TILE
  ////////////////////////////////////////////////////////////

  Widget buildTile(
      BuildContext context,
      String text,
      ) {

    final settings =
    Provider.of<AppSettings>(context);

    return GestureDetector(

      onTap: () async {

        //////////////////////////////////////////////////////
        /// PERSONAL INFORMATION
        //////////////////////////////////////////////////////

        if (text ==
            settings.text(

              english:
              "Personal Information",

              spanish:
              "Información Personal",
            )) {

          TextEditingController
          nameController =
          TextEditingController();

          TextEditingController
          ageController =
          TextEditingController();

          TextEditingController
          instituteController =
          TextEditingController();

          TextEditingController
          addressController =
          TextEditingController();

          showDialog(

            context: context,

            builder: (context) {

              return AlertDialog(

                title: Text(

                  settings.text(

                    english:
                    "Personal Information",

                    spanish:
                    "Información Personal",
                  ),
                ),

                content:
                SingleChildScrollView(

                  child: Column(

                    mainAxisSize:
                    MainAxisSize.min,

                    children: [

                      TextField(

                        controller:
                        nameController,

                        decoration:
                        InputDecoration(

                          labelText:

                          settings.text(

                            english:
                            "Name",

                            spanish:
                            "Nombre",
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      TextField(

                        controller:
                        ageController,

                        keyboardType:
                        TextInputType.number,

                        decoration:
                        InputDecoration(

                          labelText:

                          settings.text(

                            english:
                            "Age",

                            spanish:
                            "Edad",
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      TextField(

                        controller:
                        instituteController,

                        decoration:
                        InputDecoration(

                          labelText:

                          settings.text(

                            english:
                            "Institute",

                            spanish:
                            "Instituto",
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      TextField(

                        controller:
                        addressController,

                        maxLines: 2,

                        decoration:
                        InputDecoration(

                          labelText:

                          settings.text(

                            english:
                            "Address",

                            spanish:
                            "Dirección",
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                actions: [

                  TextButton(

                    onPressed: () {

                      Navigator.pop(
                          context);
                    },

                    child:
                    Text(

                      settings.text(

                        english:
                        "Cancel",

                        spanish:
                        "Cancelar",
                      ),
                    ),
                  ),

                  ElevatedButton(

                    onPressed: () {

                      ScaffoldMessenger.of(
                          context)
                          .showSnackBar(

                        SnackBar(

                          content: Text(

                            settings.text(

                              english:
                              "Information Saved",

                              spanish:
                              "Información Guardada",
                            ),
                          ),
                        ),
                      );

                      Navigator.pop(
                          context);
                    },

                    child:
                    Text(

                      settings.text(

                        english:
                        "Save",

                        spanish:
                        "Guardar",
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        }

        //////////////////////////////////////////////////////
        /// STUDY GOALS
        //////////////////////////////////////////////////////

        if (text ==
            settings.text(

              english:
              "Study Goals",

              spanish:
              "Metas de Estudio",
            )) {

          showDialog(

            context: context,

            builder: (context) {

              return AlertDialog(

                title:
                Text(

                  settings.text(

                    english:
                    "Study Goals",

                    spanish:
                    "Metas de Estudio",
                  ),
                ),

                content:
                Column(

                  mainAxisSize:
                  MainAxisSize.min,

                  crossAxisAlignment:
                  CrossAxisAlignment
                      .start,

                  children: [

                    Text(
                      settings.text(

                        english:
                        "• Study 5 hours daily",

                        spanish:
                        "• Estudiar 5 horas diarias",
                      ),
                    ),

                    SizedBox(height: 10),

                    Text(
                      settings.text(

                        english:
                        "• Reduce procrastination",

                        spanish:
                        "• Reducir la procrastinación",
                      ),
                    ),

                    SizedBox(height: 10),

                    Text(
                      settings.text(

                        english:
                        "• Complete tasks on time",

                        spanish:
                        "• Completar tareas a tiempo",
                      ),
                    ),
                  ],
                ),

                actions: [

                  TextButton(

                    onPressed: () {

                      Navigator.pop(
                          context);
                    },

                    child:
                    Text(

                      settings.text(

                        english:
                        "Close",

                        spanish:
                        "Cerrar",
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        }

        //////////////////////////////////////////////////////
        /// ACHIEVEMENTS
        //////////////////////////////////////////////////////

        if (text ==
            settings.text(

              english:
              "Achievements",

              spanish:
              "Logros",
            )) {

          showDialog(

            context: context,

            builder: (context) {

              return AlertDialog(

                title: Text(

                  settings.text(

                    english:
                    "Achievements",

                    spanish:
                    "Logros",
                  ),
                ),

                content:
                Column(

                  mainAxisSize:
                  MainAxisSize.min,

                  crossAxisAlignment:
                  CrossAxisAlignment.start,

                  children: [

                    Text(
                      settings.text(

                        english:
                        "🏆 Completed 50 Tasks",

                        spanish:
                        "🏆 50 tareas completadas",
                      ),
                    ),

                    SizedBox(height: 10),

                    Text(
                      settings.text(

                        english:
                        "🔥 7 Days Study Streak",

                        spanish:
                        "🔥 7 días de estudio seguidos",
                      ),
                    ),

                    SizedBox(height: 10),

                    Text(
                      settings.text(

                        english:
                        "⏰ Focused 100 Hours",

                        spanish:
                        "⏰ 100 horas de enfoque",
                      ),
                    ),

                    SizedBox(height: 10),

                    Text(
                      settings.text(

                        english:
                        "📚 Completed Daily Goals",

                        spanish:
                        "📚 Objetivos diarios completados",
                      ),
                    ),
                  ],
                ),

                actions: [

                  TextButton(

                    onPressed: () {

                      Navigator.pop(
                          context);
                    },

                    child:
                    Text(

                      settings.text(

                        english:
                        "Close",

                        spanish:
                        "Cerrar",
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        }

        //////////////////////////////////////////////////////
        /// HELP & SUPPORT
        //////////////////////////////////////////////////////

        if (text ==
            settings.text(

              english:
              "Help & Support",

              spanish:
              "Ayuda y Soporte",
            )) {

          showDialog(

            context: context,

            builder: (context) {

              return AlertDialog(

                title:
                Text(

                  settings.text(

                    english:
                    "Help & Support",

                    spanish:
                    "Ayuda y Soporte",
                  ),
                ),

                content:
                Column(

                  mainAxisSize:
                  MainAxisSize.min,

                  crossAxisAlignment:
                  CrossAxisAlignment
                      .start,

                  children: [

                    Text(
                      settings.text(

                        english:
                        "Email: support@focuslytics.com",

                        spanish:
                        "Correo: support@focuslytics.com",
                      ),
                    ),

                    SizedBox(height: 10),

                    Text(
                      settings.text(

                        english:
                        "Phone: +8801XXXXXXXXX",

                        spanish:
                        "Teléfono: +8801XXXXXXXXX",
                      ),
                    ),
                  ],
                ),

                actions: [

                  TextButton(

                    onPressed: () {

                      Navigator.pop(
                          context);
                    },

                    child:
                    Text(

                      settings.text(

                        english:
                        "Close",

                        spanish:
                        "Cerrar",
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        }

        //////////////////////////////////////////////////////
        /// SETTINGS
        //////////////////////////////////////////////////////

        if (text ==
            settings.text(

              english:
              "Settings",

              spanish:
              "Configuración",
            )) {

          Navigator.push(

            context,

            MaterialPageRoute(

              builder: (context) =>
              const SettingsPage(),
            ),
          );
        }

        //////////////////////////////////////////////////////
        /// LOGOUT
        //////////////////////////////////////////////////////

        if (text ==
            settings.text(

              english:
              "Logout",

              spanish:
              "Cerrar Sesión",
            )) {

          await Supabase.instance.client
              .auth
              .signOut();

          Navigator.pushAndRemoveUntil(

            context,

            MaterialPageRoute(

              builder: (context) =>
              LoginPage(),
            ),

                (route) => false,
          );
        }
      },

      child: Container(

        margin:
        const EdgeInsets.only(
            bottom: 15),

        padding:
        const EdgeInsets.all(
            18),

        decoration: BoxDecoration(

          color:
          settings.isDark
              ? Colors.grey.shade900
              : Colors.white,

          borderRadius:
          BorderRadius.circular(
              20),

          boxShadow: [

            BoxShadow(

              color:
              Colors.black.withOpacity(
                  0.03),

              blurRadius: 10,

              offset:
              const Offset(0, 4),
            ),
          ],
        ),

        child: Row(

          mainAxisAlignment:
          MainAxisAlignment
              .spaceBetween,

          children: [

            Text(

              text,

              style:
              TextStyle(

                fontWeight:
                FontWeight.w600,

                fontSize: 15,

                color:
                settings.isDark
                    ? Colors.white
                    : Colors.black,
              ),
            ),

            Icon(

              Icons.arrow_forward_ios,

              size: 16,

              color:
              settings.isDark
                  ? Colors.white70
                  : Colors.black54,
            ),
          ],
        ),
      ),
    );
  }
}