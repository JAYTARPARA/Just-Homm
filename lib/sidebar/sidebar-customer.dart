import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:justhomm/common/common.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class SidebarCustomer extends StatefulWidget {
  @override
  _SidebarCustomerState createState() => _SidebarCustomerState();
}

class _SidebarCustomerState extends State<SidebarCustomer> {
  // final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String userMobile;

  @override
  void initState() {
    super.initState();
    userMobile = GlobalConfiguration().getString("mobile");
    print(userMobile);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          _createHeader(userMobile, context),
          _customerMenu(context),
        ],
      ),
    );
  }
}

Widget _customerMenu(context) {
  return Container(
    child: Column(
      children: <Widget>[
        SizedBox(
          height: 30.0,
        ),
        ListTile(
          title: Text(
            'My Profile',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w300,
              color: Colors.white,
            ),
          ),
          leading: Icon(
            Icons.account_circle,
            color: Colors.white,
            size: 30,
          ),
          onTap: () {
            String currentPage = ModalRoute.of(context).settings.name;
            if (currentPage != '/profile') {
              Navigator.pushNamedAndRemoveUntil(
                context,
                "/profile",
                (r) => false,
              );
            } else {
              Navigator.of(context).pop();
            }
          },
        ),
        ListTile(
          title: Text(
            'Change Password',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w300,
              color: Colors.white,
            ),
          ),
          leading: Icon(
            Icons.security,
            color: Colors.white,
            size: 30,
          ),
          onTap: () {
            String currentPage = ModalRoute.of(context).settings.name;
            if (currentPage != '/change-password') {
              Navigator.pushNamedAndRemoveUntil(
                context,
                "/change-password",
                (r) => false,
              );
            } else {
              Navigator.of(context).pop();
            }
          },
        ),
        ListTile(
          title: Text(
            'My Balance',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w300,
              color: Colors.white,
            ),
          ),
          leading: Icon(
            Icons.account_balance_wallet,
            color: Colors.white,
            size: 30,
          ),
          onTap: () {
            String currentPage = ModalRoute.of(context).settings.name;
            if (currentPage != '/profile') {
              Navigator.pushNamedAndRemoveUntil(
                context,
                "/profile",
                (r) => false,
              );
            } else {
              Navigator.of(context).pop();
            }
          },
        ),
        Divider(
          height: 50,
          thickness: 0.5,
          color: Colors.white.withOpacity(0.3),
          indent: 15,
          endIndent: 15,
        ),
        ListTile(
          title: Text(
            'Share',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w300,
              color: Colors.white,
            ),
          ),
          leading: Icon(
            Icons.share,
            color: Colors.white,
            size: 30,
          ),
          onTap: () {
            String currentPage = ModalRoute.of(context).settings.name;
            if (currentPage != '/profile') {
              Navigator.pushNamedAndRemoveUntil(
                context,
                "/profile",
                (r) => false,
              );
            } else {
              Navigator.of(context).pop();
            }
          },
        ),
        ListTile(
          title: Text(
            'Logout',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w300,
              color: Colors.white,
            ),
          ),
          leading: Icon(
            Icons.exit_to_app,
            color: Colors.white,
            size: 30,
          ),
          onTap: () async {
            Alert(
              context: context,
              type: AlertType.warning,
              style: AlertStyle(
                animationType: AnimationType.fromTop,
                isCloseButton: false,
                // animationDuration: Duration(milliseconds: 400),
              ),
              title: "ALERT!!!",
              desc: "Are you sure!!! Do you want to logout?",
              buttons: [
                DialogButton(
                  color: Colors.black87,
                  child: Text(
                    "NO",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  onPressed: () {
                    print('NOOOO');
                    Navigator.pop(context);
                  },
                ),
                DialogButton(
                  color: Colors.black87,
                  child: Text(
                    "YES",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  onPressed: () async {
                    print('YESSS');
                    await Common().writeData(
                      'loggedout',
                      'yes',
                    );
                    await Common().logOut();
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      "/home",
                      (r) => false,
                    );
                  },
                ),
              ],
            ).show();
          },
        ),
      ],
    ),
  );
}

Widget _createHeader(userMobile, context) {
  return Container(
    height: 200.0,
    child: DrawerHeader(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        // color: Colors.black87,
        image: DecorationImage(
          fit: BoxFit.fill,
          image: AssetImage(
            'assets/images/sidebar_header.jpg',
          ),
        ),
      ),
      child: Center(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 18.0,
            ),
            CircularProfileAvatar(
              'https://i.ibb.co/rQv9CjQ/customer.png',
              radius: 60,
              cacheImage: true,
              backgroundColor: Colors.transparent,
              borderWidth: 3,
              borderColor: Colors.white,
              elevation: 5.0,
              foregroundColor: Colors.black87.withOpacity(0.5),
              onTap: () {
                print('pressed on icon');
                String currentPage = ModalRoute.of(context).settings.name;
                if (currentPage != '/profile') {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    "/profile",
                    (r) => false,
                  );
                } else {
                  Navigator.of(context).pop();
                }
              },
              showInitialTextAbovePicture: true,
            ),
            SizedBox(
              height: 18.0,
            ),
            Text(
              userMobile,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
