import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

final Set<Polygon> tiendaPolygons = {
      new Polygon(
        polygonId: PolygonId('1'),
        strokeWidth: 1,
        strokeColor: Colors.redAccent[400],
        fillColor: Colors.redAccent.withOpacity(0.4),
        points: <LatLng>[
          LatLng(3.4078506610619433, -76.49689139751332),
          LatLng(3.41773817203206, -76.48664787212795),
          LatLng(3.4243517169441852,-76.48536063423425),
          LatLng(3.4245915543679403, -76.47736889579466),
          LatLng(3.429602264123108, -76.47732113658524),
          LatLng(3.432105049995379, -76.4739567635709),
          LatLng(3.4392729844902074, -76.4810260253883),
          LatLng(3.4342729844902074, -76.4840260253883),
          LatLng(3.429361975982576, -76.48676990310774),
          LatLng(3.4243517169441852, -76.48894787212795),
          LatLng(3.427361975982576, -76.49294787212795),
          LatLng(3.41583817203206, -76.50489139751332),
        ]
      ),
    };