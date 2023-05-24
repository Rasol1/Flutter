import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'data.dart';
import 'main.dart';

class EditTaskScreen extends StatefulWidget {
  EditTaskScreen({super.key, required this.task});
   final TaskEntity task;

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
late  final TextEditingController _nameController = TextEditingController(text: widget.task.name);

  @override
  Widget build(BuildContext context) {
    final myThemeData = Theme.of(context);
    return Scaffold(
// ===============      start float action bottom      ==============
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          
          widget.task.name = _nameController.text;
          widget.task.priority = widget.task.priority;
          widget.task.isComplated = false;
          if (widget.task.isInBox) {
            widget.task.save();
          } else {
            final Box<TaskEntity> box = Hive.box(taskBoxName);
            box.add(widget.task);
          }

          Navigator.pop(context);
        },
        label: const Row(
          children: [
            Text('Save Changes'),
            SizedBox(
              width: 2,
            ),
            Icon(
              Icons.check,
              size: 18,
            )
          ],
        ),
      ),

// ===================     end float action bottom      ==================

//  ==================    start appbar    ===============
      appBar: AppBar(
        backgroundColor: myThemeData.colorScheme.background,
        foregroundColor: myThemeData.colorScheme.onSurface,
        title: const Text('Edit Task'),
        elevation: 0,
      ),
// ===================    end appbar     ================
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flex(
              direction: Axis.horizontal,
              children: [
                Flexible(
                  flex: 1,
                  child: PriorityCheckBox(
                    onTap: () {
                      setState(() {
                        widget.task.priority=Priority.high;
                      });
                    },
                    labal: 'High',
                    color: highPriority,
                    isSelected: widget.task.priority == Priority.high,
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Flexible(
                  flex: 1,
                  child: PriorityCheckBox(
                    onTap: () {
                      setState(() {
                        widget.task.priority=Priority.normal;
                      });
                    },
                      labal: 'Normal',
                      color: normalPriority,
                      isSelected: widget.task.priority == Priority.normal),
                ),
                const SizedBox(
                  width: 8,
                ),
                Flexible(
                  flex: 1,
                  child: PriorityCheckBox(
                    onTap: () {
                      setState(() {
                        widget.task.priority=Priority.low;
                      });
                    },
                      labal: 'Low',
                      color: lowPriority,
                      isSelected: widget.task.priority == Priority.low),
                ),
              ],
            ),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                border: InputBorder.none,
                label: Text('Add a task for today ...',style: myThemeData.textTheme.titleMedium!.apply(color:secondaryTextColor),),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class PriorityCheckBox extends StatelessWidget {
  const PriorityCheckBox(
      {super.key,
      required this.labal,
      required this.color,
      required this.isSelected, required this.onTap});
  final String labal;
  final Color color;
  final bool isSelected;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:onTap,
      child: Container(
        height: 40,
        
        decoration: BoxDecoration(
          border:
              Border.all(width: 2, color: secondaryTextColor.withOpacity(0.2)),
    
          borderRadius: BorderRadius.circular(4),
         
        ),
        child: Stack(children: [
          Center(
            child: Text(
              labal,
            ),
          ),
          Positioned(
            right: 8,
            top: 10,
            bottom: 10,
           
            child: _myCheckBoxShape(
              value: isSelected,
              color: color,
            ),
          )
        ]),
      ),
    );
  }
}

// ignore: camel_case_types
class _myCheckBoxShape extends StatelessWidget {
  const _myCheckBoxShape({required this.value, required this.color});
  final bool value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final myThemeData = Theme.of(context);
    return Container(
      height: 16,
      width: 16,
      decoration: BoxDecoration(
        color: color,

        borderRadius: BorderRadius.circular(8),
        
      ),
      child: value
          ? Icon(
              Icons.check,
              size: 12,
              color: myThemeData.colorScheme.onPrimary,
            )
          : null,
    );
  }
}
