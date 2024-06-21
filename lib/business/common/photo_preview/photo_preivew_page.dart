import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fun_joke/utils/media_util.dart';

class PhotoPreviewPage extends StatefulWidget {
  final List<String> imageUrls;
  final int index;

  const PhotoPreviewPage(
      {super.key, required this.imageUrls, required this.index});

  @override
  State<PhotoPreviewPage> createState() => _PhotoPreviewPageState();
}

class _PhotoPreviewPageState extends State<PhotoPreviewPage> {
  var _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.index;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white,),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          '${_currentIndex + 1}/${widget.imageUrls.length}',
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: PageView(
        controller: PageController(initialPage: _currentIndex),
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: widget.imageUrls
            .map((e) => SizedBox.expand(
                  child: Hero(
                      tag: e,
                      child: CachedNetworkImage(imageUrl: decodeMediaUrl(e), width: double.infinity, height: double.infinity, fit: BoxFit.fitWidth,)),
                ))
            .toList(),
      ),
    );
  }
}
