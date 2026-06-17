import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_settings.dart';

class SettingsPage extends StatefulWidget {

  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() =>
      _SettingsPageState();
}

class _SettingsPageState
    extends State<SettingsPage> {

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
              /// BACKUP
              //////////////////////////////////////////////////////

              GestureDetector(

                onTap: () {

                  ScaffoldMessenger.of(
                      context)
                      .showSnackBar(

                    SnackBar(

                      content: Text(

                        settings.text(

                          english:
                          "Backup Completed",

                          spanish:
                          "Copia Completada",
                        ),
                      ),
                    ),
                  );
                },

                child: buildTile(

                  settings,

                  Icons.backup,

                  settings.text(

                    english:
                    "Backup & Restore",

                    spanish:
                    "Copia y Restaurar",
                  ),

                  "",
                ),
              ),

              //////////////////////////////////////////////////////
              /// EXPORT DATA
              //////////////////////////////////////////////////////

              GestureDetector(

                onTap: () {

                  ScaffoldMessenger.of(
                      context)
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
                },

                child: buildTile(

                  settings,

                  Icons.upload_file,

                  settings.text(

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

                    builder: (context) {

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

                              Navigator.pop(
                                  context);

                              ScaffoldMessenger.of(
                                  context)
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