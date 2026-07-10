import 'package:flutter/material.dart';

class GradientButton extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;
  final LinearGradient gradient;
  final Color? hoverColor; // warna saat ditekan
  final VoidCallback onPressed;
  final Widget child;

  const GradientButton({
    super.key,
    required this.width,
    required this.height,
    required this.gradient,
    required this.onPressed,
    required this.child,
    this.borderRadius = 24,
    this.hoverColor,
  });

  @override
  State<GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final decoration = BoxDecoration(
      gradient: _pressed && widget.hoverColor != null
          ? null
          : widget.gradient,
      color: _pressed && widget.hoverColor != null ? widget.hoverColor : null,
      borderRadius: BorderRadius.circular(widget.borderRadius),
      boxShadow: _pressed
          ? []
          : [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
    );

    return AnimatedScale(
      duration: const Duration(milliseconds: 120),
      scale: _pressed ? 0.97 : 1.0,
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          decoration: decoration,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              onTap: widget.onPressed,
              onTapDown: (_) => setState(() => _pressed = true),
              onTapCancel: () => setState(() => _pressed = false),
              onTapUp: (_) => setState(() => _pressed = false),
              child: Center(child: widget.child),
            ),
          ),
        ),
      ),
    );
  }
}
