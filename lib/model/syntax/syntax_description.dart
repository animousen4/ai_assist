import 'package:flutter_syntax_view/flutter_syntax_view.dart';

class SyntaxDescription {
  final String themeName;
  final SyntaxTheme theme;

  SyntaxDescription(this.themeName, this.theme);
  bool operator == (Object other) {
    return (other as SyntaxDescription).themeName == themeName;
  }

  static List<SyntaxDescription> get getAllSyntaxes => [
        SyntaxDescription("Ayu Dark", SyntaxTheme.ayuDark()),
        SyntaxDescription("Ayu Light", SyntaxTheme.ayuLight()),
        SyntaxDescription("Dracula", SyntaxTheme.dracula()),
        SyntaxDescription("Gravity Dark", SyntaxTheme.gravityDark()),
        SyntaxDescription("Gravity Light", SyntaxTheme.gravityLight()),
        SyntaxDescription("Monokai Sublime", SyntaxTheme.monokaiSublime()),
        SyntaxDescription("Obsidian", SyntaxTheme.obsidian()),
        SyntaxDescription("Ocean Sunset", SyntaxTheme.oceanSunset()),
        SyntaxDescription("Standard", SyntaxTheme.standard()),
        SyntaxDescription("VsCode Dark", SyntaxTheme.vscodeDark()),
        SyntaxDescription("VsCode Light", SyntaxTheme.vscodeLight()),
      ];
}
