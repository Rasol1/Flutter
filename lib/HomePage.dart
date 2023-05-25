import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'data.dart';
import 'EditPage.dart';
import 'main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    final box = Hive.box<TaskEntity>(taskBoxName);
    final myThemeData = Theme.of(context);
    return Scaffold(
// ================  start float action bottom   ============
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditTaskScreen(
                  task: TaskEntity(),
                ),
              ));
        },
        label: Row(
          children: [
            Text('Add New Task'),
            SizedBox(
              width: 6,
            ),
            Icon(Icons.add_outlined)
          ],
        ),
      ),
// ================   end float action bottom   ==============

// ===============     start body     ===================
      body: SafeArea(
        child: Column(
          children: [
//  ================  start custom app bar   =================
            Container(
              height: 102,
              width: double.infinity,
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                myThemeData.colorScheme.primary,
                myThemeData.colorScheme.primaryContainer
              ])),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'To DO List',
                          style: myThemeData.textTheme.titleLarge!.apply(),
                        ),
                        Icon(
                          Icons.share,
                          color: myThemeData.colorScheme.onPrimary,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 12,
                    ),

//  ===================     start search field   ==================
                    Container(
                      alignment: Alignment.bottomCenter,
                      height: 38,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 20)
                          ],
                          color: myThemeData.colorScheme.onPrimary,
                          borderRadius: BorderRadiusDirectional.circular(19)),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {});
                        },
                        controller: controller,
                        decoration: InputDecoration(
                          hintText: 'Search tasks ...',
                          prefixIcon: Icon(
                            Icons.search,
                            // color: myThemeData.colorScheme.secondaryTextColor,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    )

// ===================    end search field    ====================
                  ],
                ),
              ),
            ),

// ================     end custom app bar     ==================

// ===============    start app body  ===================

            Expanded(
              child: ValueListenableBuilder<Box<TaskEntity>>(
                valueListenable: box.listenable(),
                builder: (context, box, child) {
                  final items;
                  if (controller.text.isEmpty) {
                    items = box.values.toList();
                  } else {
                    items = box.values.where(
                      (task) => task.name.contains(controller.text),
                    ).toList();
                  }
                  if (items.isNotEmpty) {
                    return ListView.builder(
                      padding: EdgeInsets.fromLTRB(16, 16, 16, 100),
                      itemCount: items.length + 1,
                      itemBuilder: (context, index) {
                        // final TaskEntity task = box.values.toList()[index];
                        if (index == 0) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Today',
                                    style: myThemeData.textTheme.titleMedium,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 4),
                                    height: 3,
                                    width: 67,
                                    decoration: BoxDecoration(
                                        color: myThemeData.colorScheme.primary,
                                        borderRadius:
                                            BorderRadius.circular(1.5)),
                                  )
                                ],
                              ),
                              MaterialButton(
                                color: Color(0xffEAEFF5),
                                textColor: secondaryTextColor,
                                elevation: 0,
                                onPressed: () {
                                  box.clear();
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      'Delee All',
                                    ),
                                    SizedBox(
                                      width: 2,
                                    ),
                                    Icon(
                                      Icons.delete,
                                      size: 18,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          );
                        } else {
                          final TaskEntity task =
                              items[index -1];
                          return TaskItem(task: task);
                        }
                      },
                    );
                  } else {
                    return EmptyState();
                  }
                },
              ),
            ),

// ===============      end app body    ====================
          ],
        ),
      ),

// ================       end body     ==================
    );
  }
}

class EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.asset(
        'assets/notask.png',
      ),
    );
  }
}

// ===============      start task item     ==================
class TaskItem extends StatefulWidget {
  const TaskItem({
    super.key,
    required this.task,
  });

  final TaskEntity task;

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  @override
  Widget build(BuildContext context) {
    final myThemeData = Theme.of(context);
    final priorityColor;
    switch (widget.task.priority) {
      case Priority.high:
        priorityColor = highPriority;
        break;
      case Priority.normal:
        priorityColor = normalPriority;
        break;
      case Priority.low:
        priorityColor = lowPriority;
        break;
    }
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => EditTaskScreen(task: widget.task),
        ));
      },
      onLongPress: () {
        widget.task.delete();
      },
      child: Container(
        alignment: Alignment.centerLeft,
        margin: EdgeInsets.only(top: 4, bottom: 4),
        padding: EdgeInsets.only(
          left: 16,
        ),
        height: 84,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: myThemeData.colorScheme.surface,
        ),
        child: Row(
          children: [
            myCheckBox(
              value: widget.task.isComplated,
              onTap: () {
                setState(() {
                  widget.task.isComplated = !widget.task.isComplated;
                });
              },
            ),
            SizedBox(
              width: 16,
            ),
            Expanded(
              child: Text(
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                widget.task.name,
                style: TextStyle(
                    fontStyle: myThemeData.textTheme.bodyMedium!.fontStyle,
                    fontSize: myThemeData.textTheme.bodyMedium!.fontSize,
                    // fontSize: 24,
                    decoration: widget.task.isComplated
                        ? TextDecoration.lineThrough
                        : null),
              ),
            ),
            SizedBox(
              width: 8,
            ),
            Container(
              height: double.infinity,
              width: 6,
              decoration: BoxDecoration(
                  color: priorityColor,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(8),
                      bottomRight: Radius.circular(8))),
            )
          ],
        ),
      ),
    );
  }
}

// ===============      end task item     ==================

// ===============      start my check box      ==============

class myCheckBox extends StatelessWidget {
  const myCheckBox({super.key, required this.value, required this.onTap});
  final bool value;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    final myThemeData = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 24,
        width: 24,
        decoration: BoxDecoration(
          color: value ? primaryColor : null,
          border: !value
              ? Border.all(
                  color: secondaryTextColor,
                )
              : null,
          borderRadius: BorderRadius.circular(12),
          // boxShadow: [
          //   BoxShadow(
          //       color: Colors.black.withOpacity(0.2),
          //       blurRadius: 20)
          // ],
        ),
        child: value
            ? Icon(
                Icons.check,
                size: 16,
                color: myThemeData.colorScheme.onPrimary,
              )
            : null,
      ),
    );
  }
}
