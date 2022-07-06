
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:balance/generated/dependencies.g.dart';

/// Widget for displaying informations about open source dependencies
class OpenSourceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('open_source_txt'.tr()),
      ),
      body: ListView(
        children: dependencies.map((e) => Card(
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    e["name"] ?? "",
                    style: Theme.of(context).textTheme.headline4.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w800
                    )
                ),
                SizedBox(width: 8.0),
                Text(
                  e["version"] ?? '',
                  style: Theme.of(context).textTheme.headline4.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w500
                  )
                ),
                e["description"] != null ?
                Column(
                  children: [
                    Divider(),
                    SizedBox(height: 4.0),
                    Text(
                      e["description"],
                      style: Theme.of(context).textTheme.headline4.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w500
                      )
                    )
                  ],
                ) : SizedBox(height: 0.0),
              ],
            ),
          ),
        )).toList(),
      ),
    );
  }
}