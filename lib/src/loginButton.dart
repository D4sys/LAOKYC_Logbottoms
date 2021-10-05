import 'package:flutter/material.dart';
import 'login_dialog.dart';

class LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Card(
        elevation: 15,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              gradient: LinearGradient(
                colors: [
                  Color(0xFFfa983a),
                  Color(0xFFfa983a),
                ],
              )),
          child: TextButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return DialogLogin(
                      clientId: '',
                      redirectUrl: '',
                      clientSecret: '',
                      scope: [],
                    );
                  });
            },
            child: Text(
              'Login with Lao KYC',
              style:
                  TextStyle(color: Color(0xFFffffff), fontFamily: 'FontHeader'),
            ),
          ),
        ),
      ),
    );
  }
}
