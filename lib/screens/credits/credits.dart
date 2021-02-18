
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

/// Widget for displaying informations about open source dependencies
class CreditsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('about_title'.tr()),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 8.0, top: 16.0, right: 8.0, bottom: 16.0),
        child: Column(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.all(20),
                width: 180,
                height: 180,
                child: Center(
                  child: Image.asset("assets/app_logo_circle.png"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                child: Text(
                  'Balance Mobile ©',
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Authors',
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      Divider(),
                      SizedBox(height: 4.0),
                      Text(
                        'Emanuele Lattanzi, Valerio Freschi, Gioele Bigini',
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Developers',
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      Divider(),
                      SizedBox(height: 4.0),
                      Text(
                        'Gioele Bigini, Gianmarco di Francesco, Lorenzo Calisti',
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Collaboratori',
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      Divider(),
                      SizedBox(height: 4.0),
                      Text(
                        'Lorenz Cuno Klopfestein, Saverio Delpriori',
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Responsabile del Trattamento Dati',
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      Divider(),
                      SizedBox(height: 4.0),
                      Text(
                        'Alessandro Bogliolo',
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sponsor e Partner',
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      Divider(),
                      SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            width: 75,
                            height: 75,
                            child: Row(
                                children: [
                                  Image.asset("assets/digitsrl.png"),
                                ]
                            ),
                          ),
                          Container(
                            width: 75,
                            height: 75,
                            child: Row(
                                children: [
                                  Image.asset("assets/marche_region.png"),
                                ]
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            width: 75,
                            height: 75,
                            child: Row(
                                children: [
                                  Image.asset("assets/tuwien.png"),
                                ]
                            ),
                          ),
                          Container(
                            width: 75,
                            height: 75,
                            child: Row(
                                children: [
                                  Image.asset("assets/univpm.png"),
                                ]
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}