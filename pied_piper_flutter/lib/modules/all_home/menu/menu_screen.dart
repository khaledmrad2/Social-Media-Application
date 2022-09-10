import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pied_piper/modules/Post/saved_post/savedposts_screen.dart';

import '../../../shared/components/components.dart';
import '../../Post/getpost/SpaceScreen.dart';
import '../../groups/create_group/creategroup_screen.dart';
import '../../groups/groups_view/allgroups_screen.dart';
import '../../groups/invitations/myinvitations_screen.dart';
import '../../groups/mygroups/mygroups_screen.dart';
import '../../setting/setting_sceen.dart';
import '../../users/suggest_friends/suggestfriends_screen.dart';

class MenuScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.green[200],
        body: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: BottomMenu(
                      screen: SettingScreen(),
                      BottomName: 'Settings',
                      BottomIcon: Icon(
                        Icons.settings,
                        size: 35,
                        color: Colors.green[500],
                      ),
                      context: context,
                    ),
                  ),
                  Expanded(
                    child: BottomMenu(
                      screen: SavedPostsScreen(),
                      BottomName: 'Saved Posts',
                      BottomIcon: Icon(
                        Icons.star_rate,
                        size: 35,
                        color: Colors.green[500],
                      ),
                      context: context,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: BottomMenu(
                      screen: SugestedScreen(),
                      BottomName: 'Suggest Friends',
                      BottomIcon: Icon(
                        Icons.group_add,
                        size: 35,
                        color: Colors.green[500],
                      ),
                      context: context,
                    ),
                  ),
                  Expanded(
                    child: BottomMenu(
                      screen: AllGroupsScreen(),
                      BottomName: 'Groups',
                      BottomIcon: Icon(
                        Icons.group_rounded,
                        size: 35,
                        color: Colors.green[500],
                      ),
                      context: context,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: BottomMenu(
                      screen: MyInvitationsScreen(),
                      BottomName: 'Groups Invitations',
                      BottomIcon: Icon(
                        Icons.insert_invitation,
                        size: 35,
                        color: Colors.green[500],
                      ),
                      context: context,
                    ),
                  ),
                  Expanded(
                    child: BottomMenu(
                      screen: MyGroupsScreen(),
                      BottomName: 'Your Groups',
                      BottomIcon: Icon(
                        Icons.group,
                        size: 35,
                        color: Colors.green[500],
                      ),
                      context: context,
                    ),
                  ),
                ],
              ),
              Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Expanded(
                  child: BottomMenu(
                    screen: CreateGroupScreen(),
                    BottomName: 'Create Group',
                    BottomIcon: Icon(
                      Icons.create,
                      size: 35,
                      color: Colors.green[500],
                    ),
                    context: context,
                  ),
                ),
              ])
            ],
          ),
        ));
  }
}
