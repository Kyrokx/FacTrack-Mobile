import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppColors {
  static const success = Color(0xFF16A34A);
  static const warning = Color(0xFFD97706);
  static const info = Color(0xFF2563EB);
}

class AppTheme {
  /*static const Color _primary = Color(0xFF2A5CAA);
  static const Color _accent = Color(0xFF4CAF50);
  static const Color _neutral = Color(0xFF424242);

  static const Color _text = Color(0xFF424242);
  static const Color _errorRed = Color(0xFFEF4444);
  static const Color _warningYellow = Color(0xFFFFC107);

  static const Color _scaffoldLight = Color(0xFFF5F5F5);*/

  static const Color _primary = Color(0xFF111111);
  static const Color _accent = Color(0xFF2A2A2A);
  static const Color _neutral = Color(0xFF737373);

  static const Color _text = Color(0xFF171717);
  static const Color _errorRed = Color(0xFFDC2626);
  static const Color _warningYellow = Color(0xFFD97706);

  static const Color _scaffoldLight = Color(0xFFF7F7F7);

  // --- DEFAULTMODE (Light Mode) ---
  static ThemeData get defaultTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: _primary,
      scaffoldBackgroundColor: _scaffoldLight,
      //textTheme: const TextTheme(fontFamily: 'Inter',),
      fontFamily: 'Inter',
      colorScheme: const ColorScheme.light(
        primary: _primary,
        onPrimary: Colors.white,
        secondary: _accent,
        onSecondary: Colors.white,
        tertiary: _neutral,
        onTertiary: Colors.white,
        error: _errorRed,
        surface: Colors.white,
      ),
      /// App Bar Theme
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: _primary,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      /// Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _accent,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26.0)),
        ),
      ),
      /// Drop Down Theme
      dropdownMenuTheme: DropdownMenuThemeData(
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
          filled: true,
          fillColor: Colors.grey[100],
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: _neutral, width: 1.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: _accent, width: 1.0),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(26.0),
            borderSide: const BorderSide(color: _errorRed,width: 1.0),
          ),
        ),
        menuStyle: MenuStyle(
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
          ),
          backgroundColor: WidgetStateProperty.all<Color>(_scaffoldLight),
          shadowColor: WidgetStateProperty.all<Color>(Colors.transparent),
        ),
      ),
      /// Input Theme
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
        filled: true,
        fillColor: Colors.grey[100],
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: _neutral, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: _accent, width: 1.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(26.0),
          borderSide: const BorderSide(color: _errorRed,width: 1.0),
        ),
      ),
      /// Tab Bar Theme
      tabBarTheme: TabBarThemeData(
        dividerHeight: 0.0,
        indicatorColor: _primary,
        labelColor: _primary,
        unselectedLabelColor: _neutral,
        indicatorAnimation: TabIndicatorAnimation.elastic,
      ),
      /// Divider Theme
      /*dividerTheme: DividerThemeData(
        color: _neutral,
        thickness: 5.0,
        indent:100.0,
        endIndent:100.0,
        radius: BorderRadius.circular(20.0),
      ),*/


      /*/// Text Theme

      textTheme: TextTheme(
        displayMedium: GoogleFonts.inter(
          fontSize: 45.0,
          fontWeight: FontWeight.w400,
          height: 1.15,
          letterSpacing: 0.0,
          color: _text,
        ),

        headlineMedium: GoogleFonts.inter(
          fontSize: 28.0,
          fontWeight: FontWeight.w400,
          height: 1.25,
          letterSpacing: 0.0,
          color: _text,
        ),

        titleMedium: GoogleFonts.inter(
          fontSize: 18.0,
          fontWeight: FontWeight.w500,
          height: 1.33,
          letterSpacing: 0.15,
          color: _text,
        ),

        bodyMedium: GoogleFonts.inter(
          fontSize: 16.0,
          fontWeight: FontWeight.w400,
          height: 1.5,
          letterSpacing: 0.5,
          color: _text,
        ),

        labelMedium: GoogleFonts.inter(
          fontSize: 14.0,
          fontWeight: FontWeight.w500,
          height: 1.43,
          letterSpacing: 0.5,
          color: Color(0xFF2A5CAA),
        ),
      ),*/
    );
  }
}