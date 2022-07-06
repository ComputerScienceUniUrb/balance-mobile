
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

class CreditsScreen extends StatefulWidget {
  @override
  _CreditsScreenState createState() => _CreditsScreenState();
}

/// Widget for displaying informations about open source dependencies
class _CreditsScreenState extends State<CreditsScreen> {
  PackageInfo packageInfo;

  @override
  void initState() {
    super.initState();
    PackageInfo.fromPlatform().then((value) => setState(() => packageInfo = value));
  }

  @override
  Widget build(BuildContext context) {
    PackageInfo.fromPlatform().then((value) => packageInfo = value);
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
                padding: const EdgeInsets.fromLTRB(0.0,16.0,0.0,0.0),
                child: Text(
                  'Balance Mobile ©',
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                child: Text(
                  "${'version_txt'.tr()} ${packageInfo?.version} (${'build_txt'.tr()}${packageInfo?.buildNumber})",
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                child: Text(
                  "credits_description_txt".tr(),
                  style: Theme.of(context).textTheme.headline4.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w500
                  ),
                  textAlign: TextAlign.justify,
                ),
              ),
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'credits_authors_txt'.tr(),
                        style: Theme.of(context).textTheme.headline4.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w700
                        )
                      ),
                      Divider(),
                      RichText(
                        overflow: TextOverflow.clip,
                        text: TextSpan(
                          text: 'Emanuele Lattanzi',
                          style: Theme.of(context).textTheme.headline4.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w700
                          )
                        ),
                      ),
                      Text(
                        'credits_authors_lattanzi_txt'.tr(),
                        style: Theme.of(context).textTheme.headline4.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w400
                        )
                      ),
                      SizedBox(height: 8.0),
                      RichText(
                        overflow: TextOverflow.clip,
                        text: TextSpan(
                          text: 'Valerio Freschi',
                          style: Theme.of(context).textTheme.headline4.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w700
                          )
                        ),
                      ),
                      Text(
                        'credits_authors_freschi_txt'.tr(),
                        style: Theme.of(context).textTheme.headline4.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w400
                        )
                      ),
                      SizedBox(height: 8.0),
                      RichText(
                        overflow: TextOverflow.clip,
                        text: TextSpan(
                          text: 'Gioele Bigini',
                          style: Theme.of(context).textTheme.headline4.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w700
                          )
                        ),
                      ),
                      Text(
                        'credits_authors_bigini_txt'.tr(),
                        style: Theme.of(context).textTheme.headline4.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w400
                        )
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'credits_developers_txt'.tr(),
                        style: Theme.of(context).textTheme.headline4.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.w700
                        )
                      ),
                      Divider(),
                      RichText(
                        overflow: TextOverflow.clip,
                        text: TextSpan(
                          text: 'Gioele Bigini',
                          style: Theme.of(context).textTheme.headline4.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w700
                          )
                        ),
                      ),
                      Text(
                        'credits_developers_bigini_txt'.tr(),
                        style: Theme.of(context).textTheme.headline4.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w400
                        )
                      ),
                      SizedBox(height: 8.0),
                      RichText(
                        overflow: TextOverflow.clip,
                        text: TextSpan(
                          text: 'Gian Marco di Francesco',
                          style: Theme.of(context).textTheme.headline4.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w700
                          )
                        ),
                      ),
                      Text(
                        'credits_developers_difrancesco_txt'.tr(),
                        style: Theme.of(context).textTheme.headline4.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w400
                        )
                      ),
                      SizedBox(height: 8.0),
                      RichText(
                        overflow: TextOverflow.clip,
                        text: TextSpan(
                          text: 'Lorenzo Calisti',
                          style: Theme.of(context).textTheme.headline4.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w700
                          )
                        ),
                      ),
                      Text(
                        'credits_developers_calisti_txt'.tr(),
                        style: Theme.of(context).textTheme.headline4.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w400
                        )
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'credits_collaborators_txt'.tr(),
                        style: Theme.of(context).textTheme.headline4.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.w700
                        )
                      ),
                      Divider(),
                      RichText(
                        overflow: TextOverflow.clip,
                        text: TextSpan(
                          text: 'Lorenz Cuno Klopfenstein',
                          style: Theme.of(context).textTheme.headline4.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w700
                          )
                        ),
                      ),
                      Text(
                        'credits_collaborators_klopfenstein_txt'.tr(),
                        style: Theme.of(context).textTheme.headline4.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w400
                        )
                      ),
                      SizedBox(height: 8.0),
                      RichText(
                        overflow: TextOverflow.clip,
                        text: TextSpan(
                          text: 'Saverio Delpriori',
                          style: Theme.of(context).textTheme.headline4.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w700
                          )
                        ),
                      ),
                      Text(
                        'credits_collaborators_delpriori_txt'.tr(),
                        style: Theme.of(context).textTheme.headline4.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w400
                        )
                      ),
                      SizedBox(height: 8.0),
                      RichText(
                        overflow: TextOverflow.clip,
                        text: TextSpan(
                          text: 'Alessandro Bogliolo',
                          style: Theme.of(context).textTheme.headline4.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w700
                          )
                        ),
                      ),
                      Text(
                        'credits_collaborators_bogliolo_txt'.tr(),
                        style: Theme.of(context).textTheme.headline4.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w400
                        )
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'credits_foundation_title'.tr(),
                        style: Theme.of(context).textTheme.headline4.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.w700
                        )
                      ),
                      Divider(),
                      InkWell(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              RichText(
                                overflow: TextOverflow.clip,
                                text: TextSpan(
                                  text: 'Standing Balance Assessment by Measurement of Body Center of Gravity Using Smartphones',
                                  style: Theme.of(context).textTheme.headline6.copyWith(fontSize: 13),
                                ),
                              ),
                              Text(
                                'E. Lattanzi et al., IEEE Access, 2019',
                                style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 12),
                              ),
                            ],
                          ),
                          onTap: () async {
                            const url = 'https://ieeexplore.ieee.org/document/9097903';
                            if (await canLaunch(url)) {
                              await launch(url);
                            } else {
                              throw 'Could not launch $url';
                            }
                          }
                      ),
                      SizedBox(height: 8.0),
                      InkWell(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              RichText(
                                overflow: TextOverflow.clip,
                                text: TextSpan(
                                  text: 'A Review on Blockchain for the Internet of Medical Things',
                                  style: Theme.of(context).textTheme.headline6.copyWith(fontSize: 13),
                                ),
                              ),
                              Text(
                                'G. Bigini et al., Future Internet, 2020',
                                style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 12),
                              ),
                            ],
                          ),
                          onTap: () async {
                            const url = 'https://www.mdpi.com/1999-5903/12/12/208';
                            if (await canLaunch(url)) {
                              await launch(url);
                            } else {
                              throw 'Could not launch $url';
                            }
                          }
                      ),
                      SizedBox(height: 8.0),
                      InkWell(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              RichText(
                                overflow: TextOverflow.clip,
                                text: TextSpan(
                                  text: 'Decentralising the IoMT with DLTs and Off-Chain Storages',
                                  style: Theme.of(context).textTheme.headline6.copyWith(fontSize: 13),
                                ),
                              ),
                              Text(
                                'G. Bigini et al., International Conference on Smart Objects and Technologies for Social Good, 2021',
                                style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 12),
                              ),
                            ],
                          ),
                          onTap: () async {
                            const url = 'https://books.google.it/books?hl=it&lr=&id=GNNSEAAAQBAJ&oi=fnd&pg=PA80&dq=Decentralising+the+Internet+of+Medical+Things+with+Distributed+Ledger+Technologies+and+Off-Chain+Storages:+A+Proof+of+Concept&ots=FF0rKuUYMI&sig=WIRf5X7f-tMJiJNu-YfKCDw_vec&redir_esc=y#v=onepage&q=Decentralising%20the%20Internet%20of%20Medical%20Things%20with%20Distributed%20Ledger%20Technologies%20and%20Off-Chain%20Storages%3A%20A%20Proof%20of%20Concept&f=false';
                            if (await canLaunch(url)) {
                              await launch(url);
                            } else {
                              throw 'Could not launch $url';
                            }
                          }
                      ),
                      SizedBox(height: 8.0),
                    ],
                  ),
                ),
              ),
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'credits_more_info_title'.tr(),
                        style: Theme.of(context).textTheme.headline4.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.w700
                        )
                      ),
                      Divider(),
                      Row(
                        children: <Widget>[
                          IconButton(
                              icon: Icon(Icons.link),
                              onPressed: () async {
                                const url = 'https://balancemobile.it';
                                if (await canLaunch(url)) {
                                  await launch(url);
                                } else {
                                  throw 'Could not launch $url';
                                }
                              }
                          ),
                          RichText(
                            overflow: TextOverflow.clip,
                            text: TextSpan(
                              text: 'credits_website_txt'.tr(),
                              style: Theme.of(context).textTheme.headline6.copyWith(fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          IconButton(
                              icon: Icon(Icons.link),
                              onPressed: () async {
                                const url = 'https://balancemobile.it/privacy';
                                if (await canLaunch(url)) {
                                  await launch(url);
                                } else {
                                  throw 'Could not launch $url';
                                }
                              }
                          ),
                          Flexible(
                            child: RichText(
                              overflow: TextOverflow.clip,
                              text: TextSpan(
                                text: 'credits_privacy_txt'.tr(),
                                style: Theme.of(context).textTheme.headline6.copyWith(fontSize: 13),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.0),
                    ],
                  ),
                ),
              ),
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'credits_sponsors_partners_txt'.tr(),
                        style: Theme.of(context).textTheme.headline4.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.w700
                        )
                      ),
                      Divider(),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            width: 75,
                            height: 75,
                            child: Row(
                                children: [
                                  Image.asset("assets/uniurb.png"),
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
                      SizedBox(height: 24),
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