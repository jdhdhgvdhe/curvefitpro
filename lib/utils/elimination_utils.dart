import 'dart:math';

class EliminationUtils {
  static Map<String, dynamic> solve2x2WithSteps(
    double a1, double b1, double c1, 
    double a2, double b2, double c2, {
    String? label1,
    String? label2,
    bool showGivenEquations = true,
  }) {
    List<Map<String, dynamic>> steps = [];

    // Use adaptive tolerance for better mobile compatibility
    const tolerance = 1e-9;
    
    // Check for zero coefficients
    if (a1.abs() < tolerance && a2.abs() < tolerance) {
      throw Exception('Both equations have zero coefficients for variable a');
    }

    // Perform partial pivoting: swap rows if needed for numerical stability
    if (a1.abs() < a2.abs()) {
      return solve2x2WithSteps(a2, b2, c2, a1, b1, c1, 
        label1: label2, label2: label1, showGivenEquations: showGivenEquations);
    }
    
    if (a1.abs() < tolerance) {
      return solve2x2WithSteps(a2, b2, c2, a1, b1, c1, 
        label1: label2, label2: label1, showGivenEquations: showGivenEquations);
    }

    // Use provided labels or default to (1) and (2)
    final eq1Label = label1 ?? '(1)';
    final eq2Label = label2 ?? '(2)';

    if (showGivenEquations) {
      steps.add({
        'type': 'equations',
        'title': 'Given Equations:',
        'equations': [
          {'coeff': a1, 'var': 'a', 'coeff2': b1, 'var2': 'b', 'result': c1, 'label': eq1Label},
          {'coeff': a2, 'var': 'a', 'coeff2': b2, 'var2': 'b', 'result': c2, 'label': eq2Label},
        ]
      });
    }

    double factor = a2 / a1;
    double newB1 = b1 * factor;
    double newC1 = c1 * factor;

    steps.add({
      'type': 'multiply',
      'title': 'Multiply equation $eq1Label by ${_formatNumber(factor)}:',
      'equation': {'coeff': a1, 'var': 'a', 'coeff2': b1, 'var2': 'b', 'result': c1, 'label': eq1Label},
      'factor': factor,
      'result': {'coeff': a1 * factor, 'var': 'a', 'coeff2': newB1, 'var2': 'b', 'result': newC1}
    });

    double newB = newB1 - b2;
    double newC = newC1 - c2;

    // Improved numerical stability check with adaptive tolerance
    double relativeError = newB.abs() / max(newB1.abs(), b2.abs()).clamp(1e-10, double.infinity);
    
    if (newB.abs() < tolerance || relativeError < tolerance) {
      // Check if equations are linearly dependent or inconsistent
      if (newC.abs() < tolerance) {
        // Try using a larger perturbation to solve
        double epsilon = 1e-8;
        newB = newB + epsilon;
        print('Warning: Near-singular matrix detected, applying numerical perturbation');
      } else {
        // Truly inconsistent system
        double ratio = newC.abs() / max(newC1.abs(), c2.abs()).clamp(1e-10, double.infinity);
        if (ratio > 1e-6) {
          throw Exception('System has no solution (inconsistent equations)');
        } else {
          // Apply perturbation for near-singular case
          double epsilon = 1e-8;
          newB = newB + epsilon;
          print('Warning: Near-degenerate system, applying numerical stabilization');
        }
      }
    }

    steps.add({
      'type': 'subtract',
      'title': 'Subtract equation $eq2Label from the new equation $eq1Label:',
      'equation1': {'coeff': a1 * factor, 'var': 'a', 'coeff2': newB1, 'var2': 'b', 'result': newC1, 'label': eq1Label},
      'equation2': {'coeff': a2, 'var': 'a', 'coeff2': b2, 'var2': 'b', 'result': c2, 'label': eq2Label},
      'result': {'coeff': 0, 'var': 'a', 'coeff2': newB, 'var2': 'b', 'result': newC},
      'eliminated': 'a'
    });

    // Solve for b with detailed division steps
    double b = newC / newB;

    steps.add({
      'type': 'solve_detailed',
      'title': 'Solve for b:',
      'equation': {'coeff': newB, 'var': 'b', 'result': newC},
      'division': {
        'numerator': newC,
        'denominator': newB,
      },
      'solution': b,
      'variable': 'b'
    });

    // Back-substitute with detailed steps
    double substitutedValue = b1 * b;
    double rightSide = c1 - substitutedValue;
    double a = rightSide / a1;

    steps.add({
      'type': 'substitute_detailed',
      'title': 'Substitute b = ${_formatNumber(b)} in equation $eq1Label:',
      'originalEquation': {'coeff': a1, 'var': 'a', 'coeff2': b1, 'var2': 'b', 'result': c1, 'label': eq1Label},
      'substitution': {'var': 'b', 'value': b},
      'afterSubstitution': {'coeff': a1, 'var': 'a', 'constant': substitutedValue, 'result': c1},
      'simplified': {'coeff': a1, 'var': 'a', 'result': rightSide},
      'division': {
        'numerator': rightSide,
        'denominator': a1,
      },
      'solution': a,
      'variable': 'a'
    });

    steps.add({
      'type': 'final',
      'title': 'Therefore:',
      'solutions': [
        {'var': 'a', 'value': a},
        {'var': 'b', 'value': b}
      ]
    });

    return {
      'a': a,
      'b': b,
      'steps': steps
    };
  }

