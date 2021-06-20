import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

import '../../logic/pg_error.dart';
import '../../provider/phase_provider.dart';
import '../common/empty_refreshable.dart';
import 'order_list_page.dart';

class PhaseLoader extends StatelessWidget {
  const PhaseLoader({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PhaseProvider>();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      provider.response.error?.showInDialog(context);
    });
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.phases.isEmpty) {
      return EmptyRefreshable(
        'No phases found.',
        onRefresh: provider.fetchPhases,
      );
    }

    return OrderListPage();
  }
}
