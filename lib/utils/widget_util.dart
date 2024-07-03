import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

extension SziedBoxExt on num {

  SizedBox get wSize => SizedBox(width: w,);
  SizedBox get hSize => SizedBox(height: w,);

}