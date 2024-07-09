import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Screens/AddInvoiceScreen.dart';
import 'Screens/Splash_View.dart';
import 'ViewModel/CustomerVIewModel.dart';
import 'ViewModel/InvoiceByOrderFreeModel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CustomerProvider()),
        ChangeNotifierProvider(create: (_) => InvoiceProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          iconTheme: const IconThemeData(color: Colors.black),
          textTheme: TextTheme(
            bodyLarge: TextStyle(
                color: Colors.black,
                fontSize: MediaQuery.sizeOf(context).width *
                    0.04), // default text color and font size
            bodyMedium: TextStyle(
                color: Colors.black,
                fontSize: MediaQuery.sizeOf(context).width *
                    0.04), // secondary text color and font size
            displayLarge: TextStyle(
                color: Colors.black,
                fontSize: MediaQuery.sizeOf(context).width *
                    0.04), // headline text color and font size
            displayMedium: TextStyle(
                color: Colors.black,
                fontSize: MediaQuery.sizeOf(context).width *
                    0.04), // headline text color and font size
            displaySmall: TextStyle(
                color: Colors.black,
                fontSize: MediaQuery.sizeOf(context).width *
                    0.04), // headline text color and font size
            headlineMedium: TextStyle(
                color: Colors.black,
                fontSize: MediaQuery.sizeOf(context).width *
                    0.04), // headline text color and font size
            headlineSmall: TextStyle(
                color: Colors.black,
                fontSize: MediaQuery.sizeOf(context).width *
                    0.04), // headline text color and font size
            titleLarge: TextStyle(
                color: Colors.black,
                fontSize: MediaQuery.sizeOf(context).width *
                    0.04), // headline text color and font size
            titleMedium: TextStyle(
                color: Colors.black,
                fontSize: MediaQuery.sizeOf(context).width *
                    0.04), // subtitle text color and font size
            titleSmall: TextStyle(
                color: Colors.black,
                fontSize: MediaQuery.sizeOf(context).width *
                    0.04), // subtitle text color and font size
            bodySmall: TextStyle(
                color: Colors.black,
                fontSize: MediaQuery.sizeOf(context).width *
                    0.04), // caption text color and font size
            labelLarge: TextStyle(
                color: Colors.black,
                fontSize: MediaQuery.sizeOf(context).width *
                    0.04), // button text color and font size
            labelSmall: TextStyle(
                color: Colors.black,
                fontSize: MediaQuery.sizeOf(context).width *
                    0.04), // overline text color and font size
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.black, // Change this to your desired color
          ),
          primaryColor: Colors.black, // Set primary color to blue
          colorScheme: ColorScheme.fromSwatch(

              primarySwatch: customBlack), // Use whiteswatch for color scheme
          useMaterial3: true,
        ),
        home: SplashScreen(),
      ),
    );
  }
}

const Map<int, Color> blackSwatch = {
  50: Color(0xFFE0E0E0),
  100: Color(0xFFB3B3B3),
  200: Color(0xFF808080),
  300: Color(0xFF4D4D4D),
  400: Color(0xFF262626),
  500: Color(0xFF000000),
  600: Color(0xFF000000),
  700: Color(0xFF000000),
  800: Color(0xFF000000),
  900: Color(0xFF000000),
};

MaterialColor customBlack = const MaterialColor(0xFF000000, blackSwatch);
