import 'package:application_1/screens/Homepage.dart';
import 'package:application_1/screens/Quranpage.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TabbarStructure extends StatefulWidget {
  const TabbarStructure({Key key}) : super(key: key);

  @override
  _TabbarStructureState createState() => _TabbarStructureState();
}

class _TabbarStructureState extends State<TabbarStructure>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Container(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        brightness: Brightness.dark,
        centerTitle: false,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                icon: Icon(
                  Icons.menu,
                  size: 100.sp,
                ));
          },
        ),
        iconTheme: IconThemeData(color: Colors.green),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.notifications_outlined,
              size: 90.sp,
            ),
          ),
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.settings_outlined,
                size: 90.sp,
              ))
        ],
        title: Image.asset(
          'assets/images/title.png',
          scale: 2.5,
        ),
      ),
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        children: [
          HomePage(
            tabcontroller: _tabController,
          ),
          Container(
            color: Colors.yellow,
          ),
          Container(
            color: Colors.blue,
          ),
          QuranPage(
            tabController: _tabController,
          ),
        ],
        controller: _tabController,
      ),
    );
  }
}
