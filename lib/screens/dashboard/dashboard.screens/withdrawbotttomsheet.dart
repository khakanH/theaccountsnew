import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fzregex/utils/fzregex.dart';
import 'package:fzregex/utils/pattern.dart';
import 'package:page_transition/page_transition.dart';
import 'package:theaccounts/ScopedModelWrapper.dart';
import 'package:theaccounts/bloc/dashboard_bloc.dart';
import 'package:theaccounts/model/WithdrawResponse.dart';
import 'package:theaccounts/model/requestbody/WithdrawReqBody.dart';
import 'package:theaccounts/networking/ApiResponse.dart';
import 'package:theaccounts/repositories/auth_repo/AuthRepository.dart';
import 'package:theaccounts/screens/dashboard/custom.widgets/custom_widgets.dart';
import 'package:theaccounts/screens/dashboard/dashboard.screens/hidecapital.screen.dart';
import 'package:theaccounts/screens/setting/components/setting.widgets.dart';
import 'package:theaccounts/screens/widgets/loading_dialog.dart';
import 'package:theaccounts/utils/Const.dart';
import 'package:theaccounts/utils/utility.dart';
import '../../../model/widthfrawdata.dart';
import '../../../repositories/DashboardRepository.dart';
import 'alerts.dart';
import 'transection_sheet.dart';

class WithDrawHoverLayerScreen extends StatefulWidget {
  WithDrawHoverLayerScreen({Key? key}) : super(key: key);
  static const routeName = '/withdraw-screen';

  @override
  State<WithDrawHoverLayerScreen> createState() =>
      _WithDrawHoverLayerScreenState();
}

class _WithDrawHoverLayerScreenState extends State<WithDrawHoverLayerScreen> {
  @override
  void initState() {
    dp(msg: "call widthdraw ");
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   WithDrawBottomSheet();
    // });
  }

  FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: size.height),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(flex: 01, child: CustomTopBar(topbartitle: "")),
              Flexible(
                flex: 09,
                child: KeyboardVisibilityBuilder(builder: (context, visible) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: visible ? 200 : 12.0.h),
                    child: WithDrawBottomSheet(),
                  );
                }),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class WithDrawBottomSheet extends StatefulWidget {
  const WithDrawBottomSheet({Key? key}) : super(key: key);

  @override
  State<WithDrawBottomSheet> createState() => _WithDrawBottomSheetState();
}

