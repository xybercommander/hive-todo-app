import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_todo_app/models/task_model.dart';
import 'package:hive_todo_app/services/boxes.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({ Key? key }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  TextEditingController _dateController = TextEditingController();
  TextEditingController _taskController = TextEditingController();
  late String _priority;

  final List<String> _priorities = ['Low', 'Medium', 'High'];
  DateTime _date = DateTime.now();  
  final DateFormat _dateFormatter = DateFormat('MMM dd, yyyy');

  Future<void> _handleDatePicker() async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100)
    );

    if(date != null && date != _date) {
      setState(() {
        _date = date;
      });
      _dateController.text = _dateFormatter.format(_date).toString();
    }
  }


  @override
  void dispose() {
    Hive.box('tasks-box').close();
    super.dispose();
  }


  //---------- UI -----------//
  @override
  Widget build(BuildContext context) {    
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xff151d27),
      body: ValueListenableBuilder(
        valueListenable: Boxes.getTasks().listenable(),
        builder: (context, value, _) {
          final tasks = box.values.toList().cast<Task>();
          tasks.sort((a, b) => a.date.compareTo(b.date));

          return tasks.isEmpty
              ? Container()
              : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ListView.builder(
                    
                    itemCount: tasks.length + 1,
                    itemBuilder: (context, index) {
                      if(index == 0) {
                        return Container(
                          alignment: Alignment.centerLeft,
                          height: 100,
                          child: Text(
                            'Your Tasks',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'RobotoSlab',
                              fontSize: 48,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        );
                      } else {
                        return Column(
                          children: [
                            Card(    
                              elevation: 0,                                   
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              color: Color(0xff212c3c),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 0),
                                child: ExpansionTile(
                                  title: Text(
                                    tasks[index - 1].task,
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontFamily: 'Nunito-SemiBold',
                                      color: Colors.white
                                    ),
                                  ),
                                  subtitle: Row(
                                    children: [
                                      Text(tasks[index - 1].date, style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: 'Nunito-SemiBold',
                                        color: Colors.white,
                                      ),),
                                      SizedBox(width: 12,),
                                      Text(
                                        'Priority: ', 
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontFamily: 'Nunito-SemiBold',
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        tasks[index - 1].priority,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontFamily: 'Nunito-SemiBold',
                                          color: tasks[index - 1].priority == 'High'
                                              ? Colors.red
                                              : tasks[index - 1].priority == 'Medium'
                                                  ? Colors.amber
                                                  : Colors.greenAccent,
                                        ),
                                      )
                                    ],
                                  ),
                                  collapsedIconColor: Colors.white,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: TextButton.icon(
                                            label: Text('Edit'),
                                            icon: Icon(Icons.edit),
                                            onPressed: () => openExistingTask(tasks[index - 1])
                                          ),
                                        ),
                                        Expanded(
                                          child: TextButton.icon(
                                            label: Text('Delete'),
                                            icon: Icon(Icons.delete),
                                            onPressed: () => deleteTask(tasks[index - 1]),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 4,)
                          ],
                        );
                      }                      
                    }
            ),
              );
        },
      ),      
      floatingActionButton: FloatingActionButton(
        onPressed: () => newTask(),
        child: Icon(Icons.add),
      ),
    );
  }
  
  //----------- HIVE FUNCTIONS -----------//

  final box = Boxes.getTasks();

  void addTask() {
    final task = Task()
          ..priority = _priority
          ..date = _dateController.text
          ..task = _taskController.text;
    
    box.add(task);

    _priority = '';
    _dateController.text = '';
    _taskController.text = ''; 
    Navigator.pop(context);   
  }

  void updateTask(Task task) {
    task.priority = _priority;
    task.date = _dateController.text;
    task.task = _taskController.text;

    task.save();
    Navigator.pop(context);
  }

  void openExistingTask(Task task) {
    _priority = task.priority;
    _dateController.text = task.date;
    _taskController.text = task.task;
    _modalBottomSheetMenu(task);
  }

  void deleteTask(Task task) {
    task.delete();
  }

  void newTask() {
    _priority = '';
    _dateController.text = '';
    _taskController.text = '';
    _modalBottomSheetMenu(
      Task()
        ..date = ''
        ..priority = ''
        ..task = ''
    );
  }

  //--------- MODAL BOTTOM SHEET ---------//

  void _modalBottomSheetMenu(Task task) {    
    showModalBottomSheet(        
        isScrollControlled: true,        
        context: context,
        builder: (builder){
          return Container(                        
            decoration: BoxDecoration(
              color: Color(0xff151d27),
              borderRadius: BorderRadius.vertical(top: Radius.circular(15.0))
            ),
            padding: MediaQuery.of(context).viewInsets,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,       
                crossAxisAlignment: CrossAxisAlignment.end,                         
                children: [
                  SizedBox(height: 32,),
                  DropdownButtonFormField(                    
                    dropdownColor: Colors.blueGrey[800],
                    isDense: true,
                    icon: Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white,),
                    style: TextStyle(fontSize: 18, fontFamily: 'Nunito-SemiBold', color: Colors.white,),                    
                    decoration: InputDecoration(
                      labelText: task.task == '' ? 'Priority' : task.priority,
                      labelStyle: TextStyle(fontSize: 18, fontFamily: 'Nunito-SemiBold', color: Colors.white,),   
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white54, width: 2),
                        borderRadius: BorderRadius.circular(10),
                      ),                                         
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white54, width: 2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    items: _priorities.map((String priority) {
                      return DropdownMenuItem(
                        value: priority,
                        child: Text(
                          priority,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,                            
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _priority = value.toString();                        
                      });                      
                    },    
                  ),
                  SizedBox(height: 16,),
                  TextFormField(
                    onTap: () => _handleDatePicker(),
                    controller: _dateController,
                    readOnly: true,             
                    // initialValue: ,
                    style: TextStyle(fontSize: 18, fontFamily: 'Nunito-SemiBold', color: Colors.white,),                                       
                    decoration: InputDecoration(                    
                      labelText: 'Date',
                      labelStyle: TextStyle(fontSize: 18, fontFamily: 'Nunito-SemiBold', color: Colors.white,),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white54, width: 2),
                        borderRadius: BorderRadius.circular(10),
                      ),    
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white54, width: 2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 16,),
                  TextFormField(
                    controller: _taskController,
                    style: TextStyle(fontSize: 18, fontFamily: 'Nunito-SemiBold', color: Colors.white,),
                    // initialValue: task.task,
                    decoration: InputDecoration(
                      labelText: 'Task',
                      labelStyle: TextStyle(fontSize: 18, fontFamily: 'Nunito-SemiBold', color: Colors.white,),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white54, width: 2),
                        borderRadius: BorderRadius.circular(10),
                      ),    
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white54, width: 2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 16,),
                  MaterialButton(
                    onPressed: () => task.task == '' ? addTask() : updateTask(task),                    
                    color: Theme.of(context).primaryColor,
                    shape: StadiumBorder(),
                    child: Text(
                      task.task == '' ? 'Add Task' : 'Update Task',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Nunito-SemiBold',                        
                      ),
                    ),
                  ),
                  SizedBox(height: 32,),
                ],
              ),
            ),
          );
        }
    );
  }  
}