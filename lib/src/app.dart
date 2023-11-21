import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'sample_feature/sample_item_details_view.dart';
import 'sample_feature/sample_item_list_view.dart';
import 'video_feed/video_feed_view.dart';
import 'settings/settings_controller.dart';
import 'settings/settings_view.dart';
import 'snapshot/snapshot_view.dart';
import 'snapshot/snapshot_provider.dart';
import 'package:provider/provider.dart';
import 'video_feed/video_feed_provider.dart';
import 'util.dart';

/// The Widget that configures your application.
class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.settingsController,
  });

  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    const AppBarTheme appBarTheme = AppBarTheme(
      toolbarHeight: 48,
      shadowColor: Colors.black,
      // color: Color.fromARGB(255, 11, 120, 50),
      color: Color.fromARGB(255, 247, 247, 247),
      // color: Color.fromARGB(255, 78, 203, 74),
      // color: Color.fromARGB(255, 37, 38, 105), # TEV
      // Note - testing font props
      // titleTextStyle: TextStyle(fontFamily: 'NotoSans', color: Colors.black, fontWeight: FontWeight.w600),
      centerTitle: false,
      foregroundColor: Color.fromARGB(255, 0, 0, 3),
    );

    ThemeData darkTheme = ThemeData.dark(); //(fontFamily: 'FiraSans');
    return ListenableBuilder(
      listenable: settingsController,
      builder: (BuildContext context, Widget? child) {
        return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => VideoFeedProvider()),
        ChangeNotifierProvider(create: (_) => SnapshotProvider()),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          restorationScopeId: 'app',
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''), // English, no country code
          ],
          title: "Pyuscope",
          // theme: ThemeData(fontFamily: 'NotoSans', appBarTheme: appBarTheme),
          theme: ThemeData(appBarTheme: appBarTheme),
          darkTheme: darkTheme,
          themeMode: settingsController.themeMode,
          onGenerateRoute: (RouteSettings routeSettings) {
            return MaterialPageRoute<void>(
              settings: routeSettings,
              builder: (BuildContext context) {
                switch (routeSettings.name) {
                  case SettingsView.routeName:
                    setPageTitle("Settings", context);
                    return SettingsView(controller: settingsController);
                  case SampleItemDetailsView.routeName:
                    return const SampleItemDetailsView();
                  case SampleItemListView.routeName:
                    return const SampleItemListView();
                  case VideoFeedView.routeName:
                    setPageTitle("Video Feed", context);
                    return const VideoFeedView();
                  case SnapshotView.routeName:
                    setPageTitle("Snapshot", context);
                    return const SnapshotView();
                  default:
                    setPageTitle("Video Feed", context);
                    return const VideoFeedView();
                }
              },
            );
          },
        ));
      },
    );
  }
}