class _WithDrawBottomSheetState extends State<WithDrawBottomSheet>
    with SingleTickerProviderStateMixin {
  //

  final _duration = Duration(milliseconds: 800);

  late AnimationController _animationController;

  late Animation _animatebottom, _opacity;

  late TextEditingController _withdrawamounttextcontroller;

  late DashboardBloc _bloc;

  WidthDrawStatus? data;

  DashboardRepository repository = DashboardRepository();

  bool isLoading = true;

  var isLoadinData = false;

  getStatus() async {
    dp(msg: "Data status call");
    try {
      var data = await repository.getWidrawStatus();

      dp(msg: "message", arg: data?.toJson());

      if (data != null) {
        // DialogBuilder(context).hideLoader();

        this.data = data;

        setState(() {
          isLoading = false;
        });

        if (data.data?.status ?? false) {
          setState(() {
            loaded = true;
          });
        } else if (!(data.data?.status ?? false) &&
            data.data?.withdrawRequest == null) {
          Navigator.pushReplacement(
            context,
            PageTransition(
              type: PageTransitionType.topToBottom,
              duration: Duration(milliseconds: 300),
              child: WithDrawPaymentAlert(
                title: "Withdraw Closed!",
                message: "Please try again on next closing",
              ),
            ),
          );
        } else if (data.data?.withdrawRequest != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WithDrawTransectionSheet(
                  message: data.message ?? '',
                  DateStr: data.data?.withdrawRequest?.requestDate.toString(),
                  title:
                      "Your previous withdraw request is ${data.data!.withdrawRequest!.status}",
                  response: data.data!.withdrawRequest!,
                  capitalAmount: data.data?.capitalAmount),
            ),
          );
        }
      } else {
        setState(() {
          isLoading = false;
        });

        // DialogBuilder(context).hideLoader();
        //showSnackBar(context, event.message, true);

        Navigator.pushReplacement(
            context,
            PageTransition(
                type: PageTransitionType.topToBottom,
                duration: Duration(milliseconds: 300),
                child: WithDrawPaymentAlert(
                    title: "Withdraw Error!",
                    message: "Error please try again")));
      }
    } catch (e) {
      dp(msg: "Error in ", arg: e.runtimeType);
      // DialogBuilder(context).hideLoader();
      //showSnackBar(context, event.message, true);

      Navigator.pushReplacement(
          context,
          PageTransition(
              type: PageTransitionType.topToBottom,
              duration: Duration(milliseconds: 300),
              child: WithDrawPaymentAlert(
                  title: "Withdraw Error!",
                  message: "Error please try again")));
    }
  }

  @override
  void initState() {
    getStatus();

    _withdrawamounttextcontroller = TextEditingController();

    _animationController =
        AnimationController(vsync: this, duration: _duration);
    _animatebottom = Tween<double>(begin: -1.0, end: 0.0).animate(
        CurvedAnimation(
            parent: _animationController,
            curve: Curves.fastLinearToSlowEaseIn));

    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: _animationController, curve: Curves.fastOutSlowIn));
    _animationController.forward();

    super.initState();
  }

  @override
  void dispose() {
    // _bloc.dispose();

    _withdrawamounttextcontroller.dispose();

    _animationController.dispose();
    super.dispose();
  }

  bool loaded = false;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return AnimatedBuilder(
      animation: _animationController.view,
      builder: (context, child) {
        if (!loaded)
          return Container(
            height: MediaQuery.of(context).size.height,
            child: Center(child: CircularProgressIndicator()),
          );

        return Transform(
          transform:
              Matrix4.translationValues(0.0, _animatebottom.value * width, 0.0),
          child: Padding(
            padding: EdgeInsets.only(bottom: 12.0, left: 10, right: 10),
            child: Container(
              height: height * 0.55,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [Color(0xFF2C7FFF), Color(0xFF6EFF98)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10.h,
                  ),
                  Divider(
                    height: 4,
                    color: Colors.white,
                    endIndent: 150.w,
                    indent: 150.w,
                    thickness: 4.h,
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  AnimatedOpacity(
                    duration: _duration,
                    opacity: _opacity.value,
                    child: Text(
                      "Withdraw",
                      style: Theme.of(context).textTheme.headline6!.copyWith(
                            fontSize: 18.sp,
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.w600,
                            color: Colors.white.withOpacity(1),
                          ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        AnimatedOpacity(
                          duration: _duration,
                          opacity: _opacity.value,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Rs. ",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                      fontSize: 20.sp,
                                      height: 2.0.h,
                                      fontFamily: "Montserrat",
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                              ),
                              Text(
                                Const.currencyFormatWithoutDecimal
                                    .format(data?.data?.capitalAmount ?? 0),
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6!
                                    .copyWith(
                                      fontSize: 36.sp,
                                      fontFamily: "Montserrat",
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(bottom: 08.h),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Center(
                                    child: SizedBox(
                                      height: 22.h,
                                      width: 22.w,
                                      child: Image.asset(
                                        "assets/images/amount.png",
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 08.h,
                                  ),
                                  Text(
                                    "Amount",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(
                                          fontSize: 18.sp,
                                          fontFamily: "Montserrat",
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white.withOpacity(1),
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            AmountInputField(
                              isBgColorWhite: true,
                              textcontroller: _withdrawamounttextcontroller,
                              color: [Colors.white, Colors.white],
                              hint: "",
                              //  data?.TotalCapital.toString() ?? "0",
                              fontsize: 25.sp,
                            ),
                            SizedBox(
                              height: 04.h,
                            ),
                          ],
                        ),
                        isLoadinData
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : GestureDetector(
                                onTap: () {
                                  if (_withdrawamounttextcontroller
                                      .text.isEmpty) {
                                    showSnackBar(context,
                                        'Please enter a valid number.', true);
                                    return;
                                  }
                                  var isValid = Fzregex.hasMatch(
                                      _withdrawamounttextcontroller.text,
                                      FzPattern.currency);

                                  dp(msg: "IValid", arg: isValid);
                                  if (!isValid) {
                                    showSnackBar(context,
                                        'Please enter a valid number.', true);
                                    return;
                                  }

                                  String source = AppModel().deviceID();

                                  double totalamount =
                                      data?.data?.capitalAmount?.toDouble() ??
                                          0.0;

                                  var amount =
                                      _withdrawamounttextcontroller.text;

                                  if (source == "" ||
                                      double.tryParse(amount)?.isFinite ==
                                          false ||
                                      (double.tryParse(amount)?.isNegative ??
                                          true)) {
                                    showSnackBar(context,
                                        'Please enter a valid number.', true);
                                    return;
                                  } else if (double.parse(amount) >
                                          totalamount ||
                                      amount == 0 ||
                                      totalamount == 0) {
                                    showSnackBar(
                                        context,
                                        'Your balance is not sufficient for withdraw.',
                                        true);
                                    return;
                                  }

                                  setState(() {
                                    isLoadinData = true;
                                  });

                                  // Navigation.pushName(context,)

                                  var dataa = WithdrawReqData(
                                    withdrawAmount: int.tryParse(amount) ?? 0,
                                    source: AppModel().deviceID(),
                                  );

                                  // _bloc.SaveWithdrawalData(dataa);

                                  WithdrawReqBody reqBody =
                                      WithdrawReqBody(data: dataa);

                                  repository
                                      .withDrawPOst(reqBody)
                                      .then((value) {
                                    setState(() {
                                      isLoadinData = true;
                                    });

                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                WithDrawTransectionSheet(
                                                    message: value.message,
                                                    DateStr: DateTime.now()
                                                        .toString(),
                                                    title:
                                                        "Your previous withdraw request is ${value.data!.withdrawRequest!.status}",
                                                    response: value
                                                        .data!.withdrawRequest!,
                                                    capitalAmount: value.data
                                                            ?.capitalAmount ??
                                                        0)));
                                  }).catchError((e) {
                                    setState(() {
                                      isLoadinData = true;
                                    });
                                    Navigator.push(
                                        context,
                                        PageTransition(
                                            type:
                                                PageTransitionType.topToBottom,
                                            duration:
                                                Duration(milliseconds: 300),
                                            child: WithDrawPaymentAlert(
                                                title: "Withdraw Error!",
                                                message: "Please try again")));
                                  });
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(bottom: 24.0.h),
                                  child: AnimatedLongButton(
                                    // textColor: Color(0xFF58595B),
                                    text: "Send".toUpperCase(),
                                    isBgColorWhite: true,
                                    color: [Colors.white, Colors.white],
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  WithDrawTransectionSheet(
      {required String message,
      String? title,
      DateStr,
      required WithdrawRequest response,
      num? capitalAmount}) {
    return Transectiondetailwidget(
      // userID: Userdata?.UserName ?? "",
      // date: DateTime.now().toString(),
      DateStr: DateStr,
      Title: title ?? "Withdraw Request has been Processed",
      amountTitle: "Withdraw Amount",
      paymentTypekey: "Capital",
      paymentTypevalue:
          Const.currencyFormatWithoutDecimal.format(capitalAmount ?? 0),
      amountTypevalue: Const.currencyFormatWithoutDecimal
          .format(response.withdrawAmount ?? 0),
      onPressed: () {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HideCapitalScreen(),
          ),
        );
      },
      color2: Color(0xFF6EFF98),
      color1: Color(0xFF2C7FFF),
    );
  }
}
