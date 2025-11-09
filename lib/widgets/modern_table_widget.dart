import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ModernTableWidget extends StatefulWidget {
  final List<String> headers;
  final List<List<String>> rows;
  final String? title;
  final IconData? titleIcon;

  const ModernTableWidget({
    super.key,
    required this.headers,
    required this.rows,
    this.title,
    this.titleIcon,
  });

  @override
  State<ModernTableWidget> createState() => _ModernTableWidgetState();
}

class _ModernTableWidgetState extends State<ModernTableWidget> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.title != null) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withOpacity(0.3),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  if (widget.titleIcon != null) ...[
                    Icon(
                      widget.titleIcon,
                      color: colorScheme.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    widget.title!,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
          Container(
            decoration: BoxDecoration(
              color: isDark 
                  ? (Colors.grey[850]?.withOpacity(0.6) ?? Colors.black38)
                  : Colors.white,
              borderRadius: widget.title != null 
                  ? const BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    )
                  : BorderRadius.circular(16),
              border: Border.all(
                color: colorScheme.primary.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: ClipRRect(
              borderRadius: widget.title != null 
                  ? const BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    )
                  : BorderRadius.circular(16),
              child: Scrollbar(
                controller: _scrollController,
                thumbVisibility: true,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  child: _buildTable(context, colorScheme, isDark),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTable(BuildContext context, ColorScheme colorScheme, bool isDark) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    
    return DataTable(
      headingRowHeight: isTablet ? 60 : 50,
      dataRowMinHeight: isTablet ? 50 : 40,
      dataRowMaxHeight: isTablet ? 60 : 50,
      columnSpacing: isTablet ? 24 : 16,
      horizontalMargin: isTablet ? 20 : 12,
      border: TableBorder(
        horizontalInside: BorderSide(
          color: colorScheme.primary.withOpacity(0.1),
          width: 1,
        ),
        verticalInside: BorderSide(
          color: colorScheme.primary.withOpacity(0.1),
          width: 1,
        ),
      ),
      headingRowColor: WidgetStateProperty.all(
        colorScheme.primaryContainer.withOpacity(0.2),
      ),
      columns: widget.headers.map((header) {
        return DataColumn(
          label: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            child: Text(
              header,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: colorScheme.primary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        );
      }).toList(),
      rows: widget.rows.asMap().entries.map((entry) {
        int index = entry.key;
        List<String> row = entry.value;
        final bool isSumRow = row.first == 'Σ';

        return DataRow(
          color: WidgetStateProperty.resolveWith((states) {
            if (isSumRow) {
              return colorScheme.secondaryContainer.withOpacity(0.3);
            }
            if (states.contains(WidgetState.selected)) {
              return colorScheme.primary.withOpacity(0.1);
            }
            return index.isEven 
                ? (Colors.grey[800]?.withOpacity(0.2) ?? Colors.black12)
                : Colors.transparent;
          }),
          cells: _buildCells(context, row, widget.headers.length, colorScheme, isSumRow),
        );
      }).toList(),
    );
  }

  List<DataCell> _buildCells(
    BuildContext context,
    List<String> row,
    int expectedLength,
    ColorScheme colorScheme,
    bool isSumRow,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final fontSize = isTablet ? 13.0 : 11.0;
    final sigmaFontSize = isTablet ? 18.0 : 16.0;

    return List.generate(expectedLength, (i) {
      String cellValue = (i < row.length) ? row[i] : '';
      
      return DataCell(
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(
            vertical: isTablet ? 12 : 8, 
            horizontal: isTablet ? 8 : 4
          ),
          child: Text(
            cellValue,
            style: GoogleFonts.robotoMono(
              fontSize: isSumRow && i == 0 ? sigmaFontSize : fontSize,
              color: isSumRow ? colorScheme.secondary : colorScheme.onSurface,
              fontWeight: isSumRow ? FontWeight.bold : FontWeight.normal,
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );
    });
  }
}
