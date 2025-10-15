/*
  file: logo.dart
  functionality:
    A reusable widget that draws a circular Tic Tac Toe frame.
    Uses Flutter’s CustomPainter to render a minimalistic design containing a 3×3 grid with an “X” in the 
    top-left cell and an “O” in the bottom-right.
    The size of the logo is customizable via the [size] parameter.
  author: Hettiarachchige Mary Shenara Amodini DE SILVA (10686404)
  date created: 20/09/2025
*/

import 'package:flutter/material.dart';

// A stateless widget that renders a circular Tic Tac Toe logo.
class TicTacToeLogo extends StatelessWidget {
  final double size;
  // Creates a Tic Tac Toe logo with a configurable [size].
  const TicTacToeLogo({super.key, this.size = 150});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: Size(size, size), painter: _TicTacToePainter());
  }
}

// Custom painter responsible for drawing the Tic Tac Toe logo.
class _TicTacToePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Outer circle
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    canvas.drawCircle(center, radius, paint);

    // Shrink grid to fit inside circle with padding
    final double padding = size.width * 0.13;
    final double gridSize = size.width - (padding * 2);
    final double third = gridSize / 3;

    final double startX = padding;
    final double startY = padding;

    // Grid lines
    for (int i = 1; i < 3; i++) {
      // vertical
      canvas.drawLine(
        Offset(startX + third * i, startY),
        Offset(startX + third * i, startY + gridSize),
        paint,
      );
      // horizontal
      canvas.drawLine(
        Offset(startX, startY + third * i),
        Offset(startX + gridSize, startY + third * i),
        paint,
      );
    }

    // X in top-left
    final double xPadding = third * 0.3;
    canvas.drawLine(
      Offset(startX + xPadding, startY + xPadding),
      Offset(startX + third - xPadding, startY + third - xPadding),
      paint,
    );
    canvas.drawLine(
      Offset(startX + third - xPadding, startY + xPadding),
      Offset(startX + xPadding, startY + third - xPadding),
      paint,
    );

    // O in bottom-right
    final double oRadius = (third / 2) - (third * 0.3);
    canvas.drawCircle(
      Offset(startX + third * 2 + third / 2, startY + third * 2 + third / 2),
      oRadius,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}