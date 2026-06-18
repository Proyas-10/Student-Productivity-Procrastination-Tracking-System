import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app_settings.dart';

class SettingsPage extends StatefulWidget {

  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() =>
      _SettingsPageState();
}

class _SettingsPageState
    extends State<SettingsPage> {

  ////////////////////////////////////////////////////////////
  /// SUPABASE
  ////////////////////////////////////////////////////////////

  final supabase =
      Supabase.instance.client;

  ////////////////////////////////////////////////////////////
  /// EXPORT IN PROGRESS
  ////////////////////////////////////////////////////////////

  bool isExporting = false;

  @override
  Widget build(BuildContext context) {

    final settings =
    Provider.of<AppSettings>(context);

    return Scaffold(

      backgroundColor:
      settings.isDark
          ? const Color(0xFF121212)
          : const Color(0xFFF8F8F8),

      ////////////////////////////////////////////////////////////
      /// BODY
      ////////////////////////////////////////////////////////////

      body: SafeArea(

        child:
        SingleChildScrollView(

          padding:
          const EdgeInsets.all(
              18),

          child: Column(

            crossAxisAlignment:
            CrossAxisAlignment
                .start,

            children: [

              //////////////////////////////////////////////////////
              /// TOP BAR
              //////////////////////////////////////////////////////

              Row(

                children: [

                  GestureDetector(

                    onTap: () {

                      Navigator.pop(
                          context);
                    },

                    child: Icon(

                      Icons.arrow_back,

                      color:
                      settings.isDark
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),

                  const SizedBox(
                      width: 15),

                  Text(

                    settings.text(

                      english:
                      "Settings",

                      spanish:
                      "Configuración",
                    ),

                    style: TextStyle(

                      fontSize: 24,

                      color:
                      settings.isDark
                          ? Colors.white
                          : Colors.black,

                      fontWeight:
                      FontWeight
                          .bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(
                  height: 30),

              //////////////////////////////////////////////////////
              /// PREFERENCES
              //////////////////////////////////////////////////////

              Text(

                settings.text(

                  english:
                  "Preferences",

                  spanish:
                  "Preferencias",
                ),

                style: TextStyle(

                  fontSize: 18,

                  color:
                  settings.isDark
                      ? Colors.white
                      : Colors.black,

                  fontWeight:
                  FontWeight.bold,
                ),
              ),

              const SizedBox(
                  height: 20),

              //////////////////////////////////////////////////////
              /// NOTIFICATION
              //////////////////////////////////////////////////////

              buildSwitchTile(

                settings,

                Icons.notifications_none,

                settings.text(

                  english:
                  "Notifications",

                  spanish:
                  "Notificaciones",
                ),

                settings
                    .notificationsEnabled,

                    (value) {

                  settings.changeNotification(
                      value);

                  ScaffoldMessenger.of(
                      context)
                      .showSnackBar(

                    SnackBar(

                      content: Text(

                        value

                            ? settings.text(

                          english:
                          "Notifications Enabled",

                          spanish:
                          "Notificaciones Activadas",
                        )

                            : settings.text(

                          english:
                          "Notifications Disabled",

                          spanish:
                          "Notificaciones Desactivadas",
                        ),
                      ),
                    ),
                  );
                },
              ),

              //////////////////////////////////////////////////////
              /// FOCUS REMINDER
              //////////////////////////////////////////////////////

              buildSwitchTile(

                settings,

                Icons.timer,

                settings.text(

                  english:
                  "Focus Reminders",

                  spanish:
                  "Recordatorios",
                ),

                settings
                    .focusReminderEnabled,

                    (value) {

                  settings.changeReminder(
                      value);

                  ScaffoldMessenger.of(
                      context)
                      .showSnackBar(

                    SnackBar(

                      content: Text(

                        value

                            ? settings.text(

                          english:
                          "Focus Reminder Enabled",

                          spanish:
                          "Recordatorio Activado",
                        )

                            : settings.text(

                          english:
                          "Focus Reminder Disabled",

                          spanish:
                          "Recordatorio Desactivado",
                        ),
                      ),
                    ),
                  );
                },
              ),

              //////////////////////////////////////////////////////
              /// THEME
              //////////////////////////////////////////////////////

              GestureDetector(

                onTap: () {

                  showModalBottomSheet(

                    context: context,

                    builder: (context) {

                      return Container(

                        padding:
                        const EdgeInsets
                            .all(20),

                        child: Column(

                          mainAxisSize:
                          MainAxisSize
                              .min,

                          children: [

                            Text(

                              settings.text(

                                english:
                                "Choose Theme",

                                spanish:
                                "Elegir Tema",
                              ),

                              style:
                              const TextStyle(

                                fontSize: 20,

                                fontWeight:
                                FontWeight.bold,
                              ),
                            ),

                            const SizedBox(
                                height: 20),

                            ListTile(

                              leading:
                              const Icon(
                                Icons.light_mode,
                              ),

                              title:
                              Text(

                                settings.text(

                                  english:
                                  "Light",

                                  spanish:
                                  "Claro",
                                ),
                              ),

                              onTap: () {

                                settings
                                    .changeTheme(
                                    false);

                                Navigator.pop(
                                    context);
                              },
                            ),

                            ListTile(

                              leading:
                              const Icon(
                                Icons.dark_mode,
                              ),

                              title:
                              Text(

                                settings.text(

                                  english:
                                  "Dark",

                                  spanish:
                                  "Oscuro",
                                ),
                              ),

                              onTap: () {

                                settings
                                    .changeTheme(
                                    true);

                                Navigator.pop(
                                    context);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },

                child: buildTile(

                  settings,

                  Icons.palette_outlined,

                  settings.text(

                    english:
                    "Theme",

                    spanish:
                    "Tema",
                  ),

                  settings.isDark

                      ? settings.text(

                    english:
                    "Dark",

                    spanish:
                    "Oscuro",
                  )

                      : settings.text(

                    english:
                    "Light",

                    spanish:
                    "Claro",
                  ),
                ),
              ),

              //////////////////////////////////////////////////////
              /// LANGUAGE
              //////////////////////////////////////////////////////

              GestureDetector(

                onTap: () {

                  showModalBottomSheet(

                    context: context,

                    builder: (context) {

                      return Container(

                        padding:
                        const EdgeInsets
                            .all(20),

                        child: Column(

                          mainAxisSize:
                          MainAxisSize
                              .min,

                          children: [

                            Text(

                              settings.text(

                                english:
                                "Select Language",

                                spanish:
                                "Seleccionar Idioma",
                              ),

                              style:
                              const TextStyle(

                                fontSize: 20,

                                fontWeight:
                                FontWeight.bold,
                              ),
                            ),

                            const SizedBox(
                                height: 20),

                            languageTile(
                                settings,
                                "English"),

                            languageTile(
                                settings,
                                "Spanish"),
                          ],
                        ),
                      );
                    },
                  );
                },

                child: buildTile(

                  settings,

                  Icons.language,

                  settings.text(

                    english:
                    "Language",

                    spanish:
                    "Idioma",
                  ),

                  settings.language,
                ),
              ),

              const SizedBox(
                  height: 30),

              //////////////////////////////////////////////////////
              /// DATA & PRIVACY
              //////////////////////////////////////////////////////

              Text(

                settings.text(

                  english:
                  "Data & Privacy",

                  spanish:
                  "Datos y Privacidad",
                ),

                style: TextStyle(

                  fontSize: 18,

                  color:
                  settings.isDark
                      ? Colors.white
                      : Colors.black,

                  fontWeight:
                  FontWeight.bold,
                ),
              ),

              const SizedBox(
                  height: 20),

              //////////////////////////////////////////////////////
              /// EXPORT DATA
              //////////////////////////////////////////////////////

              GestureDetector(

                onTap: () {

                  exportMyData(
                      context, settings);
                },

                child: buildTile(

                  settings,

                  Icons.upload_file,

                  isExporting
                      ? settings.text(
                    english:
                    "Exporting...",

                    spanish:
                    "Exportando...",
                  )
                      : settings.text(

                    english:
                    "Export My Data",

                    spanish:
                    "Exportar Datos",
                  ),

                  "",
                ),
              ),

              //////////////////////////////////////////////////////
              /// CLEAR DATA
              //////////////////////////////////////////////////////

              GestureDetector(

                onTap: () {

                  showDialog(

                    context: context,

                    builder: (dialogContext) {

                      return AlertDialog(

                        title:
                        Text(

                          settings.text(

                            english:
                            "Clear Data",

                            spanish:
                            "Borrar Datos",
                          ),
                        ),

                        content:
                        Text(

                          settings.text(

                            english:
                            "Are you sure you want to clear all data?",

                            spanish:
                            "¿Seguro que deseas borrar todos los datos?",
                          ),
                        ),

                        actions: [

                          TextButton(

                            onPressed: () {

                              Navigator.pop(
                                  dialogContext);
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

                            style:
                            ElevatedButton
                                .styleFrom(
                              backgroundColor:
                              Colors.red,
                            ),

                            onPressed: () async {

                              Navigator.pop(
                                  dialogContext);

                              await clearAllData(
                                  context, settings);
                            },

                            child:
                            Text(

                              settings.text(

                                english:
                                "Clear",

                                spanish:
                                "Borrar",
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },

                child: buildTile(

                  settings,

                  Icons.delete_outline,

                  settings.text(

                    english:
                    "Clear All Data",

                    spanish:
                    "Borrar Datos",
                  ),

                  "",
                ),
              ),

              const SizedBox(
                  height: 30),

              //////////////////////////////////////////////////////
              /// ABOUT
              //////////////////////////////////////////////////////

              Text(

                settings.text(

                  english:
                  "About",

                  spanish:
                  "Acerca de",
                ),

                style: TextStyle(

                  fontSize: 18,

                  color:
                  settings.isDark
                      ? Colors.white
                      : Colors.black,

                  fontWeight:
                  FontWeight.bold,
                ),
              ),

              const SizedBox(
                  height: 20),

              Container(

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
                      18),
                ),

                child: Row(

                  mainAxisAlignment:
                  MainAxisAlignment
                      .spaceBetween,

                  children: [

                    Text(

                      "Focuslytics",

                      style: TextStyle(

                        color:
                        settings.isDark
                            ? Colors.white
                            : Colors.black,

                        fontWeight:
                        FontWeight.w600,
                      ),
                    ),

                    const Text(

                      "Version 1.0.0",

                      style: TextStyle(
                        color:
                        Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(
                  height: 40),
            ],
          ),
        ),
      ),
    );
  }

  ////////////////////////////////////////////////////////////
  /// CSV HELPER
  ////////////////////////////////////////////////////////////
  ///
  /// Wraps a value in double quotes and escapes any internal
  /// quotes, so commas/newlines/quotes inside fields can't
  /// break the CSV structure.

  String csvField(dynamic value) {

    final stringValue =
        value?.toString() ?? "";

    final escaped =
    stringValue.replaceAll(
        '"', '""');

    return '"$escaped"';
  }

  ////////////////////////////////////////////////////////////
  /// BUILD CSV FROM ROWS
  ////////////////////////////////////////////////////////////

  String buildCsv(

      String title,

      List<String> columns,

      List<Map<String, dynamic>> rows,

      ) {

    final buffer =
    StringBuffer();

    buffer.writeln(title);

    buffer.writeln(
        columns.map(csvField).join(','));

    for (final row in rows) {

      buffer.writeln(
        columns
            .map((column) =>
            csvField(row[column]))
            .join(','),
      );
    }

    buffer.writeln();

    return buffer.toString();
  }

  ////////////////////////////////////////////////////////////
  /// EXPORT MY DATA
  ////////////////////////////////////////////////////////////
  ///
  /// Pulls the current user's tasks, delay logs, and focus
  /// sessions from Supabase, combines them into one CSV file,
  /// and opens the share sheet so the user can save/send it.

  Future<void> exportMyData(

      BuildContext context,

      AppSettings settings,

      ) async {

    final user =
        supabase.auth.currentUser;

    if (user == null) return;

    setState(() {

      isExporting = true;
    });

    try {

      ////////////////////////////////////////////////////////////
      /// FETCH USER DATA
      ////////////////////////////////////////////////////////////

      final tasks =
      List<Map<String, dynamic>>.from(
        await supabase
            .from('tasks')
            .select()
            .eq('user_id', user.id)
            .order('created_at',
            ascending: false),
      );

      final delayLogs =
      List<Map<String, dynamic>>.from(
        await supabase
            .from('delay_logs')
            .select()
            .eq('user_id', user.id)
            .order('created_at',
            ascending: false),
      );

      final focusSessions =
      List<Map<String, dynamic>>.from(
        await supabase
            .from('focus_sessions')
            .select()
            .eq('user_id', user.id)
            .order('created_at',
            ascending: false),
      );

      ////////////////////////////////////////////////////////////
      /// BUILD CSV CONTENT
      ////////////////////////////////////////////////////////////

      final csvBuffer =
      StringBuffer();

      csvBuffer.write(
        buildCsv(
          'TASKS',
          [
            'id',
            'title',
            'start_time',
            'end_time',
            'completed',
            'created_at',
          ],
          tasks,
        ),
      );

      csvBuffer.write(
        buildCsv(
          'DELAY LOGS',
          [
            'id',
            'reason',
            'duration_minutes',
            'note',
            'created_at',
          ],
          delayLogs,
        ),
      );

      csvBuffer.write(
        buildCsv(
          'FOCUS SESSIONS',
          [
            'id',
            'duration',
            'note',
            'created_at',
          ],
          focusSessions,
        ),
      );

      ////////////////////////////////////////////////////////////
      /// WRITE TO FILE
      ////////////////////////////////////////////////////////////

      final directory =
      await getTemporaryDirectory();

      final timestamp =
      DateTime.now()
          .millisecondsSinceEpoch;

      final file = File(
          '${directory.path}/my_data_$timestamp.csv');

      await file.writeAsString(
          csvBuffer.toString());

      ////////////////////////////////////////////////////////////
      /// SHARE FILE
      ////////////////////////////////////////////////////////////

      if (!context.mounted) return;

      await Share.shareXFiles(
        [XFile(file.path)],
        text: settings.text(
          english:
          "Here is my exported data",
          spanish:
          "Aquí están mis datos exportados",
        ),
      );

      if (!context.mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(

          content: Text(

            settings.text(

              english:
              "Data Exported Successfully",

              spanish:
              "Datos Exportados",
            ),
          ),
        ),
      );
    }

    catch (error) {

      if (!context.mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(

          content: Text(

            settings.text(

              english:
              "Export failed. Please try again.",

              spanish:
              "Error al exportar. Inténtalo de nuevo.",
            ),
          ),
        ),
      );
    }

    finally {

      if (context.mounted) {

        setState(() {

          isExporting = false;
        });
      }
    }
  }

  ////////////////////////////////////////////////////////////
  /// CLEAR ALL DATA
  ////////////////////////////////////////////////////////////
  ///
  /// Permanently deletes the current user's tasks, delay logs,
  /// and focus sessions from Supabase. The user's account and
  /// profile (`users` table) are left untouched.

  Future<void> clearAllData(

      BuildContext context,

      AppSettings settings,

      ) async {

    final user =
        supabase.auth.currentUser;

    if (user == null) return;

    try {

      await supabase
          .from('tasks')
          .delete()
          .eq('user_id', user.id);

      await supabase
          .from('delay_logs')
          .delete()
          .eq('user_id', user.id);

      await supabase
          .from('focus_sessions')
          .delete()
          .eq('user_id', user.id);

      if (!context.mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(

          content: Text(

            settings.text(

              english:
              "All Data Cleared",

              spanish:
              "Datos Eliminados",
            ),
          ),
        ),
      );
    }

    catch (error) {

      if (!context.mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(

          content: Text(

            settings.text(

              english:
              "Failed to clear data. Please try again.",

              spanish:
              "No se pudieron borrar los datos. Inténtalo de nuevo.",
            ),
          ),
        ),
      );
    }
  }

  ////////////////////////////////////////////////////////////
  /// NORMAL TILE
  ////////////////////////////////////////////////////////////

  Widget buildTile(

      AppSettings settings,

      IconData icon,

      String text,

      String trailing,
      ) {

    return Container(

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
            18),
      ),

      child: Row(

        children: [

          Icon(

            icon,

            color:
            Colors.deepPurple,
          ),

          const SizedBox(
              width: 15),

          Expanded(

            child: Text(

              text,

              style: TextStyle(

                color:
                settings.isDark
                    ? Colors.white
                    : Colors.black,

                fontWeight:
                FontWeight.w600,
              ),
            ),
          ),

          Text(

            trailing,

            style:
            const TextStyle(
              color:
              Colors.grey,
            ),
          ),

          const SizedBox(
              width: 10),

          const Icon(

            Icons.arrow_forward_ios,

            size: 16,
          ),
        ],
      ),
    );
  }

  ////////////////////////////////////////////////////////////
  /// SWITCH TILE
  ////////////////////////////////////////////////////////////

  Widget buildSwitchTile(

      AppSettings settings,

      IconData icon,

      String text,

      bool value,

      Function(bool) onChanged,
      ) {

    return Container(

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
            18),
      ),

      child: Row(

        children: [

          Icon(

            icon,

            color:
            Colors.deepPurple,
          ),

          const SizedBox(
              width: 15),

          Expanded(

            child: Text(

              text,

              style: TextStyle(

                color:
                settings.isDark
                    ? Colors.white
                    : Colors.black,

                fontWeight:
                FontWeight.w600,
              ),
            ),
          ),

          Switch(

            value: value,

            activeColor:
            Colors.deepPurple,

            onChanged:
            onChanged,
          ),
        ],
      ),
    );
  }

  ////////////////////////////////////////////////////////////
  /// LANGUAGE TILE
  ////////////////////////////////////////////////////////////

  Widget languageTile(

      AppSettings settings,

      String language,
      ) {

    return ListTile(

      title: Text(language),

      trailing:

      settings.language ==
          language

          ? const Icon(

        Icons.check,

        color:
        Colors.deepPurple,
      )

          : null,

      onTap: () {

        settings.changeLanguage(
            language);

        Navigator.pop(
            context);
      },
    );
  }
}