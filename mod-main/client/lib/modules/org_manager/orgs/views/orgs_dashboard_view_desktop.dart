import 'package:flutter/material.dart';
import 'package:mod_main/modules/org_manager/orgs/view_model/orgs_view_model.dart';
import 'package:mod_main/modules/org_manager/orgs/widgets/data_pane/data_pane.dart';

import 'package:mod_main/modules/org_manager/orgs/widgets/filter_pane.dart';
import 'package:responsive_builder/responsive_builder.dart';

class OrgDashboardDesktopView extends StatelessWidget {
  final OrgsViewModel model;

  const OrgDashboardDesktopView({Key key, this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("Desktop ");
    return Scaffold(
      body: ResponsiveBuilder(
        builder: (context, sizingInfo) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              FilterPane(sizingInfo: sizingInfo),
              SizedBox(width: 16),
              Expanded(
                  child: DataPane(
                sizingInfo: sizingInfo,
                model: model,
              )),
            ],
          );
        },
      ),
    );
  }
}
