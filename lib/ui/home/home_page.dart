import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../injection.dart';
import 'topic/notification_provider.dart';
import '../order/order_provider.dart';
import '../order/order_list/order_status_provider.dart';
import '../phase/phase_provider.dart';
import '../recipe/recipe_provider.dart';
import 'table/table_provider.dart';
import 'topic/topic_provider.dart';
import '../common/build_context_ext_screen_size.dart';
import 'home_page_tight.dart';
import 'home_page_wide.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: di<TableProvider>()),
        ChangeNotifierProvider.value(value: di<TopicProvider>()),
        ChangeNotifierProvider.value(value: di<NotificationProvider>()),
        ChangeNotifierProvider(create: (_) => di<OrderProvider>()),
        ChangeNotifierProvider(create: (_) => di<RecipeProvider>()),
        ChangeNotifierProvider(create: (_) => di<PhaseProvider>()),
        ChangeNotifierProvider(create: (_) => di<RecipeProvider>()),
        ChangeNotifierProvider(create: (_) => di<OrderStatusProvider>()),
      ],
      child: Container(
        color: Theme.of(context).colorScheme.primary,
        child: LayoutBuilder(builder: (context, constraints) {
          if (constraints.maxWidth >= kTabletWidth) return HomePageWide();
          return HomePageTight();
        }),
      ),
    );
  }
}
