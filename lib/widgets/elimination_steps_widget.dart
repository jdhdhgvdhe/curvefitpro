import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EliminationStepsWidget extends StatelessWidget {
  final List<Map<String, dynamic>> steps;

  const EliminationStepsWidget({
    super.key,
    required this.steps,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;
    final screenWidth = MediaQuery.of(context).size.width;
    
    // Responsive padding and font sizes
    final padding = screenWidth > 600 ? 24.0 : 16.0;
    final titleSize = screenWidth > 600 ? 20.0 : 18.0;
    final iconSize = screenWidth > 600 ? 28.0 : 24.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: double.infinity,
          constraints: BoxConstraints(
            maxWidth: screenWidth > 1200 ? 1000 : double.infinity,
          ),
          padding: EdgeInsets.all(padding),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.grey[850]?.withOpacity(0.6) ?? Colors.grey.withOpacity(0.4)
                : colorScheme.primaryContainer.withOpacity(0.2),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: colorScheme.primary.withOpacity(0.5),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: colorScheme.primary.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.calculate,
                    color: colorScheme.primary,
                    size: iconSize,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "📝 Elimination Method Steps",
                      style: GoogleFonts.poppins(
                        fontSize: titleSize,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ...steps.map((step) => _buildStep(context, step, colorScheme, isDark)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStep(BuildContext context, Map<String, dynamic> step, ColorScheme colorScheme, bool isDark) {
    try {
      switch (step['type']) {
        case 'equations':
          return _buildEquationsStep(context, step, colorScheme, isDark);
        case 'new_equations':
          return _buildNewEquationsStep(context, step, colorScheme, isDark);
        case 'multiply':
          return _buildMultiplyStep(context, step, colorScheme, isDark);
        case 'subtract':
          return _buildSubtractStep(context, step, colorScheme, isDark);
        case 'solve':
          return _buildSolveStep(context, step, colorScheme, isDark);
        case 'solve_detailed':
          return _buildSolveDetailedStep(context, step, colorScheme, isDark);
        case 'substitute':
          return _buildSubstituteStep(context, step, colorScheme, isDark);
        case 'substitute_detailed':
          return _buildSubstituteDetailedStep(context, step, colorScheme, isDark);
        case 'substitute_detailed_3x3':
          return _buildSubstituteDetailed3x3Step(context, step, colorScheme, isDark);
        case 'substitute_final':
          return _buildSubstituteFinalStep(context, step, colorScheme, isDark);
        case 'exponential_conversion':
          return _buildExponentialConversionStep(context, step, colorScheme, isDark);
        case 'final':
          return _buildFinalStep(context, step, colorScheme, isDark);
        default:
          return const SizedBox.shrink();
      }
    } catch (e) {
      // Error rendering step - show error message for debugging
      return Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.red),
        ),
        child: Text(
          'Error rendering step: ${step['type']} - ${e.toString()}',
          style: const TextStyle(color: Colors.red, fontSize: 12),
        ),
      );
    }
  }

  Widget _buildEquationsStep(BuildContext context, Map<String, dynamic> step, ColorScheme colorScheme, bool isDark) {
    final equations = step['equations'] as List?;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${step['title']}',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          if (equations != null)
            ...equations.map((eq) => _buildEquation(context, eq, colorScheme, isDark)),
        ],
      ),
    );
  }

  Widget _buildNewEquationsStep(BuildContext context, Map<String, dynamic> step, ColorScheme colorScheme, bool isDark) {
    final equations = step['equations'] as List?;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green, width: 2),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.new_releases, color: Colors.green, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      '${step['title']}',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade800,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (equations != null)
                  ...equations.map((eq) => _buildEquation(context, eq, colorScheme, isDark)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEquation(BuildContext context, Map<String, dynamic> eq, ColorScheme colorScheme, bool isDark, {bool hasLabel = true}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[800]?.withOpacity(0.5) ?? Colors.black26 : Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colorScheme.primary.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildEquationContent(eq, colorScheme),
          ),
          if (hasLabel && eq['label'] != null) ...[
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '${eq['label']}',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
            ),
          ]
        ],
      ),
    );
  }

  Widget _buildEquationContent(Map<String, dynamic> eq, ColorScheme colorScheme) {
    List<Widget> children = [];

    // Helper to safely convert to double
    double _toDouble(dynamic value) {
      if (value is int) return value.toDouble();
      if (value is double) return value;
      return 0.0;
    }

    if (eq['coeff'] != null && _toDouble(eq['coeff']).abs() > 1e-9) {
      children.add(_buildCoefficient(eq['coeff'], colorScheme));
      if (eq['var'] != null) children.add(_buildVariable(eq['var'], colorScheme));
    }

    if (eq['coeff2'] != null && _toDouble(eq['coeff2']).abs() > 1e-9) {
      if (children.isNotEmpty) children.add(_buildOperator(_toDouble(eq['coeff2']) >= 0 ? '+' : '-', colorScheme));
      children.add(_buildCoefficient(_toDouble(eq['coeff2']).abs(), colorScheme));
      if (eq['var2'] != null) children.add(_buildVariable(eq['var2'], colorScheme));
    }

    if (eq['coeff3'] != null && _toDouble(eq['coeff3']).abs() > 1e-9) {
      if (children.isNotEmpty) children.add(_buildOperator(_toDouble(eq['coeff3']) >= 0 ? '+' : '-', colorScheme));
      children.add(_buildCoefficient(_toDouble(eq['coeff3']).abs(), colorScheme));
      if (eq['var3'] != null) children.add(_buildVariable(eq['var3'], colorScheme));
    }

    if (children.isEmpty) {
      children.add(_buildCoefficient(0.0, colorScheme));
    }

    if (eq['result'] != null) {
      children.add(_buildOperator('=', colorScheme));
      children.add(_buildCoefficient(eq['result'], colorScheme));
    }

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: children,
    );
  }

  Widget _buildCoefficient(dynamic value, ColorScheme colorScheme) {
    if (value == null) return const SizedBox.shrink();
    
    // Safely convert to double
    double doubleValue;
    if (value is int) {
      doubleValue = value.toDouble();
    } else if (value is double) {
      doubleValue = value;
    } else {
      return const SizedBox.shrink();
    }
    
    return Text(
      _formatNumber(doubleValue),
      style: GoogleFonts.robotoMono(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: colorScheme.onSurface,
      ),
    );
  }

  Widget _buildVariable(String variable, ColorScheme colorScheme) {
    Color varColor;
    switch (variable) {
      case 'a': varColor = Colors.blue.shade600; break;
      case 'b': varColor = Colors.red.shade600; break;
      case 'c': varColor = Colors.green.shade600; break;
      default: varColor = colorScheme.primary;
    }
    
    return Text(
      variable,
      style: GoogleFonts.robotoMono(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: varColor,
      ),
    );
  }

  Widget _buildOperator(String op, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        op,
        style: GoogleFonts.robotoMono(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: colorScheme.onSurface,
        ),
      ),
    );
  }

  Widget _buildMultiplyStep(BuildContext context, Map<String, dynamic> step, ColorScheme colorScheme, bool isDark) {
    final equation = step['equation'] as Map<String, dynamic>?;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${step['title']}',
            style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: colorScheme.onSurface),
          ),
          if (step['subtitle'] != null) ...[
            const SizedBox(height: 4),
            Text(
              '${step['subtitle']}',
              style: GoogleFonts.poppins(fontSize: 12, color: colorScheme.onSurface.withOpacity(0.7)),
            ),
          ],
          const SizedBox(height: 8),
          if (equation != null) _buildEquation(context, equation, colorScheme, isDark),
        ],
      ),
    );
  }

  Widget _buildSubtractStep(BuildContext context, Map<String, dynamic> step, ColorScheme colorScheme, bool isDark) {
    final eq1 = step['equation1'] as Map<String, dynamic>?;
    final eq2 = step['equation2'] as Map<String, dynamic>?;
    final result = step['result'] as Map<String, dynamic>?;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${step['title']}',
            style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: colorScheme.onSurface),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[800]?.withOpacity(0.5) ?? Colors.black26 : Colors.white.withOpacity(0.7),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: colorScheme.error.withOpacity(0.5)),
            ),
            child: Column(
              children: [
                if (eq1 != null) _buildEquation(context, eq1, colorScheme, isDark),
                if (eq2 != null)
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Text('-', style: GoogleFonts.robotoMono(fontSize: 16, fontWeight: FontWeight.bold, color: colorScheme.error)),
                      ),
                      Expanded(child: _buildEquation(context, eq2, colorScheme, isDark)),
                    ],
                  ),
                if (result != null) ...[
                  Divider(color: colorScheme.onSurface.withOpacity(0.3), thickness: 1, height: 20),
                  _buildEquation(context, result, colorScheme, isDark),
                ]
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSolveStep(BuildContext context, Map<String, dynamic> step, ColorScheme colorScheme, bool isDark) {
    final equation = step['equation'] as Map<String, dynamic>?;
    final variable = step['variable'] as String?;
    final solution = step['solution'] as double?;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${step['title']}',
            style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: colorScheme.onSurface),
          ),
          const SizedBox(height: 8),
          if (equation != null && variable != null && solution != null)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.lightBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.lightBlue.withOpacity(0.5)),
              ),
              child: Row(
                children: [
                  Expanded(child: _buildEquationContent(equation, colorScheme)),
                  const SizedBox(width: 12),
                  const Icon(Icons.arrow_forward, size: 16, color: Colors.grey),
                  const SizedBox(width: 12),
                  _buildVariable(variable, colorScheme),
                  _buildOperator('=', colorScheme),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.lightBlue.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      _formatNumber(solution),
                      style: GoogleFonts.robotoMono(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blue.shade800),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSubstituteStep(BuildContext context, Map<String, dynamic> step, ColorScheme colorScheme, bool isDark) {
    final equation = step['equation'] as Map<String, dynamic>?;
    final result = step['result'] as Map<String, dynamic>?;
    final variable = step['variable'] as String?;
    final solution = step['solution'] as double?;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${step['title']}',
            style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: colorScheme.onSurface),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.pink.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.pink.withOpacity(0.5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (equation != null) _buildEquation(context, equation, colorScheme, isDark),
                if (result != null) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.arrow_forward, size: 16, color: Colors.grey),
                      const SizedBox(width: 8),
                      _buildEquationContent(result, colorScheme),
                    ],
                  ),
                ],
                if (variable != null && solution != null) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.arrow_forward, size: 16, color: Colors.grey),
                      const SizedBox(width: 8),
                      _buildVariable(variable, colorScheme),
                      _buildOperator('=', colorScheme),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.pink.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          _formatNumber(solution),
                          style: GoogleFonts.robotoMono(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.pink.shade800),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubstituteFinalStep(BuildContext context, Map<String, dynamic> step, ColorScheme colorScheme, bool isDark) {
    final equation = step['equation'] as Map<String, dynamic>?;
    final intermediate = step['intermediate'] as String?;
    final finalStep = step['final_step'] as String?;
    final variable = step['variable'] as String?;
    final solution = step['solution'] as double?;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${step['title']}',
            style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: colorScheme.onSurface),
          ),
          if (step['subtitle'] != null) ...[
            const SizedBox(height: 4),
            Text(
              '${step['subtitle']}',
              style: GoogleFonts.poppins(fontSize: 12, color: colorScheme.onSurface.withOpacity(0.7)),
            ),
          ],
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.purple.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.purple.withOpacity(0.5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (equation != null) _buildEquation(context, equation, colorScheme, isDark),
                if (intermediate != null) ...[
                  const SizedBox(height: 8),
                  Text(intermediate, style: GoogleFonts.robotoMono(fontSize: 13, color: colorScheme.onSurface)),
                ],
                if (finalStep != null) ...[
                  const SizedBox(height: 4),
                  Text(finalStep, style: GoogleFonts.robotoMono(fontSize: 13, color: colorScheme.onSurface)),
                ],
                if (variable != null && solution != null) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.arrow_forward, size: 16, color: Colors.grey),
                      const SizedBox(width: 8),
                      _buildVariable(variable, colorScheme),
                      _buildOperator('=', colorScheme),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.purple.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          _formatNumber(solution),
                          style: GoogleFonts.robotoMono(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.purple.shade800),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinalStep(BuildContext context, Map<String, dynamic> step, ColorScheme colorScheme, bool isDark) {
    final solutions = step['solutions'] as List?;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${step['title']}',
            style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: colorScheme.onSurface),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.orange.withOpacity(0.5), width: 2),
            ),
            child: Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 16,
              runSpacing: 8,
              children: [
                const Text('∴', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                if (solutions != null)
                  ...solutions.map((solution) {
                    final variable = solution['var'] as String?;
                    final value = solution['value'] as double?;
                    if (variable == null || value == null) return const SizedBox.shrink();
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildVariable(variable, colorScheme),
                        _buildOperator('=', colorScheme),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            _formatNumber(value),
                            style: GoogleFonts.robotoMono(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.orange.shade800),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSolveDetailedStep(BuildContext context, Map<String, dynamic> step, ColorScheme colorScheme, bool isDark) {
    final equation = step['equation'] as Map<String, dynamic>?;
    final division = step['division'] as Map<String, dynamic>?;
    final variable = step['variable'] as String?;
    final solution = step['solution'] as double?;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${step['title']}',
            style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: colorScheme.onSurface),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.lightBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.lightBlue.withOpacity(0.5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (equation != null) ...[
                  Text(_formatEquationText(equation), style: GoogleFonts.robotoMono(fontSize: 14, color: colorScheme.onSurface)),
                  const SizedBox(height: 8),
                ],
                if (division != null) ...[
                  const Icon(Icons.arrow_downward, size: 16, color: Colors.grey),
                  const SizedBox(height: 4),
                  Text(
                    'Divide both sides by ${_formatNumber(division['denominator'])}:',
                    style: GoogleFonts.poppins(fontSize: 12, color: Colors.blue.shade700, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${variable} = ${_formatNumber(division['numerator'])} ÷ ${_formatNumber(division['denominator'])}',
                    style: GoogleFonts.robotoMono(fontSize: 14, color: colorScheme.onSurface),
                  ),
                  const SizedBox(height: 8),
                ],
                if (variable != null && solution != null) ...[
                  Row(
                    children: [
                      _buildVariable(variable, colorScheme),
                      _buildOperator('=', colorScheme),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.lightBlue.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          _formatNumber(solution),
                          style: GoogleFonts.robotoMono(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blue.shade800),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubstituteDetailedStep(BuildContext context, Map<String, dynamic> step, ColorScheme colorScheme, bool isDark) {
    final originalEq = step['originalEquation'] as Map<String, dynamic>?;
    final substitution = step['substitution'] as Map<String, dynamic>?;
    final afterSub = step['afterSubstitution'] as Map<String, dynamic>?;
    final simplified = step['simplified'] as Map<String, dynamic>?;
    final division = step['division'] as Map<String, dynamic>?;
    final variable = step['variable'] as String?;
    final solution = step['solution'] as double?;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${step['title']}',
            style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: colorScheme.onSurface),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.pink.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.pink.withOpacity(0.5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (originalEq != null) ...[
                  Text('Original equation:', style: GoogleFonts.poppins(fontSize: 12, color: isDark ? Colors.grey : (Colors.grey[700] ?? Colors.grey))),
                  const SizedBox(height: 4),
                  Text(_formatEquationText(originalEq), style: GoogleFonts.robotoMono(fontSize: 14, color: colorScheme.onSurface)),
                  const SizedBox(height: 8),
                ],
                if (substitution != null) ...[
                  const Icon(Icons.arrow_downward, size: 16, color: Colors.grey),
                  const SizedBox(height: 4),
                  Text(
                    'Put ${substitution['var']} = ${_formatNumber(substitution['value'])}:',
                    style: GoogleFonts.poppins(fontSize: 12, color: Colors.pink.shade700, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 4),
                  if (afterSub != null)
                    Text(
                      '${_formatNumber(afterSub['coeff'])}${afterSub['var']} + ${_formatNumber(afterSub['constant'])} = ${_formatNumber(afterSub['result'])}',
                      style: GoogleFonts.robotoMono(fontSize: 14, color: colorScheme.onSurface),
                    ),
                  const SizedBox(height: 8),
                ],
                if (simplified != null) ...[
                  const Icon(Icons.arrow_downward, size: 16, color: Colors.grey),
                  const SizedBox(height: 4),
                  Text('Simplify:', style: GoogleFonts.poppins(fontSize: 12, color: Colors.pink.shade700, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 4),
                  Text(
                    '${_formatNumber(simplified['coeff'])}${simplified['var']} = ${_formatNumber(simplified['result'])}',
                    style: GoogleFonts.robotoMono(fontSize: 14, color: colorScheme.onSurface),
                  ),
                  const SizedBox(height: 8),
                ],
                if (division != null) ...[
                  const Icon(Icons.arrow_downward, size: 16, color: Colors.grey),
                  const SizedBox(height: 4),
                  Text(
                    'Divide both sides by ${_formatNumber(division['denominator'])}:',
                    style: GoogleFonts.poppins(fontSize: 12, color: Colors.pink.shade700, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${variable} = ${_formatNumber(division['numerator'])} ÷ ${_formatNumber(division['denominator'])}',
                    style: GoogleFonts.robotoMono(fontSize: 14, color: colorScheme.onSurface),
                  ),
                  const SizedBox(height: 8),
                ],
                if (variable != null && solution != null) ...[
                  Row(
                    children: [
                      _buildVariable(variable, colorScheme),
                      _buildOperator('=', colorScheme),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.pink.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          _formatNumber(solution),
                          style: GoogleFonts.robotoMono(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.pink.shade800),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubstituteDetailed3x3Step(BuildContext context, Map<String, dynamic> step, ColorScheme colorScheme, bool isDark) {
    final originalEq = step['originalEquation'] as Map<String, dynamic>?;
    final substitutions = step['substitutions'] as List?;
    final afterSub = step['afterSubstitution'] as Map<String, dynamic>?;
    final simplified = step['simplified'] as Map<String, dynamic>?;
    final division = step['division'] as Map<String, dynamic>?;
    final variable = step['variable'] as String?;
    final solution = step['solution'] as double?;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${step['title']}',
            style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: colorScheme.onSurface),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.purple.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.purple.withOpacity(0.5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (originalEq != null) ...[
                  Text('Original equation:', style: GoogleFonts.poppins(fontSize: 12, color: isDark ? Colors.grey : (Colors.grey[700] ?? Colors.grey))),
                  const SizedBox(height: 4),
                  Text(_formatEquationText(originalEq), style: GoogleFonts.robotoMono(fontSize: 14, color: colorScheme.onSurface)),
                  const SizedBox(height: 8),
                ],
                if (substitutions != null) ...[
                  const Icon(Icons.arrow_downward, size: 16, color: Colors.grey),
                  const SizedBox(height: 4),
                  ...substitutions.map((sub) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      'Put ${sub['var']} = ${_formatNumber(sub['value'])}: ${_formatNumber(sub['coeff'])} × ${_formatNumber(sub['value'])} = ${_formatNumber(sub['product'])}',
                      style: GoogleFonts.poppins(fontSize: 12, color: Colors.purple.shade700, fontWeight: FontWeight.w500),
                    ),
                  )),
                  const SizedBox(height: 4),
                  if (afterSub != null)
                    Text(
                      '${_formatNumber(afterSub['coeff'])}${afterSub['var']} + ${_formatNumber(afterSub['constant'])} = ${_formatNumber(afterSub['result'])}',
                      style: GoogleFonts.robotoMono(fontSize: 14, color: colorScheme.onSurface),
                    ),
                  const SizedBox(height: 8),
                ],
                if (simplified != null) ...[
                  const Icon(Icons.arrow_downward, size: 16, color: Colors.grey),
                  const SizedBox(height: 4),
                  Text('Simplify:', style: GoogleFonts.poppins(fontSize: 12, color: Colors.purple.shade700, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 4),
                  Text(
                    '${_formatNumber(simplified['coeff'])}${simplified['var']} = ${_formatNumber(simplified['result'])}',
                    style: GoogleFonts.robotoMono(fontSize: 14, color: colorScheme.onSurface),
                  ),
                  const SizedBox(height: 8),
                ],
                if (division != null) ...[
                  const Icon(Icons.arrow_downward, size: 16, color: Colors.grey),
                  const SizedBox(height: 4),
                  Text(
                    'Divide both sides by ${_formatNumber(division['denominator'])}:',
                    style: GoogleFonts.poppins(fontSize: 12, color: Colors.purple.shade700, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${variable} = ${_formatNumber(division['numerator'])} ÷ ${_formatNumber(division['denominator'])}',
                    style: GoogleFonts.robotoMono(fontSize: 14, color: colorScheme.onSurface),
                  ),
                  const SizedBox(height: 8),
                ],
                if (variable != null && solution != null) ...[
                  Row(
                    children: [
                      _buildVariable(variable, colorScheme),
                      _buildOperator('=', colorScheme),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.purple.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          _formatNumber(solution),
                          style: GoogleFonts.robotoMono(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.purple.shade800),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatEquationText(Map<String, dynamic> eq) {
    List<String> terms = [];
    
    // First term (coefficient a)
    if (eq['coeff'] != null && (eq['coeff'] as double).abs() > 1e-9) {
      String coeff = _formatNumber(eq['coeff']);
      String var1 = eq['var'] ?? '';
      terms.add('$coeff$var1');
    }
    
    // Second term (coefficient b)
    if (eq['coeff2'] != null && (eq['coeff2'] as double).abs() > 1e-9) {
      double val = eq['coeff2'] as double;
      String sign = val >= 0 ? '+' : '-';
      String coeff = _formatNumber(val.abs());
      String var2 = eq['var2'] ?? '';
      if (terms.isNotEmpty) {
        terms.add('$sign $coeff$var2');
      } else {
        terms.add('${val < 0 ? '-' : ''}$coeff$var2');
      }
    }
    
    // Third term (coefficient c)
    if (eq['coeff3'] != null && (eq['coeff3'] as double).abs() > 1e-9) {
      double val = eq['coeff3'] as double;
      String sign = val >= 0 ? '+' : '-';
      String coeff = _formatNumber(val.abs());
      String var3 = eq['var3'] ?? '';
      if (terms.isNotEmpty) {
        terms.add('$sign $coeff$var3');
      } else {
        terms.add('${val < 0 ? '-' : ''}$coeff$var3');
      }
    }
    
    String leftSide = terms.isEmpty ? '0' : terms.join(' ');
    
    // Result (right side of equation)
    if (eq['result'] != null) {
      String result = _formatNumber(eq['result']);
      String label = eq['label'] != null ? ' ${eq['label']}' : '';
      return '$leftSide = $result$label';
    }
    
    return leftSide;
  }

  Widget _buildExponentialConversionStep(BuildContext context, Map<String, dynamic> step, ColorScheme colorScheme, bool isDark) {
    final conversions = step['conversions'] as List?;
    
    // Check if any conversion uses antilog10
    bool hasAntilog = false;
    if (conversions != null) {
      for (var conv in conversions) {
        String operation = conv['operation'] as String? ?? '';
        if (operation.contains('antilog10')) {
          hasAntilog = true;
          break;
        }
      }
    }
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.teal.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.teal, width: 2),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.transform, color: Colors.teal, size: 24),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${step['title']}',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal.shade800,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (conversions != null)
                  ...conversions.map((conv) {
                    String varName = conv['variable'] as String;
                    double logValue = conv['logValue'] as double;
                    String finalVar = conv['finalVariable'] as String;
                    double finalValue = conv['finalValue'] as double;
                    
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isDark ? (Colors.grey[800] ?? Colors.black87) : Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.teal.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          Text(
                            '$varName = ${_formatNumber(logValue, decimals: 4)}',
                            style: GoogleFonts.robotoMono(
                              fontSize: 14,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Icon(Icons.arrow_forward, size: 16, color: Colors.teal),
                          const SizedBox(width: 12),
                          Text(
                            '$finalVar = ${_formatNumber(finalValue, decimals: 4)}',
                            style: GoogleFonts.robotoMono(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal.shade700,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                // Calculator note - only show if antilog10 is used
                if (hasAntilog) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.amber.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.amber.shade700, width: 1),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.calculate, size: 16, color: Colors.amber.shade800),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Note: To find antilog10 in fx82ms, press shift+log (value)',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.amber.shade900,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatNumber(double value, {int decimals = 3}) {
    if (value.isNaN || value.isInfinite) return 'Error';
    if (value.abs() < 1e-9) return '0';
    String result = value.toStringAsFixed(decimals);
    if (result.contains('.')) {
      result = result.replaceAll(RegExp(r'0*$'), '');
      if (result.endsWith('.')) {
        result = result.substring(0, result.length - 1);
      }
    }
    return result;
  }
}
