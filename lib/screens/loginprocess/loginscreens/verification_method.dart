import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:theaccounts/bloc/auth_bloc.dart';
import 'package:theaccounts/model/auth_model/LoginData.dart';
import 'package:theaccounts/networking/ApiResponse.dart';
import 'package:theaccounts/screens/dashboard/custom.widgets/custom_widgets.dart';
import 'package:theaccounts/screens/dashboard/dashboard.screens/hidecapital.screen.dart';
import 'package:theaccounts/screens/loginprocess/loginscreens/Login_Screen.dart';
import 'package:theaccounts/screens/loginprocess/loginscreens/Otp_Screen.dart';
import 'package:theaccounts/screens/widgets/loading_dialog.dart';
import 'package:theaccounts/utils/utility.dart';

String method = "Phone";

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({Key? key, required this.skipOtp}) : super(key: key);
  static const routeName = '/verification-screen';
  final bool skipOtp;
  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  late AuthBloc _bloc;

  @override
  void initState() {
    _bloc = AuthBloc();
    _bloc.sendOtopDateStream.listen((event) {
      if (event.status == Status.COMPLETED) {
        //

        DialogBuilder(context).hideLoader();

        var phone = event.data?.EmailPhone;

        String phone2 = phone.toString();

        String? t = event.data?.Type;

        String t2 = t.toString();

        if (widget.skipOtp) {
          Navigator.pushReplacementNamed(context, HideCapitalScreen.routeName);
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => OtpScreen(
                phone_number: phone2,
                otpMethod: t2,
                skipOtp: widget.skipOtp,
              ),
            ),
          );
        }
      } else if (event.status == Status.ERROR) {
        DialogBuilder(context).hideLoader();
        showSnackBar(context, event.message, true);
        CheckUnauthMessage(context, event.message);
      } else if (event.status == Status.LOADING) {
        DialogBuilder(context).showLoader();
      }
    });
    super.initState();

    method = "Email";
    SendOtpData data = SendOtpData(OtpMethod: method);
    _bloc.postSendOtp(data);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, MyHomePage.routeName);
        return true;
      },
      child: Scaffold(
        // backgroundColor: Color(0xfff1f1f2),
        resizeToAvoidBottomInset: true,
        body: Container(
          height: size.height,
          width: size.width,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Flexible(
                  flex: 1,
                  child: Bounce(
                    duration: Duration(milliseconds: 100),
                    onPressed: () {
                      method = "Email";
                      SendOtpData data = SendOtpData(OtpMethod: method);
                      _bloc.postSendOtp(data);
                    },
                    child: AnimatedCircularBar(
                      child: Center(
                        child: SizedBox(
                          height: 80,
                          width: 80,
                          child: SvgPicture.asset(
                            "assets/svg/mail_verif.svg",
                            color: isDarkThemeEnabled(context)
                                ? Colors.white
                                : null,
                          ),
                        ),
                      ),
                      radius: 170,
                      color: Colors.grey.withOpacity(0.1),
                      color1: Colors.grey.withOpacity(0.2),
                    ),
                  ),
                ),
                // Flexible(
                //   flex: 1,
                //   child: Bounce(
                //     onPressed: () {
                //       method = "Phone";
                //       SendOtpData data = SendOtpData(OtpMethod: method);
                //       _bloc.postSendOtp(data);
                //     },
                //     duration: Duration(milliseconds: 100),
                //     child: AnimatedCircularBar(
                //       child: Center(
                //         child: SizedBox(
                //           height: 80,
                //           width: 80,
                //           child: SvgPicture.asset(
                //             "assets/svg/phone_verif.svg",
                //             color: isDarkThemeEnabled(context)
                //                 ? Colors.white
                //                 : null,
                //           ),
                //         ),
                //       ),
                //       radius: 170,
                //       color: Colors.grey.withOpacity(0.1),
                //       color1: Colors.grey.withOpacity(0.2),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
