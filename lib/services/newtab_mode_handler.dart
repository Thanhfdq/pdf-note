import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../providers/tab_mangager.dart';

class NewtabModeHandler {
  static void handleNewTabButton(BuildContext context) {
    final tabsManager = Provider.of<TabsManager>(context, listen: false);
    tabsManager.addTab("new", "");
    tabsManager.setCurrentTab(tabsManager.tabs.length - 1);
    print(
        "Current tab: ${Provider.of<TabsManager>(context, listen: false).currentTab}");
  }
}
