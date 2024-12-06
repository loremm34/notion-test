import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notion_test/common/helpers/wrapper.dart';
import 'package:notion_test/configs/theme/app_theme.dart';
import 'package:notion_test/firebase_options.dart';
import 'package:notion_test/presentation/add_note/bloc/add_note_bloc.dart';
import 'package:notion_test/presentation/home/bloc/filter_sort_bloc.dart';
import 'package:notion_test/services/notification_service.dart';
import 'package:notion_test/simple_bloc_observer.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await NotificationService().requestPermissions();
  await NotificationService().initNotifications();
  log('Уведомления инициализированы');
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Europe/Moscow'));

  Bloc.observer = SimpleBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AddNoteBloc(),
        ),
        BlocProvider(
          create: (context) => FilterSortBloc(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: AppTheme.lightTheme,
        home: const Wrapper(),
      ),
    );
  }
}
