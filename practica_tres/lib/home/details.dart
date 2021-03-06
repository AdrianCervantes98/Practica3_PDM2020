import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:practica_tres/models/barcode_item.dart';
import 'package:practica_tres/models/image_label_item.dart';

class Details extends StatefulWidget {
  final BarcodeItem barcode;
  final ImageLabelItem imageLabeled;
  Details({
    Key key,
    this.barcode,
    this.imageLabeled,
  }) : super(key: key);

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  Uint8List imageBytes;

  @override
  Widget build(BuildContext context) {
    // convierte la string base 64 a bytes para poder pintar Image.memory(Uint8List)
    if (widget.barcode != null) {
      imageBytes = base64Decode(widget.barcode.imagenBase64);
    } else {
      imageBytes = base64Decode(widget.imageLabeled.imagenBase64);
    }

    return Scaffold(
      appBar: AppBar(title: Text("Detalles")),
      body: Center(
        child: widget.barcode == null ? label(context) : barcode(context),
      ),
    );
  }

  Widget label(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          width: 200,
          height: 200,
          child: Image.memory(imageBytes),
        ),
        Text("Similitud: ${widget.imageLabeled.similitud}"),
        Text("Identificador: ${widget.imageLabeled.identificador}"),
        Text("Texto: ${widget.imageLabeled.texto}"),
      ],
    );
  }

  Widget barcode(BuildContext context) {
    return Column(
      children: <Widget>[
        Align(
          alignment: Alignment.center,
          child: CustomPaint(
            foregroundPainter:
                RectPainter(pointsList: widget.barcode.puntosEsquinas),
            child: Image.memory(imageBytes),
          ),
        ),
        Text("Código: ${widget.barcode.codigo}"),
        Text("Tipo código: ${widget.barcode.tipoCodigo}"),
        Text("Título url: ${widget.barcode.tituloUrl}"),
        Text("Url: ${widget.barcode.url}"),
      ],
    );
  }
}

class RectPainter extends CustomPainter {
  final List<Offset> pointsList;

  RectPainter({@required this.pointsList});

  @override
  bool shouldRepaint(CustomPainter old) => false;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromPoints(pointsList[0], pointsList[2]);
    final line = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawRect(rect, line);
  }
}
