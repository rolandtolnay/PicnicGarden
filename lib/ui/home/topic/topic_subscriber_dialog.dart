import 'package:flutter/material.dart';
import 'package:picnicgarden/domain/model/topic.dart';
import 'package:provider/provider.dart';

import '../../../domain/extensions.dart';
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
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final provider = context.watch<TopicProvider>();

    var content = <Widget>[Center(child: CircularProgressIndicator())];
    if (!provider.isLoading) {
      content = provider.topics
          .map((topic) => _buildCheckboxTile(topic, provider))
          .toList();
    }

    // TODO: Extract common Dialog widget
    return Dialog(
      elevation: 2,
      insetPadding: EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 24,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 24),
            Row(
              children: [
                const SizedBox(width: 16.0),
                const Icon(Icons.notifications),
                const SizedBox(width: 8.0),
                Text('Subscribed topics', style: textTheme.headline6),
              ],
            ),
            const SizedBox(height: 16),
            ...content,
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('CLOSE'),
                ),
              ),
            )
          ],
        ),
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
