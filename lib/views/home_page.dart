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

  void _modalBottomSheetMenu(){
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
                      labelText: 'Priority',
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
                  TextField(
                    onTap: () => _handleDatePicker(),
                    controller: _dateController,
                    readOnly: true,                    
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
                  TextField(
                    controller: _taskController,
                    style: TextStyle(fontSize: 18, fontFamily: 'Nunito-SemiBold',),
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
                      print(_priority);
                      print(_dateController.text);
                      print(_taskController.text);
                      setState(() {
                        tasks.add(
                          Task()
                          ..priority = _priority
                          ..date = _dateController.text
                          ..task = _taskController.text
                        );
                      });
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
                ),
              );
            }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _modalBottomSheetMenu(),
        child: Icon(Icons.add),
      ),
    );
  }
}