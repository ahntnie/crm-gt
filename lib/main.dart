import 'package:core/locales/generated/l10n.dart';
import 'package:crm_gt/apps/app_cubit.dart';
import 'package:crm_gt/di.dart';
import 'package:crm_gt/presentations/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DependencyInjection.init();

  runApp(
    BlocProvider<AppCubit>(
      create: (_) => AppCubit(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      buildWhen: (previous, current) => previous.locale != current.locale,
      builder: (context, state) {
        return MaterialApp.router(
          color: Colors.white,
          title: 'MyEvo',
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
          locale: Locale('vn'),
          routerConfig: AppNavigator.router,
        );
      },
    );
  }
}
