import 'package:flutter/material.dart';
import 'package:flutter_application_1/analytics_page.dart';
import 'package:flutter_application_1/app_settings.dart';
import 'package:flutter_application_1/home_page.dart';
import 'package:flutter_application_1/profile_page.dart';
import 'package:flutter_application_1/settings_page.dart';
import 'package:flutter_application_1/timer_page.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TasksPage extends StatefulWidget {

  const TasksPage({super.key});

  @override
  State<TasksPage> createState() =>
      _TasksPageState();
}

class _TasksPageState
    extends State<TasksPage> {

  ////////////////////////////////////////////////////////////
  /// SUPABASE
  ////////////////////////////////////////////////////////////

  final supabase =
      Supabase.instance.client;

  ////////////////////////////////////////////////////////////
  /// TASKS
  ////////////////////////////////////////////////////////////

  List<Map<String, dynamic>>
      tasks = [];

  ////////////////////////////////////////////////////////////
  /// SELECTED TAB
  ////////////////////////////////////////////////////////////

  String selectedTab =
      "All Tasks";

  ////////////////////////////////////////////////////////////
  /// LOAD TASKS
  ////////////////////////////////////////////////////////////

  Future<void> loadTasks() async {

    ////////////////////////////////////////////////////////////
    /// CURRENT USER
    ////////////////////////////////////////////////////////////

    final user =
        supabase.auth.currentUser;

    if (user == null) return;

    ////////////////////////////////////////////////////////////
    /// LOAD USER TASKS
    ////////////////////////////////////////////////////////////

    final data =
    await supabase
        .from('tasks')
        .select()
        .eq('user_id', user.id)
        .order(
      'created_at',
      ascending: false,
    );

    setState(() {

      tasks =
          List<Map<String, dynamic>>
              .from(data);
    });
  }

  ////////////////////////////////////////////////////////////
  /// ADD TASK
  ////////////////////////////////////////////////////////////

  Future<void> addTask(

      String title,

      String startTime,

      String endTime,

      ) async {

    final user =
        supabase.auth.currentUser;

    if (user == null) return;

    await supabase
        .from('tasks')
        .insert({

      'user_id': user.id,

      'title': title,

      'start_time': startTime,

      'end_time': endTime,

      'completed': false,
    });

    loadTasks();
  }

  ////////////////////////////////////////////////////////////
  /// COMPLETE TASK
  ////////////////////////////////////////////////////////////

  Future<void> completeTask(

      String id,
      bool value,
      ) async {

    await supabase
        .from('tasks')
        .update({

      'completed': value,
    }).eq('id', id);

    loadTasks();
  }

  ////////////////////////////////////////////////////////////
  /// EDIT TASK
  ////////////////////////////////////////////////////////////

  Future<void> editTask(

      String id,

      String title,

      String startTime,

      String endTime,

      ) async {

    await supabase
        .from('tasks')
        .update({

      'title': title,

      'start_time': startTime,

      'end_time': endTime,
    })

        .eq('id', id);

    loadTasks();
  }

  ////////////////////////////////////////////////////////////
  /// DELETE TASK
  ////////////////////////////////////////////////////////////

  Future<void> deleteTask(
      String id,
      ) async {

    await supabase
        .from('tasks')
        .delete()
        .eq('id', id);

    loadTasks();
  }

  ////////////////////////////////////////////////////////////
  /// INIT
  ////////////////////////////////////////////////////////////

  @override
  void initState() {

    super.initState();

    loadTasks();
  }

  ////////////////////////////////////////////////////////////
  /// ADD TASK DIALOG
  ////////////////////////////////////////////////////////////

  void showAddTaskDialog() {

    TextEditingController
    titleController =
    TextEditingController();

    TextEditingController
    startController =
    TextEditingController();

    TextEditingController
    endController =
    TextEditingController();

    showDialog(

      context: context,

      builder: (context) {

        return AlertDialog(

          shape: RoundedRectangleBorder(

            borderRadius:
            BorderRadius.circular(
                22),
          ),

          title:
          const Text(
            "Add Task",
          ),

          content:
          SingleChildScrollView(

            child: Column(

              mainAxisSize:
              MainAxisSize.min,

              children: [

                TextField(

                  controller:
                  titleController,

                  decoration:
                  const InputDecoration(

                    labelText:
                    "Task Name",
                  ),
                ),

                const SizedBox(
                    height: 15),

                TextField(

                  controller:
                  startController,

                  decoration:
                  const InputDecoration(

                    labelText:
                    "Start Time",
                  ),
                ),

                const SizedBox(
                    height: 15),

                TextField(

                  controller:
                  endController,

                  decoration:
                  const InputDecoration(

                    labelText:
                    "End Time",
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
              const Text(
                  "Cancel"),
            ),

            ElevatedButton(

              style:
              ElevatedButton.styleFrom(

                backgroundColor:
                const Color.fromARGB(255, 168, 136, 224),

                shape:
                RoundedRectangleBorder(

                  borderRadius:
                  BorderRadius.circular(
                      14),
                ),
              ),

              onPressed: () async {

                await addTask(

                  titleController.text,

                  startController.text,

                  endController.text,
                );

                Navigator.pop(
                    context);
              },

              child:
              const Text(
                  "Add"),
            ),
          ],
        );
      },
    );
  }

  ////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {

    final settings =
    Provider.of<AppSettings>(context);

    ////////////////////////////////////////////////////////////
    /// COMPLETED TASKS
    ////////////////////////////////////////////////////////////

    List<Map<String, dynamic>>
    completedTasks =
    tasks.where(

          (task) =>
      task['completed'] ==
          true,
    ).toList();

    ////////////////////////////////////////////////////////////

    return Scaffold(

      backgroundColor:

      settings.isDark

          ? const Color(0xFF121212)

          : const Color(0xFFF8F8F8),

      ////////////////////////////////////////////////////////////
      /// FLOATING BUTTON
      ////////////////////////////////////////////////////////////

      floatingActionButton:
      FloatingActionButton.extended(

        elevation: 8,

        backgroundColor:
        const Color.fromARGB(255, 170, 151, 201),

        onPressed: () {

          showAddTaskDialog();
        },

        label: Text(

          settings.text(

            english:
            "Add Task",

            spanish:
            "Agregar Tarea",
          ),
        ),

        icon:
        const Icon(Icons.add),
      ),

      ////////////////////////////////////////////////////////////
      /// BOTTOM NAVIGATION
      ////////////////////////////////////////////////////////////

      bottomNavigationBar:
      BottomNavigationBar(

        currentIndex: 2,

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

            label:

            settings.text(

              english:
              "Home",

              spanish:
              "Inicio",
            ),
          ),

          BottomNavigationBarItem(

            icon:
            const Icon(Icons.timer),

            label:

            settings.text(

              english:
              "Timer",

              spanish:
              "Temporizador",
            ),
          ),

          BottomNavigationBarItem(

            icon:
            const Icon(Icons.task_alt),

            label:

            settings.text(

              english:
              "Tasks",

              spanish:
              "Tareas",
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

      ////////////////////////////////////////////////////////////
      /// BODY
      ////////////////////////////////////////////////////////////

      body: SafeArea(

        child: Padding(

          padding:
          const EdgeInsets.all(20),

          child: Column(

            crossAxisAlignment:
            CrossAxisAlignment
                .start,

            children: [

              //////////////////////////////////////////////////////
              /// TOP BAR
              //////////////////////////////////////////////////////

              Row(

                mainAxisAlignment:
                MainAxisAlignment
                    .spaceBetween,

                children: [

                  const SizedBox(
                    width: 24,
                  ),

                  Text(

                    settings.text(

                      english:
                      "Tasks",

                      spanish:
                      "Tareas",
                    ),

                    style: TextStyle(

                      fontSize: 28,

                      letterSpacing: 0.5,

                      color:

                      settings.isDark

                          ? Colors.white

                          : Colors.black,

                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),

                  GestureDetector(

                    onTap: () {

                      Navigator.push(

                        context,

                        MaterialPageRoute(

                          builder: (context) =>
                          const SettingsPage(),
                        ),
                      );
                    },

                    child: Container(

                      padding:
                      const EdgeInsets.all(
                          10),

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

                      child: Icon(

                        Icons.settings,

                        color:

                        settings.isDark

                            ? Colors.white

                            : Colors.black,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              //////////////////////////////////////////////////////
              /// TABS
              //////////////////////////////////////////////////////

              SingleChildScrollView(

                scrollDirection:
                Axis.horizontal,

                child: Row(

                  children: [

                    buildTab(
                      settings,
                      "All Tasks",
                    ),

                    const SizedBox(width: 10),

                    buildTab(
                      settings,
                      "Completed",
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              //////////////////////////////////////////////////////
              /// PROGRESS
              //////////////////////////////////////////////////////

              Container(

                padding:
                const EdgeInsets.all(22),

                decoration: BoxDecoration(

                  gradient:

                  settings.isDark

                      ? LinearGradient(

                    colors: [

                      Colors.grey.shade900,

                      Colors.grey.shade800,
                    ],
                  )

                      : const LinearGradient(

                    colors: [

                      Color(0xFF6C63FF),

                      Color(0xFFD946EF),
                    ],
                  ),

                  borderRadius:
                  BorderRadius.circular(
                      24),

                  boxShadow: [

                    BoxShadow(

                      color:
                      Colors.deepPurple
                          .withOpacity(0.15),

                      blurRadius: 18,

                      offset:
                      const Offset(0, 8),
                    ),
                  ],
                ),

                child: Column(

                  crossAxisAlignment:
                  CrossAxisAlignment.start,

                  children: [

                    Row(

                      children: [

                        Container(

                          padding:
                          const EdgeInsets.all(
                              10),

                          decoration:
                          BoxDecoration(

                            color:
                            Colors.white
                                .withOpacity(
                                0.15),

                            borderRadius:
                            BorderRadius.circular(
                                14),
                          ),

                          child: const Icon(

                            Icons.analytics_outlined,

                            color:
                            Colors.white,
                          ),
                        ),

                        const SizedBox(
                            width: 12),

                        Text(

                          settings.text(

                            english:
                            "Progress",

                            spanish:
                            "Progreso",
                          ),

                          style:
                          const TextStyle(

                            color:
                            Colors.white,

                            fontSize: 18,

                            fontWeight:
                            FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 22),

                    Text(

                      "${completedTasks.length} / ${tasks.length}",

                      style:
                      const TextStyle(

                        fontSize: 38,

                        color:
                        Colors.white,

                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 4),

                    const Text(

                      "Tasks Completed",

                      style: TextStyle(

                        color:
                        Colors.white70,
                      ),
                    ),

                    const SizedBox(height: 18),

                    ClipRRect(

                      borderRadius:
                      BorderRadius.circular(
                          20),

                      child:
                      LinearProgressIndicator(

                        minHeight: 10,

                        value:

                        tasks.isEmpty

                            ? 0

                            : completedTasks
                            .length /
                            tasks.length,

                        backgroundColor:
                        Colors.white24,

                        color:
                        Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              //////////////////////////////////////////////////////
              /// TASK TITLE
              //////////////////////////////////////////////////////

              Text(

                selectedTab,

                style: TextStyle(

                  fontSize: 22,

                  color:

                  settings.isDark

                      ? Colors.white

                      : Colors.black,

                  fontWeight:
                  FontWeight.bold,
                ),
              ),

              const SizedBox(height: 18),

              //////////////////////////////////////////////////////
              /// TASK LIST
              //////////////////////////////////////////////////////

              Expanded(

                child: ListView.builder(

                  physics:
                  const BouncingScrollPhysics(),

                  itemCount:

                  selectedTab ==
                      "Completed"

                      ? completedTasks.length

                      : tasks.isEmpty
                      ? 1
                      : tasks.length,

                  itemBuilder:
                      (context, index) {

                    //////////////////////////////////////////////////////////
                    /// NO TASK
                    //////////////////////////////////////////////////////////

                    if (selectedTab ==
                        "All Tasks" &&

                        tasks.isEmpty) {

                      return Container(

                        margin:
                        const EdgeInsets.only(
                            top: 30),

                        padding:
                        const EdgeInsets.all(
                            24),

                        decoration:
                        BoxDecoration(

                          color:

                          settings.isDark

                              ? Colors.grey.shade900

                              : Colors.white,

                          borderRadius:
                          BorderRadius.circular(
                              22),
                        ),

                        child: Column(

                          children: [

                            Icon(

                              Icons.task_alt,

                              size: 60,

                              color:
                              Colors.grey.shade400,
                            ),

                            const SizedBox(height: 16),

                            Text(

                              "No task yet",

                              style: TextStyle(

                                fontSize: 18,

                                fontWeight:
                                FontWeight.bold,

                                color:

                                settings.isDark

                                    ? Colors.white

                                    : Colors.black,
                              ),
                            ),

                            const SizedBox(height: 6),

                            Text(

                              "Add your first task",

                              style: TextStyle(

                                color:
                                Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    //////////////////////////////////////////////////////////
                    /// TASK FILTER
                    //////////////////////////////////////////////////////////

                    final task =

                    selectedTab ==
                        "Completed"

                        ? completedTasks[index]

                        : tasks[index];

                    return TaskTile(

                      settings:
                      settings,

                      title:
                      task['title'],

                      subtitle:
                      "${task['start_time']} - ${task['end_time']}",

                      completed:
                      task['completed'],

                      onChanged:
                          (value) {

                        completeTask(

                          task['id'],

                          value!,
                        );
                      },

                      onEdit: () {

                        TextEditingController
                        titleController =

                        TextEditingController(

                          text:
                          task['title'],
                        );

                        TextEditingController
                        startController =

                        TextEditingController(

                          text:
                          task['start_time'],
                        );

                        TextEditingController
                        endController =

                        TextEditingController(

                          text:
                          task['end_time'],
                        );

                        showDialog(

                          context: context,

                          builder: (context) {

                            return AlertDialog(

                              shape:
                              RoundedRectangleBorder(

                                borderRadius:
                                BorderRadius.circular(
                                    22),
                              ),

                              title:
                              const Text(
                                "Edit Task",
                              ),

                              content:
                              SingleChildScrollView(

                                child: Column(

                                  mainAxisSize:
                                  MainAxisSize.min,

                                  children: [

                                    TextField(

                                      controller:
                                      titleController,

                                      decoration:
                                      const InputDecoration(

                                        labelText:
                                        "Task Name",
                                      ),
                                    ),

                                    const SizedBox(
                                        height: 15),

                                    TextField(

                                      controller:
                                      startController,

                                      decoration:
                                      const InputDecoration(

                                        labelText:
                                        "Start Time",
                                      ),
                                    ),

                                    const SizedBox(
                                        height: 15),

                                    TextField(

                                      controller:
                                      endController,

                                      decoration:
                                      const InputDecoration(

                                        labelText:
                                        "End Time",
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
                                  const Text(
                                      "Cancel"),
                                ),

                                ElevatedButton(

                                  style:
                                  ElevatedButton.styleFrom(

                                    backgroundColor:
                                    Colors.deepPurple,

                                    shape:
                                    RoundedRectangleBorder(

                                      borderRadius:
                                      BorderRadius.circular(
                                          14),
                                    ),
                                  ),

                                  onPressed: () async {

                                    await editTask(

                                      task['id'],

                                      titleController.text,

                                      startController.text,

                                      endController.text,
                                    );

                                    Navigator.pop(
                                        context);
                                  },

                                  child:
                                  const Text(
                                      "Save"),
                                ),
                              ],
                            );
                          },
                        );
                      },

                      onDelete: () {

                        showDialog(

                          context: context,

                          builder: (context) {

                            return AlertDialog(

                              shape:
                              RoundedRectangleBorder(

                                borderRadius:
                                BorderRadius.circular(
                                    22),
                              ),

                              title:
                              const Text(
                                "Delete Task",
                              ),

                              content:
                              const Text(
                                "Are you sure you want to delete this task?",
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

                                  style:
                                  ElevatedButton.styleFrom(

                                    backgroundColor:
                                    Colors.red,

                                    shape:
                                    RoundedRectangleBorder(

                                      borderRadius:
                                      BorderRadius.circular(
                                          14),
                                    ),
                                  ),

                                  onPressed: () async {

                                    await deleteTask(
                                        task['id']);

                                    Navigator.pop(
                                        context);
                                  },

                                  child:
                                  const Text(
                                      "Delete"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ////////////////////////////////////////////////////////////
  /// TAB
  ////////////////////////////////////////////////////////////

  Widget buildTab(

      AppSettings settings,

      String text,
      ) {

    bool selected =
        selectedTab == text;

    return GestureDetector(

      onTap: () {

        setState(() {

          selectedTab = text;
        });
      },

      child: AnimatedContainer(

        duration:
        const Duration(
            milliseconds: 250),

        padding:
        const EdgeInsets.symmetric(

          horizontal: 18,

          vertical: 10,
        ),

        decoration: BoxDecoration(

          color:

          selected

              ? Colors.deepPurple

              : Colors.transparent,

          borderRadius:
          BorderRadius.circular(
              18),
        ),

        child: Text(

          text,

          style: TextStyle(

            color:

            selected

                ? Colors.white

                : Colors.grey,

            fontWeight:

            selected

                ? FontWeight.bold

                : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class TaskTile extends StatelessWidget {

  final AppSettings settings;

  final String title;

  final String subtitle;

  final bool completed;

  final Function(bool?)
  onChanged;

  final VoidCallback onEdit;

  final VoidCallback onDelete;

  const TaskTile({

    super.key,

    required this.settings,

    required this.title,

    required this.subtitle,

    required this.completed,

    required this.onChanged,

    required this.onEdit,

    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {

    return Container(

      margin:
      const EdgeInsets.only(
          bottom: 16),

      padding:
      const EdgeInsets.all(18),

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

        children: [

          Checkbox(

            value: completed,

            activeColor:
            Colors.deepPurple,

            onChanged:
            onChanged,
          ),

          Expanded(

            child: Column(

              crossAxisAlignment:
              CrossAxisAlignment
                  .start,

              children: [

                Text(

                  title,

                  style: TextStyle(

                    color:

                    settings.isDark

                        ? Colors.white

                        : Colors.black,

                    fontWeight:
                    FontWeight.bold,

                    fontSize: 16,
                  ),
                ),

                const SizedBox(
                    height: 6),

                Text(

                  subtitle,

                  style:
                  const TextStyle(

                    color:
                    Colors.grey,

                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          PopupMenuButton(

            icon: const Icon(
              Icons.more_vert,
            ),

            itemBuilder: (context) => [

              const PopupMenuItem(

                value: "edit",

                child: Text("Edit"),
              ),

              const PopupMenuItem(

                value: "delete",

                child: Text("Delete"),
              ),
            ],

            onSelected: (value) {

              if (value == "edit") {

                onEdit();
              }

              if (value == "delete") {

                onDelete();
              }
            },
          ),
        ],
      ),
    );
  }
}