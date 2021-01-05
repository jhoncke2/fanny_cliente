import 'package:flutter/cupertino.dart';

class SizeUtils{

  static final SizeUtils _instance = SizeUtils._internal();
  SizeUtils._internal();
  factory SizeUtils(){
    return _instance;
  }

  Size size;
  double _xasisYasisProm;
  void initUtil(Size pSize){
    size = pSize;
    _xasisYasisProm = (size.width + size.height)/2;
  }
  double get xasisSobreYasis => _xasisYasisProm;

  Map<String, double> get headerLeftComponentPadding{
    return {
      'top': xasisSobreYasis * 0.015,
      'bottom': xasisSobreYasis * 0.015,
      'left': xasisSobreYasis * 0.04,
      'right': xasisSobreYasis * 0.025
    };
  }

  double get littleHorizontalScaffoldPadding{
    return _xasisYasisProm * 0.045;
  }

  double get normalHorizontalScaffoldPadding{
    return _xasisYasisProm * 0.09;
  }

  double get largeHorizontalScaffoldPadding{
    return _xasisYasisProm * 0.13;
  }

  /**
   * El container que contiene al listview principal de tamaño normal de un scaffold
   */
  double get normalMainListviewContainerHeight{
    return _xasisYasisProm;
  }

  double get superTitleSize{
    return _xasisYasisProm * 0.05;
  }

  double get titleSize{
    return _xasisYasisProm * 0.042;
  }

  double get littleTitleSize{
    return _xasisYasisProm * 0.038;
  }

  double get subtitleSize{
    return _xasisYasisProm * 0.032;
  }

  double get normalTextSize{
    return _xasisYasisProm * 0.027;
  }

  double get littleTextSize{
    return _xasisYasisProm * 0.022;
  }

  double get normalLabelTextSize{
    return _xasisYasisProm * 0.0345;
  }

  double get littleLabelTextSize{
    return _xasisYasisProm * 0.03;
  }

  double get littleIconSize{
    return _xasisYasisProm * 0.045;
  }

  double get normalIconSize{
    return _xasisYasisProm * 0.055;
  }

  double get largeIconSize{
    return _xasisYasisProm * 0.065;
  }

  double get extraLargeIconSize{
    return _xasisYasisProm * 0.08;
  }

  double get flatButtonTextSize{
    return _xasisYasisProm * 0.03;
  }
  
  Map<String, double> get largeFlatButtonPadding{
    return {
      'vertical':_xasisYasisProm * 0.003,
      'horizontal':_xasisYasisProm * 0.08
    };
  }

  Map<String, double> get fatLargeFlatButtonPadding{
    return {
      'vertical':_xasisYasisProm * 0.0175,
      'horizontal':_xasisYasisProm * 0.09
    };
  }

  Map<String, double> get shortFlatButtonPadding{
    return {
      'vertical':_xasisYasisProm * 0.003,
      'horizontal':_xasisYasisProm * 0.045
    };
  }

  Map<String, double> get circleButtonPadding{
    return {
      'vertical':_xasisYasisProm * 0.015,
      'horizontal':_xasisYasisProm * 0.015
    };
  }

  Map<String, dynamic> get largeIconButtonPadding{
    return {
      'vertical':_xasisYasisProm * 0.0125,
      'horizontal':_xasisYasisProm * 0.06
    };
  }

  List<double> get submitButtonPadding{
    return [
      _xasisYasisProm * 0.037,
      _xasisYasisProm * 0.004
    ];
  }

  List<double> get veryWideTextFormFieldSize{
    return [
      _xasisYasisProm * 0.6,
      _xasisYasisProm * 0.067
    ];
  }

  double get veryMuchLittleSizedBoxHeigh{
    return _xasisYasisProm * 0.008;
  }

  double get littleSizedBoxHeigh{
    return _xasisYasisProm * 0.015;
  }

  double get normalSizedBoxHeigh{
    return _xasisYasisProm * 0.04;
  }

  double get largeSizedBoxHeigh{
    return _xasisYasisProm * 0.085;
  }

  double get veryMuchLargeSizedBoxHeigh{
    return _xasisYasisProm * 0.12;
  }

  double get giantSizedBoxHeight{
    return _xasisYasisProm * 0.23;
  }

  double get selectableCircleRadius{
    return _xasisYasisProm * 0.04;
  }

  double get submitButtonBorderRadius{
    return _xasisYasisProm * 0.03;
  }

  double get normalListviewVerticalPadding{
    return _xasisYasisProm * 0.027;
  }

  Map<String, double> get mainLogoSize{
    return {
      'vertical':_xasisYasisProm * 0.45,
      'horizontal':_xasisYasisProm * 0.47
      
    };
  }

  Map<String, double> get littleMainLogoSize{
    return {
      'vertical':_xasisYasisProm * 0.35,
      'horizontal':_xasisYasisProm * 0.38
      
    };
  }

  Map<String, double> get diminuteLogoSize{
    return {
      'vertical':_xasisYasisProm * 0.09,
      'horizontal':_xasisYasisProm * 0.1
      
    };
  }

  

  double get normalMainMenuPopUpMenuItemHeigh{
    return _xasisYasisProm * 0.09;
  }

  double get littleMainMenuPopUpMenuItemHeigh{
    return _xasisYasisProm * 0.082;
  }

  double get normalMainMenuText{
    return _xasisYasisProm * 0.029;
  }

  double get littleMainMenuText{
    return _xasisYasisProm * 0.024;
  }
}