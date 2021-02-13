import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

import '../logic/pg_error.dart';
import '../provider/phase_provider.dart';
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
      return Center(child: CircularProgressIndicator());
    }

    if (provider.phases.isEmpty) {
      return RefreshIndicator(
        onRefresh: provider.fetchPhases,
        child: Stack(
          children: [
            ListView(),
            Center(
                child: Text('No phases found.',
                    style: Theme.of(context).textTheme.subtitle1)),
          ],
        ),
      );
    }

    return OrderListPage();
  }
}
