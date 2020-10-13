import 'package:flutter/cupertino.dart';

class Ghost extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Image.asset('lib/ghost.png'),
    );

  }


}