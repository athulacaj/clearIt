import 'dart:async';

import 'package:flare_flutter/asset_provider.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_cache_builder.dart';
import 'package:flutter/material.dart';

class CoinLoading extends StatefulWidget {
  final bool showSpinner;
  final Widget child;
  CoinLoading({required this.showSpinner, required this.child});
  @override
  _CoinLoadingState createState() => _CoinLoadingState();
}

class _CoinLoadingState extends State<CoinLoading> {
  bool isOpen = true;
  Size? size;
  @override
  void initState() {
    isOpen = true;
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          widget.child,
          widget.showSpinner
              ? Container(
                  height: size!.height,
                  width: size!.width,
                  color: Colors.grey.withOpacity(0.3),
                )
              : Container(),
          widget.showSpinner
              ? Column(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        child: FlareActor(
                          "images/coin.flr",
                          animation:
                              isOpen ? 'animation' : 'animation Duplicate',
                          fit: BoxFit.contain,
                          callback: (value) {
                            print(value);
                            isOpen = !isOpen;
                            setState(() {});
                          },
                        ),
                      ),
                    ),
                  ],
                )
              : Container(),
        ],
      ),
    );
  }
}
