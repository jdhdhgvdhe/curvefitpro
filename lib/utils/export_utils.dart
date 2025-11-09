import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/services.dart' show Clipboard, ClipboardData;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class ExportUtils {
  static Future<void> exportAsPDF({
    required String curveType,
    required String finalEquation,
    required List<String> headers,
    required List<List<String>> tableData,
    required List<String> sumRow,
    required List<Map<String, dynamic>> eliminationSteps,
    required BuildContext context,
    String? calculationSteps,
    List<double>? xValues,
    List<double>? yValues,
  }) async {
    // Handle permissions for mobile platforms
    if (!kIsWeb && Platform.isAndroid) {
      bool permissionGranted = await _requestStoragePermission(context);
      if (!permissionGranted) {
        return;
      }
    }

    final pdf = pw.Document();

    final font = await PdfGoogleFonts.notoSansRegular();
    final boldFont = await PdfGoogleFonts.notoSansBold();
    final logo = await _loadLogo();

    final theme = pw.ThemeData.withFont(
      base: font,
      bold: boldFont,
    );

    pdf.addPage(
      pw.MultiPage(
        theme: theme,
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (pw.Context pwContext) => [
          _buildHeader(logo, "CurveFit - Report"),
          pw.SizedBox(height: 30),
          if (xValues != null && yValues != null) _buildInputDataSection(xValues, yValues),
          pw.SizedBox(height: 20),
          _buildInfoSection(curveType, finalEquation),
          pw.SizedBox(height: 30),
          if (tableData.isNotEmpty) _buildTableSection(headers, tableData, sumRow),
          if (calculationSteps != null) _buildCalculationStepsSection(calculationSteps),
          if (eliminationSteps.isNotEmpty) _buildEliminationSection(eliminationSteps),
        ],
        footer: (pw.Context pwContext) => _buildFooter(pwContext),
      ),
    );

    try {
      if (kIsWeb) {
        // Web: Show PDF preview with print/download options
        await Printing.layoutPdf(onLayout: (format) async => pdf.save());
      } else {
        // Android/Mobile: Save to file, no preview
        final directory = await getExternalStorageDirectory();
        if (directory == null) {
          _showError(context, "Cannot access storage directory");
          return;
        }
        
        // Create Downloads/CurveFitPro folder
        final downloadsPath = Directory('/storage/emulated/0/Download/CurveFitPro');
        if (!await downloadsPath.exists()) {
          await downloadsPath.create(recursive: true);
        }
        
        // Generate filename with timestamp
        final timestamp = DateTime.now();
        final dateStr = '${timestamp.year}${timestamp.month.toString().padLeft(2, '0')}${timestamp.day.toString().padLeft(2, '0')}_${timestamp.hour.toString().padLeft(2, '0')}${timestamp.minute.toString().padLeft(2, '0')}';
        final fileName = 'CurveFit_${curveType.split('.').first.trim()}_$dateStr.pdf';
        
        final pdfBytes = await pdf.save();
        final file = File('${downloadsPath.path}/$fileName');
        await file.writeAsBytes(pdfBytes);
        
        // Save last export path to preferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('last_pdf_path', file.path);
        
        _showSuccess(context, "✅ PDF saved successfully!\n📂 Location: Download/CurveFitPro/$fileName");
        
        // Offer to share the PDF (Android only)
        await Printing.sharePdf(bytes: pdfBytes, filename: fileName);
      }
    } catch (e) {
      _showError(context, "❌ Failed to export PDF: ${e.toString()}");
    }
  }

  static Future<pw.ImageProvider?> _loadLogo() async {
    try {
      final byteData = await rootBundle.load('assets/image.png');
      return pw.MemoryImage(byteData.buffer.asUint8List());
    } catch (e) {
      print("Logo not found at 'assets/image.png'. Error: $e");
      return null;
    }
  }

  static pw.Widget _buildHeader(pw.ImageProvider? logo, String title) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        pw.Text(title, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 20)),
        if (logo != null) 
          pw.Opacity(
            opacity: 0.25, // 25% transparency
            child: pw.Image(logo, width: 50, height: 50),
          ),
      ],
    );
  }

  static pw.Widget _buildInputDataSection(List<double> xValues, List<double> yValues) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        color: PdfColors.blue50,
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
        border: pw.Border.all(color: PdfColors.blue700, width: 2),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            children: [
              pw.Container(
                width: 20,
                height: 20,
                decoration: const pw.BoxDecoration(
                  color: PdfColors.blue700,
                  shape: pw.BoxShape.circle,
                ),
              ),
              pw.SizedBox(width: 8),
              pw.Text(
                'Input Data',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 16,
                  color: PdfColors.blue900,
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 12),
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'X Values:',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11, color: PdfColors.blue800),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      xValues.map((x) => _formatNumber(x)).join(', '),
                      style: const pw.TextStyle(fontSize: 10),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(width: 20),
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Y Values:',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11, color: PdfColors.blue800),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      yValues.map((y) => _formatNumber(y)).join(', '),
                      style: const pw.TextStyle(fontSize: 10),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildInfoSection(String curveType, String finalEquation) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        color: PdfColors.green50,
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
        border: pw.Border.all(color: PdfColors.green700, width: 2),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Analysis Details',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 16, color: PdfColors.green900),
          ),
          pw.Divider(thickness: 1.5, color: PdfColors.green300),
          pw.SizedBox(height: 10),
          pw.RichText(
            text: pw.TextSpan(
              style: const pw.TextStyle(fontSize: 11),
              children: [
                pw.TextSpan(text: 'Curve Type: ', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.green800)),
                pw.TextSpan(text: curveType),
              ],
            ),
          ),
          pw.SizedBox(height: 8),
          pw.RichText(
            text: pw.TextSpan(
              style: const pw.TextStyle(fontSize: 11),
              children: [
                pw.TextSpan(text: 'Equation:   ', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.green800)),
                pw.TextSpan(text: finalEquation),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildTableSection(List<String> headers, List<List<String>> tableData, List<String> sumRow) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('Data Table', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 16)),
        pw.Divider(thickness: 1.5),
        pw.SizedBox(height: 10),
        pw.Table.fromTextArray(
          headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
          cellStyle: const pw.TextStyle(fontSize: 9),
          headerDecoration: const pw.BoxDecoration(color: PdfColors.grey200),
          headers: headers,
          data: tableData,
          border: pw.TableBorder.all(color: PdfColors.grey400),
          cellAlignments: { for (var i = 0; i < headers.length; i++) i: pw.Alignment.center },
        ),
        pw.SizedBox(height: 5),
        pw.Table.fromTextArray(
          cellStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9),
          headers: headers,
          data: [sumRow],
          border: pw.TableBorder.all(color: PdfColors.grey400),
          cellAlignments: { for (var i = 0; i < headers.length; i++) i: pw.Alignment.center },
        ),
        pw.SizedBox(height: 30),
      ],
    );
  }

  static pw.Widget _buildCalculationStepsSection(String calculationSteps) {
    // Replace subscript notation for PDF rendering
    String formattedSteps = calculationSteps
        .replaceAll('log₁₀', 'log10')
        .replaceAll('antilog₁₀', 'antilog10');
    
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 20),
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        color: PdfColors.purple50,
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
        border: pw.Border.all(color: PdfColors.purple700, width: 2),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Calculation Steps',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 16, color: PdfColors.purple900),
          ),
          pw.Divider(thickness: 1.5, color: PdfColors.purple300),
          pw.SizedBox(height: 10),
          pw.Paragraph(text: formattedSteps, style: const pw.TextStyle(fontSize: 11, lineSpacing: 4)),
        ],
      ),
    );
  }

  static pw.Widget _buildEliminationSection(List<Map<String, dynamic>> steps) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        color: PdfColors.orange50,
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
        border: pw.Border.all(color: PdfColors.orange700, width: 2),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Step-by-Step Solution',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 16, color: PdfColors.orange900),
          ),
          pw.Divider(thickness: 1.5, color: PdfColors.orange300),
          pw.SizedBox(height: 10),
          ...steps.map((step) => _buildPdfStep(step)),
        ],
      ),
    );
  }

  static pw.Widget _buildPdfStep(Map<String, dynamic> step) {
    final titleStyle = pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11);
    final subtitleStyle = const pw.TextStyle(fontSize: 10, color: PdfColors.grey600);
    final equationStyle = const pw.TextStyle(fontSize: 10);

    pw.Widget content;
    switch (step['type']) {
      case 'equations':
        content = pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: (step['equations'] as List).map((eq) => pw.Container(
            margin: const pw.EdgeInsets.only(bottom: 4),
            padding: const pw.EdgeInsets.all(6),
            decoration: pw.BoxDecoration(
              color: PdfColors.grey100,
              borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
            ),
            child: pw.Text(_formatPdfEquation(eq), style: equationStyle),
          )).toList(),
        );
        break;
      case 'new_equations':
        content = pw.Container(
          padding: const pw.EdgeInsets.all(10),
          decoration: pw.BoxDecoration(
            color: PdfColors.green50,
            borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
            border: pw.Border.all(color: PdfColors.green700, width: 1),
          ),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: (step['equations'] as List).map((eq) => pw.Container(
              margin: const pw.EdgeInsets.only(bottom: 4),
              child: pw.Text(_formatPdfEquation(eq), style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
            )).toList(),
          ),
        );
        break;
      case 'multiply':
      case 'subtract':
        content = pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
          if (step['subtitle'] != null) pw.Text(step['subtitle'], style: subtitleStyle),
          if (step['equation1'] != null) pw.Text(_formatPdfEquation(step['equation1']), style: equationStyle),
          if (step['equation2'] != null) pw.Text('- ' + _formatPdfEquation(step['equation2']), style: equationStyle),
          if (step['result'] != null) ...[pw.Divider(height: 8, thickness: 0.5, color: PdfColors.grey), pw.Text(_formatPdfEquation(step['result']), style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10))]
        ]);
        break;
      case 'solve':
        content = pw.Text('${_formatPdfEquation(step['equation'])}  =>  ${step['variable']} = ${_formatNumber(step['solution'])}', style: equationStyle);
        break;
      case 'solve_detailed':
        final equation = step['equation'] as Map<String, dynamic>?;
        final division = step['division'] as Map<String, dynamic>?;
        final variable = step['variable'] as String?;
        final solution = step['solution'] as double?;
        
        content = pw.Container(
          padding: const pw.EdgeInsets.all(10),
          decoration: pw.BoxDecoration(
            color: PdfColors.blue50,
            borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
            border: pw.Border.all(color: PdfColors.blue300, width: 1),
          ),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              if (equation != null) pw.Text(_formatPdfEquation(equation), style: equationStyle),
              if (division != null) ...[
                pw.SizedBox(height: 6),
                pw.Text('Divide both sides by ${_formatNumber(division['denominator'])}:', style: pw.TextStyle(fontSize: 9, color: PdfColors.blue700)),
                pw.SizedBox(height: 4),
                pw.Text('${variable} = ${_formatNumber(division['numerator'])} / ${_formatNumber(division['denominator'])}', style: equationStyle),
              ],
              if (variable != null && solution != null) ...[
                pw.SizedBox(height: 6),
                pw.Container(
                  padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.blue100,
                    borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
                  ),
                  child: pw.Text('$variable = ${_formatNumber(solution)}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10, color: PdfColors.blue900)),
                ),
              ],
            ],
          ),
        );
        break;
      case 'substitute_detailed':
        final originalEq = step['originalEquation'] as Map<String, dynamic>?;
        final substitution = step['substitution'] as Map<String, dynamic>?;
        final afterSub = step['afterSubstitution'] as Map<String, dynamic>?;
        final simplified = step['simplified'] as Map<String, dynamic>?;
        final division = step['division'] as Map<String, dynamic>?;
        final variable = step['variable'] as String?;
        final solution = step['solution'] as double?;
        
        content = pw.Container(
          padding: const pw.EdgeInsets.all(10),
          decoration: pw.BoxDecoration(
            color: PdfColors.pink50,
            borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
            border: pw.Border.all(color: PdfColors.pink300, width: 1),
          ),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              if (originalEq != null) ...[
                pw.Text('Original equation:', style: pw.TextStyle(fontSize: 9, color: PdfColors.grey700)),
                pw.Text(_formatPdfEquation(originalEq), style: equationStyle),
                pw.SizedBox(height: 6),
              ],
              if (substitution != null && afterSub != null) ...[
                pw.Text('Put ${substitution['var']} = ${_formatNumber(substitution['value'])}:', style: pw.TextStyle(fontSize: 9, color: PdfColors.pink700)),
                pw.Text('${_formatNumber(afterSub['coeff'])}${afterSub['var']} + ${_formatNumber(afterSub['constant'])} = ${_formatNumber(afterSub['result'])}', style: equationStyle),
                pw.SizedBox(height: 6),
              ],
              if (simplified != null) ...[
                pw.Text('Simplify:', style: pw.TextStyle(fontSize: 9, color: PdfColors.pink700)),
                pw.Text('${_formatNumber(simplified['coeff'])}${simplified['var']} = ${_formatNumber(simplified['result'])}', style: equationStyle),
                pw.SizedBox(height: 6),
              ],
              if (division != null) ...[
                pw.Text('Divide both sides by ${_formatNumber(division['denominator'])}:', style: pw.TextStyle(fontSize: 9, color: PdfColors.pink700)),
                pw.Text('${variable} = ${_formatNumber(division['numerator'])} / ${_formatNumber(division['denominator'])}', style: equationStyle),
                pw.SizedBox(height: 6),
              ],
              if (variable != null && solution != null) ...[
                pw.Container(
                  padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.pink100,
                    borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
                  ),
                  child: pw.Text('$variable = ${_formatNumber(solution)}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10, color: PdfColors.pink900)),
                ),
              ],
            ],
          ),
        );
        break;
      case 'substitute_detailed_3x3':
        final originalEq = step['originalEquation'] as Map<String, dynamic>?;
        final substitutions = step['substitutions'] as List?;
        final afterSub = step['afterSubstitution'] as Map<String, dynamic>?;
        final simplified = step['simplified'] as Map<String, dynamic>?;
        final division = step['division'] as Map<String, dynamic>?;
        final variable = step['variable'] as String?;
        final solution = step['solution'] as double?;
        
        content = pw.Container(
          padding: const pw.EdgeInsets.all(10),
          decoration: pw.BoxDecoration(
            color: PdfColors.purple50,
            borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
            border: pw.Border.all(color: PdfColors.purple300, width: 1),
          ),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              if (originalEq != null) ...[
                pw.Text('Original equation:', style: pw.TextStyle(fontSize: 9, color: PdfColors.grey700)),
                pw.Text(_formatPdfEquation(originalEq), style: equationStyle),
                pw.SizedBox(height: 6),
              ],
              if (substitutions != null) ...[
                ...substitutions.map((sub) => pw.Text(
                  'Put ${sub['var']} = ${_formatNumber(sub['value'])}: ${_formatNumber(sub['coeff'])} x ${_formatNumber(sub['value'])} = ${_formatNumber(sub['product'])}',
                  style: pw.TextStyle(fontSize: 9, color: PdfColors.purple700),
                )),
                pw.SizedBox(height: 4),
              ],
              if (afterSub != null) ...[
                pw.Text('${_formatNumber(afterSub['coeff'])}${afterSub['var']} + ${_formatNumber(afterSub['constant'])} = ${_formatNumber(afterSub['result'])}', style: equationStyle),
                pw.SizedBox(height: 6),
              ],
              if (simplified != null) ...[
                pw.Text('Simplify:', style: pw.TextStyle(fontSize: 9, color: PdfColors.purple700)),
                pw.Text('${_formatNumber(simplified['coeff'])}${simplified['var']} = ${_formatNumber(simplified['result'])}', style: equationStyle),
                pw.SizedBox(height: 6),
              ],
              if (division != null) ...[
                pw.Text('Divide both sides by ${_formatNumber(division['denominator'])}:', style: pw.TextStyle(fontSize: 9, color: PdfColors.purple700)),
                pw.Text('${variable} = ${_formatNumber(division['numerator'])} / ${_formatNumber(division['denominator'])}', style: equationStyle),
                pw.SizedBox(height: 6),
              ],
              if (variable != null && solution != null) ...[
                pw.Container(
                  padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.purple100,
                    borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
                  ),
                  child: pw.Text('$variable = ${_formatNumber(solution)}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10, color: PdfColors.purple900)),
                ),
              ],
            ],
          ),
        );
        break;
      case 'exponential_conversion':
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
        
        content = pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            ...conversions?.map((conv) => pw.Container(
              margin: const pw.EdgeInsets.only(bottom: 6),
              padding: const pw.EdgeInsets.all(8),
              decoration: const pw.BoxDecoration(
                color: PdfColors.teal50,
                borderRadius: pw.BorderRadius.all(pw.Radius.circular(4)),
              ),
              child: pw.Row(
                children: [
                  pw.Text(
                    '${conv['variable']} = ${_formatNumber(conv['logValue'])}',
                    style: equationStyle,
                  ),
                  pw.SizedBox(width: 10),
                  pw.Text('=>', style: const pw.TextStyle(fontSize: 10)),
                  pw.SizedBox(width: 10),
                  pw.Text(
                    '${conv['finalVariable']} = ${_formatNumber(conv['finalValue'])}',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
                  ),
                ],
              ),
            )).toList() ?? [],
            // Only show calculator note if antilog10 is used
            if (hasAntilog) ...[
              pw.SizedBox(height: 8),
              pw.Container(
                padding: const pw.EdgeInsets.all(8),
                decoration: pw.BoxDecoration(
                  color: PdfColors.amber50,
                  borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
                  border: pw.Border.all(color: PdfColors.amber700, width: 0.5),
                ),
              child: pw.Text(
                'Note: To find antilog10 in fx82ms, press shift+log (value)',
                style: pw.TextStyle(fontSize: 9, color: PdfColors.amber900),
              ),
              ),
            ],
          ],
        );
        break;
      case 'final':
        content = pw.Container(
          padding: const pw.EdgeInsets.all(10),
          decoration: const pw.BoxDecoration(color: PdfColors.orange50, borderRadius: pw.BorderRadius.all(pw.Radius.circular(4))),
          child: pw.Text((step['solutions'] as List).map((s) => '${s['var']} = ${_formatNumber(s['value'])}').join('  |  '), style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12, color: PdfColors.orange800)),
        );
        break;
      default: content = pw.SizedBox.shrink();
    }

    return pw.Container(margin: const pw.EdgeInsets.only(bottom: 12), child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [pw.Text(step['title'], style: titleStyle), pw.SizedBox(height: 6), pw.Padding(padding: const pw.EdgeInsets.only(left: 10), child: content)]));
  }

  static String _formatPdfEquation(Map<String, dynamic> eq) {
    List<String> parts = [];
    if (eq['coeff'] != null && (eq['coeff'] as double).abs() > 1e-9) parts.add('${_formatNumber(eq['coeff'])}${eq['var'] ?? ''}');
    if (eq['coeff2'] != null && (eq['coeff2'] as double).abs() > 1e-9) parts.add('${(eq['coeff2'] as double) >= 0 ? '+' : '-'} ${_formatNumber((eq['coeff2'] as double).abs())}${eq['var2'] ?? ''}');
    if (eq['coeff3'] != null && (eq['coeff3'] as double).abs() > 1e-9) parts.add('${(eq['coeff3'] as double) >= 0 ? '+' : '-'} ${_formatNumber((eq['coeff3'] as double).abs())}${eq['var3'] ?? ''}');
    return '${parts.join(' ')} = ${_formatNumber(eq['result'])} ${eq['label'] != null ? eq['label'] : ''}';
  }

  static String _formatNumber(double value, {int decimals = 4}) {
    if (value.isNaN || value.isInfinite) return 'Error';
    if (value.abs() < 1e-9) return '0';
    String result = value.toStringAsFixed(decimals);
    if (result.contains('.')) {
      result = result.replaceAll(RegExp(r'0*$'), '');
      if (result.endsWith('.')) result = result.substring(0, result.length - 1);
    }
    return result;
  }

  static pw.Widget _buildFooter(pw.Context context) {
    return pw.Container(
      alignment: pw.Alignment.center,
      margin: const pw.EdgeInsets.only(top: 20),
      child: pw.Column(children: [
        pw.Divider(),
        pw.SizedBox(height: 5),
        pw.Text('Generated by CurveFit', style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey)),
        pw.Text('Page ${context.pageNumber} of ${context.pagesCount}', style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey)),
      ]),
    );
  }

  /// Request storage permission with proper handling for different Android versions
  static Future<bool> _requestStoragePermission(BuildContext context) async {
    if (Platform.isAndroid) {
      // For Android 13+ (API 33+), we don't need storage permission for app-specific directories
      // But we'll still check for legacy storage permission on older devices
      
      // Check Android version
      PermissionStatus status;
      
      // Try to request appropriate permission based on Android version
      if (await Permission.manageExternalStorage.isGranted) {
        return true;
      }
      
      // For Android 11+ (API 30+), try manage external storage
      if (await Permission.manageExternalStorage.request().isGranted) {
        return true;
      }
      
      // Fallback to regular storage permission for older Android versions
      status = await Permission.storage.status;
      
      if (status.isGranted) {
        return true;
      }
      
      if (status.isDenied) {
        // Request permission
        status = await Permission.storage.request();
        
        if (status.isGranted) {
          return true;
        }
        
        if (status.isDenied) {
          _showPermissionDialog(
            context,
            'Storage Permission Required',
            'This app needs storage permission to save PDF files. Please grant the permission.',
            showSettings: false,
          );
          return false;
        }
      }
      
      if (status.isPermanentlyDenied) {
        // Show dialog to open settings
        _showPermissionDialog(
          context,
          'Permission Permanently Denied',
          'Storage permission has been permanently denied. Please enable it in app settings to export PDF files.',
          showSettings: true,
        );
        return false;
      }
      
      return false;
    }
    
    return true; // For non-Android platforms
  }
  
  /// Show permission dialog with option to open settings
  static Future<void> _showPermissionDialog(
    BuildContext context,
    String title,
    String message, {
    bool showSettings = false,
  }) async {
    if (!context.mounted) return;
    
    return showDialog(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 28),
            const SizedBox(width: 12),
            Expanded(child: Text(title, style: const TextStyle(fontSize: 18))),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          if (showSettings)
            ElevatedButton.icon(
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                await openAppSettings();
              },
              icon: const Icon(Icons.settings, size: 20),
              label: const Text('Open Settings'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
            )
          else
            ElevatedButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                // Retry permission request
                await Permission.storage.request();
              },
              child: const Text('Grant Permission'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
            ),
        ],
      ),
    );
  }

  /// Get the last exported PDF path
  static Future<String?> getLastPDFPath() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('last_pdf_path');
    } catch (e) {
      return null;
    }
  }

  /// Get the CurveFitPro downloads folder path
  static String getDownloadFolderPath() {
    return '/storage/emulated/0/Download/CurveFitPro';
  }

  /// Open the downloads folder (requires external app)
  static Future<bool> openDownloadsFolder(BuildContext context) async {
    try {
      if (Platform.isAndroid) {
        final folderPath = getDownloadFolderPath();
        
        // Show dialog with folder path and instructions
        if (context.mounted) {
          showDialog(
            context: context,
            builder: (dialogContext) => AlertDialog(
              title: const Row(
                children: [
                  Icon(Icons.folder, color: Colors.blue),
                  SizedBox(width: 12),
                  Text('Download Folder'),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Your PDFs are saved in:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: SelectableText(
                      folderPath,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'To access:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text('1. Open File Manager'),
                  const Text('2. Go to Downloads folder'),
                  const Text('3. Look for "CurveFitPro" folder'),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Close'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                    // Copy path to clipboard
                    Clipboard.setData(ClipboardData(text: folderPath));
                    _showSuccess(context, '📋 Path copied to clipboard!');
                  },
                  icon: const Icon(Icons.copy),
                  label: const Text('Copy Path'),
                ),
              ],
            ),
          );
        }
        return true;
      }
      return false;
    } catch (e) {
      _showError(context, 'Error: ${e.toString()}');
      return false;
    }
  }

  static void _showSuccess(BuildContext context, String message) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(child: Text(message)),
            ],
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 4),
          action: SnackBarAction(
            label: 'VIEW FOLDER',
            textColor: Colors.white,
            onPressed: () => openDownloadsFolder(context),
          ),
        ),
      );
    }
  }

  static void _showError(BuildContext context, String message) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(child: Text(message)),
            ],
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }
}
