import 'package:flutter/material.dart';
import 'package:read_right_project/screens/create_account_screen.dart';
import 'package:read_right_project/screens/developer_screen.dart';
import 'package:read_right_project/screens/role_selection_screen.dart';
import '../screens/login_screen.dart';
import '../screens/practice_screen.dart';
import '../screens/progress_screen.dart';
import '../screens/teacher_dashboard_screen.dart';
import '../screens/word_list_screen.dart';
import '../screens/feedback_screen.dart';
import '../screens/pronunciation_screen.dart';

class AppRoutes {
  static const main = '/';
  static const dev = '/dev';
  static const role = '/role';
  static const login = '/login';
  static const create_account = '/create_account';
  static const practice = '/practice';
  static const progress = '/progress';
  static const teacherDashboard = '/teacherDashboard';
  static const wordList = '/wordList';
  static const feedback = '/feedback';
  static const pronunciation = '/pronunciation';
}

final Map<String, WidgetBuilder> appRoutes = {
  AppRoutes.dev: (context) => const DeveloperScreen(),
  AppRoutes.role: (context) => const RoleSelectionScreen(),
  AppRoutes.login: (context) => const LoginScreen(),
  AppRoutes.create_account: (context) => const CreateAccountScreen(),
  AppRoutes.practice: (context) => const PracticeScreen(),
  AppRoutes.progress: (context) => const ProgressScreen(),
  AppRoutes.teacherDashboard: (context) => TeacherDashboardScreen(),
  AppRoutes.wordList: (context) => const WordListScreen(),
  AppRoutes.feedback: (context) => const FeedbackScreen(),
  AppRoutes.pronunciation: (context) => PronunciationScreen(),
};