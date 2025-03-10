import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/core_provider/core_notifier.dart';
import 'core/routes/routes.dart';
import 'core/theme/dark_theme.dart';
import 'core/theme/light_theme.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coreState = ref.watch(coreNotifierProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: coreState.themeMode,
      theme: lightTheme(),
      darkTheme: darkTheme(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: coreState.language.value,
      onGenerateRoute: Routes.generateRoute,
      initialRoute: RouteKeys.addCaregiverScreen,
      builder: (context, child) {
        return Directionality(
          textDirection: coreState.language.value.languageCode == 'ar'
              ? TextDirection.rtl
              : TextDirection.ltr,
          child: MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: TextScaler.linear(1.0)),
            child: child!,
          ),
        );
      },
    );
  }
}
