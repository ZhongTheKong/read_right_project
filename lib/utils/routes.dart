import 'package:flutter/material.dart';
import '../screens/login_screen.dart';
import '../screens/practice_screen.dart';
import '../screens/progress_screen.dart';
import '../screens/teacher_dashboard_screen.dart';
import '../screens/word_list_screen.dart';
import '../screens/feedback_screen.dart';
import '../main.dart';

class AppRoutes {
  static const main = '/';
  static const login = '/login';
  static const practice = '/practice';
  static const progress = '/progress';
  static const teacherDashboard = '/teacherDashboard';
  static const wordList = '/wordList';
  static const feedback = '/feedback';
}

final Map<String, WidgetBuilder> appRoutes = {
  AppRoutes.main: (context) => const MainScreen(),
  AppRoutes.login: (context) => const LoginScreen(),
  AppRoutes.practice: (context) => const PracticeScreen(),
  AppRoutes.progress: (context) => const ProgressScreen(),
  AppRoutes.teacherDashboard: (context) => const TeacherDashboardScreen(),
  AppRoutes.wordList: (context) => const WordListScreen(),
  AppRoutes.feedback: (context) => const FeedbackScreen(),
};