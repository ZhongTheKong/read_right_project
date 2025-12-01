
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:read_right_project/models/labeled_login_text_field.dart';
import 'package:read_right_project/providers/all_users_provider.dart';
import 'package:read_right_project/providers/session_provider.dart';
import 'package:read_right_project/utils/all_users_data.dart';
import 'package:read_right_project/utils/routes.dart';
import 'package:read_right_project/utils/student_user_data.dart';
import 'package:read_right_project/utils/teacher_user_data.dart';
import 'package:read_right_project/utils/user_data.dart';

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

    // List<String> teacherUsernames = allUsersProvider.allUserData.teacherUserDataList
    //   .map((teacher) => '${teacher.firstName} ${teacher.lastName}')
    //   .toList();


    return Scaffold(
      appBar: AppBar(
        // title: sessionProvider.isTeacher ? const Text('Teacher Login Screen') : const Text('Student Login Screen')
        backgroundColor: Colors.blue,
        title: Center(
          child: Container(
            // color: Colors.white,
            padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
            decoration: BoxDecoration(
              // shape: BoxShape.circle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(10)
            ),
            child: Text('Create Account')
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Personal Information',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),

            LabelledLoginTextField(
                textEditingController: firstNameTextEditingController,
                fieldIcon: Icons.face,
                labelText: "First Name"
            ),
            const SizedBox(height: 20),

            LabelledLoginTextField(
                textEditingController: lastNameTextEditingController,
                fieldIcon: Icons.key,
                labelText: "Last Name"
            ),
            const SizedBox(height: 20),

            LabelledLoginTextField(
                textEditingController: emailTextEditingController,
                fieldIcon: Icons.key,
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

            const Text(
              'Credentials',
              style: TextStyle(fontSize: 18),
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

            ElevatedButton(
              onPressed: () async {
                final username = usernameTextEditingController.text;
                final password = passwordTextEditingController.text;
                final firstName = firstNameTextEditingController.text;
                final lastName = lastNameTextEditingController.text;
                // Navigate back to main screen and clear previous routes
                // Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                // if (LoginData.isValidLoginData(username, password) == true)
                // {
                //   print("successful login");
                //   sessionProvider.saveUsername(username);
                //   /// Share data with provider
                //   // Provider.of<SessionProvider>(context, listen: false).saveUsername(username);
                //   // Navigator.pushNamedAndRemoveUntil(context, AppRoutes.practice, (route) => false);
                //   Navigator.pushReplacementNamed(context, AppRoutes.practice);
                //   // Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                // }
                // else
                // {
                //   print("incorrect login");
                // }
                // TODO: Check for unique username
                AllUserData allUserData = allUsersProvider.allUserData;
                if (sessionProvider.isTeacher)
                {
                  allUserData.teacherUserDataList.add(TeacherUserData(
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
                  allUserData.studentUserDataList.add(StudentUserData(
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
                // allUserData.userDataList.add(UserData(username: username, password: password, isTeacher: sessionProvider.isTeacher, attempts: []));
                allUsersProvider.saveCurrentUserData();
                Navigator.pushReplacementNamed(context, AppRoutes.login);

              },
              child: const Text('Create Account'),
            ),
            const SizedBox(height: 20),

            // ElevatedButton(
            //   onPressed: () {
            //     // Navigate back to main screen and clear previous routes
            //     Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);

            //   },
            //   child: const Text('Back to Main Screen'),
            // ),

          ],
        ),
      ),
    );
  }
}
