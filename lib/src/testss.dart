import 'package:flutter/material.dart';
import 'package:laokyc_logbottom/laokyc_logbottom.dart';

class testt extends StatelessWidget {
  const testt({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DialogLogin(
        clientId:'1',
        redirectUrl: 'xyz',
        clientSecret: '007',
        scope: ['1','2','3'],
      ),
    );
      
    
  }
}