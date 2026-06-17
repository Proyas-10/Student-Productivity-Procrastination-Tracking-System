import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/analytics_page.dart';
import 'package:flutter_application_1/app_settings.dart';
import 'package:flutter_application_1/home_page.dart';
import 'package:flutter_application_1/profile_page.dart';
import 'package:flutter_application_1/settings_page.dart';
import 'package:flutter_application_1/tasks_page.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TimerPage extends StatefulWidget {

  const TimerPage({super.key});

  @override
  State<TimerPage> createState() =>
      _TimerPageState();
}

class _TimerPageState
    extends State<TimerPage> {

  ////////////////////////////////////////////////////////////
  /// TIMER
  ////////////////////////////////////////////////////////////

  Timer? timer;

  Timer? breakTimer;

  int seconds = 0;

  int pausedSeconds = 0;

  int breakRemainingSeconds = 0;

  bool isRunning = false;

  bool isBreakRunning = false;

  String currentMode = "Focus";

  ////////////////////////////////////////////////////////////
  /// PROGRESS
  ////////////////////////////////////////////////////////////

  int completedSessions = 0;

  int shortBreakCount = 0;

  int longBreakCount = 0;

  ////////////////////////////////////////////////////////////
  /// BREAK SETTINGS
  ////////////////////////////////////////////////////////////

  int shortBreakMinutes = 5;

  int longBreakMinutes = 20;

  String shortBreakReason =
      "Refresh Mind";

  String longBreakReason =
      "Relax";

  ////////////////////////////////////////////////////////////
  /// CURRENT BREAK INFO
  ////////////////////////////////////////////////////////////

  String currentBreakReason = "";

  int currentBreakMinutes = 0;

  ////////////////////////////////////////////////////////////
  /// FORMAT TIME
  ////////////////////////////////////////////////////////////

  String formatTime(int totalSeconds) {

    int hrs = totalSeconds ~/ 3600;

    int mins =
        (totalSeconds % 3600) ~/ 60;

    int secs = totalSeconds % 60;

    return
        "${hrs.toString().padLeft(2, '0')}:"
        "${mins.toString().padLeft(2, '0')}:"
        "${secs.toString().padLeft(2, '0')}";
  }

  ////////////////////////////////////////////////////////////
  /// START TIMER
  ////////////////////////////////////////////////////////////

  void startTimer() {

    if (isRunning) return;

    setState(() {

      isRunning = true;

      currentMode = "Focus";
    });

    timer = Timer.periodic(

      const Duration(seconds: 1),

          (t) {

        setState(() {

          seconds++;
        });
      },
    );
  }

  ////////////////////////////////////////////////////////////
  /// STOP TIMER
  ////////////////////////////////////////////////////////////

  void stopTimer() {

    timer?.cancel();

    timer = null;

    breakTimer?.cancel();

    setState(() {

      isRunning = false;

      isBreakRunning = false;

      completedSessions++;
    });

    showSaveDialog();
  }

  ////////////////////////////////////////////////////////////
  /// SAVE SESSION
  ////////////////////////////////////////////////////////////

  void showSaveDialog() {

    TextEditingController noteController =
    TextEditingController();

    final settings =
    Provider.of<AppSettings>(
      context,
      listen: false,
    );

    showDialog(

      context: context,

      builder: (context) {

        return AlertDialog(

          title:
          Text(

            settings.text(

              english:
              "Session Completed",

              spanish:
              "Sesión Completada",
            ),
          ),

          content: Column(

            mainAxisSize:
            MainAxisSize.min,

            children: [

              Text(

                settings.text(

                  english:
                  "Time: ${formatTime(seconds)}",

                  spanish:
                  "Tiempo: ${formatTime(seconds)}",
                ),
              ),

              const SizedBox(height: 15),

              TextField(

                controller:
                noteController,

                decoration:
                InputDecoration(

                  labelText:

                  settings.text(

                    english:
                    "What did you do?",

                    spanish:
                    "¿Qué hiciste?",
                  ),
                ),
              ),
            ],
          ),

          actions: [

            ElevatedButton(

              onPressed: () async {

                final user =
                    Supabase.instance.client
                        .auth.currentUser;

                if (user != null) {

                  await Supabase.instance
                      .client
                      .from(
                      'focus_sessions')
                      .insert({

                    'user_id':
                    user.id,

                    'duration':
                    formatTime(
                        seconds),

                    'note':
                    noteController
                        .text,
                  });
                }

                setState(() {

                  seconds = 0;
                });

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

  ////////////////////////////////////////////////////////////
  /// BREAK DIALOG
  ////////////////////////////////////////////////////////////

  void showBreakDialog(bool isShort) {

    TextEditingController timeController =
    TextEditingController();

    TextEditingController reasonController =
    TextEditingController();

    final settings =
    Provider.of<AppSettings>(
      context,
      listen: false,
    );

    if (isShort) {

      timeController.text =
          shortBreakMinutes.toString();

      reasonController.text =
          shortBreakReason;
    }

    else {

      timeController.text =
          longBreakMinutes.toString();

      reasonController.text =
          longBreakReason;
    }

    showDialog(

      context: context,

      builder: (context) {

        return AlertDialog(

          title: Text(

            isShort

                ? settings.text(

              english:
              "Short Break",

              spanish:
              "Descanso Corto",
            )

                : settings.text(

              english:
              "Long Break",

              spanish:
              "Descanso Largo",
            ),
          ),

          content: Column(

            mainAxisSize:
            MainAxisSize.min,

            children: [

              TextField(

                controller:
                timeController,

                keyboardType:
                TextInputType.number,

                decoration:
                InputDecoration(

                  labelText:

                  settings.text(

                    english:
                    "Minutes",

                    spanish:
                    "Minutos",
                  ),
                ),
              ),

              const SizedBox(height: 15),

              TextField(

                controller:
                reasonController,

                decoration:
                InputDecoration(

                  labelText:

                  settings.text(

                    english:
                    "Reason",

                    spanish:
                    "Razón",
                  ),
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
                  "Cancel",

                  spanish:
                  "Cancelar",
                ),
              ),
            ),

            ElevatedButton(

              onPressed: () {

                int mins =
                    int.tryParse(
                        timeController
                            .text) ??
                        0;

                //////////////////////////////////////////////////
                /// VALIDATION
                //////////////////////////////////////////////////

                bool invalidRange = false;

                if (isShort) {

                  if (mins < 1 || mins > 20) {

                    invalidRange = true;
                  }
                }

                else {

                  if (mins < 21 || mins > 60) {

                    invalidRange = true;
                  }
                }

                if (invalidRange) {

                  ScaffoldMessenger.of(context)
                      .showSnackBar(

                    SnackBar(

                      content: Text(

                        settings.text(

                          english:

                          isShort

                              ? "Invalid time range! Short break must be 1-20 min."

                              : "Invalid time range! Long break must be 21-60 min.",

                          spanish:

                          isShort

                              ? "¡Tiempo inválido! Descanso corto debe ser 1-20 min."

                              : "¡Tiempo inválido! Descanso largo debe ser 21-60 min.",
                        ),
                      ),
                    ),
                  );

                  return;
                }

                //////////////////////////////////////////////////
                /// STOP FOCUS TIMER
                //////////////////////////////////////////////////

                timer?.cancel();

                pausedSeconds =
                    seconds;

                isRunning = false;

                //////////////////////////////////////////////////
                /// BREAK INFO
                //////////////////////////////////////////////////

                setState(() {

                  currentBreakMinutes =
                      mins;

                  currentBreakReason =
                      reasonController
                          .text;

                  breakRemainingSeconds =
                      mins * 60;

                  isBreakRunning = true;
                });

                if (isShort) {

                  shortBreakMinutes =
                      mins;

                  shortBreakReason =
                      reasonController
                          .text;

                  shortBreakCount++;

                  currentMode =
                  "Short Break";
                }

                else {

                  longBreakMinutes =
                      mins;

                  longBreakReason =
                      reasonController
                          .text;

                  longBreakCount++;

                  currentMode =
                  "Long Break";
                }

                //////////////////////////////////////////////////
                /// START BREAK TIMER
                //////////////////////////////////////////////////

                breakTimer?.cancel();

                breakTimer = Timer.periodic(

                  const Duration(
                      seconds: 1),

                      (t) {

                    if (breakRemainingSeconds >
                        0) {

                      setState(() {

                        breakRemainingSeconds--;
                      });
                    }

                    else {

                      t.cancel();

                      //////////////////////////////////////////////////
                      /// RESUME FOCUS TIMER
                      //////////////////////////////////////////////////

                      setState(() {

                        currentMode =
                        "Focus";

                        isRunning =
                        true;

                        isBreakRunning =
                        false;

                        seconds =
                            pausedSeconds;
                      });

                      timer = Timer.periodic(

                        const Duration(
                            seconds: 1),

                            (timer) {

                          setState(() {

                            seconds++;
                          });
                        },
                      );
                    }
                  },
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

  ////////////////////////////////////////////////////////////

@override
void dispose() {

  ////////////////////////////////////////////////////////////
  /// DO NOT STOP TIMER ON PAGE CHANGE
  ////////////////////////////////////////////////////////////

  super.dispose();
}
  ////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {

    final settings =
    Provider.of<AppSettings>(context);

    return Scaffold(

      backgroundColor:

      settings.isDark

          ? const Color(0xFF121212)

          : const Color(0xFFF8F8F8),

      drawer: Drawer(

        backgroundColor:

        settings.isDark

            ? Colors.black

            : Colors.white,

        child: SafeArea(

          child: Column(

            children: [

              const SizedBox(height: 40),

              ListTile(

                leading:
                const Icon(
                  Icons.settings,
                ),

                title:
                Text(

                  settings.text(

                    english:
                    "Settings",

                    spanish:
                    "Configuración",
                  ),
                ),

                onTap: () {

                  Navigator.push(

                    context,

                    MaterialPageRoute(

                      builder: (context) =>
                      const SettingsPage(),
                    ),
                  );
                },
              ),

              ListTile(

                leading:
                const Icon(
                  Icons.person,
                ),

                title:
                Text(

                  settings.text(

                    english:
                    "Profile",

                    spanish:
                    "Perfil",
                  ),
                ),

                onTap: () {

                  Navigator.push(

                    context,

                    MaterialPageRoute(

                      builder: (context) =>
                      const ProfilePage(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar:
      BottomNavigationBar(

        currentIndex: 1,

        backgroundColor:

        settings.isDark

            ? Colors.black

            : Colors.white,

        selectedItemColor:
        Colors.deepPurple,

        unselectedItemColor:
        Colors.grey.shade400,

        type:
        BottomNavigationBarType.fixed,

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

          if (index == 4) {

            Navigator.push(

              context,

              MaterialPageRoute(

                builder: (context) =>
                const ProfilePage(),
              ),
            );
          }
        },

        items: [

          BottomNavigationBarItem(

            icon:
            const Icon(Icons.home),

            label:

            settings.text(

              english: "Home",

              spanish: "Inicio",
            ),
          ),

          BottomNavigationBarItem(

            icon:
            const Icon(Icons.timer),

            label:

            settings.text(

              english: "Timer",

              spanish:
              "Temporizador",
            ),
          ),

          BottomNavigationBarItem(

            icon:
            const Icon(Icons.task),

            label:

            settings.text(

              english: "Tasks",

              spanish: "Tareas",
            ),
          ),

          BottomNavigationBarItem(

            icon:
            const Icon(Icons.bar_chart),

            label:

            settings.text(

              english:
              "Analytics",

              spanish:
              "Analítica",
            ),
          ),

          BottomNavigationBarItem(

            icon:
            const Icon(Icons.person),

            label:

            settings.text(

              english:
              "Profile",

              spanish:
              "Perfil",
            ),
          ),
        ],
      ),

      body: SafeArea(

        child:
        SingleChildScrollView(

          padding:
          const EdgeInsets.all(20),

          child: Column(

            children: [

              Row(

                mainAxisAlignment:
                MainAxisAlignment
                    .spaceBetween,

                children: [

                  Builder(

                    builder: (context) {

                      return Container(

                        decoration:
                        BoxDecoration(

                          color:

                          settings.isDark

                              ? Colors.grey.shade900

                              : Colors.white,

                          borderRadius:
                          BorderRadius.circular(
                              14),
                        ),

                        child: IconButton(

                          onPressed: () {

                            Scaffold.of(context)
                                .openDrawer();
                          },

                          icon: Icon(

                            Icons.menu,

                            color:

                            settings.isDark

                                ? Colors.white

                                : Colors.black,
                          ),
                        ),
                      );
                    },
                  ),

                  Text(

                    settings.text(

                      english:
                      currentMode,

                      spanish:

                      currentMode == "Focus"

                          ? "Enfoque"

                          : currentMode == "Short Break"

                          ? "Descanso Corto"

                          : currentMode == "Long Break"

                          ? "Descanso Largo"

                          : currentMode,
                    ),

                    style: TextStyle(

                      fontSize: 26,

                      color:

                      settings.isDark

                          ? Colors.white

                          : Colors.black,

                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),

                  const SizedBox(width: 50),
                ],
              ),

              const SizedBox(height: 45),

              Container(

                padding:
                const EdgeInsets.symmetric(

                  horizontal: 14,

                  vertical: 14,
                ),

                decoration: BoxDecoration(

                  color:

                  settings.isDark

                      ? Colors.grey.shade900

                      : Colors.white,

                  borderRadius:
                  BorderRadius.circular(
                      22),

                  boxShadow: [

                    BoxShadow(

                      color:
                      Colors.black.withOpacity(
                          0.04),

                      blurRadius: 10,

                      offset:
                      const Offset(0, 4),
                    ),
                  ],
                ),

                child: Row(

                  mainAxisAlignment:
                  MainAxisAlignment
                      .spaceAround,

                  children: [

                    Text(

                      settings.text(

                        english:
                        "Focus",

                        spanish:
                        "Enfoque",
                      ),

                      style: const TextStyle(

                        color:
                        Colors.deepPurple,

                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),

                    GestureDetector(

                      onTap: () {

                        showBreakDialog(
                            true);
                      },

                      child: Text(

                        settings.text(

                          english:
                          "Short Break",

                          spanish:
                          "Descanso Corto",
                        ),
                      ),
                    ),

                    GestureDetector(

                      onTap: () {

                        showBreakDialog(
                            false);
                      },

                      child: Text(

                        settings.text(

                          english:
                          "Long Break",

                          spanish:
                          "Descanso Largo",
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              Container(

                height: 290,

                width: 290,

                decoration: BoxDecoration(

                  shape:
                  BoxShape.circle,

                  gradient:
                  const LinearGradient(

                    colors: [

                      Color(0xFF6C63FF),

                      Color(0xFFD946EF),
                    ],
                  ),

                  boxShadow: [

                    BoxShadow(

                      color:
                      Colors.deepPurple
                          .withOpacity(
                          0.25),

                      blurRadius: 20,

                      offset:
                      const Offset(0, 8),
                    ),
                  ],
                ),

                child: Container(

                  margin:
                  const EdgeInsets.all(
                      10),

                  decoration:
                  BoxDecoration(

                    shape:
                    BoxShape.circle,

                    color:

                    settings.isDark

                        ? const Color(
                        0xFF121212)

                        : Colors.white,
                  ),

                  child: Column(

                    mainAxisAlignment:
                    MainAxisAlignment
                        .center,

                    children: [

                      Text(

                        settings.text(

                          english:
                          currentMode,

                          spanish:

                          currentMode == "Focus"

                              ? "Enfoque"

                              : currentMode == "Short Break"

                              ? "Descanso Corto"

                              : currentMode == "Long Break"

                              ? "Descanso Largo"

                              : currentMode,
                        ),

                        style:
                        const TextStyle(

                          color:
                          Colors.grey,

                          fontSize: 16,
                        ),
                      ),

                      const SizedBox(height: 15),

                      Text(

                        isBreakRunning

                            ? formatTime(
                            breakRemainingSeconds)

                            : formatTime(
                            seconds),

                        style: TextStyle(

                          fontSize: 44,

                          color:

                          settings.isDark

                              ? Colors.white

                              : Colors.black,

                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 22),

                      GestureDetector(

                        onTap: () {

                          if (isRunning) {

                            stopTimer();
                          }

                          else {

                            startTimer();
                          }
                        },

                        child:
                        AnimatedContainer(

                          duration:
                          const Duration(
                              milliseconds:
                              300),

                          height: 75,

                          width: 75,

                          decoration:
                          BoxDecoration(

                            shape:
                            BoxShape.circle,

                            color:
                            Colors.deepPurple,

                            boxShadow: [

                              BoxShadow(

                                color:
                                Colors.deepPurple
                                    .withOpacity(
                                    0.35),

                                blurRadius:
                                12,

                                offset:
                                const Offset(
                                    0,
                                    5),
                              ),
                            ],
                          ),

                          child: Icon(

                            isRunning
                                ? Icons.stop
                                : Icons.play_arrow,

                            color:
                            Colors.white,

                            size: 42,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 35),

              buildCard(

                settings,

                settings.text(

                  english:
                  "Today's Progress",

                  spanish:
                  "Progreso de Hoy",
                ),

                [

                  settings.text(

                    english:
                    "• Completed Sessions: $completedSessions",

                    spanish:
                    "• Sesiones completadas: $completedSessions",
                  ),

                  settings.text(

                    english:
                    "• Short Breaks: $shortBreakCount",

                    spanish:
                    "• Descansos cortos: $shortBreakCount",
                  ),

                  settings.text(

                    english:
                    "• Long Breaks: $longBreakCount",

                    spanish:
                    "• Descansos largos: $longBreakCount",
                  ),
                ],
              ),

              const SizedBox(height: 24),

              buildCard(

                settings,

                settings.text(

                  english:
                  "Current Break Info",

                  spanish:
                  "Información del descanso",
                ),

                [

                  settings.text(

                    english:
                    "Current Mode: $currentMode",

                    spanish:
                    "Modo actual: $currentMode",
                  ),

                  settings.text(

                    english:
                    "Break Reason: $currentBreakReason",

                    spanish:
                    "Razón del descanso: $currentBreakReason",
                  ),

                  settings.text(

                    english:
                    "Break Time: $currentBreakMinutes min",

                    spanish:
                    "Tiempo de descanso: $currentBreakMinutes min",
                  ),
                ],
              ),

              const SizedBox(height: 18),

              Container(

                width: double.infinity,

                padding:
                const EdgeInsets.all(16),

                decoration: BoxDecoration(

                  gradient:
                  LinearGradient(

                    colors:

                    settings.isDark

                        ? [

                      Colors.grey.shade900,

                      Colors.grey.shade800,
                    ]

                        : [

                      Colors.deepPurple
                          .withOpacity(0.08),

                      Colors.purple
                          .withOpacity(0.04),
                    ],
                  ),

                  borderRadius:
                  BorderRadius.circular(
                      20),

                  boxShadow: [

                    BoxShadow(

                      color:
                      Colors.black.withOpacity(
                          0.04),

                      blurRadius: 10,

                      offset:
                      const Offset(0, 4),
                    ),
                  ],
                ),

                child: Row(

                  crossAxisAlignment:
                  CrossAxisAlignment.start,

                  children: [

                    Container(

                      padding:
                      const EdgeInsets.all(10),

                      decoration:
                      BoxDecoration(

                        color:
                        Colors.deepPurple
                            .withOpacity(0.12),

                        borderRadius:
                        BorderRadius.circular(
                            14),
                      ),

                      child: const Icon(

                        Icons.info_outline,

                        color:
                        Colors.deepPurple,
                      ),
                    ),

                    const SizedBox(width: 14),

                    Expanded(

                      child: Column(

                        crossAxisAlignment:
                        CrossAxisAlignment.start,

                        children: [

                          Text(

                            settings.text(

                              english:
                              "Break Limits",

                              spanish:
                              "Límites de descanso",
                            ),

                            style: TextStyle(

                              fontSize: 16,

                              fontWeight:
                              FontWeight.bold,

                              color:

                              settings.isDark

                                  ? Colors.white

                                  : Colors.black,
                            ),
                          ),

                          const SizedBox(height: 10),

                          Text(

                            settings.text(

                              english:
                              "• Short Break Limit: 1-20 minutes",

                              spanish:
                              "• Límite descanso corto: 1-20 minutos",
                            ),

                            style: TextStyle(

                              height: 1.5,

                              color:

                              settings.isDark

                                  ? Colors.white70

                                  : Colors.black87,
                            ),
                          ),

                          const SizedBox(height: 6),

                          Text(

                            settings.text(

                              english:
                              "• Long Break Limit: 21-60 minutes",

                              spanish:
                              "• Límite descanso largo: 21-60 minutos",
                            ),

                            style: TextStyle(

                              height: 1.5,

                              color:

                              settings.isDark

                                  ? Colors.white70

                                  : Colors.black87,
                            ),
                          ),

                          const SizedBox(height: 10),

                          Text(

                            settings.text(

                              english:
                              "Balanced breaks improve concentration and maintain healthy productivity sessions.",

                              spanish:
                              "Los descansos equilibrados mejoran la concentración y mantienen sesiones productivas saludables.",
                            ),

                            style: TextStyle(

                              fontSize: 12,

                              fontStyle:
                              FontStyle.italic,

                              color:

                              settings.isDark

                                  ? Colors.white54

                                  : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCard(

      AppSettings settings,

      String title,

      List<String> texts,
      ) {

    return Container(

      width: double.infinity,

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
                0.04),

            blurRadius: 12,

            offset:
            const Offset(0, 4),
          ),
        ],
      ),

      child: Column(

        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          Text(

            title,

            style: TextStyle(

              fontSize: 20,

              color:

              settings.isDark

                  ? Colors.white

                  : Colors.black,

              fontWeight:
              FontWeight.bold,
            ),
          ),

          const SizedBox(height: 18),

          ...texts.map(

                (text) => Padding(

              padding:
              const EdgeInsets.only(
                  bottom: 10),

              child: Text(

                text,

                style: TextStyle(

                  height: 1.5,

                  color:

                  settings.isDark

                      ? Colors.white

                      : Colors.black87,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}