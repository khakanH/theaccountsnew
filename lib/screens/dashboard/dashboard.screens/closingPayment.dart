import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fzregex/utils/fzregex.dart';
import 'package:fzregex/utils/pattern.dart';
import 'package:page_transition/page_transition.dart';
import 'package:theaccounts/ScopedModelWrapper.dart';
import 'package:theaccounts/model/requestbody/ReceivePaymentReqBody.dart';
import 'package:theaccounts/repositories/DashboardRepository.dart';
import 'package:theaccounts/repositories/auth_repo/AuthRepository.dart';
import 'package:theaccounts/screens/dashboard/custom.widgets/custom_widgets.dart';
import 'package:theaccounts/screens/dashboard/dashboard.screens/alerts.dart';
import 'package:theaccounts/screens/dashboard/dashboard.screens/hidecapital.screen.dart';
import 'package:theaccounts/screens/setting/components/setting.widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:theaccounts/utils/Const.dart';
import 'package:theaccounts/utils/utility.dart';
import '../../../model/tranfer_rolll_over.dart';
import 'transection_sheet.dart';

class ClosingPaymentScreen extends StatelessWidget {
  ClosingPaymentScreen({Key? key}) : super(key: key);
  static const routeName = '/closing_payment-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(flex: 01, child: CustomTopBar(topbartitle: "")),
                Flexible(
                  flex: 09,
                  child: KeyboardVisibilityBuilder(builder: (context, visible) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: visible ? 200 : 12.0.h),
                      child: ClosingPaymentBottomSheet(),
                    );
                  }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ClosingPaymentBottomSheet extends StatefulWidget {
  const ClosingPaymentBottomSheet({Key? key}) : super(key: key);

  @override
  State<ClosingPaymentBottomSheet> createState() =>
      _ClosingPaymentBottomSheetState();
}

