import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:justhomm/common/common.dart';
import 'package:justhomm/sidebar/sidebar-broker.dart';
import 'package:justhomm/sidebar/sidebar-customer.dart';
import 'package:global_configuration/global_configuration.dart';

class PropertyList extends StatefulWidget {
  @override
  _PropertyListState createState() => _PropertyListState();
}

class _PropertyListState extends State<PropertyList> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String responseUserRole;

  @override
  void initState() {
    super.initState();
    responseUserRole = GlobalConfiguration().getString("role");
    // GlobalConfiguration().updateValue("role", "broker");
    // Future.delayed(Duration.zero, this.checkUserRole);
  }

  checkUserRole() async {
    responseUserRole = await Common().readData('userrole');
    print(responseUserRole);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('All Properties'),
        centerTitle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(25),
          ),
        ),
      ),
      drawer: responseUserRole == 'broker' ? SidebarBroker() : SidebarCustomer(),
      body: DoubleBackToCloseApp(
        snackBar: const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('Press again to exit'),
        ),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Welcome',
                style: TextStyle(fontSize: 25.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
