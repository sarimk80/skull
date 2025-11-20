import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:skool_app/bloc/bloc/events_bloc.dart';
import 'package:skool_app/bloc/cubit/auth_bloc_cubit.dart';
import 'package:skool_app/helpers/routes.dart';
import 'package:skool_app/home.dart';
import 'package:skool_app/providers/repository.dart';
import 'package:skool_app/views/event_home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openBox("skool");

  runApp(
    RepositoryProvider(
      create: (context) => Repository(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthBlocCubit(
              authProvider: RepositoryProvider.of<Repository>(
                context,
              ).authProvider,
            ),
          ),

          BlocProvider(
            create: (context) => EventsBloc(
              eventProvider: RepositoryProvider.of<Repository>(
                context,
              ).eventProvider,
            ),
          ),
        ],
        child: RootView(),
      ),
    ),
  );
}

class RootView extends StatelessWidget {
  const RootView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: tokenWidget(),
      onGenerateRoute: Routes.generateRoute,
      builder: (context, widget) {
        ErrorWidget.builder = (FlutterErrorDetails details) {
          return Text(details.library ?? '');
        };
        return widget!;
      },
      //routes: Routes.routes,
      onUnknownRoute: (RouteSettings settings) {
        return MaterialPageRoute(builder: (BuildContext context) => RootView());
      },
    );
  }

  Widget tokenWidget() {
    final userBox = Hive.box('skool');
    String? token = userBox.get('userId');

    return token == null ? MyHomePage(title: "") : EventHome();
  }
}
