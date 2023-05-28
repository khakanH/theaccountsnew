import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../model/DashboardResponse.dart';
import '../../../utils/shared_pref.dart';
import '../custom.widgets/custom_widgets.dart';

class Transectiondetailwidget extends StatefulWidget {
  Transectiondetailwidget(
      {Key? key,
      // this.userID,
      // required this.date,
      this.amountTitle,
      this.paymentTypekey,
      this.paymentTypevalue,
      this.amountTypevalue,
      required this.onPressed,
      required this.color1,
      required this.Title,
      required this.DateStr,
      required this.color2})
      : super(key: key);
  // final String? userID;
  // final String date;
  final String? paymentTypekey;
  final String? amountTitle;
  final Color color1;
  final Color color2;
  final amountTypevalue;
  final paymentTypevalue;
  final VoidCallback onPressed;
  final String Title;
  final String DateStr;

  @override
  State<Transectiondetailwidget> createState() =>
      _TransectiondetailwidgetState();
}

class _TransectiondetailwidgetState extends State<Transectiondetailwidget> {
  late DashboardResponseData Userdata = DashboardResponseData(
      IsRefrenceInAllowed: false,
      IsShowDataAllowed: false,
      IsShowListAllowed: false,
      IsSubReferenceAllowed: false);

  @override
  void initState() {
    // Userdata = DashboardResponseData();
    super.initState();
    SessionData().getUserProfile().then(
          (value) => setState(() {
            print(value.toJson());
            Userdata = value;
          }),
        );
  }

  // var Date = DateTime.now().toString().substring(0, 10);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: WillPopScope(
      onWillPop: () async {
        widget.onPressed();
        return true;
      },
      child: SafeArea(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 20.h),
                child: Text(
                  "Transaction Details",
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              Column(
                // mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    margin: EdgeInsets.all(08),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          widget.color1, widget.color2,
                          // Color(0xFFB31E8E),
                          // Color(0xFF8F71FF),
                        ],
                      ),
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(14)),
                    ),
                    child: ListTile(
                        leading: Image.asset(
                          'assets/images/tick.png',
                          height: 38.h,
                          width: 38.w,
                        ),
                        // Theme.of(context).iconTheme.color,
                        // ),
                        title: SizedBox(
                          width: 60.w,
                          child: Text(
                            widget
                                .Title, //"Rollover Request has been Processed",
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.visible,
                            maxLines: 2,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2!
                                .copyWith(
                                    color: Colors.white,
                                    fontFamily: "Montserrat",
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w300),
                          ),
                        ),
                        trailing: GestureDetector(
                          onTap: () {
                            widget.onPressed(); //Navigator.of(context).pop();
                          },
                          child: Image.asset(
                            'assets/images/cross.png',
                            height: 25.h,
                            width: 25.w,
                          ),
                        )),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: 28.w, right: 40.w, top: 12.h, bottom: 12.h),
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          flex: 07,
                          child: Container(
                            width: size.width * 0.4,
                            child: Text(
                              "User ID",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                      fontSize: 14.sp,
                                      fontFamily: "Montserrat",
                                      fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 03,
                          child: Container(
                              width: size.width * 0.4,
                              child: Text(
                                Userdata.UserName.toString(),
                                textAlign: TextAlign.start,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                        fontSize: 14.sp,
                                        fontFamily: "Montserrat",
                                        fontWeight: FontWeight.w500),
                              )),
                        )
                      ],
                    ),
                  ),
                  divider(),
                  Padding(
                    padding: EdgeInsets.only(
                        left: 28.w, right: 40.w, top: 12.h, bottom: 12.h),
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          flex: 07,
                          child: Container(
                            width: size.width * 0.4,
                            child: Text(
                              "Date Time",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                      fontFamily: "Montserrat",
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 03,
                          child: Container(
                            width: size.width * 0.4,
                            child: Text(
                              DateFormat('d-MMM-y, h:mm:ss a')
                                  .format(DateTime.parse(widget.DateStr)),
                              textAlign: TextAlign.start,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                      fontFamily: "Montserrat",
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                      height: 1.8),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  divider(),
                  Padding(
                    padding: EdgeInsets.only(
                        left: 28.w, right: 40.w, top: 12.h, bottom: 12.h),
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          flex: 09,
                          child: Container(
                            width: size.width * 0.4,
                            child: Text(
                              widget.paymentTypekey.toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                      fontSize: 14.sp,
                                      fontFamily: "Montserrat",
                                      fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 05,
                          child: Container(
                            width: size.width,
                            child: Text(
                              widget.paymentTypevalue,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                      fontFamily: "Montserrat",
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  divider(),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 28.0.w, vertical: 12.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.amountTitle.toString(),
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(
                                  fontFamily: "Montserrat",
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: 10.sp,
                        )
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Rs. ",
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                              fontFamily: "Montserrat",
                              fontSize: 18.sp,
                              height: 2,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                      Text(
                        widget.amountTypevalue.toString(),
                        style: Theme.of(context).textTheme.headline5!.copyWith(
                              fontSize: 28.sp,
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  GestureDetector(
                    onTap: () => widget.onPressed(),
                    child: AnimatedLongButton(
                      text: "CLOSED",
                      color: [widget.color1, widget.color2],
                      isBgColorWhite: false,
                    ),
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ));
  }

  Divider divider() {
    return Divider(
      indent: 25,
      endIndent: 25,
      color: Colors.grey.withOpacity(0.5),
      thickness: 2,
      height: 1,
    );
  }
}
