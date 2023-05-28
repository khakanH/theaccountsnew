import 'package:flutter/material.dart';
import 'package:theaccounts/screens/dashboard/custom.widgets/custom_widgets.dart';

class WithDrawPaymentAlert extends StatefulWidget {
  WithDrawPaymentAlert({Key? key, required this.message, this.title})
      : super(key: key);
  static const routeName = '/withdraw_alert-screen';
  final String message;
  final String? title;
  @override
  State<WithDrawPaymentAlert> createState() => _WithDrawPaymentAlertState();
}

class _WithDrawPaymentAlertState extends State<WithDrawPaymentAlert>
    with TickerProviderStateMixin {
  final _duration = Duration(milliseconds: 800);

  late AnimationController _controller;
  late Animation<double> _animateright;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: _duration);

    _animateright = Tween<double>(begin: -2.0, end: 0.0).animate(
        CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _controller.view,
          builder: (context, child) {
            return Transform(
              transform: Matrix4.translationValues(
                  0.0, _animateright.value * width, 0.0),
              child: child,
            );
          },
          child: Container(
            alignment: Alignment.bottomCenter,
            child: AnimatedAlertDialog(
              title: widget.title,
              description: widget.message,
            ),
          ),
        ),
      ),
    );
  }
}

class ClosingPaymentAlert extends StatefulWidget {
  ClosingPaymentAlert({Key? key, required this.message, this.title})
      : super(key: key);
  static const routeName = '/closing_alert-screen';
  final String message;
  final String? title;
  @override
  State<ClosingPaymentAlert> createState() => _ClosingPaymentAlertState();
}

class _ClosingPaymentAlertState extends State<ClosingPaymentAlert>
    with TickerProviderStateMixin {
  //

  final _duration = Duration(milliseconds: 800);

  late AnimationController _controller;
  late Animation<double> _animateright;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: _duration);

    _animateright = Tween<double>(begin: -2.0, end: 0.0).animate(
        CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return SafeArea(
        child: Scaffold(
      body: AnimatedBuilder(
        animation: _controller.view,
        builder: (context, child) {
          return AnimatedAlign(
            alignment: Alignment.bottomCenter,
            duration: _duration,
            child: Transform(
              transform: Matrix4.translationValues(
                  0.0, _animateright.value * width, 0.0),
              child: Container(
                alignment: Alignment.bottomCenter,
                child: AnimatedAlertDialog(
                  begin: Alignment.topRight,
                  
                  end: Alignment.bottomLeft,
                  textcolor: Colors.white,
                  btn_begin: Alignment.centerLeft,
                  btn_end: Alignment.centerRight,
                  color_v2: [Colors.white],
                  iconcolor: Color(0xff9E1F63),
                  description: widget.message,
                  title: widget.title,
                  color: [
                    Color(0xffDA1467),
                    Color(0xffFF992E),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    ));
  }
}

class RolloverPaymentAlert extends StatefulWidget {
  RolloverPaymentAlert({Key? key, required this.message, this.title})
      : super(key: key);
  static const routeName = '/closing_alert-screen';
  final String message;
  final String? title;
  @override
  State<RolloverPaymentAlert> createState() => _RolloverPaymentAlertState();
}

class _RolloverPaymentAlertState extends State<RolloverPaymentAlert>
    with TickerProviderStateMixin {
  final _duration = Duration(milliseconds: 800);

  late AnimationController _controller;
  late Animation<double> _animateright;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: _duration);

    _animateright = Tween<double>(begin: -2.0, end: 0.0).animate(
        CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: AnimatedBuilder(
            animation: _controller.view,
            builder: (context, child) {
              return AnimatedAlign(
                alignment: Alignment.bottomCenter,
                duration: _duration,
                child: Transform(
                  transform: Matrix4.translationValues(
                      0.0, _animateright.value * width, 0.0),
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    child: AnimatedAlertDialog(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      textcolor: Colors.white,
                      btn_begin: Alignment.centerLeft,
                      btn_end: Alignment.centerRight,
                      iconcolor: Color(0xFFAC2EA3),
                      description: widget.message,
                      title: widget.title,
                      color: [Color(0xFF926AF6), Color(0xFFAC2EA3)],
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }
}
