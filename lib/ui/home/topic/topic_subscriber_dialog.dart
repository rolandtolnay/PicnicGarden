import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../domain/extensions.dart';
import '../../../domain/model/topic.dart';
import '../../common/common_dialog.dart';
import '../../common/dialog_cancel_button.dart';
import '../../common/dialog_title.dart';
import 'topic_provider.dart';

class TopicSubscriberDialog extends StatelessWidget {
  const TopicSubscriberDialog({Key? key}) : super(key: key);

  static void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => context.buildTopicSubscriber(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TopicProvider>();

    var content = <Widget>[Center(child: CircularProgressIndicator())];
    if (!provider.isLoading) {
      content = provider.topics
          .map((topic) => _buildCheckboxTile(topic, provider))
          .toList();
    }

    return CommonDialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const DialogTitle(
            text: 'Subscribed topics',
            icon: Icons.notifications,
          ),
          ...content,
          const DialogCancelButton(),
        ],
      ),
    );
  }

  CheckboxListTile _buildCheckboxTile(Topic topic, TopicProvider provider) {
    return CheckboxListTile(
      title: Text(topic.name.capitalized),
      controlAffinity: ListTileControlAffinity.leading,
      value: provider.isSubscribedToTopic(topic),
      onChanged: (value) {
        if (value == null) return;
        provider.setSubscribedToTopic(value, topic: topic);
      },
    );
  }
}

extension on BuildContext {
  Widget buildTopicSubscriber() {
    return ChangeNotifierProvider.value(
      value: read<TopicProvider>(),
      child: TopicSubscriberDialog(),
    );
  }
}
