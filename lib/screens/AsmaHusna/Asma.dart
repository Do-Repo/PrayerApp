import 'package:flutter/material.dart';
import 'package:application_1/models/asma.dart';
import 'package:application_1/screens/QuranPage/QuranPage.dart';
import 'package:application_1/src/apiCalls.dart';
import 'package:application_1/src/widgetAnimator.dart';

class AsmaHosna extends StatefulWidget {
  const AsmaHosna({Key? key}) : super(key: key);

  @override
  State<AsmaHosna> createState() => _AsmaHosnaState();
}

class _AsmaHosnaState extends State<AsmaHosna>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        appBar: AppBar(
          title: Text("Asma al Husna"),
          elevation: 0,
        ),
        body: Column(
          children: [
            Flexible(
              child: FutureBuilder(
                future: getNames(),
                builder: (context, AsyncSnapshot<List<Asma>> snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return Column(
                      children: const [LinearProgressIndicator(), Spacer()],
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
                                ? Colors.transparent
                                : Theme.of(context)
                                    .colorScheme
                                    .secondary
                                    .withOpacity(0.1),
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

  @override
  bool get wantKeepAlive => true;
}
