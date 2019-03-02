import 'package:flutter/material.dart';
import 'package:firebase_admob/firebase_admob.dart';

void main() {
  // Initialize AdMob
  FirebaseAdMob.instance
      .initialize(appId: 'ca-app-pub-3940256099942544~3347511713');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter + AdMob Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  var myInterstitial;
  var myBanner1;
  var myBanner2;

  @override
  void initState() {
    super.initState();
    MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
      keywords: <String>['flutterio', 'beautiful apps'],
      contentUrl: 'https://flutter.io',
      birthday: DateTime.now(),
      childDirected: false,
      designedForFamilies: false,
      gender: MobileAdGender.male,
      testDevices: <String>[], // Android emulators are considered test devices
    );

    myBanner1 = BannerAd(
      adUnitId: BannerAd.testAdUnitId,
      size: AdSize.smartBanner,
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        print("BannerAd event is $event");
      },
    );

    myBanner2 = BannerAd(
      adUnitId: BannerAd.testAdUnitId,
      size: AdSize.smartBanner,
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        print("BannerAd event is $event");
      },
    );

//    myInterstitial = InterstitialAd(
//      // Replace the testAdUnitId with an ad unit id from the AdMob dash.
//      // https://developers.google.com/admob/android/test-ads
//      // https://developers.google.com/admob/ios/test-ads
//      adUnitId: InterstitialAd.testAdUnitId,
//      targetingInfo: targetingInfo,
//      listener: (MobileAdEvent event) {
//        print("InterstitialAd event is $event");
//      },
//    );
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    var scaffold = Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: LayoutBuilder(builder: (context, constraint) {
        /*
         * zonble:
         *
         * Actually the banner is not a Flutter widget but a native view above
         * the Flutter view, and we can only set the offset of banner, but not
         * to set its layout within a container.
         *
         * However, We can still use a layout builder here to know about the
         * height of the  region without the app bar, and then set the offset
         * of the admob view.
         */
        var offset = MediaQuery.of(context).size.height - constraint.maxHeight;
        myBanner1
          ..load()
          ..show(
            anchorOffset: offset,
            anchorType: AnchorType.top,
          );
//        myInterstitial
//          ..load()
//          ..show(
//            anchorType: AnchorType.bottom,
//            anchorOffset: 0.0,
//          );

        return Column(
          children: <Widget>[
            Expanded(child: LayoutBuilder(builder: (context, constraint2) {
              var offset2 = constraint.maxHeight - constraint2.maxHeight;
              myBanner2
                ..load()
                ..show(
                  anchorOffset: offset2,
                  anchorType: AnchorType.bottom,
                );

              return buildCenter(context);
            })),
            BottomNavigationBar(
              items: [
                BottomNavigationBarItem(
                    icon: Icon(Icons.add), title: Text('1')),
                BottomNavigationBarItem(icon: Icon(Icons.add), title: Text('2'))
              ],
            ),
          ],
        );
      }),
    );
    return scaffold;
  }

  Widget buildCenter(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
