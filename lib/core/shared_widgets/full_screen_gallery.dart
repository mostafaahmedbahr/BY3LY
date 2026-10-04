import 'package:by3ly/core/shared_widgets/custom_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

/// Full-screen swipeable gallery with pinch-to-zoom.
///
/// Open it from any details screen:
/// ```dart
/// FullScreenGallery.open(context, images: urls, initialIndex: i);
/// ```
class FullScreenGallery extends StatefulWidget {
  const FullScreenGallery({
    super.key,
    required this.images,
    this.initialIndex = 0,
  });

  final List<String> images;
  final int initialIndex;

  static Future<void> open(
    BuildContext context, {
    required List<String> images,
    int initialIndex = 0,
  }) {
    final urls =
        images.where((u) => u.trim().isNotEmpty).toList();
    if (urls.isEmpty) return Future.value();
    final safeIndex =
        initialIndex.clamp(0, urls.length - 1);
    return Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.fade,
        child: FullScreenGallery(
          images: urls,
          initialIndex: safeIndex,
        ),
      ),
    );
  }

  @override
  State<FullScreenGallery> createState() => _FullScreenGalleryState();
}

class _FullScreenGalleryState extends State<FullScreenGallery> {
  late final PageController _controller;
  late int _index;

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex;
    _controller = PageController(initialPage: _index);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          '${_index + 1} / ${widget.images.length}',
          style: const TextStyle(color: Colors.white, fontSize: 15),
        ),
        centerTitle: true,
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: widget.images.length,
            onPageChanged: (i) => setState(() => _index = i),
            itemBuilder: (context, i) => InteractiveViewer(
              minScale: 1,
              maxScale: 4,
              child: Center(
                child: CustomNetWorkImage(
                  imageUrl: widget.images[i],
                  raduis: 0,
                  fit: BoxFit.contain,
                  width: double.infinity,
                ),
              ),
            ),
          ),
          if (widget.images.length > 1)
            Positioned(
              bottom: 24,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (int i = 0;
                      i < widget.images.length;
                      i++)
                    Container(
                      width: _index == i ? 20 : 7,
                      height: 7,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 3),
                      decoration: BoxDecoration(
                        color: _index == i
                            ? Colors.white
                            : Colors.white.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
