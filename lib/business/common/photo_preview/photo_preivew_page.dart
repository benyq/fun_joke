import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:fun_joke/utils/media_util.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class PhotoPreviewPage extends StatefulWidget {
  final List<String> imageUrls;
  final int index;
  const PhotoPreviewPage({super.key, required this.imageUrls, required this.index});

  @override
  State<PhotoPreviewPage> createState() => _PhotoPreviewPageState();
}

class _PhotoPreviewPageState extends State<PhotoPreviewPage> {
  var _currentIndex = 0;
  late PageController _controller;
  late final List<String> imageUrls;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.index;
    imageUrls = widget.imageUrls;
    _controller = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          '${_currentIndex + 1}/${imageUrls.length}',
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: GestureDetector(
        onLongPress: () {
          var realUrl = decodeMediaUrl(imageUrls[_currentIndex]);
          if (isNetworkImage(realUrl)) {
            _showSavePicBottomSheet();
          }
        },
        child: PhotoViewGallery.builder(
          scrollPhysics: const BouncingScrollPhysics(),
          builder: (BuildContext context, int index) {
            return _getGalleryPageOptions(imageUrls[index]);
          },
          loadingBuilder: (context, event) => Center(
            child: SizedBox(
              width: 20.w,
              height: 20.w,
              child: CircularProgressIndicator(
                value: event == null
                    ? 0
                    : event.cumulativeBytesLoaded / event.expectedTotalBytes!,
              ),
            ),
          ),
          itemCount: imageUrls.length,
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          pageController: _controller,
        ),
      ),
    );
  }

  PhotoViewGalleryPageOptions _getGalleryPageOptions(String url) {
    return isNetworkImage(decodeMediaUrl(url))
        ? PhotoViewGalleryPageOptions(
            imageProvider: CachedNetworkImageProvider(decodeMediaUrl(url)),
            maxScale: 4.0,
            minScale: 0.3,
            initialScale: PhotoViewComputedScale.contained * 0.8,
            basePosition: Alignment.center,
            heroAttributes: PhotoViewHeroAttributes(tag: url),
          )
        : PhotoViewGalleryPageOptions(
            imageProvider: FileImage(File(url)),
            maxScale: 4.0,
            minScale: 0.3,
            initialScale: PhotoViewComputedScale.contained * 0.8,
            heroAttributes: PhotoViewHeroAttributes(tag: url),
          );
  }

  void _showSavePicBottomSheet() {
    showMaterialModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.w),
                topRight: Radius.circular(16.w))),
        builder: (context) {
          return SizedBox(
              height: 120.w,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _saveImage();
                    },
                    child: const Text('保存到相册', style: TextStyle(color: Colors.black),),
                  ),
                  Container(color: Colors.grey.withOpacity(0.2), height: 5.w),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('取消', style: TextStyle(color: Colors.black),),
                  ),
                ],
              ));
        });
  }

  void _saveImage() async {
    var realUrl = decodeMediaUrl(imageUrls[_currentIndex]);
    var res = await saveNetworkImage(realUrl);
    if (res) {
      SmartDialog.showToast('保存成功');
    } else {
      SmartDialog.showToast('保存失败');
    }
  }
}


class PreviewArgument {
  final int index;
  final List<String> images;

  PreviewArgument({required this.index, required this.images});
}

