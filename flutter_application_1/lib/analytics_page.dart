import 'package:flutter/material.dart';
import 'package:flutter_application_1/home_page.dart';
import 'package:flutter_application_1/tasks_page.dart';
import 'package:flutter_application_1/timer_page.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app_settings.dart';

class AnalyticsPage extends StatefulWidget {

  const AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() =>
      _AnalyticsPageState();
}

class _AnalyticsPageState
    extends State<AnalyticsPage> {

  final supabase =
      Supabase.instance.client;

  ////////////////////////////////////////////////////////////
  /// REALTIME
  ////////////////////////////////////////////////////////////

  RealtimeChannel? realtimeChannel;

  List<double> studyHours =
  List.generate(10, (index) => 0);

  List<String> last10Days = [];

  int selectedIndex = 0;

  double selectedStudyMinutes = 0;

  double selectedDelayMinutes = 0;

  double productivityScore = 0;

  Map<String, double>
  reasonPercentages = {

    "Social Media": 0,

    "YouTube": 0,

    "Overthinking": 0,

    "Games": 0,

    "Friends": 0,

    "Entertainment": 0,

    "Others": 0,
  };

  @override
  void initState() {

    super.initState();

    generateLast10Days();

    loadAnalytics();

    ////////////////////////////////////////////////////////////
    /// REALTIME ANALYTICS
    ////////////////////////////////////////////////////////////

    realtimeChannel = supabase

        .channel('analytics-live')

////////////////////////////////////////////////////////////
/// DELAY LOGS
////////////////////////////////////////////////////////////

      ..onPostgresChanges(

        event:
        PostgresChangeEvent.all,

        schema: 'public',

        table: 'delay_logs',

        callback: (payload) {

          loadAnalytics();
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

          loadAnalytics();
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
  /// LAST 10 DAYS
  ////////////////////////////////////////////////////////////

  void generateLast10Days() {

    last10Days.clear();

    for (int i = 9; i >= 0; i--) {

      DateTime day =
      DateTime.now().subtract(
        Duration(days: i),
      );

      String text =
          "${day.day}/${day.month}";

      last10Days.add(text);
    }
  }

  ////////////////////////////////////////////////////////////
  /// LOAD ANALYTICS
  ////////////////////////////////////////////////////////////

  Future<void> loadAnalytics() async {

    final user =
    supabase.auth.currentUser;

    if (user == null) return;

    final focusData =
    await supabase
        .from('focus_sessions')
        .select()
        .eq('user_id', user.id);

    final delayData =
    await supabase
        .from('delay_logs')
        .select()
        .eq('user_id', user.id);

    List<double> tempStudy =
    List.generate(10,
            (index) => 0);

    for (var item in focusData) {

      DateTime date =
      DateTime.parse(
          item['created_at'])
          .toLocal();

      DateTime today =
      DateTime.now();

      DateTime normalizedToday =
      DateTime(
        today.year,
        today.month,
        today.day,
      );

      DateTime normalizedDate =
      DateTime(
        date.year,
        date.month,
        date.day,
      );

      int diff =
      normalizedToday
          .difference(
          normalizedDate)
          .inDays;

      if (diff >= 0 &&
          diff < 10) {

        int index = 9 - diff;

        String duration =
            item['duration'] ??
                "00:00:00";

        List<String> parts =
        duration.split(":");

        if (parts.length == 3) {

          int hours =
          int.tryParse(
              parts[0]) ?? 0;

          int minutes =
          int.tryParse(
              parts[1]) ?? 0;

          int seconds =
          int.tryParse(
              parts[2]) ?? 0;

          double totalMinutes =

              (hours * 60.0) +
                  minutes +
                  (seconds / 60.0);

          tempStudy[index] +=
              totalMinutes;
        }
      }
    }

    DateTime selectedDate =
    DateTime.now().subtract(

      Duration(
          days:
          9 -
              selectedIndex),
    );

    double delayMinutes = 0;

    Map<String, int> reasons = {

      "Social Media": 0,

      "YouTube": 0,

      "Overthinking": 0,

      "Games": 0,

      "Friends": 0,

      "Entertainment": 0,

      "Others": 0,
    };

    for (var item in delayData) {

      DateTime date =
      DateTime.parse(
          item['created_at'])
          .toLocal();

      bool sameDay =

          date.day ==
              selectedDate.day &&

              date.month ==
                  selectedDate.month &&

              date.year ==
                  selectedDate.year;

      if (sameDay) {

        int mins =
        item['duration_minutes'];

        delayMinutes += mins;

        String reason =
            item['reason'];

        if (reasons.containsKey(
            reason)) {

          reasons[reason] =
              reasons[reason]! +
                  mins;
        }
      }
    }

    Map<String, double>
    percentages = {};

    reasons.forEach((key, value) {

      if (delayMinutes == 0) {

        percentages[key] = 0;
      }

      else {

        percentages[key] =

            (value /
                delayMinutes) *
                100;
      }
    });

    double studyMins =
    tempStudy[selectedIndex]
        .toDouble();

    ////////////////////////////////////////////////////////////
    /// PRODUCTIVITY SCORE
    ////////////////////////////////////////////////////////////

    double score =

    ((studyMins * 2)
        - delayMinutes);

    score =

    ((score / 600) * 100);

    if (score < 0) {

      score = 0;
    }

    if (score > 100) {

      score = 100;
    }

    ////////////////////////////////////////////////////////////
    /// PRINT PRODUCTIVITY CALCULATION
    ////////////////////////////////////////////////////////////

    print("========== PRODUCTIVITY CALCULATION ==========");
    print("Study Minutes: $studyMins");
    print("Delay Minutes: $delayMinutes");
    print("Formula: ((studyMins * 2) - delayMinutes)");
    print("Raw Score: ${(studyMins * 2) - delayMinutes}");
    print("Final Productivity: ${score.toStringAsFixed(2)}%");

    ////////////////////////////////////////////////////////////

    setState(() {

      studyHours = tempStudy;

      selectedStudyMinutes =
          tempStudy[selectedIndex]
              .toDouble();

      selectedDelayMinutes =
          delayMinutes;

      productivityScore =
          score;

      reasonPercentages =
          percentages;
    });
  }

  ////////////////////////////////////////////////////////////
  /// REFRESH DAY
  ////////////////////////////////////////////////////////////

  Future<void> refreshDay(
      int index) async {

    setState(() {

      selectedIndex = index;
    });

    await loadAnalytics();
  }

  @override
  Widget build(BuildContext context) {

    final settings =
    Provider.of<AppSettings>(context);

    return Scaffold(

      backgroundColor:
      settings.isDark
          ? const Color(0xFF121212)
          : const Color(0xFFF7F7F7),

      ////////////////////////////////////////////////////////////
      /// BOTTOM NAV
      ////////////////////////////////////////////////////////////

      bottomNavigationBar:
      BottomNavigationBar(

        currentIndex: 3,

        selectedItemColor:
        Colors.deepPurple,

        unselectedItemColor:
        Colors.grey,

        backgroundColor:
        settings.isDark
            ? Colors.black
            : Colors.white,

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
        },

        items: [

          BottomNavigationBarItem(

            icon: const Icon(Icons.home),

            label: settings.text(

              english: "Home",

              spanish: "Inicio",
            ),
          ),

          BottomNavigationBarItem(

            icon: const Icon(Icons.timer),

            label: settings.text(

              english: "Timer",

              spanish: "Temporizador",
            ),
          ),

          BottomNavigationBarItem(

            icon: const Icon(Icons.task),

            label: settings.text(

              english: "Tasks",

              spanish: "Tareas",
            ),
          ),

          BottomNavigationBarItem(

            icon: const Icon(Icons.bar_chart),

            label: settings.text(

              english: "Analytics",

              spanish: "Analíticas",
            ),
          ),
        ],
      ),

      ////////////////////////////////////////////////////////////
      /// BODY
      ////////////////////////////////////////////////////////////

      body: SafeArea(

        child: SingleChildScrollView(

          padding:
          const EdgeInsets.all(18),

          child: Column(

            crossAxisAlignment:
            CrossAxisAlignment.start,

            children: [

              Center(

                child: Text(

                  settings.text(

                    english:
                    "Analytics",

                    spanish:
                    "Analíticas",
                  ),

                  style: TextStyle(

                    fontSize: 30,

                    fontWeight:
                    FontWeight.bold,

                    color:
                    settings.isDark
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              Text(

                settings.text(

                  english:
                  "Study Time",

                  spanish:
                  "Tiempo de Estudio",
                ),

                style: TextStyle(

                  fontSize: 20,

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

                "${selectedStudyMinutes.toStringAsFixed(0)} min",

                style: const TextStyle(

                  fontSize: 45,

                  color:
                  Colors.deepPurple,

                  fontWeight:
                  FontWeight.bold,
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(

                height: 240,

                child: Row(

                  crossAxisAlignment:
                  CrossAxisAlignment.end,

                  mainAxisAlignment:
                  MainAxisAlignment
                      .spaceBetween,

                  children:
                  List.generate(

                    studyHours.length,

                        (index) {

                      double value =
                      studyHours[index];

                      return GestureDetector(

                        onTap: () async {

                          await refreshDay(
                              index);
                        },

                        child: Column(

                          mainAxisAlignment:
                          MainAxisAlignment.end,

                          children: [

                            AnimatedContainer(

                              duration:
                              const Duration(
                                  milliseconds:
                                  300),

                              width: 26,

                              height:
                              value <= 0
                                  ? 20
                                  : (value * 4)
                                  .clamp(
                                  20,
                                  220),

                              decoration:
                              BoxDecoration(

                                color:

                                selectedIndex ==
                                    index

                                    ? Colors
                                    .deepPurple

                                    : Colors
                                    .deepPurple
                                    .shade200,

                                borderRadius:
                                BorderRadius
                                    .circular(
                                    14),
                              ),
                            ),

                            const SizedBox(
                                height: 10),

                            Text(

                              last10Days[index],

                              style:
                              TextStyle(

                                fontSize: 11,

                                color:
                                settings.isDark
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 25),

              Row(

                children: [

                  Expanded(

                    child:
                    analyticsCard(

                      settings:
                      settings,

                      title:
                      settings.text(

                        english:
                        "Productivity",

                        spanish:
                        "Productividad",
                      ),

                      value:
                      "${productivityScore.toStringAsFixed(2)}%",

                      color:
                      Colors.deepPurple,
                    ),
                  ),

                  const SizedBox(width: 15),

                  Expanded(

                    child:
                    analyticsCard(

                      settings:
                      settings,

                      title:
                      settings.text(

                        english:
                        "Delay Time",

                        spanish:
                        "Tiempo Perdido",
                      ),

                      value:
                      "${selectedDelayMinutes.toStringAsFixed(0)} min",

                      color:
                      Colors.pink,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              Text(

                settings.text(

                  english:
                  "Top Delay Reasons",

                  spanish:
                  "Razones Principales",
                ),

                style: TextStyle(

                  fontSize: 22,

                  fontWeight:
                  FontWeight.bold,

                  color:
                  settings.isDark
                      ? Colors.white
                      : Colors.black,
                ),
              ),

              const SizedBox(height: 18),

              Container(

                width: double.infinity,

                padding:
                const EdgeInsets.all(
                    20),

                decoration: BoxDecoration(

                  color:
                  settings.isDark
                      ? Colors.grey.shade900
                      : Colors.white,

                  borderRadius:
                  BorderRadius.circular(
                      20),
                ),

                child: Column(

                  children:
                  reasonPercentages
                      .entries
                      .map((e) {

                    return Padding(

                      padding:
                      const EdgeInsets.only(
                          bottom: 16),

                      child: Row(

                        mainAxisAlignment:
                        MainAxisAlignment
                            .spaceBetween,

                        children: [

                          Row(

                            children: [

                              Container(

                                width: 12,

                                height: 12,

                                decoration:
                                BoxDecoration(

                                  color:
                                  Colors.deepPurple,

                                  borderRadius:
                                  BorderRadius
                                      .circular(
                                      20),
                                ),
                              ),

                              const SizedBox(
                                  width: 10),

                              Text(

                                e.key,

                                style: TextStyle(

                                  color:
                                  settings.isDark
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ],
                          ),

                          Text(

                            "${e.value.toStringAsFixed(0)}%",

                            style: TextStyle(

                              color:
                              settings.isDark
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  ////////////////////////////////////////////////////////////
  /// CARD
  ////////////////////////////////////////////////////////////

  Widget analyticsCard({

    required AppSettings settings,

    required String title,

    required String value,

    required Color color,
  }) {

    return Container(

      padding:
      const EdgeInsets.all(18),

      decoration: BoxDecoration(

        color:
        settings.isDark
            ? Colors.grey.shade900
            : Colors.white,

        borderRadius:
        BorderRadius.circular(
            20),
      ),

      child: Column(

        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          Text(

            title,

            style: TextStyle(

              fontWeight:
              FontWeight.bold,

              color:
              settings.isDark
                  ? Colors.white
                  : Colors.black,
            ),
          ),

          const SizedBox(height: 15),

          Text(

            value,

            style: TextStyle(

              fontSize: 30,

              fontWeight:
              FontWeight.bold,

              color: color,
            ),
          ),
        ],
      ),
    );
  }
}