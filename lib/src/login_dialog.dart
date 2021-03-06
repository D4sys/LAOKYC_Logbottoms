import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:laokyc_logbottom/src/callfunction.dart';
import 'package:laokyc_logbottom/utils/prefUserInfo.dart';
import 'package:laokyc_logbottom/constant/route.dart' as custom_route;
import 'package:platform_device_id/platform_device_id.dart';

import 'dialogreqotp.dart';

class DialogLogin extends StatefulWidget {
  late String clientId;
  late String redirectUrl;
  late String clientSecret;
  late List<String> scope;
  DialogLogin({
    required this.clientId,
    required this.clientSecret,
    required this.redirectUrl,
    List<String>? scope,
  }) : this.scope = scope ?? [];

  @override
  _DialogLoginState createState() => _DialogLoginState();
}

class _DialogLoginState extends State<DialogLogin> {
  //late Buttslog data;
  late Timer _timer;
  late String deviceId;
  final tfDialogLoginPhoneNumber = TextEditingController();
  final FlutterAppAuth _appAuth = FlutterAppAuth();
  late final String _clientId;
  late final String _redirectUrl;
  late final List<String> _scope = <String>[];
  late String _idToken;
  late String _accessToken;
  late String _first_name;
  late String _family_name;
  late String _preferred_username;
  late String _phone;
  late String _sub;
  final TextEditingController _authorizationCodeTextController =
      TextEditingController();
  final TextEditingController _accessTokenTextController =
      TextEditingController();

  final TextEditingController _accessTokenExpirationTextController =
      TextEditingController();

  final TextEditingController _idTokenTextController = TextEditingController();
  final TextEditingController _refreshTokenTextController =
      TextEditingController();

  final AuthorizationServiceConfiguration _serviceConfiguration =
      AuthorizationServiceConfiguration(
          'https://login.oneid.sbg.la/connect/authorize',
          'https://login.oneid.sbg.la/connect/token');

  get http => null;

  Future<void> _requestOTP(String urlPath, String phonenumber) async {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        _timer = Timer.periodic(Duration(seconds: 3), (timer) {
          Navigator.pop(ctx);
        });
        return DialogReqOTP(
          text: '??????????????????????????? OTP ????????????\n??????????????????????????????',
        );
      },
    ).then((value) {
      if (_timer.isActive) {
        _timer.cancel();
        _signInWithAutoCodeExchange(phonenumber, 'Android');
      }
    });

    // Clear cache Image circle
    imageCache!.clear();

    try {
      deviceId = (await PlatformDeviceId.getDeviceId)!;
    } on PlatformException {
      deviceId = 'Failed to get deviceId.';
    }

    Map<String, dynamic> _body = {
      'phone': phonenumber,
      'Device': deviceId,
    };

    String jsonBody = json.encode(_body);
    final encoding = Encoding.getByName('utf-8');

    var response = await http.post(
      Uri.parse(urlPath),
      headers: {
        "content-type": "application/json",
      },
      body: jsonBody,
      encoding: encoding,
    );
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
    }
  }

  Future<void> _signInWithAutoCodeExchange(String phonenumber, String platform,
      {bool preferEphemeralSession = false}) async {
    try {
      _setBusyState();

      final AuthorizationTokenResponse? result =
          await _appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          _clientId = widget.clientId.toString(),
          _redirectUrl = '${widget.redirectUrl}',
          clientSecret: '${widget.clientSecret}',
          additionalParameters: {'phone': phonenumber, 'platform': platform},
          promptValues: ['login'],
          scopes: widget.scope,
          serviceConfiguration: _serviceConfiguration,
          preferEphemeralSession: preferEphemeralSession,
        ),
      );

      if (result != null) {
        _processAuthTokenResponse(result);
        //await _testApi(result);
      }
    } catch (e) {
      print('Error: $e');
      _clearBusyState();
    }
  }

  void _clearBusyState() {
    setState(() {});
  }

  void _setBusyState() {
    setState(() {});
  }

  void _processAuthTokenResponse(AuthorizationTokenResponse response) {
    setState(() async {
      try {
        _accessToken =
            (_accessTokenTextController.text = response.accessToken!);
        _idToken = response.idToken!; // <======
        //_idTokenTextController.text = response.idToken!;
        // _refreshToken =
        //    (_refreshTokenTextController.text = response.refreshToken!);
        _accessTokenExpirationTextController.text =
            response.accessTokenExpirationDateTime!.toIso8601String();
        Map<String, dynamic> decodedToken =
            JwtDecoder.decode(_idToken); // <======= id Token JWT
        _first_name = decodedToken["name"];
        _family_name = decodedToken["family_name"];
        _preferred_username = decodedToken["preferred_username"]; // 205xxxxxxx
        _phone = decodedToken["phone"]; // +856205xxxxxx
        _sub = decodedToken["sub"];
      } on Exception catch (_) {
        print('Error Profile !!!');
      }
      PreferenceInfo().saveUserInfo(
          _first_name, _family_name, _preferred_username, _accessToken);

      //StoreDetailUser()
      // .sharePrefName(_first_name, _family_name, _preferred_username);
      Navigator.pushNamed(context, custom_route.Route.home);
      // _storeToken(response.accessToken);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Container(
        height: 350,
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: CircleAvatar(
                    radius: 14.0,
                    backgroundColor: Colors.red,
                    child: Icon(Icons.close, color: Colors.white),
                  ),
                ),
              ],
            ),
            Center(
              child: Image.asset(
                'assets/images/LaoKYCgateway.png',
                width: 110,
                height: 120,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Center(
              child: Text(
                'Authentication with LaoKYC',
                style: TextStyle(
                    fontFamily: 'Phetsarath',
                    fontSize: 15,
                    color: Colors.grey[600]),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              maxLength: 10,
              textAlign: TextAlign.center,
              controller: tfDialogLoginPhoneNumber,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  hintText: '?????????????????????????????????????????? (20xxxxxxxx)',
                  contentPadding: EdgeInsets.all(5.0),
                  counterText: "",
                  hintStyle: TextStyle(color: Colors.grey)),
            ),
            SizedBox(
              height: 12,
            ),
            Container(
              width: double.infinity,
              child: MaterialButton(
                  padding: EdgeInsets.only(top: 13, bottom: 13),
                  onPressed: () {
                    _requestOTP("https://gateway.sbg.la/api/login",
                            tfDialogLoginPhoneNumber.text)
                        .whenComplete(() => custom_route.Route
                            .home); // Send Phonenumber (TextField 2077710008) ==> After success custom_route.Route.home
                  },
                  color: Color(0xFF70CBBD),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40)),
                  child: Text(
                    '????????????????????????????????? OTP',
                    style: TextStyle(
                      fontFamily: 'Phetsarath',
                      color: Color(0xFFffffff),
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
