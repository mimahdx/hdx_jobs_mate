import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'di/injection_container.dart' as di;
import 'presentation/pages/welcome/welcome_page.dart';
import 'presentation/pages/dashboard/dashboard_page.dart';
import 'data/datasources/local/shared_prefs/first_launch_manager.dart';
import 'presentation/blocs/category/category_bloc.dart';
import 'presentation/blocs/saving/saving_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CategoryBloc>(
          create: (_) => di.sl<CategoryBloc>(),
        ),
        BlocProvider<SavingBloc>(
          create: (_) => di.sl<SavingBloc>(),
        ),
      ],
      child: MaterialApp(
        title: '',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        home: FutureBuilder<bool>(
          future: di.sl<FirstLaunchManager>().isFirstLaunch(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            final isFirstLaunch = snapshot.data ?? true;
            return isFirstLaunch ? const WelcomePage() : const DashboardPage();
          },
        ),
      ),
    );
  }
}