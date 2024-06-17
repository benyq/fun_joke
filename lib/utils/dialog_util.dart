import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DialogUtil {
  static void showLoadingDialog(BuildContext context, {bool isCancel = false}) {
    showDialog(
      context: context,
      barrierDismissible: false,
        barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return PopScope(
          canPop: isCancel,
          child: Center(
            child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(10),
                ),
                width: 130.w,
                height: 130.w,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 20.w,
                    ),
                    SizedBox(
                        width: 40.w,
                        height: 40.w,
                        child: const CircularProgressIndicator(
                          color: Colors.white,
                        )),
                    const Spacer(),
                    Text(
                      'loading...',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13.sp,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    SizedBox(
                      height: 20.w,
                    ),
                  ],
                )),
          ),
        );
      },
    );
  }

  static showLoading2(BuildContext context, {bool barrierDismissible = false}) {
    final overlay = Overlay.of(context);
    OverlayEntry? overlayEntry;
    overlayEntry = OverlayEntry(builder: (context) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: barrierDismissible ? () {
          overlayEntry?.remove();
        } : null,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.transparent,
          child: Center(
            child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(10),
                ),
                width: 130.w,
                height: 130.w,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 20.w,
                    ),
                    SizedBox(
                        width: 40.w,
                        height: 40.w,
                        child: const CircularProgressIndicator(
                          color: Colors.white,
                        )),
                    const Spacer(),
                    Text(
                      'loading...',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13.sp,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    SizedBox(
                      height: 20.w,
                    ),
                  ],
                )),
          ),
        ),
      );
    });
    overlay.insert(overlayEntry);
  }
}
