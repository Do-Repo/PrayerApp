import 'package:application_1/screens/HadithPage/HadithList.dart';
import 'package:application_1/screens/Homepage.dart';
import 'package:application_1/screens/Qiblah.dart';
import 'package:application_1/screens/Quranpage/QuranList.dart';

import 'package:application_1/src/Drawer.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TabbarStructure extends StatefulWidget {
  const TabbarStructure({Key? key}) : super(key: key);

  @override
  _TabbarStructureState createState() => _TabbarStructureState();
}

class _TabbarStructureState extends State<TabbarStructure>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
    _tabController!.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: DrawerContent(
        tabController: _tabController,
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        brightness: Brightness.dark,
        centerTitle: false,
        elevation: 0,
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
      ),
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        children: [
          HomePage(
            tabcontroller: _tabController,
          ),
          QuranList(
            isArabic: true,
            tabController: _tabController,
          ),
          QuranList(
            isArabic: false,
            tabController: _tabController,
          ),
          HadithList(isArabic: false, tabController: _tabController),
          HadithList(isArabic: true, tabController: _tabController),
          Qiblah(tabController: _tabController),
        ],
        controller: _tabController,
      ),
    );
  }
}
