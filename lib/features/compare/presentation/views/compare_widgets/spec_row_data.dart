/// Row metadata for the side-by-side comparison table.
class SpecRowData {
  final String label;
  final String first;
  final String second;
  final bool highlight;
  final bool strikethrough;

  const SpecRowData({
    required this.label,
    required this.first,
    required this.second,
    this.highlight = false,
    this.strikethrough = false,
  });
}
