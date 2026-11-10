/// Pure helpers for banner deep links — extracted for unit testing.
class BannerLink {
  const BannerLink._();

  /// Normalizes a raw link from the API into a launchable URI.
  ///
  /// Returns null when [raw] is null/blank or cannot be parsed, so callers
  /// can silently skip broken banners instead of crashing.
  static String? normalizeUrl(String? raw) {
    final trimmed = raw?.trim();
    if (trimmed == null || trimmed.isEmpty) return null;
    var url = trimmed;
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      url = 'https://$url';
    }
    final uri = Uri.tryParse(url);
    if (uri == null || (uri.host.isEmpty)) return null;
    return url;
  }
}
