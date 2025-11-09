import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ColorPickerWidget extends StatefulWidget {
  final Color selectedColor;
  final ValueChanged<Color> onColorChanged;
  final String title;

  const ColorPickerWidget({
    super.key,
    required this.selectedColor,
    required this.onColorChanged,
    required this.title,
  });

  @override
  State<ColorPickerWidget> createState() => _ColorPickerWidgetState();
}

class _ColorPickerWidgetState extends State<ColorPickerWidget> {
  late Color _selectedColor;

  final List<Color> _predefinedColors = [
    Colors.indigo,
    Colors.blue,
    Colors.cyan,
    Colors.teal,
    Colors.green,
    Colors.lightGreen,
    Colors.lime,
    Colors.yellow,
    Colors.amber,
    Colors.orange,
    Colors.deepOrange,
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.deepPurple,
    Colors.brown,
    Colors.grey,
    Colors.blueGrey,
  ];

  @override
  void initState() {
    super.initState();
    _selectedColor = widget.selectedColor;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? (Colors.grey[850]?.withOpacity(0.4) ?? Colors.black26) : colorScheme.primaryContainer.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: colorScheme.primary.withValues(alpha: 0.3)),
          ),
          child: Column(
            children: [
              // Current color display
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _selectedColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: _selectedColor, width: 2),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: _selectedColor,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: colorScheme.onSurface.withValues(alpha: 0.2)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Selected Color",
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          Text(
                            _getColorName(_selectedColor),
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: colorScheme.onSurface.withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: _showColorPicker,
                      icon: Icon(
                        Icons.colorize,
                        color: _selectedColor,
                      ),
                      tooltip: "Custom Color",
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              
              // Predefined colors grid
              Text(
                "Quick Colors",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 6,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: _predefinedColors.length,
                itemBuilder: (context, index) {
                  final color = _predefinedColors[index];
                  final isSelected = _selectedColor == color;
                  
                  return GestureDetector(
                    onTap: () => _selectColor(color),
                    child: Container(
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSelected ? colorScheme.onSurface : Colors.transparent,
                          width: isSelected ? 3 : 1,
                        ),
                        boxShadow: isSelected ? [
                          BoxShadow(
                            color: color.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ] : null,
                      ),
                      child: isSelected
                          ? Icon(
                              Icons.check,
                              color: _getContrastColor(color),
                              size: 20,
                            )
                          : null,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _selectColor(Color color) {
    setState(() {
      _selectedColor = color;
    });
    widget.onColorChanged(color);
  }

  void _showColorPicker() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Choose Custom Color",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Select a custom color for your theme",
                style: GoogleFonts.poppins(fontSize: 14),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Theme.of(context).dividerColor),
                ),
                child: ColorPicker(
                  pickerColor: _selectedColor,
                  onColorChanged: (color) {
                    setState(() {
                      _selectedColor = color;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              widget.onColorChanged(_selectedColor);
              Navigator.of(context).pop();
            },
            child: Text("Apply"),
          ),
        ],
      ),
    );
  }

  String _getColorName(Color color) {
    if (color == Colors.indigo) return "Indigo";
    if (color == Colors.blue) return "Blue";
    if (color == Colors.cyan) return "Cyan";
    if (color == Colors.teal) return "Teal";
    if (color == Colors.green) return "Green";
    if (color == Colors.lightGreen) return "Light Green";
    if (color == Colors.lime) return "Lime";
    if (color == Colors.yellow) return "Yellow";
    if (color == Colors.amber) return "Amber";
    if (color == Colors.orange) return "Orange";
    if (color == Colors.deepOrange) return "Deep Orange";
    if (color == Colors.red) return "Red";
    if (color == Colors.pink) return "Pink";
    if (color == Colors.purple) return "Purple";
    if (color == Colors.deepPurple) return "Deep Purple";
    if (color == Colors.brown) return "Brown";
    if (color == Colors.grey) return "Grey";
    if (color == Colors.blueGrey) return "Blue Grey";
    return "Custom";
  }

  Color _getContrastColor(Color color) {
    // Calculate luminance to determine if we need light or dark text
    final luminance = color.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }
}

// Simple Color Picker Widget
class ColorPicker extends StatefulWidget {
  final Color pickerColor;
  final ValueChanged<Color> onColorChanged;

  const ColorPicker({
    super.key,
    required this.pickerColor,
    required this.onColorChanged,
  });

  @override
  State<ColorPicker> createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  late Color _currentColor;

  @override
  void initState() {
    super.initState();
    _currentColor = widget.pickerColor;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // HSV Color Picker
        Container(
          width: double.infinity,
          height: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.red,
                Colors.yellow,
                Colors.green,
                Colors.cyan,
                Colors.blue,
                Colors.purple,
                Colors.red,
              ],
            ),
          ),
          child: GestureDetector(
            onTapDown: (details) => _onColorTap(details),
            child: CustomPaint(
              painter: ColorPickerPainter(_currentColor),
            ),
          ),
        ),
        const SizedBox(height: 16),
        
        // Color preview
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: _currentColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey),
          ),
        ),
      ],
    );
  }

  void _onColorTap(TapDownDetails details) {
    final RenderBox box = context.findRenderObject() as RenderBox;
    final Offset localPosition = box.globalToLocal(details.globalPosition);
    
    // Simple color calculation based on position
    final double x = localPosition.dx.clamp(0.0, box.size.width);
    final double y = localPosition.dy.clamp(0.0, box.size.height);
    
    // Convert position to HSV
    final double hue = (x / box.size.width) * 360;
    final double saturation = 1.0;
    final double value = 1.0 - (y / box.size.height);
    
    setState(() {
      _currentColor = HSVColor.fromAHSV(1.0, hue, saturation, value).toColor();
    });
    
    widget.onColorChanged(_currentColor);
  }
}

class ColorPickerPainter extends CustomPainter {
  final Color selectedColor;

  ColorPickerPainter(this.selectedColor);

  @override
  void paint(Canvas canvas, Size size) {
    // Draw a simple crosshair or circle to show selected position
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Calculate position based on color
    final hsv = HSVColor.fromColor(selectedColor);
    final x = (hsv.hue / 360) * size.width;
    final y = (1 - hsv.value) * size.height;

    canvas.drawCircle(Offset(x, y), 8, paint);
    canvas.drawCircle(Offset(x, y), 6, Paint()..color = Colors.black..style = PaintingStyle.stroke);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