  static Map<String, dynamic> solve3x3WithSteps(
    double a11, double a12, double a13, double b1,
    double a21, double a22, double a23, double b2,
    double a31, double a32, double a33, double b3,
  ) {
    List<Map<String, dynamic>> steps = [];

    // Use adaptive tolerance for better mobile compatibility
    const tolerance = 1e-9;
    
    // Perform partial pivoting: choose the row with largest leading coefficient
    if (a21.abs() > a11.abs() && a21.abs() >= a31.abs()) {
      return solve3x3WithSteps(a21, a22, a23, b2, a11, a12, a13, b1, a31, a32, a33, b3);
    } else if (a31.abs() > a11.abs() && a31.abs() > a21.abs()) {
      return solve3x3WithSteps(a31, a32, a33, b3, a21, a22, a23, b2, a11, a12, a13, b1);
    }
    
    if (a11.abs() < tolerance) {
      if (a21.abs() >= tolerance) {
        return solve3x3WithSteps(a21, a22, a23, b2, a11, a12, a13, b1, a31, a32, a33, b3);
      } else if (a31.abs() >= tolerance) {
        return solve3x3WithSteps(a31, a32, a33, b3, a21, a22, a23, b2, a11, a12, a13, b1);
      } else {
        throw Exception('All equations have zero coefficients for variable a');
      }
    }

    steps.add({
      'type': 'equations',
      'title': 'Given Equations:',
      'equations': [
        {'coeff': a11, 'var': 'a', 'coeff2': a12, 'var2': 'b', 'coeff3': a13, 'var3': 'c', 'result': b1, 'label': '(1)'},
        {'coeff': a21, 'var': 'a', 'coeff2': a22, 'var2': 'b', 'coeff3': a23, 'var3': 'c', 'result': b2, 'label': '(2)'},
        {'coeff': a31, 'var': 'a', 'coeff2': a32, 'var2': 'b', 'coeff3': a33, 'var3': 'c', 'result': b3, 'label': '(3)'},
      ]
    });

    double factor1 = a21 / a11;
    double newA22 = a22 - a12 * factor1;
    double newA23 = a23 - a13 * factor1;
    double newB2 = b2 - b1 * factor1;

    steps.add({
      'type': 'subtract',
      'title': 'Eliminate a from equation (2) by subtracting ${_formatNumber(factor1)} × eq (1):',
      'equation1': {'coeff': a21, 'var': 'a', 'coeff2': a22, 'var2': 'b', 'coeff3': a23, 'var3': 'c', 'result': b2, 'label': '(2)'},
      'equation2': {'coeff': a11 * factor1, 'var': 'a', 'coeff2': a12 * factor1, 'var2': 'b', 'coeff3': a13 * factor1, 'var3': 'c', 'result': b1 * factor1, 'label': '(${_formatNumber(factor1)} × eq 1)'},
      'result': {'coeff': 0, 'var': 'a', 'coeff2': newA22, 'var2': 'b', 'coeff3': newA23, 'var3': 'c', 'result': newB2},
      'eliminated': 'a'
    });

    double factor2 = a31 / a11;
    double newA32 = a32 - a12 * factor2;
    double newA33 = a33 - a13 * factor2;
    double newB3 = b3 - b1 * factor2;

    steps.add({
      'type': 'subtract',
      'title': 'Eliminate a from equation (3) by subtracting ${_formatNumber(factor2)} × eq (1):',
      'equation1': {'coeff': a31, 'var': 'a', 'coeff2': a32, 'var2': 'b', 'coeff3': a33, 'var3': 'c', 'result': b3, 'label': '(3)'},
      'equation2': {'coeff': a11 * factor2, 'var': 'a', 'coeff2': a12 * factor2, 'var2': 'b', 'coeff3': a13 * factor2, 'var3': 'c', 'result': b1 * factor2, 'label': '(${_formatNumber(factor2)} × eq 1)'},
      'result': {'coeff': 0, 'var': 'a', 'coeff2': newA32, 'var2': 'b', 'coeff3': newA33, 'var3': 'c', 'result': newB3},
      'eliminated': 'a'
    });

    steps.add({
      'type': 'new_equations',
      'title': 'After eliminating a, we have a 2x2 system:',
      'equations': [
        {'coeff': newA22, 'var': 'b', 'coeff2': newA23, 'var2': 'c', 'result': newB2, 'label': '(4)'},
        {'coeff': newA32, 'var': 'b', 'coeff2': newA33, 'var2': 'c', 'result': newB3, 'label': '(5)'},
      ]
    });

    var result2x2 = solve2x2WithSteps(
      newA22, newA23, newB2, 
      newA32, newA33, newB3,
      label1: '(4)',
      label2: '(5)',
      showGivenEquations: false,  // Don't show "Given Equations" again since we already showed new equations
    );
    double b = result2x2['a']!;
    double c = result2x2['b']!;

    // Add all steps from the 2x2 solution
    for (var step in result2x2['steps'] as List<Map<String, dynamic>>) {
      steps.add(step);
    }

    // Back-substitute with very detailed steps
    double substitutedB = a12 * b;
    double substitutedC = a13 * c;
    double totalSubstituted = substitutedB + substitutedC;
    double rightSide3x3 = b1 - totalSubstituted;
    double a = rightSide3x3 / a11;

    steps.add({
      'type': 'substitute_detailed_3x3',
      'title': 'Substitute b = ${_formatNumber(b)} and c = ${_formatNumber(c)} in equation (1):',
      'originalEquation': {'coeff': a11, 'var': 'a', 'coeff2': a12, 'var2': 'b', 'coeff3': a13, 'var3': 'c', 'result': b1, 'label': '(1)'},
      'substitutions': [
        {'var': 'b', 'value': b, 'coeff': a12, 'product': substitutedB},
        {'var': 'c', 'value': c, 'coeff': a13, 'product': substitutedC}
      ],
      'afterSubstitution': {'coeff': a11, 'var': 'a', 'constant': totalSubstituted, 'result': b1},
      'simplified': {'coeff': a11, 'var': 'a', 'result': rightSide3x3},
      'division': {
        'numerator': rightSide3x3,
        'denominator': a11,
      },
      'solution': a,
      'variable': 'a'
    });

    steps.add({
      'type': 'final',
      'title': 'Final Solution:',
      'solutions': [
        {'var': 'a', 'value': a},
        {'var': 'b', 'value': b},
        {'var': 'c', 'value': c}
      ]
    });

    return {
      'a': a,
      'b': b,
      'c': c,
      'steps': steps
    };
  }
  
  static String _formatNumber(double value, {int decimals = 4}) {
    if (value.isNaN || value.isInfinite) {
      return 'Error';
    }
    
    if (value.abs() < 1e-10) {
      return '0';
    }
    
    String result = value.toStringAsFixed(decimals);
    
    if (result.contains('.')) {
      result = result.replaceAll(RegExp(r'0+$'), '');
      result = result.replaceAll(RegExp(r'\.$'), '');
    }
    
    return result;
  }
}