class _ClosingPaymentBottomSheetState extends State<ClosingPaymentBottomSheet>
    with TickerProviderStateMixin {
  //

  final _duration = Duration(milliseconds: 600);

  late AnimationController _animationcontroller;
  late Animation _animateopacity;
  late Animation<double> _animateleft;

  int total_amount = 0;
  int transfer_amount = 0;
  int rollover_amt = 0;

  bool isLaoding = false;

  late TextEditingController _transfertextcontroller;

  late TextEditingController _rollovertextcontroller;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // late DashboardBloc _bloc;

  TransferRollover? data;

  // DashboardResponseData Userdata =
  //     DashboardResponseData(IsRefrenceInAllowed: false);

  bool loaded = false;

  DashboardRepository repository = DashboardRepository();

  getTranferData() {
    repository.getTransferData().then((event) async {
      print(" Data " + jsonEncode(event.data));

      setState(() {
        data = event;
        print(data?.toJson());
      });

      await Future.delayed(Duration(milliseconds: 200));

      if (data?.data?.status ?? false) {
        total_amount = data?.data?.closingPayment?.toInt() ?? 0;
        setState(() {
          loaded = true;
        });
      } else if (!(data?.data?.status ?? false) &&
          data?.data?.transferRolloverRequest == null) {
        Navigator.pushReplacement(
          context,
          PageTransition(
            type: PageTransitionType.topToBottom,
            duration: Duration(milliseconds: 300),
            child: ClosingPaymentAlert(
                title: "Alert!", message: "Closing Payment has \nbeen closed."),
          ),
        );
      } else if (data?.data?.transferRolloverRequest != null) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ClosingTransectionSheet(
                    DateStr: data?.data?.transferRolloverRequest?.requestDate,
                    message: event.message ?? '',
                    title:
                        "Your previous payment request is ${data?.data?.transferRolloverRequest?.status}",
                    response: data?.data?.transferRolloverRequest)));
      } else {
        Navigator.pushReplacement(
            context,
            PageTransition(
                type: PageTransitionType.leftToRight,
                duration: Duration(milliseconds: 300),
                child: ClosingPaymentAlert(
                    title: "Payment Error", message: "Error in geting data")));
      }
    }).catchError((e) {
      dp(msg: "Error in t", arg: e);

      Navigator.pushReplacement(
          context,
          PageTransition(
              type: PageTransitionType.leftToRight,
              duration: Duration(milliseconds: 300),
              child: ClosingPaymentAlert(
                  title: "Payment Error", message: "Error in geting data")));
    });
  }

  @override
  void initState() {
    getTranferData();

    _transfertextcontroller = TextEditingController();

    _rollovertextcontroller = TextEditingController();

    _animationcontroller =
        AnimationController(vsync: this, duration: _duration);

    _animateopacity = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: _animationcontroller, curve: Curves.fastOutSlowIn));
    _animateleft = Tween<double>(begin: -1.0, end: 0.0).animate(CurvedAnimation(
        parent: _animationcontroller, curve: Curves.fastOutSlowIn));

    _animationcontroller.forward();

    // _transfertextcontroller.addListener(getLatestvalue);

    // _rollovertextcontroller.addListener(getRollervalue);

    super.initState();
  }

  @override
  void dispose() {
    _animationcontroller.dispose();
    _transfertextcontroller.dispose();
    _rollovertextcontroller.dispose();
    super.dispose();
  }

  getLatestvalue() {
    setState(() {
      if (_transfertextcontroller.text.isNotEmpty) {
        rollover_amt =
            (total_amount) - (int.tryParse(_transfertextcontroller.text) ?? 0);
        transfer_amount = total_amount - rollover_amt;
        _rollovertextcontroller.clear();
      } else {}
    });
  }

  getRollervalue() {
    setState(() {
      if (_rollovertextcontroller.text.isNotEmpty) {
        transfer_amount =
            (total_amount) - (int.tryParse(_rollovertextcontroller.text) ?? 0);
        rollover_amt = total_amount - transfer_amount;
        _transfertextcontroller.clear();
      } else {}
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    Size size = MediaQuery.of(context).size;

    // transfer_amount = double.tryParse(_transfertextcontroller.text) ?? 0.0;
    // var rollover_amount = double.tryParse(_rollovertextcontroller.text);
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return AnimatedBuilder(
        key: _scaffoldKey,
        animation: _animationcontroller.view,
        builder: (context, child) {
          if (!loaded)
            return Container(
              height: MediaQuery.of(context).size.height,
              child: Center(child: CircularProgressIndicator()),
            );
          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xffFF992E),
                    Color(0xffDA1467),
                  ],
                ),
                borderRadius: BorderRadius.circular(25),
              ),
              child: SingleChildScrollView(
                reverse: true,
                child: Padding(
                  padding: EdgeInsets.only(bottom: bottom),
                  child: Container(
                    height: size.height * 0.65,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 15.h,
                        ),
                        divider,
                        SizedBox(
                          height: 10.h,
                        ),
                        Text(
                          "Closing Payment",
                          style:
                              Theme.of(context).textTheme.headline6!.copyWith(
                                    fontSize: 18.sp,
                                    fontFamily: "Montserrat",
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                        ),
                        SizedBox(height: 25.h),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              AnimatedOpacity(
                                duration: _duration,
                                opacity: _animateopacity.value,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Rs. ",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6!
                                          .copyWith(
                                            fontSize: 20.sp,
                                            height: 2.0.h,
                                            fontFamily: "Montserrat",
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                    ),
                                    Text(
                                      Const.currencyFormatWithoutDecimal.format(
                                          data?.data?.closingPayment ?? 0),
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6!
                                          .copyWith(
                                              fontSize: 36.sp,
                                              fontFamily: "Montserrat",
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20.h),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SvgPicture.asset(
                                      "assets/svg/total_transfer.svg"),
                                  SizedBox(
                                    width: 08.h,
                                  ),
                                  Text(
                                    "Transfer",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: "Montserrat",
                                          color: Colors.white,
                                        ),
                                  ),
                                ],
                              ),
                              AmountInputField(
                                isBgColorWhite: true,
                                textcontroller: _transfertextcontroller,
                                hint: "0",
                                fontsize: 26.sp,
                                onChanged: (p0) {
                                  //

                                  if (p0.isNotEmpty &&
                                      !(int.tryParse(p0)?.isNaN ?? false)) {
                                    //

                                    rollover_amt = (total_amount) -
                                        (int.tryParse(p0) ?? 0);

                                    transfer_amount =
                                        total_amount - rollover_amt;

                                    _rollovertextcontroller.text =
                                        rollover_amt.toString();
                                  } else {
                                    transfer_amount = 0;
                                    rollover_amt = total_amount;

                                    _rollovertextcontroller.text =
                                        total_amount.toString();
                                  }
                                },
                                color: [Colors.white, Colors.white],
                              ),
                              SizedBox(height: 20.h),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  AnimatedOpacity(
                                    duration: _duration,
                                    opacity: _animateopacity.value,
                                    child: Icon(
                                      Icons.settings_backup_restore_rounded,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 08.h,
                                  ),
                                  AnimatedOpacity(
                                    duration: _duration,
                                    opacity: _animateopacity.value,
                                    child: Text(
                                      "Rollover",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'Montserrat',
                                            color: Colors.white,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                              AmountInputField(
                                isBgColorWhite: true,
                                textcontroller: _rollovertextcontroller,
                                hint: "0",
                                onChanged: (p0) {
                                  //

                                  if (p0.isNotEmpty &&
                                      !(int.tryParse(p0)?.isNaN ?? false)) {
                                    //

                                    transfer_amount = (total_amount) -
                                        (int.tryParse(p0) ?? 0);

                                    _transfertextcontroller.text =
                                        transfer_amount.toString();

                                    rollover_amt =
                                        total_amount - transfer_amount;
                                  } else {
                                    rollover_amt = 0;

                                    transfer_amount = total_amount;

                                    _transfertextcontroller.text =
                                        total_amount.toString();
                                  }
                                },
                                fontsize: 26.h,
                                color: [Colors.white, Colors.white],
                              ),
                              SizedBox(
                                height: 29.h,
                              ),
                              isLaoding
                                  ? Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : GestureDetector(
                                      onTap: () {
                                        print("$transfer_amount $rollover_amt");

                                        // if (_transfertextcontroller
                                        //         .text.isEmpty ||
                                        //     _rollovertextcontroller
                                        //         .text.isEmpty) {
                                        //   showSnackBar(
                                        //       context,
                                        //       'Please enter a valid number.',
                                        //       true);
                                        //   return;
                                        // }
                                        var isValid = Fzregex.hasMatch(
                                            transfer_amount.toString(),
                                            FzPattern.currency);

                                        var isRoller = Fzregex.hasMatch(
                                            rollover_amt.toString(),
                                            FzPattern.currency);

                                        if (!isValid || !isRoller) {
                                          showSnackBar(
                                              context,
                                              'Please enter a valid number',
                                              true);
                                          return;
                                        }

                                        if ((transfer_amount.isNegative) ||
                                            (rollover_amt.isNegative)) {
                                          showSnackBar(
                                              context,
                                              'Amount should not be in negative',
                                              true);
                                          return;
                                        }

                                        if (transfer_amount <= 0.0) {
                                          showSnackBar(
                                              context,
                                              'Tranfer amount should not be zero',
                                              true);

                                          return;
                                        } else if (transfer_amount >
                                            total_amount) {
                                          showSnackBar(
                                              context,
                                              'Transfer amount must be smaller then Closing Payment.',
                                              true);
                                          return;
                                        }

                                        setState(() {
                                          isLaoding = true;
                                        });

                                        var data = ReceivePaymentReqData(
                                            rolloverAmount: rollover_amt,
                                            source: AppModel().deviceID(),
                                            transferAmount: transfer_amount);

                                        dp(msg: "Data", arg: data.toJson());

                                        dp(
                                            msg: "Req body",
                                            arg: jsonEncode(data));

                                        ReceivePaymentReqBody reqBody =
                                            ReceivePaymentReqBody(data: data);

                                        repository.SavePaymentRolloverNew(
                                                reqBody)
                                            .then((value) {
                                          //

                                          setState(() {
                                            isLaoding = false;
                                          });

                                          if (value != null &&
                                              value.data!
                                                      .transferRolloverRequest !=
                                                  null) {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ClosingTransectionSheet(
                                                          DateStr:
                                                              DateTime.now(),
                                                          message:
                                                              value.message,
                                                          response: value.data
                                                              ?.transferRolloverRequest,
                                                          title:
                                                              "Your previous payment request is ${value.data!.transferRolloverRequest?.status}")),
                                            );
                                          } else {
                                            showSnackBar(context,
                                                "Error please try again", true);
                                          }
                                        }).catchError((e) {
                                          setState(() {
                                            isLaoding = false;
                                          });
                                        });
                                      },
                                      child: AnimatedLongButton(
                                        text: "Send".toUpperCase(),
                                        isBgColorWhite: true,
                                        color: [Colors.white, Colors.white],
                                      ),
                                    ),
                              SizedBox(
                                height: 20.h,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }

  ClosingTransectionSheet(
      {required String message,
      String? title,
      DateStr,
      TransferRolloverRequest? response}) {
    dp(msg: "Rollover ", arg: response?.rollover);
    return Transectiondetailwidget(
      DateStr: DateStr?.toString() ?? '',
      Title: title ?? "Payment Request has been Processed",
      amountTitle: "Transfer Amount",
      paymentTypekey: "Rollover",
      paymentTypevalue:
          Const.currencyFormatWithoutDecimal.format(response?.rollover),
      amountTypevalue:
          Const.currencyFormatWithoutDecimal.format(response?.transfer),
      onPressed: () {
        //

        Navigator.pop(context);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HideCapitalScreen(),
          ),
        );
      },
      color2: Color(0xffDA1467),
      color1: Color(0xffFF992E),
    );
  }
}

final divider = Divider(
  height: 8,
  color: Colors.white,
  endIndent: 150,
  indent: 150,
  thickness: 3.5,
);
