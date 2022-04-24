import 'package:firebase_core/firebase_core.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:picnicgarden/ui/theme_provider.dart';
import 'package:provider/provider.dart';

import 'ui/auth_provider.dart';
import 'injection.dart';
import 'ui/root_page.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await configureDependencies();
  runApp(Application());
}

class Application extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Application({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final lightTheme = FlexThemeData.light(
      scheme: FlexScheme.jungle,
      surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
      blendLevel: 20,
      appBarOpacity: 0.95,
      subThemesData: const FlexSubThemesData(
        blendOnLevel: 20,
        blendOnColors: false,
      ),
      visualDensity: FlexColorScheme.comfortablePlatformDensity,
      useMaterial3: true,
      fontFamily: GoogleFonts.notoSans().fontFamily,
    );
    final darkTheme = FlexThemeData.dark(
      scheme: FlexScheme.jungle,
      surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
      blendLevel: 15,
      appBarStyle: FlexAppBarStyle.background,
      appBarOpacity: 0.90,
      subThemesData: const FlexSubThemesData(
        blendOnLevel: 30,
      ),
      visualDensity: FlexColorScheme.comfortablePlatformDensity,
      useMaterial3: true,
      fontFamily: GoogleFonts.notoSans().fontFamily,
    );

    return ChangeNotifierProvider.value(
      value: di<ThemeModeProvider>(),
      builder: (context, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Picnic Garden',
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: context.watch<ThemeModeProvider>().themeMode,
          home: FutureBuilder(
            future: _initialization,
            builder: (_, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }
              return ChangeNotifierProvider.value(
                value: di<AuthProvider>(),
                child: AnnotatedRegion(
                  value: SystemUiOverlayStyle.light,
                  child: RootPage(),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
