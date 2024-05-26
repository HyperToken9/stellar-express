
import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:star_routes/game/star_routes.dart';

import 'package:star_routes/screen_components/missions_page.dart';


class DashboardScreen extends StatefulWidget {

  final StarRoutes game;
  static const String id = "dashboard";

  const DashboardScreen({super.key, required this.game});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with SingleTickerProviderStateMixin {
  /*Tab controller */
  late TabController _tabController;
  // = TabController(length: 3, vsync: this)
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }
  
  @override
  Widget build(BuildContext context) {
    late PageController _pageController= PageController();
    int _currentIndex = 0;

    @override
    void initState() {
      super.initState();
      // _pageController
    }

    @override
    void dispose() {
      _pageController.dispose();
      super.dispose();
    }

    void onTabTapped(int index) {
      setState(() {
        _currentIndex = index;
      });
      _pageController.animateToPage(index, duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
    }


    return Container(
      /* Rounded borders */
      margin: EdgeInsets.only(top: 95, left: 20, right: 20, bottom: 50),
      child: ClipRect(

        child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                /* Add rounded borders to the container */
                decoration: BoxDecoration(
                  color: const Color(0xFFA4A4A4).withOpacity(0.57),
                ),

                child: MaterialApp(
                  theme: ThemeData(
                    tabBarTheme: TabBarTheme(
                      overlayColor: MaterialStateProperty.all(const Color(0xFFA4A4A4).withOpacity(0.1)),
                    ),
                  ),
                  debugShowCheckedModeBanner: false,
                  home: DefaultTabController(
                    length: 2,
                    child: Scaffold(
                      /*Make corners round */

                      backgroundColor: Colors.transparent,
                      appBar: AppBar(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.transparent,
                        toolbarHeight: 0,
                        bottom: TabBar(

                          indicatorColor: Color(0xFAEEEEEE),
                          labelColor: Color(0xFAEEEEEE),
                          unselectedLabelColor: Colors.white.withOpacity(0.3),
                          tabs: [
                            Tab(
                              child: Text(
                              "Missions".toUpperCase(),
                              style: TextStyle(
                                  fontSize: 15,
                                ),
                              )
                            ),
                            Tab(
                                child: Text(
                                  "Ships".toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                )
                            ),
                          ],
                        ),
                      ),
                      body: const TabBarView(
                        children: [
                          MissionsPage(),
                          Icon(Icons.directions_transit),
                        ],
                      ),
                    ),
                  ),
                )

              // color: Color(0xFFA4A4A4).withOpacity(0.5),
              /* Add background blur to the container */
                  ),
            ))));
  }
}

