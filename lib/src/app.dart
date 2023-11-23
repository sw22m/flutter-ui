import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'sample_feature/sample_item_details_view.dart';
import 'sample_feature/sample_item_list_view.dart';
import 'video_feed/video_feed_view.dart';
import 'settings/settings_controller.dart';
import 'settings/settings_view.dart';
import 'snapshot/snapshot_view.dart';
import 'snapshot/snapshot_provider.dart';
import 'package:provider/provider.dart';
import 'video_feed/video_feed_provider.dart';
import 'video_feed/axes_controls_widget.dart';
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
    FlexScheme myFlexScheme = FlexScheme.tealM3;
    TextTheme myTextTheme = TextTheme(
      displayLarge: const TextStyle(
        fontSize: 32,
        // fontWeight: FontWeight.bold,
      ),
      titleLarge: GoogleFonts.jetBrainsMono(
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      titleSmall: GoogleFonts.jetBrainsMono(
        fontSize: 16,
        fontWeight: FontWeight.w300,
      ),

      bodyMedium: GoogleFonts.assistant(
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      displaySmall: GoogleFonts.pacifico(),
    );

    return ListenableBuilder(
      listenable: settingsController,
      builder: (BuildContext context, Widget? child) {
        return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => VideoFeedProvider()),
        ChangeNotifierProvider(create: (_) => SnapshotProvider()),
        ChangeNotifierProvider(create: (_) => PositionProvider()),
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
          theme: FlexThemeData.light(
            scheme: myFlexScheme,
            textTheme: myTextTheme,
            appBarBackground: const Color.fromARGB(240, 24, 24, 24),
            appBarOpacity: 0.9,
          ),
          darkTheme: FlexThemeData.dark(
            scheme: myFlexScheme,
            appBarBackground: const Color.fromARGB(240, 24, 24, 24),
            textTheme: myTextTheme,
          ),
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
