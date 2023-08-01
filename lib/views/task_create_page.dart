import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:todo_with_showcase/controller/showcase_controller.dart';
import 'package:todo_with_showcase/views/task_listing_page.dart';
import 'package:todo_with_showcase/views/widgets/primary_text_field.dart';

import '../controller/task_controller.dart';
import '../models/task.dart';

class TaskCreatePage extends StatefulWidget {
  const TaskCreatePage({Key? key}) : super(key: key);

  @override
  State<TaskCreatePage> createState() => _TaskCreatePageState();
}

class _TaskCreatePageState extends State<TaskCreatePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final task = Task();
  final _key1 = GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(milliseconds: 400), () {
      if (myContext.read<ShowcaseController>().isActive) {
        ShowCaseWidget.of(myContext).startShowCase([_key1]);
      }
      myContext.read<ShowcaseController>().disableShowcaseOnCreatePage();
    });
  }

  late BuildContext myContext;

  @override
  Widget build(BuildContext context) {
    return ShowCaseWidget(
      builder: Builder(builder: (context) {
        myContext = context;
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 30,
                color: Colors.black,
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Text(
                      'Add New Task',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    SizedBox(height: 30),
                    PrimaryTextField(
                      hintText: "What's your plan?🤔",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "This field can't be empty";
                        } else {
                          return null;
                        }
                      },
                      onSaved: (value) {
                        task.title = value ?? "";
                      },
                    ),
                    SizedBox(height: 20),
                    PrimaryTextField(
                      hintText: "Your notes here",
                      maxLines: 5,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "This field can't be empty";
                        } else {
                          return null;
                        }
                      },
                      onSaved: (value) {
                        task.notes = value ?? "";
                      },
                    ),
                    SizedBox(height: 30),
                    Align(
                        alignment: Alignment.bottomRight,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("Date: ",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(color: Colors.grey)),
                            Text(
                              DateFormat('MMM dd, yyyy').format(
                                DateTime.now(),
                              ),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: Colors.grey),
                            ),
                          ],
                        )),
                    SizedBox(height: 40),
                    Showcase(
                      key: _key1,
                      description:
                          "Type your plan, notes and click to add your task",
                      descTextStyle: kShowCaseTextStyle,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState?.validate() == true) {
                            _formKey.currentState!.save();
                            await Provider.of<TaskController>(context,
                                    listen: false)
                                .addTask(task);

                            Navigator.of(context).pop();
                          }
                        },
                        child: const Text("Add"),
                        style: ButtonStyle(
                            minimumSize:
                                MaterialStateProperty.all<Size>(Size(250, 45)),
                            backgroundColor: MaterialStateProperty.all(
                                Colors.deepPurpleAccent)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
