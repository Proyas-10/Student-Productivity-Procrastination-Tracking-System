import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app_settings.dart';

class LogDelayPage extends StatefulWidget {

  const LogDelayPage({super.key});

  @override
  State<LogDelayPage> createState() =>
      _LogDelayPageState();
}

class _LogDelayPageState
    extends State<LogDelayPage> {

  ////////////////////////////////////////////////////////////
  /// SUPABASE
  ////////////////////////////////////////////////////////////

  final supabase =
      Supabase.instance.client;

  ////////////////////////////////////////////////////////////
  /// SELECTED REASON
  ////////////////////////////////////////////////////////////

  String selectedReason =
      "Social Media";

  ////////////////////////////////////////////////////////////
  /// SELECTED TIME
  ////////////////////////////////////////////////////////////

  String selectedTime =
      "30 min";

  ////////////////////////////////////////////////////////////
  /// NOTE CONTROLLER
  ////////////////////////////////////////////////////////////

  final TextEditingController
  noteController =
  TextEditingController();

  ////////////////////////////////////////////////////////////
  /// CUSTOM TIME
  ////////////////////////////////////////////////////////////

  final TextEditingController
  customTimeController =
  TextEditingController();

  ////////////////////////////////////////////////////////////
  /// SAVE DELAY
  ////////////////////////////////////////////////////////////

  Future<void> logDelay() async {

    ////////////////////////////////////////////////////////////
    /// SETTINGS
    ////////////////////////////////////////////////////////////

    final settings =
    Provider.of<AppSettings>(
      context,
      listen: false,
    );

    ////////////////////////////////////////////////////////////
    /// USER
    ////////////////////////////////////////////////////////////

    final user =
        supabase.auth.currentUser;

    if (user == null) return;

    ////////////////////////////////////////////////////////////
    /// CONVERT TIME
    ////////////////////////////////////////////////////////////

    int durationMinutes = 0;

    if (selectedTime == "5 min") {

      durationMinutes = 5;
    }

    else if (selectedTime ==
        "15 min") {

      durationMinutes = 15;
    }

    else if (selectedTime ==
        "30 min") {

      durationMinutes = 30;
    }

    else if (selectedTime ==
        "45 min") {

      durationMinutes = 45;
    }

    else if (selectedTime ==
        "1 hour") {

      durationMinutes = 60;
    }

    else {

      durationMinutes =
          int.tryParse(
            customTimeController.text,
          ) ??
              0;
    }

    ////////////////////////////////////////////////////////////
    /// INSERT
    ////////////////////////////////////////////////////////////

    await supabase
        .from('delay_logs')
        .insert({

      'user_id': user.id,

      'reason': selectedReason,

      'duration_minutes':
      durationMinutes,

      'note':
      noteController.text,
    });

    ////////////////////////////////////////////////////////////
    /// SUCCESS
    ////////////////////////////////////////////////////////////

    ScaffoldMessenger.of(context)
        .showSnackBar(

      SnackBar(

        content: Text(

          settings.text(

            english:
            "Delay Logged Successfully",

            spanish:
            "Retraso Registrado",
          ),
        ),
      ),
    );

    ////////////////////////////////////////////////////////////
    /// RESET
    ////////////////////////////////////////////////////////////

    setState(() {

      selectedReason =
      "Social Media";

      selectedTime =
      "30 min";

      noteController.clear();

      customTimeController.clear();
    });

    Navigator.pop(context);
  }

  ////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {

    final settings =
    Provider.of<AppSettings>(context);

    return Scaffold(

      ////////////////////////////////////////////////////////////
      /// BACKGROUND
      ////////////////////////////////////////////////////////////

      backgroundColor:

      settings.isDark

          ? const Color(0xFF121212)

          : const Color(0xFFF7F7FB),

      ////////////////////////////////////////////////////////////
      /// BODY
      ////////////////////////////////////////////////////////////

      body: SafeArea(

        child: SingleChildScrollView(

          padding:
          const EdgeInsets.all(20),

          child: Column(

            crossAxisAlignment:
            CrossAxisAlignment.start,

            children: [

              //////////////////////////////////////////////////////
              /// TOP
              //////////////////////////////////////////////////////

              Row(

                children: [

                  GestureDetector(

                    onTap: () {

                      Navigator.pop(
                          context);
                    },

                    child: Container(

                      padding:
                      const EdgeInsets.all(
                          12),

                      decoration:
                      BoxDecoration(

                        color:

                        settings.isDark

                            ? Colors.grey.shade900

                            : Colors.white,

                        borderRadius:
                        BorderRadius.circular(
                            18),

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

                      child: Icon(

                        Icons.arrow_back_ios_new_rounded,

                        size: 20,

                        color:

                        settings.isDark

                            ? Colors.white

                            : Colors.black,
                      ),
                    ),
                  ),

                  const Spacer(),

                  Column(

                    children: [

                      Text(

                        settings.text(

                          english:
                          "Log Delay",

                          spanish:
                          "Registrar Retraso",
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

                      const SizedBox(height: 4),

                      Text(

                        settings.text(

                          english:
                          "Track distractions professionally",

                          spanish:
                          "Rastrea distracciones profesionalmente",
                        ),

                        style: TextStyle(

                          color:

                          settings.isDark

                              ? Colors.grey.shade400

                              : Colors.grey.shade600,

                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  Container(

                    padding:
                    const EdgeInsets.all(12),

                    decoration:
                    BoxDecoration(

                      gradient:
                      const LinearGradient(

                        colors: [

                          Color(0xFF6C63FF),

                          Color(0xFFD946EF),
                        ],
                      ),

                      borderRadius:
                      BorderRadius.circular(
                          18),
                    ),

                    child: const Icon(

                      Icons.psychology_alt,

                      color:
                      Colors.white,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              //////////////////////////////////////////////////////
              /// REASON TITLE
              //////////////////////////////////////////////////////

              Text(

                settings.text(

                  english:
                  "What distracted you?",

                  spanish:
                  "¿Qué te distrajo?",
                ),

                style: TextStyle(

                  fontSize: 20,

                  fontWeight:
                  FontWeight.bold,

                  letterSpacing: 0.3,

                  color:

                  settings.isDark

                      ? Colors.white

                      : Colors.black,
                ),
              ),

              const SizedBox(height: 20),

              //////////////////////////////////////////////////////
              /// OPTIONS
              //////////////////////////////////////////////////////

              Wrap(

                spacing: 14,

                runSpacing: 14,

                children: [

                  buildOption(
                    settings,
                    "Social Media",
                    Icons.phone_android,
                  ),

                  buildOption(
                    settings,
                    "YouTube",
                    Icons.play_circle,
                  ),

                  buildOption(
                    settings,
                    "Overthinking",
                    Icons.psychology,
                  ),

                  buildOption(
                    settings,
                    "Games",
                    Icons.sports_esports,
                  ),

                  buildOption(
                    settings,
                    "Friends",
                    Icons.people,
                  ),

                  buildOption(
                    settings,
                    "Entertainment",
                    Icons.movie,
                  ),

                  buildOption(
                    settings,
                    "Others",
                    Icons.more_horiz,
                  ),
                ],
              ),

              const SizedBox(height: 40),

              //////////////////////////////////////////////////////
              /// TIME TITLE
              //////////////////////////////////////////////////////

              Text(

                settings.text(

                  english:
                  "How long were you distracted?",

                  spanish:
                  "¿Cuánto tiempo te distraíste?",
                ),

                style: TextStyle(

                  fontSize: 20,

                  fontWeight:
                  FontWeight.bold,

                  letterSpacing: 0.3,

                  color:

                  settings.isDark

                      ? Colors.white

                      : Colors.black,
                ),
              ),

              const SizedBox(height: 20),

              //////////////////////////////////////////////////////
              /// TIME OPTIONS
              //////////////////////////////////////////////////////

              Wrap(

                spacing: 12,

                runSpacing: 12,

                children: [

                  buildTime(
                      settings,
                      "5 min"),

                  buildTime(
                      settings,
                      "15 min"),

                  buildTime(
                      settings,
                      "30 min"),

                  buildTime(
                      settings,
                      "45 min"),

                  buildTime(
                      settings,
                      "1 hour"),

                  buildTime(
                      settings,
                      "Custom"),
                ],
              ),

              //////////////////////////////////////////////////////
              /// CUSTOM TIME
              //////////////////////////////////////////////////////

              if (selectedTime ==
                  "Custom")

                Padding(

                  padding:
                  const EdgeInsets.only(
                      top: 20),

                  child: TextField(

                    controller:
                    customTimeController,

                    keyboardType:
                    TextInputType.number,

                    style: TextStyle(

                      color:

                      settings.isDark

                          ? Colors.white

                          : Colors.black,
                    ),

                    decoration:
                    InputDecoration(

                      hintText:

                      settings.text(

                        english:
                        "Enter minutes",

                        spanish:
                        "Ingresar minutos",
                      ),

                      hintStyle:
                      const TextStyle(

                        color:
                        Colors.grey,
                      ),

                      filled: true,

                      fillColor:

                      settings.isDark

                          ? Colors.grey.shade900

                          : Colors.white.withOpacity(0.95),

                      prefixIcon:
                      const Icon(
                        Icons.timer,
                      ),

                      contentPadding:
                      const EdgeInsets.symmetric(

                        horizontal: 20,

                        vertical: 18,
                      ),

                      border:
                      OutlineInputBorder(

                        borderRadius:
                        BorderRadius.circular(
                            18),

                        borderSide:
                        BorderSide.none,
                      ),
                    ),
                  ),
                ),

              const SizedBox(height: 40),

              //////////////////////////////////////////////////////
              /// NOTE TITLE
              //////////////////////////////////////////////////////

              Text(

                settings.text(

                  english:
                  "Add Note",

                  spanish:
                  "Agregar Nota",
                ),

                style: TextStyle(

                  fontSize: 20,

                  fontWeight:
                  FontWeight.bold,

                  letterSpacing: 0.3,

                  color:

                  settings.isDark

                      ? Colors.white

                      : Colors.black,
                ),
              ),

              const SizedBox(height: 15),

              //////////////////////////////////////////////////////
              /// NOTE FIELD
              //////////////////////////////////////////////////////

              TextField(

                controller:
                noteController,

                maxLines: 5,

                style: TextStyle(

                  color:

                  settings.isDark

                      ? Colors.white

                      : Colors.black,
                ),

                decoration:
                InputDecoration(

                  hintText:

                  settings.text(

                    english:
                    "Write your thoughts...",

                    spanish:
                    "Escribe tus pensamientos...",
                  ),

                  hintStyle:
                  const TextStyle(

                    color:
                    Colors.grey,
                  ),

                  filled: true,

                  fillColor:

                  settings.isDark

                      ? Colors.grey.shade900

                      : Colors.white.withOpacity(0.95),

                  contentPadding:
                  const EdgeInsets.symmetric(

                    horizontal: 20,

                    vertical: 18,
                  ),

                  border:
                  OutlineInputBorder(

                    borderRadius:
                    BorderRadius.circular(
                        20),

                    borderSide:
                    BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 45),

              //////////////////////////////////////////////////////
              /// BUTTON
              //////////////////////////////////////////////////////

              SizedBox(

                width:
                double.infinity,

                height: 60,

                child:
                ElevatedButton(

                  style:
                  ElevatedButton.styleFrom(

                    backgroundColor:
                    Colors.transparent,

                    shadowColor:
                    Colors.transparent,

                    padding:
                    EdgeInsets.zero,

                    shape:
                    RoundedRectangleBorder(

                      borderRadius:
                      BorderRadius.circular(
                          22),
                    ),
                  ),

                  onPressed: () {

                    logDelay();
                  },

                  child: Ink(

                    decoration:
                    BoxDecoration(

                      gradient:
                      const LinearGradient(

                        colors: [

                          Color(0xFF6C63FF),

                          Color(0xFFD946EF),
                        ],
                      ),

                      borderRadius:
                      BorderRadius.circular(
                          22),

                      boxShadow: [

                        BoxShadow(

                          color:
                          Colors.deepPurple
                              .withOpacity(0.25),

                          blurRadius: 16,

                          offset:
                          const Offset(0, 6),
                        ),
                      ],
                    ),

                    child: Container(

                      alignment:
                      Alignment.center,

                      child:
                      Row(

                        mainAxisAlignment:
                        MainAxisAlignment.center,

                        children: [

                          const Icon(

                            Icons.save_rounded,

                            color:
                            Colors.white,
                          ),

                          const SizedBox(width: 10),

                          Text(

                            settings.text(

                              english:
                              "Log Delay",

                              spanish:
                              "Registrar Retraso",
                            ),

                            style: const TextStyle(

                              color:
                              Colors.white,

                              fontSize: 18,

                              fontWeight:
                              FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ////////////////////////////////////////////////////////////
  /// OPTION
  ////////////////////////////////////////////////////////////

  Widget buildOption(

      AppSettings settings,

      String text,

      IconData icon,
      ) {

    bool selected =
        selectedReason == text;

    return GestureDetector(

      onTap: () {

        setState(() {

          selectedReason = text;
        });
      },

      child: AnimatedContainer(

        duration:
        const Duration(
            milliseconds: 250),

        padding:
        const EdgeInsets.symmetric(

          horizontal: 18,

          vertical: 15,
        ),

        decoration:
        BoxDecoration(

          gradient:

          selected

              ? const LinearGradient(

            colors: [

              Color(0xFF6C63FF),

              Color(0xFFD946EF),
            ],
          )

              : null,

          color:

          selected

              ? null

              : settings.isDark

              ? Colors.grey.shade900

              : Colors.white,

          borderRadius:
          BorderRadius.circular(
              22),

          border:

          selected

              ? null

              : Border.all(

            color:
            Colors.grey.shade200,
          ),

          boxShadow: [

            BoxShadow(

              color:

              selected

                  ? Colors.deepPurple
                  .withOpacity(0.25)

                  : Colors.black
                  .withOpacity(0.04),

              blurRadius: 14,

              offset:
              const Offset(0, 5),
            ),
          ],
        ),

        child: Row(

          mainAxisSize:
          MainAxisSize.min,

          children: [

            Icon(

              icon,

              color:

              selected

                  ? Colors.white

                  : settings.isDark

                  ? Colors.white

                  : Colors.black,
            ),

            const SizedBox(width: 10),

            Text(

              text,

              style: TextStyle(

                color:

                selected

                    ? Colors.white

                    : settings.isDark

                    ? Colors.white

                    : Colors.black,

                fontWeight:
                FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  ////////////////////////////////////////////////////////////
  /// TIME
  ////////////////////////////////////////////////////////////

  Widget buildTime(

      AppSettings settings,

      String text,
      ) {

    bool selected =
        selectedTime == text;

    return GestureDetector(

      onTap: () {

        setState(() {

          selectedTime = text;
        });
      },

      child: AnimatedContainer(

        duration:
        const Duration(
            milliseconds: 250),

        padding:
        const EdgeInsets.symmetric(

          horizontal: 20,

          vertical: 14,
        ),

        decoration:
        BoxDecoration(

          gradient:

          selected

              ? const LinearGradient(

            colors: [

              Color(0xFF6C63FF),

              Color(0xFFD946EF),
            ],
          )

              : null,

          color:

          selected

              ? null

              : settings.isDark

              ? Colors.grey.shade900

              : Colors.white,

          borderRadius:
          BorderRadius.circular(
              18),

          border:

          selected

              ? null

              : Border.all(

            color:
            Colors.grey.shade200,
          ),

          boxShadow: [

            BoxShadow(

              color:

              selected

                  ? Colors.deepPurple
                  .withOpacity(0.25)

                  : Colors.black
                  .withOpacity(0.04),

              blurRadius: 10,

              offset:
              const Offset(0, 4),
            ),
          ],
        ),

        child: Text(

          text,

          style: TextStyle(

            color:

            selected

                ? Colors.white

                : settings.isDark

                ? Colors.white

                : Colors.black,

            fontWeight:
            FontWeight.w600,
          ),
        ),
      ),
    );
  }
}