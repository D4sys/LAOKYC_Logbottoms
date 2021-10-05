import 'package:flutter/widgets.dart';

class Buttslog {
  late final String clientId;
  late final String redirectUrl;
  late final String clientSecret;
  late final List<String> scope;
  Buttslog({
    required this.clientId,
    required this.clientSecret,
    required this.redirectUrl,
    List<String>? scope,
  }) : this.scope = scope ?? [];

  /*final data = Buttslog(
      clientId: '1',
      redirectUrl: 'Xyz-Summon',
      clientSecret: '007',
      scope: ['openid', 'profile', 'LaoKYC', 'mkyc_api', 'phone']);*/
}
