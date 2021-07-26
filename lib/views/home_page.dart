import 'package:flutter/material.dart';
import 'package:hive_todo_app/models/task_model.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({ Key? key }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  List<Task> tasks = [];

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
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: tasks.isEmpty 
        ? Container()
        : ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              return Card(
                child: ExpansionTile(
                  title: Text(
                    tasks[index].task,
                    style: TextStyle(
                      fontSize: 32,
                      fontFamily: 'Nunito-SemiBold'
                    ),
                  ),
                  subtitle: Text(tasks[index].date),
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextButton.icon(
                            label: Text('Edit'),
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              _priority = tasks[index].priority;
                              _dateController.text = tasks[index].date;
                              _taskController.text = tasks[index].task;
                              _modalBottomSheetMenu(tasks[index]);
                            }
                          ),
                        ),
                        Expanded(
                          child: TextButton.icon(
                            label: Text('Delete'),
                            icon: Icon(Icons.delete),
                            onPressed: () {},
                          ),
                        )
                      ],
                    )
                  ],
                ),
              );
            }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => addTask(),
        child: Icon(Icons.add),
      ),
    );
  }

  void addTask() {
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

  void _modalBottomSheetMenu(Task task) {    
    showModalBottomSheet(        
        isScrollControlled: true,        
        context: context,
        builder: (builder){
          return Container(                        
            decoration: BoxDecoration(
              color: Colors.white,
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
                    dropdownColor: Colors.white,
                    isDense: true,
                    icon: Icon(Icons.arrow_drop_down_circle),
                    style: TextStyle(fontSize: 18, fontFamily: 'Nunito-SemiBold',),                    
                    decoration: InputDecoration(
                      labelText: task.priority == '' ? 'Priority' : task.priority,
                      labelStyle: TextStyle(fontSize: 18, fontFamily: 'Nunito-SemiBold',),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)
                      )
                    ),
                    items: _priorities.map((String priority) {
                      return DropdownMenuItem(
                        value: priority,
                        child: Text(
                          priority,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18
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
                    style: TextStyle(fontSize: 18, fontFamily: 'Nunito-SemiBold',),                                       
                    decoration: InputDecoration(                    
                      labelText: 'Date',
                      labelStyle: TextStyle(fontSize: 18, fontFamily: 'Nunito-SemiBold',),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)
                      )
                    ),
                  ),
                  SizedBox(height: 16,),
                  TextFormField(
                    controller: _taskController,
                    style: TextStyle(fontSize: 18, fontFamily: 'Nunito-SemiBold',),
                    // initialValue: task.task,
                    decoration: InputDecoration(
                      labelText: 'Task',
                      labelStyle: TextStyle(fontSize: 18, fontFamily: 'Nunito-SemiBold',),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)
                      )
                    ),
                  ),
                  SizedBox(height: 16,),
                  MaterialButton(
                    onPressed: () {             
                      setState(() {
                        tasks.add(
                          Task()
                          ..priority = _priority
                          ..date = _dateController.text
                          ..task = _taskController.text
                        );
                      });         
                      _priority = '';
                      _dateController.text = '';
                      _taskController.text = '';                      
                    },
                    color: Theme.of(context).primaryColor,
                    shape: StadiumBorder(),
                    child: Text(
                      'Add Task',
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