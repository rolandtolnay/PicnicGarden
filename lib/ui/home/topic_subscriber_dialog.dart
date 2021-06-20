import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../logic/extensions.dart';
import '../../provider/topic_provider.dart';

class TopicSubscriberDialog extends StatelessWidget {
  const TopicSubscriberDialog({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TopicProvider>();

    var content = <Widget>[Center(child: CircularProgressIndicator())];
    if (!provider.isLoading) {
      content = provider.topics
          .map((topic) => CheckboxListTile(
                title: Text(topic.name.capitalized),
                controlAffinity: ListTileControlAffinity.leading,
                value: provider.isSubscribedToTopic(topic),
                onChanged: (value) {
                  provider.setSubscribedToTopic(value, topic: topic);
                },
              ))
          .toList();
    }

    return AlertDialog(
      elevation: 2,
      title: Text('Subscribed topics'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [...content],
      ),
      actions: [
        FlatButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('CLOSE'),
        )
      ],
    );
  }
}
