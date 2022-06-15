import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../injection.dart';
import '../common/build_context_ext_screen_size.dart';
import '../order/order_list/order_status_provider.dart';
import '../order/order_provider.dart';
import '../phase/phase_provider.dart';
import '../recipe/recipe_provider.dart';
import 'home_page_tight.dart';
import 'home_page_wide.dart';
import 'table/table_filter_provider.dart';
import 'table/table_provider.dart';
import 'table/table_status_provider.dart';
import 'topic/notification_provider.dart';
import 'topic/topic_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: getIt<TableProvider>()),
        ChangeNotifierProvider.value(value: getIt<TopicProvider>()),
        ChangeNotifierProvider.value(value: getIt<TableFilterProvider>()),
        ChangeNotifierProvider.value(value: getIt<NotificationProvider>()),
        ChangeNotifierProvider(create: (_) => getIt<RecipeProvider>()),
        ChangeNotifierProvider(create: (_) => getIt<PhaseProvider>()),
        ChangeNotifierProvider(create: (_) => getIt<OrderStatusProvider>()),
        ChangeNotifierProvider(create: (_) => getIt<TableStatusProvider>()),
        ChangeNotifierProvider(create: (_) => getIt<OrderProvider>()),
      ],
      builder: (context, _) {
        final provider = context.read<NotificationProvider>();
        return Container(
          color: Theme.of(context).colorScheme.primary,
          child: FutureBuilder(
            future: provider.initialize(),
            builder: (_, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }

              WidgetsBinding.instance.addPostFrameCallback(
                (_) => provider.listenOnNotificationUpdates(),
              );

              return LayoutBuilder(builder: (_, constraints) {
                if (constraints.maxWidth >= kTabletWidth) return HomePageWide();
                return HomePageTight();
              });
            },
          ),
        );
      },
    );
  }
}
