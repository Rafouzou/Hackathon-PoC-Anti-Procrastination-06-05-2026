import 'package:flutter/material.dart';
import '../theme/verifi_theme.dart';

class VerifiButton extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isLoading;
  final Color backgroundColor;
  final Color textColor;
  final double? width;
  final bool isPrimary;

  const VerifiButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.backgroundColor = VerifiColors.yellow,
    this.textColor = VerifiColors.black,
    this.width,
    this.isPrimary = true,
  });

  @override
  State<VerifiButton> createState() => _VerifiButtonState();
}

class _VerifiButtonState extends State<VerifiButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width ?? double.infinity,
      height: 56,
      child: widget.isPrimary
          ? ElevatedButton(
              onPressed: widget.isLoading ? null : widget.onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.backgroundColor,
                foregroundColor: widget.textColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(VerifiRadius.medium),
                ),
                elevation: 4,
              ),
              child: widget.isLoading
                  ? const VerifiLoader(size: 24)
                  : Text(
                      widget.label,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            )
          : OutlinedButton(
              onPressed: widget.isLoading ? null : widget.onPressed,
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color: widget.textColor,
                  width: 2,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(VerifiRadius.medium),
                ),
              ),
              child: widget.isLoading
                  ? const VerifiLoader(size: 24)
                  : Text(
                      widget.label,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: widget.textColor,
                      ),
                    ),
            ),
    );
  }
}

class VerifiLoader extends StatefulWidget {
  final double size;
  final Color color;

  const VerifiLoader({
    super.key,
    this.size = 48,
    this.color = VerifiColors.black,
  });

  @override
  State<VerifiLoader> createState() => _VerifiLoaderState();
}

class _VerifiLoaderState extends State<VerifiLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _controller,
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: widget.color.withValues(alpha: 0.3),
            width: 4,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(widget.color),
            strokeWidth: 4,
          ),
        ),
      ),
    );
  }
}
