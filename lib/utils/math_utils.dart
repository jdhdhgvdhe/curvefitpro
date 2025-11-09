import 'dart:math';

class MathUtils {
  // Sum of list
  static double sum(List<double> values) {
    return values.isEmpty ? 0 : values.reduce((a, b) => a + b);
  }

  // Sum of squares
  static double sumSquares(List<double> values) {
    return values.map((x) => x * x).reduce((a, b) => a + b);
  }

  // Sum of products
  static double sumProduct(List<double> x, List<double> y) {
    double result = 0;
    for (int i = 0; i < x.length; i++) {
      result += x[i] * y[i];
    }
    return result;
  }

  // Sum of x^n
  static double sumPower(List<double> values, int power) {
    return values.map((x) => pow(x, power).toDouble()).reduce((a, b) => a + b);
  }

  // Sum of x^n * y
  static double sumPowerTimesY(List<double> x, List<double> y, int power) {
    double result = 0;
    for (int i = 0; i < x.length; i++) {
      result += pow(x[i], power).toDouble() * y[i];
    }
    return result;
  }

  // Natural logarithm of list
  static List<double> logTransform(List<double> values) {
    return values.map((x) => log(x)).toList();
  }

  // Check if all values are positive (for log transform)
  static bool allPositive(List<double> values) {
    return values.every((x) => x > 0);
  }

  // Solve 2x2 system using Cramer's rule
  static Map<String, double> solve2x2(
    double a11, double a12, double b1,
    double a21, double a22, double b2,
  ) {
    double det = a11 * a22 - a12 * a21;
    if (det.abs() < 1e-10) {
      throw Exception("System has no unique solution (determinant ≈ 0)");
    }
    double x = (b1 * a22 - b2 * a12) / det;
    double y = (a11 * b2 - a21 * b1) / det;
    return {'a': x, 'b': y};
  }

  // Solve 3x3 system using Cramer's rule
  static Map<String, double> solve3x3(
    double a11, double a12, double a13, double b1,
    double a21, double a22, double a23, double b2,
    double a31, double a32, double a33, double b3,
  ) {
    // Calculate main determinant
    double det = a11 * (a22 * a33 - a23 * a32) -
                 a12 * (a21 * a33 - a23 * a31) +
                 a13 * (a21 * a32 - a22 * a31);

    if (det.abs() < 1e-10) {
      throw Exception("System has no unique solution (determinant ≈ 0)");
    }

    // Calculate determinants for each variable
    double detA = b1 * (a22 * a33 - a23 * a32) -
                  a12 * (b2 * a33 - a23 * b3) +
                  a13 * (b2 * a32 - a22 * b3);

    double detB = a11 * (b2 * a33 - a23 * b3) -
                  b1 * (a21 * a33 - a23 * a31) +
                  a13 * (a21 * b3 - b2 * a31);

    double detC = a11 * (a22 * b3 - b2 * a32) -
                  a12 * (a21 * b3 - b2 * a31) +
                  b1 * (a21 * a32 - a22 * a31);

    return {
      'a': detA / det,
      'b': detB / det,
      'c': detC / det,
    };
  }
}
