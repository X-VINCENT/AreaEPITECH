import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:src/data/local_storage/secure_storage.dart';
import 'package:src/data/provider/user_provider.dart';

class UserInfo extends ConsumerWidget {
  final LocalSecureStorage storage = LocalSecureStorage();
  Map<String, dynamic>? userMap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {

  Future<Map<String, dynamic>> fetchData() async {
    userMap = await storage.readMap('user');
    final auth = ref.watch(authProvider);
    final servicesProvider = ref.watch(serviceProvider);
    return {'name': userMap?['name'], 'email': userMap?['email']};
  }


    final auth = ref.watch(authProvider);
    userMap = auth?.getUser();
    Widget myWidget({required String name, required String email}) {
          return Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 0),
                    child: Text(
                      name,
                      style: TextStyle(
                        color: Theme.of(context).textTheme.displayLarge?.color,
                        fontFamily: "Rockwell",
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      email,
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodySmall?.color,
                        fontFamily: "Rockwell",
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        }

    if (userMap == null) {
      return FutureBuilder<Map<String, dynamic>>(
      future: fetchData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Erreur: ${snapshot.error}');
        } else {
          final name = snapshot.data?['name'] ?? "Test test";
          final email = snapshot.data?['email'] ?? "letest@gmail.com";
          return myWidget(name: name, email: email);
      }
      }
    );
    } else {
      return myWidget(name: userMap?['name'], email: userMap?['email']);
    }
  }
}