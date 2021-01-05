import 'package:flutter/material.dart';
class SizeBloc{
  Size size;
  double _xasisYasisProm;
  void initBloc(Size pSize){
    size = pSize;
    _xasisYasisProm = (size.width + size.height)/2;
  }
  double get xasisSobreYasis => _xasisYasisProm;

  double get horizontalScaffoldPadding{
    return _xasisYasisProm * 0.036;
  }

  double get topScaffoldPadding{
    return _xasisYasisProm * 0.065;
  }

  /**
   * El container que contiene al listview principal de tamaño normal de un scaffold
   */
  double get normalMainListviewContainerHeight{
    return _xasisYasisProm;
  }

  double get titleSize{
    return _xasisYasisProm * 0.044;
  }

  double get littleTitleSize{
    return _xasisYasisProm * 0.038;
  }

  double get subtitleSize{
    return _xasisYasisProm * 0.033;
  }

  double get normalTextSize{
    return _xasisYasisProm * 0.027;
  }

  double get littleTextSize{
    return _xasisYasisProm * 0.022;
  }

  double get largeIconSize{
    return _xasisYasisProm * 0.065;
  }

  double get normalIconSize{
    return _xasisYasisProm * 0.05;
  }

  double get littleIconSize{
    return _xasisYasisProm * 0.022;
  }

  double get flatButtonTextSize{
    return _xasisYasisProm * 0.038;
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

  double get littleSizedBoxHeigh{
    return _xasisYasisProm * 0.008;
  }

  double get normalSizedBoxHeigh{
    return _xasisYasisProm * 0.027;
  }

  double get largeSizedBoxHeigh{
    return _xasisYasisProm * 0.07;
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

  List<double> get mainFannyIconSize{
    return [
      _xasisYasisProm * 0.28,
      _xasisYasisProm * 0.16
    ];
  }

  double get normalMainMenuPopUpMenuItemHeigh{
    return _xasisYasisProm * 0.12;
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