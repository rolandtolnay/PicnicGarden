import 'package:flutter/material.dart';

import '../../../../domain/model/table_status.dart';

extension TableStatusUI on TableStatus? {
  String get title => this?.name.toUpperCase() ?? 'SET STATUS';

  IconData get icon => this == null ? Icons.flag : Icons.tour;
}
