import 'package:application_1/src/Tabbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(1080, 2160),
      builder: () => MaterialApp(
          debugShowCheckedModeBanner: false, home: TabbarStructure()),
    );
  }
}

// class Wrapper extends StatefulWidget {
//   @override
//   _WrapperState createState() => _WrapperState();
// }

// class _WrapperState extends State<Wrapper> with WidgetsBindingObserver {
//   PermissionStatus _permissionStatus;

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback(onLayoutDone);
//   }

//   void onLayoutDone(Duration timeStamp) async {
//     _permissionStatus = await Permission.location.status;
//     setState(() {});
//   }

//   void _askLocationPermission() async {
//     if (await Permission.location.request().isGranted) {
//       _permissionStatus = await Permission.location.status;
//       setState(() {});
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.white,
//       child: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: <Widget>[
//             Text(
//               '$_permissionStatus',
//               style: Theme.of(context).textTheme.headline5,
//             ),
//             RaisedButton(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(
//                   vertical: 14.0,
//                 ),
//                 child: Text(
//                   'Request Permission',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 16.0,
//                   ),
//                 ),
//               ),
//               color: Colors.lightBlue,
//               onPressed: () {
//                 _askLocationPermission();
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
