import 'package:flutter/material.dart';
import '../theme/verifi_theme.dart';

class VerifiCard extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;
  final EdgeInsets padding;
  final double borderRadius;
  final double elevation;
  final VoidCallback? onTap;

  const VerifiCard({
    super.key,
    required this.child,
    this.backgroundColor = VerifiColors.yellow,
    this.padding = const EdgeInsets.all(VerifiSpacing.md),
    this.borderRadius = VerifiRadius.medium,
    this.elevation = 4,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: elevation,
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: VerifiColors.black.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Padding(
            padding: padding,
            child: child,
          ),
        ),
      ),
    );
  }
}

class VerifiSection extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final EdgeInsets padding;

  const VerifiSection({
    super.key,
    required this.title,
    required this.children,
    this.padding = const EdgeInsets.all(VerifiSpacing.md),
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: VerifiSpacing.sm),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        ...children,
      ],
    );
  }
}
