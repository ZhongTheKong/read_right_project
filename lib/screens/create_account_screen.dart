
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:read_right_project/models/labeled_login_text_field.dart';
import 'package:read_right_project/providers/all_users_provider.dart';
import 'package:read_right_project/providers/session_provider.dart';
import 'package:read_right_project/utils/all_users_data.dart';
import 'package:read_right_project/utils/routes.dart';
import 'package:read_right_project/utils/student_user_data.dart';
import 'package:read_right_project/utils/teacher_user_data.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  @override
  Widget build(BuildContext context) {
    TextEditingController usernameTextEditingController = TextEditingController();
    TextEditingController passwordTextEditingController = TextEditingController();
    TextEditingController firstNameTextEditingController = TextEditingController();
    TextEditingController lastNameTextEditingController = TextEditingController();
    TextEditingController emailTextEditingController = TextEditingController();
    TeacherUserData? selectedTeacher;




    SessionProvider sessionProvider = context.read<SessionProvider>();
    AllUsersProvider allUsersProvider = context.read<AllUsersProvider>();


    return Scaffold(
      appBar: AppBar(
        // title: sessionProvider.isTeacher ? const Text('Teacher Login Screen') : const Text('Student Login Screen')
        backgroundColor: Colors.blue,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Container(
                // color: Colors.white,
                padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                decoration: BoxDecoration(
                  // shape: BoxShape.circle,
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10)
                ),
                child: Text(
                  'Create Account',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold
                  ),
                )
              ),
            ),
            // ElevatedButton(
            //   onPressed: () {
            //     Navigator.pushReplacementNamed(context, AppRoutes.login);
            //   }, 
            //   child: Text("EXIT")
            // )
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(
                  width: 5,
                  color: Colors.blue
                ),
                borderRadius: BorderRadius.circular(8)
              ),
              child: Column(
                children: [
                  const Text(
                    'Personal Information',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  const SizedBox(height: 20),
              
                  LabelledLoginTextField(
                      textEditingController: firstNameTextEditingController,
                      fieldIcon: Icons.abc,
                      labelText: "First Name"
                  ),
                  const SizedBox(height: 20),
              
                  LabelledLoginTextField(
                      textEditingController: lastNameTextEditingController,
                      fieldIcon: Icons.abc,
                      labelText: "Last Name"
                  ),
                  const SizedBox(height: 20),
              
                  LabelledLoginTextField(
                      textEditingController: emailTextEditingController,
                      fieldIcon: Icons.mail_outline,
                      labelText: "Email"
                  ),
                  const SizedBox(height: 20),
              
                  SizedBox(
                    width: 250,
                    child: DropdownButton(
                      isExpanded: true,
                      hint: Text("Instructor"),
                      items: allUsersProvider.allUserData.teacherUserDataList.map((teacherUserData) {
                        return DropdownMenuItem<TeacherUserData>(
                          value: teacherUserData,
                          child: Text('${teacherUserData.firstName} ${teacherUserData.lastName}'),
                        );
                      }).toList(),
                      onChanged: (value) { selectedTeacher = value; }
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 10,),

            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(
                  width: 5,
                  color: Colors.red
                ),
                borderRadius: BorderRadius.circular(8)
              ),
              child: Column(
                children: [
                  const Text(
                    'Credentials',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  const SizedBox(height: 20),
              
                  LabelledLoginTextField(
                      textEditingController: usernameTextEditingController,
                      fieldIcon: Icons.face,
                      labelText: "Username"
                  ),
                  const SizedBox(height: 20),
              
                  LabelledLoginTextField(
                      textEditingController: passwordTextEditingController,
                      fieldIcon: Icons.key,
                      labelText: "Password"
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),

            SizedBox(height: 10,),

            Row(
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: ElevatedButton(
                      onPressed: () async {
                        final username = usernameTextEditingController.text;
                        final password = passwordTextEditingController.text;
                        final firstName = firstNameTextEditingController.text;
                        final lastName = lastNameTextEditingController.text;
                    
                        if (sessionProvider.isCreateAccountTeacher)
                        {
                          allUsersProvider.addTeacher(TeacherUserData(
                            username: username, 
                            password: password, 
                            firstName: firstName,
                            lastName: lastName,
                            isTeacher: true, 
                            studentUsernames: []
                          ));
                        }
                        else
                        {
                          allUsersProvider.addStudent(StudentUserData(
                            username: username, 
                            password: password, 
                            firstName: firstName,
                            lastName: lastName,
                            isTeacher: false, 
                            // attempts: [],
                            // word_list_attempts: {},
                            word_list_progression_data: {}
                          ));
                        }
                        allUsersProvider.saveCurrentUserData();
                        // Navigator.pushReplacementNamed(context, AppRoutes.login);
                        Navigator.pop(context);
                    
                      },
                      child: const Text('Create Account'),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
