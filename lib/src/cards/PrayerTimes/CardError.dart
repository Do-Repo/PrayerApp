import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CardError extends StatelessWidget {
  const CardError({
    Key? key,
    required VoidCallback onPressed,
    required AsyncSnapshot snap,
  })  : snapshot = snap,
        func = onPressed,
        super(key: key);

  final AsyncSnapshot snapshot;
  final VoidCallback func;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 420.h,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Oops... Looks like something went wrong",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              "Make sure you're connected to the Internet and press retry, if that doesn't work you can always report the issue",
            ),
            Text(
              "ERROR: ${snapshot.error.toString()}",
              style: TextStyle(fontSize: 10),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Spacer(),
                TextButton(
                    onPressed: func,
                    child: Text(
                      "Try Again",
                      style: TextStyle(color: Colors.green),
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }
}
