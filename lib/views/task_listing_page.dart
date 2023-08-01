import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:todo_with_showcase/core/routes.dart';
import '../controller/task_controller.dart';
import 'package:showcaseview/showcaseview.dart';

const kShowCaseTextStyle = const TextStyle(
    fontWeight: FontWeight.w500, color: Colors.deepPurpleAccent, fontSize: 16);

class TaskListingPage extends StatefulWidget {
  const TaskListingPage({Key? key}) : super(key: key);

  @override
  State<TaskListingPage> createState() => _TaskListingPageState();
}

class _TaskListingPageState extends State<TaskListingPage> {
  GlobalKey<SliderDrawerState> drawerKey = GlobalKey<SliderDrawerState>();
  final _key1 = GlobalKey();
  final _key2 = GlobalKey();
  final _key3 = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => ShowCaseWidget.of(context).startShowCase([_key1, _key2, _key3]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FAB(
          showcaseKey: _key1,
          showcaseDeleteKey: _key2,
          showcaseMenuKey: _key3,
        ),
        body: SliderDrawer(
          isDraggable: false,
          key: drawerKey,
          animationDuration: 500,
          appBar: MyAppBar(
            showcaseKey2: _key3,
            showcaseKey: _key2,
            drawerKey: drawerKey,
            // key: drawerKey,
          ),
          slider: HomeDrawer(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child:
                Consumer<TaskController>(builder: (context, taskController, _) {
              return taskController.tasks.isNotEmpty
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Your Tasks",
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600),
                        ),
                        Expanded(
                          child: ListView.separated(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            itemBuilder: (context, index) {
                              final task = taskController.tasks[index];
                              return Dismissible(
                                direction: DismissDirection.horizontal,
                                background: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.delete_outline,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Text("Remove",
                                        style: TextStyle(
                                          color: Colors.grey,
                                        ))
                                  ],
                                ),
                                onDismissed: (direction) {
                                  taskController.delete(index);
                                },
                                key: Key(index.toString()),
                                child: Container(
                                  width: double.maxFinite,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 20),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: const Color(0xffffd2d7),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(task.title,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headlineSmall
                                                    ?.copyWith(
                                                        decoration:
                                                            task.isCompleted
                                                                ? TextDecoration
                                                                    .lineThrough
                                                                : null)),
                                            SizedBox(height: 10),
                                            Text(
                                              task.notes,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Checkbox(
                                        value: task.isCompleted,
                                        onChanged: (value) async {
                                          await taskController.toggleComplete(
                                              index, task);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return const SizedBox(height: 10);
                            },
                            itemCount:
                                context.read<TaskController>().tasks.length,
                          ),
                        ),
                      ],
                    )
                  : Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Lottie.asset('assets/lottie/1.json', width: 200),
                          FadeInUp(
                            from: 30,
                            child: const Text("You Have Done All Tasks!👌"),
                          ),
                        ],
                      ),
                    );
            }),
          ),
        ));
  }
}

class FAB extends StatefulWidget {
  final GlobalKey showcaseKey;
  final GlobalKey showcaseDeleteKey;
  final GlobalKey showcaseMenuKey;

  const FAB(
      {Key? key,
      required this.showcaseKey,
      required this.showcaseDeleteKey,
      required this.showcaseMenuKey})
      : super(key: key);

  @override
  State<FAB> createState() => _FABState();
}

class _FABState extends State<FAB> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, Routes.addTask);
      },
      child: Showcase(
        key: widget.showcaseKey,
        description: "Click to create a task",
        descTextStyle: kShowCaseTextStyle,
        disposeOnTap: true,
        onTargetClick: () {
          Navigator.of(context).pushNamed(Routes.addTask).then((value) {
            ShowCaseWidget.of(context).startShowCase(
                [widget.showcaseDeleteKey, widget.showcaseMenuKey]);
          });
        },
        child: Material(
          color: Colors.deepPurpleAccent,
          borderRadius: BorderRadius.circular(15),
          elevation: 10,
          child: Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Center(
                child: Icon(
              Icons.add,
              color: Colors.white,
            )),
          ),
        ),
      ),
    );
  }
}

class HomeDrawer extends StatelessWidget {
  HomeDrawer({
    Key? key,
  }) : super(key: key);

  /// Icons
  List<IconData> icons = [
    CupertinoIcons.home,
    CupertinoIcons.person_fill,
    CupertinoIcons.settings,
    CupertinoIcons.info_circle_fill,
  ];

  /// Texts
  List<String> texts = [
    "Home",
    "Profile",
    "Settings",
    "Details",
  ];

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return Container(
      height: double.maxFinite,
      padding: const EdgeInsets.symmetric(vertical: 90),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.deepPurpleAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircleAvatar(
              radius: 45,
              backgroundImage: AssetImage('assets/img/logo-color 4 blue.jpg'),
            ),
            const SizedBox(
              height: 8,
            ),
            Text("CodeCraft", style: textTheme.headlineMedium),
            Text("Flutter Developer", style: textTheme.headlineSmall),
            Container(
              margin: const EdgeInsets.symmetric(
                vertical: 0,
                horizontal: 10,
              ),
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: icons.length,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (ctx, i) {
                    return InkWell(
                      // ignore: avoid_print
                      onTap: () => print("$i Selected"),
                      child: Container(
                        margin: const EdgeInsets.all(5),
                        child: ListTile(
                            leading: Icon(
                              icons[i],
                              color: Colors.white,
                              size: 30,
                            ),
                            title: Text(
                              texts[i],
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            )),
                      ),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}

class MyAppBar extends StatefulWidget implements PreferredSizeWidget {
  MyAppBar({
    Key? key,
    required this.showcaseKey,
    required this.showcaseKey2,
    required this.drawerKey,
  }) : super(key: key);
  GlobalKey<SliderDrawerState> drawerKey;

  final GlobalKey showcaseKey;
  final GlobalKey showcaseKey2;

  @override
  State<MyAppBar> createState() => _MyAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(100);
}

class _MyAppBarState extends State<MyAppBar>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  bool isDrawerOpen = false;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void toggle() {
    setState(() {
      isDrawerOpen = !isDrawerOpen;
      if (isDrawerOpen) {
        controller.forward();
        widget.drawerKey.currentState!.openSlider();
      } else {
        controller.reverse();
        widget.drawerKey.currentState!.closeSlider();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 132,
      child: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Showcase(
                key: widget.showcaseKey2,
                description: 'Open drawer to explore other menus',
                descTextStyle: kShowCaseTextStyle,
                child: IconButton(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    icon: AnimatedIcon(
                      icon: AnimatedIcons.menu_close,
                      progress: controller,
                      size: 30,
                    ),
                    onPressed: toggle),
              ),
            ),

            /// Delete Icon
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: GestureDetector(
                onTap: () async {
                  PanaraConfirmDialog.show(
                    context,
                    title: "Are you sure?",
                    message:
                        "Do You really want to delete all tasks? You will no be able to undo this action!",
                    confirmButtonText: "Yes",
                    cancelButtonText: "No",
                    onTapCancel: () {
                      Navigator.pop(context);
                    },
                    onTapConfirm: () {
                      context.read<TaskController>().deleteAll();
                      Navigator.pop(context);
                    },
                    panaraDialogType: PanaraDialogType.error,
                    barrierDismissible: false,
                  );
                },
                child: Showcase(
                  description: "Click to delete all tasks",
                  key: widget.showcaseKey,
                  descTextStyle: kShowCaseTextStyle,
                  child: const Icon(
                    CupertinoIcons.trash,
                    size: 30,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
