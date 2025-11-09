import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EquationBox extends StatelessWidget {
  final String equation;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? textColor;

  const EquationBox({
    super.key,
    required this.equation,
    this.backgroundColor,
    this.borderColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      constraints: const BoxConstraints(
        minHeight: 100,
      ),
      decoration: BoxDecoration(
        color: backgroundColor ??
            (isDark
                ? colorScheme.primaryContainer.withValues(alpha: 0.3)
                : colorScheme.primaryContainer.withValues(alpha: 0.2)),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: borderColor ?? colorScheme.primary,
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: (borderColor ?? colorScheme.primary).withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            Icons.functions,
            size: 32,
            color: borderColor ?? colorScheme.primary,
          ),
          const SizedBox(height: 12),
          Text(
            'Final Equation',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: textColor ?? colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Flexible(
            child: SelectableText(
              equation,
              style: GoogleFonts.robotoMono(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: textColor ?? colorScheme.primary,
                letterSpacing: 1.2,
              ),
              textAlign: TextAlign.center,
              maxLines: 3,
            ),
          ),
        ],
      ),
    );
  }
}
