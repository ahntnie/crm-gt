import 'package:core/core.dart';
import 'package:crm_gt/apps/app_colors.dart' as app;
import 'package:crm_gt/apps/app_cubit.dart';
import 'package:crm_gt/core/services/app_refresh_service.dart';
import 'package:crm_gt/di.dart';
import 'package:crm_gt/features/routes.dart';
import 'package:crm_gt/firebase/firebase_api.dart';
import 'package:crm_gt/firebase/background_message_handler.dart';
import 'package:crm_gt/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Đăng ký background message handler TRƯỚC khi khởi tạo FirebaseApi
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  
  FirebaseApi firebaseApi = FirebaseApi();
  firebaseApi.initNotifications();
  String FCM_TOPIC_ALL = "crm_gt_all";
  FirebaseMessaging.instance.subscribeToTopic(FCM_TOPIC_ALL);
  await DependencyInjection.init();

  runApp(
    BlocProvider<AppCubit>(
      create: (_) => AppCubit(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Đăng ký callback refresh
    AppRefreshService().setRefreshCallback(() {
      _handleAppRefresh();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        AppRefreshService().onAppResumed();
        break;
      case AppLifecycleState.paused:
        AppRefreshService().onAppPaused();
        break;
      case AppLifecycleState.inactive:
        // Không làm gì, chờ paused hoặc resumed
        break;
      case AppLifecycleState.detached:
        AppRefreshService().onAppDetached();
        break;
      case AppLifecycleState.hidden:
        break;
    }
  }

  void _handleAppRefresh() {
    debugPrint('MyApp: Handling app refresh - navigating to splash');
    // Navigate về splash screen để refresh toàn bộ app
    AppNavigator.go(Routes.splash);
    AppRefreshService().markRefreshed();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      buildWhen: (previous, current) => previous.locale != current.locale,
      builder: (context, state) {
        return MaterialApp.router(
          color: app.AppColors.mono0,
          title: 'CRM GT',
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: ThemeMode.light,
          debugShowCheckedModeBanner: false,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          builder: (context, child) {
            return MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
                child: EasyLoading.init()(context, child));
          },
          locale: const Locale('vn'),
          routerConfig: AppNavigator.router,
        );
      },
    );
  }
}
