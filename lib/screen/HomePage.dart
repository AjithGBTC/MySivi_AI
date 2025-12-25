import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'UsersPage.dart';
import 'ChatHistoryPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late TabController tabController;
  bool showSwitcher = true;
  late ScrollController userScroll;
  late ScrollController historyScroll;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    userScroll = ScrollController();
    historyScroll = ScrollController();

    userScroll.addListener(_scrollListener);
    historyScroll.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (userScroll.position.userScrollDirection == ScrollDirection.reverse ||
        historyScroll.position.userScrollDirection == ScrollDirection.reverse) {
      if (showSwitcher) setState(() => showSwitcher = false);
    }

    if (userScroll.position.userScrollDirection == ScrollDirection.forward ||
        historyScroll.position.userScrollDirection == ScrollDirection.forward) {
      if (!showSwitcher) setState(() => showSwitcher = true);
    }
  }

  @override
  void dispose() {
    tabController.dispose();
    userScroll.dispose();
    historyScroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: showSwitcher
            ? Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _switchBtn("Users", 0),
                _switchBtn("Chat History", 1),
              ],
            ),
          ),
        )
            : const SizedBox(),
      ),
      body: Column(
        children: [
          SizedBox(height: 10,),

          Divider(indent: 10,endIndent: 10,),

          SizedBox(height: 10,),
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: [
                UsersPage(scroll: userScroll),
                ChatHistoryPage(scroll: historyScroll),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _switchBtn(String text, int i) {
    return GestureDetector(
      onTap: () {
        tabController.animateTo(i);
        setState(() {});
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
            color: tabController.index == i ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: tabController.index == i ? Colors.black : Colors.grey.shade700,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}