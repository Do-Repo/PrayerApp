import 'package:application_1/models/AsmaModel.dart';
import 'package:application_1/src/customWidgets/API.dart';
import 'package:application_1/src/customWidgets/animator.dart';
import 'package:application_1/src/customWidgets/customWidgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AsmaHosna extends StatefulWidget {
  const AsmaHosna({Key? key, required this.pageController}) : super(key: key);
  final PageController pageController;

  @override
  State<AsmaHosna> createState() => _AsmaHosnaState();
}

class _AsmaHosnaState extends State<AsmaHosna> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        customHomeAppbar(context, widget.pageController,
            AppLocalizations.of(context)!.asmaAlHusnatitle, false, () {}),
        Flexible(
          child: FutureBuilder(
            future: getNames(),
            builder: (context, AsyncSnapshot<List<Asma>> snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return Column(
                  children: [LinearProgressIndicator(), Spacer()],
                );
              } else if (snapshot.hasError) {
                return Column(
                  children: [
                    NoConnectionWidget(function: () {
                      setState(() {
                        getNames();
                      });
                    }),
                  ],
                );
              } else {
                List<Widget> reasonList = [];
                snapshot.data!.forEach((element) {
                  reasonList.add(ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(element.transliteration),
                        Text(element.name),
                      ],
                    ),
                    subtitle: Text(element.meaning),
                  ));
                });
                return ListView.builder(
                  itemBuilder: (context, i) {
                    return WidgetAnimator(
                      child: Container(
                        color: (i.isOdd)
                            ? Theme.of(context).backgroundColor
                            : Colors.transparent,
                        child: reasonList[i],
                      ),
                    );
                  },
                  itemCount: reasonList.length,
                );
              }
            },
          ),
        )
      ],
    ));
  }
}
