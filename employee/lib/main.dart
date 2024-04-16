import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Employee App',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueGrey, // Setting a cool background color
          title: const Row(
            children: [
              Icon(
                Icons
                    .people, // You can change the icon to any cool-looking icon
                color: Colors.white, // Setting the icon color to white
              ),
              SizedBox(width: 10), // Adding space between icon and text
              Text(
                'Employee Directory', // Customizing the title text
                style: TextStyle(
                  color: Colors.white, // Setting the text color to white
                  fontSize:
                      20, // Increasing the font size for a bold appearance
                ),
              ),
            ],
          ),
        ),
        body: EmployeeList(),
      ),
    );
  }
}

class EmployeeList extends StatefulWidget {
  @override
  _EmployeeListState createState() => _EmployeeListState();
}

class _EmployeeListState extends State<EmployeeList> {
  List<Employee> employees = [];

  @override
  void initState() {
    super.initState();
    fetchEmployees();
  }

  Future<void> fetchEmployees() async {
    final response =
        await http.get(Uri.parse('http://localhost:3000/employees'));
    if (response.statusCode == 200) {
      final List<dynamic> employeeData = json.decode(response.body);
      setState(() {
        employees = employeeData.map((e) => Employee.fromJson(e)).toList();
      });
    } else {
      throw Exception('Failed to load employees');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Employee List'),
      // ),
      body: ListView.builder(
        itemCount: employees.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Row(
              children: [
                const Icon(Icons.person),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    '${employees[index].name} - ${employees[index].isActive ? "Active" : "Not Active"}, WE - ${employees[index].workExperience} years',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            tileColor: employees[index].isSenior && employees[index].isActive
                ? Colors.green
                : null,
          );
        },
      ),
    );
  }
}

class Employee {
  final String name;
  final int workExperience;
  final bool isSenior;
  final bool isActive;

  Employee({
    required this.name,
    required this.workExperience,
    required this.isSenior,
    required this.isActive,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      name: json['name'],
      workExperience: json['workExperience'],
      isSenior: json['workExperience'] >= 5,
      isActive: json['isActive'],
    );
  }
}
