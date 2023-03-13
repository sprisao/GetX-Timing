import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timing/viewmodel/timing_viewmodel.dart';

import 'amplifyconfiguration.dart';
import 'models/ModelProvider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await _configureAmplify();
  } on AmplifyAlreadyConfiguredException {
    safePrint('Amplify was already configured. Was the app restarted?');
  }
  runApp(const TimingApp());
}

Future<void> _configureAmplify() async {
  await Amplify.addPlugins([
    AmplifyDataStore(modelProvider: ModelProvider.instance),
    AmplifyAuthCognito(),
    AmplifyAPI(modelProvider: ModelProvider.instance),
  ]);
  await Amplify.configure(amplifyconfig);
}

class TimingApp extends StatelessWidget {
  const TimingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Authenticator(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => TimingViewModel())
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          // set the default theme
          theme: ThemeData.from(
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.red,
              backgroundColor: Colors.white,
            ),
          ).copyWith(
            indicatorColor: Colors.red,
          ),
          // set the dark theme (optional)
          darkTheme: ThemeData.from(
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.red,
              backgroundColor: Colors.black,
              brightness: Brightness.dark,
            ),
          ),
          // set the theme mode to respond to the user's system preferences (optional)
          themeMode: ThemeMode.system,
          builder: Authenticator.builder(),
          home: Consumer<TimingViewModel>(builder: (context, model, child) {
            return Scaffold(
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  FilledButton(
                      onPressed: () {
                        model.currentUserId();
                      },
                      child: Text(
                        'currentUserId',
                        style: TextStyle(color: Colors.white),
                      )),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
