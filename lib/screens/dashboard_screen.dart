
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:star_routes/game/star_routes.dart';

import 'package:star_routes/data/mission_data.dart';

import 'package:star_routes/screen_components/missions_page.dart';
import 'package:star_routes/screen_components/space_ships_page.dart';


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

  void acceptMissionCallback(MissionData missionData){
    print("Accepting Mission");
    widget.game.playerData.acceptedMissions.add(missionData);
    widget.game.playerData.availableMissions.remove(missionData);
    setState(() {});
  }

  void rejectMissionCallback(MissionData missionData){
    print("Rejecting Mission");
    widget.game.playerData.availableMissions.remove(missionData);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    List<MissionData> availableMissions = widget.game.playerData.availableMissions;
    List<MissionData> acceptedMissions = widget.game.playerData.acceptedMissions;
    List<MissionData> initiatedMissions = widget.game.playerData.initiatedMissions;

    return Container(
      /* Rounded borders */
      margin: const EdgeInsets.only(top: 95, left: 20, right: 20, bottom: 50),
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
                      overlayColor: WidgetStateProperty.all(const Color(0xFFA4A4A4).withOpacity(0.1)),
                    ),
                  ),
                  debugShowCheckedModeBanner: false,
                  home: DefaultTabController(
                    initialIndex: 0,
                    length: 2,
                    child: Scaffold(
                      /*Make corners round */

                      backgroundColor: Colors.transparent,
                      appBar: AppBar(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.transparent,
                        toolbarHeight: 0,
                        bottom: TabBar(

                          indicatorColor: const Color(0xFAEEEEEE),
                          labelColor: const Color(0xFAEEEEEE),
                          unselectedLabelColor: Colors.white.withOpacity(0.3),
                          tabs: [
                            Tab(
                              child: Text(
                              "Missions".toUpperCase(),
                              style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Audiowide',
                                ),
                              )
                            ),
                            Tab(
                                child: Text(
                                  "Ships".toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Audiowide',
                                  ),
                                )
                            ),
                          ],
                        ),
                      ),
                      body: TabBarView(
                        children: [
                          MissionsPage(
                              initiatedMissions: initiatedMissions,
                              acceptedMissions: acceptedMissions,
                              availableMissions: availableMissions,
                              onAccept: acceptMissionCallback,
                              onReject: rejectMissionCallback,
                          ),
                          SpaceShipsPage(
                            spaceShipStates: widget.game.playerData.spaceShipStates,
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ),
            )
        )
      )
    );
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    widget.game.dashboardButton.setState(false);
    return true;
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    BackButtonInterceptor.add(myInterceptor);
  }

  @override
  void dispose() {

    widget.game.dashboardButton.setState(false);
    BackButtonInterceptor.remove(myInterceptor);
    _tabController.dispose();
    super.dispose();
  }
}

