import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:talker/talker.dart';
import 'package:talker_dio_logger/talker_dio_logger_interceptor.dart';
import 'package:talker_dio_logger/talker_dio_logger_settings.dart';

import '../shared.dart';

part 'dto/json_collection_dto.dart';
part 'dto/json_dto.dart';
part 'dto/json_paginated_collection_dto.dart';
part 'request/remote_request.dart';
part 'sources/dio_client.dart';
part 'sources/hive_local_source.dart';
part 'sources/remoute_sources.dart';
