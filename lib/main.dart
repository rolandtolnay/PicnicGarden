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
  await configureInjection();

  runApp(Application());
}

class Application extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Application({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: getIt<ThemeModeProvider>(),
      builder: (context, _) {
        return GestureDetector(
          onTap: () => _hideKeyboard(context),
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'PICNIC',
            theme: ThemeBuilder.light,
            darkTheme: ThemeBuilder.dark,
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
                  value: getIt<AuthProvider>()..signIn(),
                  child: AnnotatedRegion(
                    value: SystemUiOverlayStyle.light,
                    child: RootPage(),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _hideKeyboard(BuildContext context) {
    final currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }
}

class ThemeBuilder {
  static ThemeData get light {
    return FlexThemeData.light(
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
  }

  static ThemeData get dark {
    return FlexThemeData.dark(
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
  }
}
