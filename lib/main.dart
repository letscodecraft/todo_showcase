import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:todo_with_showcase/controller/showcase_controller.dart';
import 'package:todo_with_showcase/core/routes.dart';
import 'package:todo_with_showcase/views/task_create_page.dart';
import 'package:todo_with_showcase/views/task_listing_page.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'controller/task_controller.dart';
import 'models/task.dart';

main() async {
  /// Initial Hive DB
  await Hive.initFlutter();

  /// Register Hive Adapter
  Hive.registerAdapter<Task>(TaskAdapter());

  await Hive.openBox<Task>('tasks');

  runApp(TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => TaskController(Hive.box('tasks')),
        ),
        ChangeNotifierProvider(
          create: (_) => ShowcaseController(),
        ),
      ],
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: ShowCaseWidget(
          builder: Builder(builder: (context) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              initialRoute: Routes.taskList,
              routes: {
                Routes.taskList: (context) => TaskListingPage(),
                Routes.addTask: (context) => TaskCreatePage(),
              },
            );
          }),
        ),
      ),
    );
  }
}
