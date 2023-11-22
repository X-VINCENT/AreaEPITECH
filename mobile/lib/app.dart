import 'package:flutter/material.dart';
import 'package:src/data/provider/user_provider.dart';
import 'package:src/components/animation/spin_loading_register.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:src/data/local_storage/secure_storage.dart';
import "screens/login/welcome.dart";
import "screens/login/login.dart";
import "screens/login/register.dart";
import 'components/navbar/navbar.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_translate/flutter_translate.dart';

Future<Widget> checkLogin(WidgetRef ref) async {
  final auth = ref.watch(authProvider);
  LocalSecureStorage storage = LocalSecureStorage();

  final token = await storage.read("token");
  final user = await storage.readMap("user");

  if (token == null || user == null) {
    return const Welcome();
  }
  auth?.setToken(token);
  auth?.setUser(user);
  return SpinLoading();
}

class App extends ConsumerStatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  AppState createState() => AppState();

  static AppState of(BuildContext context) {
    final AppState? app = context.findAncestorStateOfType<AppState>();
    if (app == null) {
      throw FlutterError('App widget not found in the widget tree');
    }
    return app;
  }
}

class AppState extends ConsumerState<App> {
  Locale locale_ = const Locale("us");

  void setLocale(Locale value) {
    setState(() {
      locale_ = value;
    });
  }

  String getLocale() {
    return locale_.toString();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(userPreferencesProvider).getTheme();
    var localizationDelegate = LocalizedApp.of(context).delegate;

    return LocalizationProvider(
        state: LocalizationProvider.of(context).state,
        child: MaterialApp(
          locale: locale_,
          debugShowCheckedModeBanner: false,
          theme: theme,
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            localizationDelegate
          ],
          supportedLocales: localizationDelegate.supportedLocales,
          home: FutureBuilder<Widget>(
            future: checkLogin(ref),
            builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return Center(
                      child: Text(
                          "Une erreur s'est produite : ${snapshot.error}"));
                } else {
                  return snapshot.data ?? const Placeholder();
                }
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
          routes: {
            '/welcome': (context) => const Welcome(),
            '/login': (context) => Login(),
            '/register': (context) => Register(),
            '/home': (context) => const Navbar(),
            '/splash': (context) => SpinLoading(),
          },
        ));
  }
}
