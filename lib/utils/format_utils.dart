class FormatUtils {
  // Format number to specified decimal places (removes trailing zeros)
  static String formatNumber(double value, {int decimals = 4}) {
    // Handle special cases
    if (value.isNaN) return 'NaN';
    if (value.isInfinite) return value.isNegative ? '-∞' : '∞';
    if (value.abs() < 1e-15) return '0';  // Handle very small numbers as zero
    
    String result = value.toStringAsFixed(decimals);
    // Remove trailing zeros after decimal point
    if (result.contains('.')) {
      result = result.replaceAll(RegExp(r'0*$'), '');
      result = result.replaceAll(RegExp(r'\.$'), '');
    }
    return result;
  }

  // Format with sign (+ or -)
  static String formatWithSign(double value, {int decimals = 4}) {
    String sign = value >= 0 ? '+' : '';
    return '$sign${formatNumber(value, decimals: decimals)}';
  }

  // Format coefficient for equation display
  static String formatCoefficient(double value, {int decimals = 4}) {
    if (value >= 0) {
      return formatNumber(value, decimals: decimals);
    } else {
      return '(${formatNumber(value, decimals: decimals)})';
    }
  }

  // Build equation string for straight line
  static String buildStraightLineEquation(double a, double b) {
    String aStr = formatNumber(a);
    String bStr = formatNumber(b.abs());
    String sign = b >= 0 ? '+' : '-';
    return 'y = $aStr $sign ${bStr}x';
  }

  // Build equation string for quadratic
  static String buildQuadraticEquation(double a, double b, double c) {
    String aStr = formatNumber(a);
    String bStr = formatNumber(b.abs());
    String cStr = formatNumber(c.abs());
    String signB = b >= 0 ? '+' : '-';
    String signC = c >= 0 ? '+' : '-';
    
    // Full form (always showing all terms, even if coefficient is 0)
    String fullForm = 'y = $aStr $signB ${bStr}x $signC ${cStr}x²';
    
    // Simplified form (remove terms with coefficient ~0 or simplify)
    List<String> terms = [];
    
    // Constant term
    if (a.abs() > 1e-9) {
      terms.add(aStr);
    } else if (a.abs() < 1e-9 && terms.isEmpty) {
      // Keep 0 if it's the leading term
      terms.add('0');
    }
    
    // Linear term
    if (b.abs() > 1e-9) {
      if (terms.isNotEmpty && b >= 0 && terms[0] != '0') {
        terms.add('+ ${bStr}x');
      } else if (b < 0) {
        terms.add('- ${bStr}x');
      } else {
        if (terms[0] == '0') {
          terms.clear();
        }
        terms.add('${bStr}x');
      }
    }
    
    // Quadratic term
    if (c.abs() > 1e-9) {
      if (terms.isNotEmpty && c >= 0) {
        terms.add('+ ${cStr}x²');
      } else if (c < 0) {
        terms.add('- ${cStr}x²');
      } else {
        terms.add('${cStr}x²');
      }
    }
    
    String simplified = terms.isEmpty ? '0' : terms.join(' ');
    
    // Always show both forms for parabola
    // If c is essentially 0, show that it simplifies
    if (c.abs() < 1e-9) {
      return '$fullForm = $simplified';
    } else {
      return fullForm;
    }
  }

  // Build equation string for exponential (y = a * e^(bx))
  static String buildExponentialEquation(double a, double b, String type) {
    String aStr = formatNumber(a);
    String bStr = formatNumber(b);
    
    switch (type) {
      case 'e^(bx)':
        return 'y = $aStr × e^(${bStr}x)';
      case 'a×b^x':
        double base = formatNumber(b.abs()) == formatNumber(b) 
            ? double.parse(formatNumber(b)) 
            : double.parse(formatNumber(b));
        return 'y = $aStr × ${formatNumber(base)}^x';
      case 'a×x^b':
        return 'y = $aStr × x^$bStr';
      default:
        return 'y = $aStr × e^(${bStr}x)';
    }
  }

  // Format LaTeX for elimination steps
  static String buildEliminationSteps({
    required String curveType,
    required Map<String, double> sums,
    required Map<String, double> coefficients,
    required List<String> equations,
    required List<String> steps,
  }) {
    StringBuffer latex = StringBuffer();
    
    latex.writeln(r'\text{\textbf{Elimination Method Steps}}\\[8pt]');
    
    // Given data
    latex.write(r'\text{Given: }');
    sums.forEach((key, value) {
      latex.write('$key = ${formatNumber(value, decimals: 2)}, \\; ');
    });
    latex.writeln(r'\\[12pt]');
    
    // Normal equations
    latex.writeln(r'\text{\underline{Normal Equations:}}\\[6pt]');
    for (int i = 0; i < equations.length; i++) {
      latex.writeln('${equations[i]} \\qquad \\text{(${i + 1})}\\\\[4pt]');
    }
    latex.writeln(r'\\[12pt]');
    
    // Elimination steps
    for (String step in steps) {
      latex.writeln('$step\\\\[6pt]');
    }
    
    return latex.toString();
  }

  // Convert double to clean string (remove trailing zeros)
  static String cleanNumber(double value) {
    String str = value.toStringAsFixed(4);
    // Remove trailing zeros
    str = str.replaceAll(RegExp(r'\.?0+$'), '');
    return str;
  }
}
