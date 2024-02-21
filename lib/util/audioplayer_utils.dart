import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui' as ui;

import 'package:ima2_habeesjobs/net/api.dart';

import 'package:ima2_habeesjobs/service/ser_base.dart';
import 'package:ima2_habeesjobs/util/datetime.dart';
import 'package:ima2_habeesjobs/util/language.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app_update/flutter_app_update.dart';
import 'package:heqian_flutter_utils/heqian_flutter_utils.dart';
import 'package:image/image.dart' as img;
import 'package:lpinyin/lpinyin.dart';
import 'package:provider/src/provider.dart';
