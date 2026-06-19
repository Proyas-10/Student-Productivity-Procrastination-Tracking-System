import 'package:flutter/material.dart';
import 'package:flutter_application_1/analytics_page.dart';
import 'package:flutter_application_1/logdelay_page.dart';
import 'package:flutter_application_1/profile_page.dart';
import 'package:flutter_application_1/settings_page.dart';
import 'package:flutter_application_1/tasks_page.dart';
import 'package:flutter_application_1/timer_page.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app_settings.dart';

class HomePage extends StatefulWidget {

  const HomePage({super.key});

  @override
  State<HomePage> createState() =>
      _HomePageState();
}

class _HomePageState
    extends State<HomePage> {

  final supabase =
  Supabase.instance.client;

  double todayStudyMinutes = 0;

  int completedTasks = 0;

  int totalTasks = 0;

  double todayDelayMinutes = 0;

  String delayReason =
      "No Delay";

  double productivityScore = 0;

  bool isLoading = true;

  ////////////////////////////////////////////////////////////
  /// REALTIME
  ///////////////////////////

  RealtimeChannel? realtimeChannel;

  ////////////////////////////////////////////////////////////
  /// INIT
  ////////////////////////////////////////////////////////////

  @override
  void initState() {

    super.initState();

    loadHomeData();

    ////////////////////////////////////////////////////////////
    /// LIVE REFRESH
    ////////////////////////////////////////////////////////////

    realtimeChannel = supabase

        .channel('live-home-update')

////////////////////////////////////////////////////////////
/// TASKS
////////////////////////////////////////////////////////////

      ..onPostgresChanges(

        event:
        PostgresChangeEvent.all,

        schema: 'public',

        table: 'tasks',

        callback: (payload) {

          loadHomeData();
        },
      )

////////////////////////////////////////////////////////////
/// DELAY LOGS
////////////////////////////////////////////////////////////

      ..onPostgresChanges(

        event:
        PostgresChangeEvent.all,

        schema: 'public',

        table: 'delay_logs',

        callback: (payload) {

          loadHomeData();
        },
      )

////////////////////////////////////////////////////////////
/// FOCUS SESSION
////////////////////////////////////////////////////////////

      ..onPostgresChanges(

        event:
        PostgresChangeEvent.all,

        schema: 'public',

        table: 'focus_sessions',

        callback: (payload) {

          loadHomeData();
        },
      )

////////////////////////////////////////////////////////////
/// SUBSCRIBE
////////////////////////////////////////////////////////////

      ..subscribe();
  }

  ////////////////////////////////////////////////////////////
  /// DISPOSE
  ////////////////////////////////////////////////////////////

  @override
  void dispose() {

    if (realtimeChannel != null) {

      supabase.removeChannel(
          realtimeChannel!);
    }

    super.dispose();
  }

  ////////////////////////////////////////////////////////////
  /// LOAD HOME DATA
  ////////////////////////////////////////////////////////////

  Future<void> loadHomeData() async {

    final user =
    supabase.auth.currentUser;

    if (user == null) return;

    //////////////////////////////////////////////////////
    /// CURRENT DAY
    //////////////////////////////////////////////////////

    DateTime now = DateTime.now();

    DateTime startOfDay = DateTime(

      now.year,

      now.month,

      now.day,
    );

    //////////////////////////////////////////////////////
    /// TODAY FOCUS SESSION
    //////////////////////////////////////////////////////

    final focusData =
    await supabase

        .from('focus_sessions')

        .select()

        .eq('user_id', user.id);

    double totalMinutes = 0;

    for (var item in focusData) {

      DateTime created =
      DateTime.parse(

          item['created_at'])

          .toLocal();

      if (created.isAfter(
          startOfDay)) {

        String duration =

            item['duration'] ??
                "00:00:00";

        List<String> parts =
        duration.split(":");

        if (parts.length == 3) {

          int h =
              int.tryParse(
                  parts[0]) ?? 0;

          int m =
              int.tryParse(
                  parts[1]) ?? 0;

          int s =
              int.tryParse(
                  parts[2]) ?? 0;

          totalMinutes +=

              (h * 60) +

                  m +

                  (s / 60);
        }
      }
    }

    //////////////////////////////////////////////////////
    /// ALL TASKS
    //////////////////////////////////////////////////////

    final taskData =
    await supabase

        .from('tasks')

        .select()

        .eq('user_id', user.id);

    int completed = 0;

    int total = taskData.length;

    for (var item in taskData) {

      if (item['completed']
      == true) {

        completed++;
      }
    }

    //////////////////////////////////////////////////////
    /// LIVE TODAY DELAY
    //////////////////////////////////////////////////////

    final delayData =
    await supabase

        .from('delay_logs')

        .select()

        .eq('user_id', user.id)
        .order(
      'created_at',
      ascending: false,
    );

    double delayMinutes = 0;

    List<String> reasons = [];

    for (var item in delayData) {

      DateTime created =
      DateTime.parse(
          item['created_at'])
          .toLocal();

      final delayDate =
      DateTime(
        created.year,
        created.month,
        created.day,
      );

      final today =
      DateTime(
        now.year,
        now.month,
        now.day,
      );

      //////////////////////////////////////////////////////
      /// TODAY ONLY
      //////////////////////////////////////////////////////

      if (delayDate == today) {

        delayMinutes +=
        (item['duration_minutes'] ?? 0)
            .toDouble();

        String currentReason =
            item['reason'] ?? "";

        if (currentReason.isNotEmpty &&
            !reasons.contains(
                currentReason)) {

          reasons.add(
              currentReason);
        }
      }
    }

    //////////////////////////////////////////////////////
    /// PRODUCTIVITY SCORE
    //////////////////////////////////////////////////////

    double score =

    ((totalMinutes * 2)
        - delayMinutes);

    score =

    ((score / 600) * 100);

    if (score < 0) {

      score = 0;
    }

    if (score > 100) {

      score = 100;
    }

    //////////////////////////////////////////////////////
    /// UPDATE
    //////////////////////////////////////////////////////

    if (!mounted) return;

    setState(() {

      todayStudyMinutes =
          totalMinutes;

      completedTasks =
          completed;

      totalTasks =
          total;

      todayDelayMinutes =
          delayMinutes;

      delayReason =
      reasons.isEmpty

          ? settingsText(
        context,
        english: "No Delay",
        spanish: "Sin Retraso",
      )

          : reasons.join(", ");

      productivityScore =
          score;

      isLoading = false;
    });
  }

  ////////////////////////////////////////////////////////////
  /// SETTINGS TEXT
  ////////////////////////////////////////////////////////////

  String settingsText(

      BuildContext context, {

        required String english,

        required String spanish,
      }) {

    final settings =
    Provider.of<AppSettings>(
      context,
      listen: false,
    );

    return settings.text(

      english: english,

      spanish: spanish,
    );
  }

  ////////////////////////////////////////////////////////////
  /// BUILD
  ////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {

    final settings =
    Provider.of<AppSettings>(context);

    if (isLoading) {

      return const Scaffold(

        body: Center(

          child:
          CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(

      backgroundColor:

      settings.isDark

          ? const Color(
          0xFF121212)

          : const Color(
          0xFFF3F4F6),

      ////////////////////////////////////////////////////////////
      /// BOTTOM NAVIGATION
      ////////////////////////////////////////////////////////////

      bottomNavigationBar:
      BottomNavigationBar(

        currentIndex: 0,

        selectedItemColor:
        Colors.deepPurple,

        unselectedItemColor:
        Colors.grey,

        backgroundColor:

        settings.isDark

            ? Colors.black

            : Colors.white,

        showUnselectedLabels:
        true,

        type:
        BottomNavigationBarType
            .fixed,

        onTap: (index) {

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

          if (index == 4) {

            Navigator.pushReplacement(

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

            label: settings.text(

              english: "Home",

              spanish: "Inicio",
            ),
          ),

          BottomNavigationBarItem(

            icon:
            const Icon(Icons.timer),

            label: settings.text(

              english: "Timer",

              spanish: "Temporizador",
            ),
          ),

          BottomNavigationBarItem(

            icon:
            const Icon(Icons.task),

            label: settings.text(

              english: "Tasks",

              spanish: "Tareas",
            ),
          ),

          BottomNavigationBarItem(

            icon:
            const Icon(Icons.bar_chart),

            label: settings.text(

              english: "Analytics",

              spanish: "Analíticas",
            ),
          ),

          BottomNavigationBarItem(

            icon:
            const Icon(Icons.person),

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

        child: RefreshIndicator(

          onRefresh:
          loadHomeData,

          child: SingleChildScrollView(

            physics:
            const AlwaysScrollableScrollPhysics(),

            child: Padding(

              padding:
              const EdgeInsets.all(
                  24),

              child: Column(

                crossAxisAlignment:
                CrossAxisAlignment
                    .start,

                children: [

                  Row(

                    mainAxisAlignment:
                    MainAxisAlignment.start,

                    children: [

                      GestureDetector(

                        onTap: () {

                          Navigator.push(

                            context,

                            MaterialPageRoute(

                              builder:
                                  (context) =>
                              const SettingsPage(),
                            ),
                          );
                        },

                        child: Icon(

                          Icons.settings,

                          size: 28,

                          color:

                          settings.isDark

                              ? Colors.white

                              : Colors.black,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                      height: 35),

                  FutureBuilder(

                    future:
                    Supabase.instance.client

                        .from('users')

                        .select('name')

                        .eq(

                      'id',

                      Supabase.instance
                          .client
                          .auth
                          .currentUser!
                          .id,
                    )

                        .single(),

                    builder:
                        (context, snapshot) {

                      String userName =
                          "User";

                      if (snapshot.hasData &&
                          snapshot.data !=
                              null) {

                        userName =

                            snapshot
                                .data!['name'] ??

                                "User";
                      }

                      final hour =
                          DateTime.now()
                              .hour;

                      String greeting =
                      settings.text(

                        english:
                        "Good Evening",

                        spanish:
                        "Buenas Noches",
                      );

                      if (hour >= 5 &&
                          hour < 12) {

                        greeting =
                        settings.text(

                          english:
                          "Good Morning",

                          spanish:
                          "Buenos Días",
                        );
                      }

                      else if (hour >= 12 &&
                          hour < 18) {

                        greeting =
                        settings.text(

                          english:
                          "Good Afternoon",

                          spanish:
                          "Buenas Tardes",
                        );
                      }

                      return Column(

                        crossAxisAlignment:
                        CrossAxisAlignment
                            .start,

                        children: [

                          Text(

                            "$greeting, $userName 👋",

                            style:
                            TextStyle(

                              fontSize: 32,

                              fontWeight:
                              FontWeight.bold,

                              color:

                              settings.isDark

                                  ? Colors.white

                                  : Colors.black,
                            ),
                          ),

                          const SizedBox(
                              height: 8),

                          Text(

                            settings.text(

                              english:
                              "Your daily productivity overview",

                              spanish:
                              "Resumen diario de productividad",
                            ),

                            style:
                            const TextStyle(

                              color:
                              Colors.grey,

                              fontSize: 16,
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                  const SizedBox(
                      height: 28),

                  Container(

                    padding:
                    const EdgeInsets.all(
                        24),

                    decoration:
                    BoxDecoration(

                      gradient:
                      const LinearGradient(

                        colors: [

                          Color(0xFF6C63FF),

                          Color(0xFF8E85FF),
                        ],
                      ),

                      borderRadius:
                      BorderRadius.circular(
                          24),

                      boxShadow: [

                        BoxShadow(

                          color:
                          Colors.deepPurple
                              .withOpacity(
                              0.2),

                          blurRadius: 15,

                          offset:
                          const Offset(
                              0,
                              6),
                        ),
                      ],
                    ),

                    child: Column(

                      crossAxisAlignment:
                      CrossAxisAlignment
                          .start,

                      children: [

                        Row(

                          mainAxisAlignment:
                          MainAxisAlignment
                              .spaceBetween,

                          children: [

                            Text(

                              settings.text(

                                english:
                                "Today's Study Time",

                                spanish:
                                "Tiempo de Estudio de Hoy",
                              ),

                              style:
                              const TextStyle(

                                color:
                                Colors.white70,

                                fontSize: 16,
                              ),
                            ),

                            const Icon(

                              Icons.timer,

                              color:
                              Colors.white,
                            ),
                          ],
                        ),

                        const SizedBox(
                            height: 18),

                        Text(

                          "${(todayStudyMinutes ~/ 60)}h ${(todayStudyMinutes % 60).toInt()}m",

                          style:
                          const TextStyle(

                            fontSize: 42,

                            fontWeight:
                            FontWeight.bold,

                            color:
                            Colors.white,
                          ),
                        ),

                        const SizedBox(
                            height: 10),

                        Text(

                          settings.text(

                            english:
                            "Today's total focus session time",

                            spanish:
                            "Tiempo total de enfoque de hoy",
                          ),

                          style:
                          const TextStyle(

                            color:
                            Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(
                      height: 22),

                  Row(

                    children: [

                      Expanded(

                        child: infoCard(

                          settings:
                          settings,

                          title:
                          settings.text(

                            english:
                            "Tasks",

                            spanish:
                            "Tareas",
                          ),

                          value:

                          totalTasks == 0

                              ? settings.text(

                            english:
                            "No Task",

                            spanish:
                            "Sin Tareas",
                          )

                              : "$completedTasks/$totalTasks",

                          subtitle:

                          totalTasks == 0

                              ? settings.text(

                            english:
                            "No task added",

                            spanish:
                            "No hay tareas",
                          )

                              : settings.text(

                            english:
                            "$completedTasks completed",

                            spanish:
                            "$completedTasks completadas",
                          ),

                          icon:
                          Icons.task_alt,

                          color:
                          Colors.deepPurple,
                        ),
                      ),

                      const SizedBox(
                          width: 16),

                      Expanded(

                        child:
                        GestureDetector(

                          onTap: () {

                            Navigator.push(

                              context,

                              MaterialPageRoute(

                                builder:
                                    (context) =>
                                const LogDelayPage(),
                              ),
                            );
                          },

                          child: infoCard(

                            settings:
                            settings,

                            title:
                            settings.text(

                              english:
                              "Delay",

                              spanish:
                              "Retraso",
                            ),

                            value:

                            todayDelayMinutes == 0

                                ? settings.text(

                              english:
                              "No Delay",

                              spanish:
                              "Sin Retraso",
                            )

                                : "${todayDelayMinutes.toInt()}m",

                            subtitle:
                            delayReason,

                            icon:
                            Icons.access_time,

                            color:
                            Colors.orange,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                      height: 22),

                  Container(

                    padding:
                    const EdgeInsets.all(
                        24),

                    decoration:
                    BoxDecoration(

                      color:

                      settings.isDark

                          ? Colors.grey
                          .shade900

                          : Colors.white,

                      borderRadius:
                      BorderRadius.circular(
                          24),

                      boxShadow: [

                        BoxShadow(

                          color:
                          Colors.black
                              .withOpacity(
                              0.05),

                          blurRadius: 12,

                          offset:
                          const Offset(
                              0,
                              4),
                        ),
                      ],
                    ),

                    child: Row(

                      mainAxisAlignment:
                      MainAxisAlignment
                          .spaceBetween,

                      children: [

                        Column(

                          crossAxisAlignment:
                          CrossAxisAlignment
                              .start,

                          children: [

                            Text(

                              settings.text(

                                english:
                                "Today's Productivity",

                                spanish:
                                "Productividad de Hoy",
                              ),

                              style:
                              const TextStyle(

                                color:
                                Colors.grey,
                              ),
                            ),

                            const SizedBox(
                                height: 12),

                            Text(

                              "${productivityScore.toStringAsFixed(2)}%",

                              style:
                              TextStyle(

                                fontSize: 36,

                                fontWeight:
                                FontWeight.bold,

                                color:

                                settings.isDark

                                    ? Colors.white

                                    : Colors.black,
                              ),
                            ),

                            const SizedBox(
                                height: 8),

                            Text(

                              productivityScore >= 70

                                  ? settings.text(

                                english:
                                "Excellent consistency",

                                spanish:
                                "Excelente consistencia",
                              )

                                  : productivityScore >= 40

                                  ? settings.text(

                                english:
                                "Good progress",

                                spanish:
                                "Buen progreso",
                              )

                                  : settings.text(

                                english:
                                "Need more focus",

                                spanish:
                                "Necesita más enfoque",
                              ),

                              style:
                              const TextStyle(

                                color:
                                Colors.grey,
                              ),
                            ),
                          ],
                        ),

                        Stack(

                          alignment:
                          Alignment.center,

                          children: [

                            SizedBox(

                              width: 90,

                              height: 90,

                              child:
                              CircularProgressIndicator(

                                value:
                                productivityScore /
                                    100,

                                strokeWidth:
                                10,

                                backgroundColor:
                                Colors.grey
                                    .shade300,

                                color:
                                Colors.deepPurple,
                              ),
                            ),

                            Text(

                              "${productivityScore.toStringAsFixed(2)}%",

                              style:
                              const TextStyle(

                                fontWeight:
                                FontWeight.bold,

                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(
                      height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  ////////////////////////////////////////////////////////////
  /// INFO CARD
  ////////////////////////////////////////////////////////////

  static Widget infoCard({

    required AppSettings settings,

    required String title,

    required String value,

    required String subtitle,

    required IconData icon,

    required Color color,
  }) {

    return Container(

      padding:
      const EdgeInsets.all(22),

      decoration:
      BoxDecoration(

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
            Colors.black
                .withOpacity(
                0.05),

            blurRadius: 10,

            offset:
            const Offset(0, 4),
          ),
        ],
      ),

      child: Column(

        crossAxisAlignment:
        CrossAxisAlignment
            .start,

        children: [

          Container(

            padding:
            const EdgeInsets.all(
                10),

            decoration:
            BoxDecoration(

              color:
              color.withOpacity(
                  0.12),

              borderRadius:
              BorderRadius.circular(
                  14),
            ),

            child: Icon(

              icon,

              color: color,
            ),
          ),

          const SizedBox(
              height: 18),

          Text(

            title,

            style:
            const TextStyle(

              color:
              Colors.grey,

              fontSize: 14,
            ),
          ),

          const SizedBox(
              height: 8),

          Text(

            value,

            style:
            TextStyle(

              fontSize: 28,

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

            subtitle,

            maxLines: 2,

            overflow:
            TextOverflow.ellipsis,

            style: TextStyle(

              color: color,

              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}