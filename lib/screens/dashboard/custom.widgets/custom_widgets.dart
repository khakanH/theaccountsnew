import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:theaccounts/model/DashboardResponse.dart';
import 'package:theaccounts/model/SendNotificationResponse.dart';
import 'package:theaccounts/networking/ApiResponse.dart';
import 'package:theaccounts/screens/dashboard/dashboard.screens/dashboard.dart';
import 'package:theaccounts/screens/dashboard/dashboard.screens/hidecapital.screen.dart';
import 'package:theaccounts/screens/dashboard/dashboard.screens/notifications.dart';
import 'package:theaccounts/screens/setting/components/setting.widgets.dart';
import 'package:theaccounts/screens/setting/setting.dart';
import 'package:theaccounts/screens/widgets/back_alert.dart';

import '../../../ScopedModelWrapper.dart';

enum screen { home, dashboard, setting, logout }

var currentScreen = BehaviorSubject<screen>.seeded(screen.home);

//Animated bottomBar
class AnimatedBottomBar extends StatefulWidget {
  //

  AnimatedBottomBar({Key? key}) : super(key: key);

  static const routeName = '/animatedBottomBar';

  @override
  State<AnimatedBottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<AnimatedBottomBar> {
  //

  // final _duration = Duration(milliseconds: 1500);

  // late AnimationController _controller;
  // late Animation<double> _animopacity;

  // late Animation<double> _animateleft, _animateright;

  // @override
  // void initState() {
  //   //
  //   _controller = AnimationController(vsync: this, duration: _duration);

  //   _animopacity = Tween<double>(begin: 0.0, end: 1.0).animate(
  //       CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn));

  //   _animateleft = Tween<double>(begin: -1.0, end: 0.0).animate(
  //       CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn));

  //   _animateright = Tween<double>(begin: 1.0, end: 0.0).animate(
  //       CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn));

  //   _controller.forward();

  //   super.initState();
  // }

  // @override
  // Future<void> dispose() async {
  //   _controller.dispose();

  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double width = MediaQuery.of(context).size.width;
    AppModel model = ScopedModel.of<AppModel>(context);

    return Container(
      height: isTablet() ? 170 : size.height * 0.12.h,
      width: size.width,
      alignment: Alignment.bottomCenter,
      color: model.isDarkTheme ? Color(0xff585959) : Color(0xffE5E7E7),
      padding: EdgeInsets.only(top: isTablet() ? 0 : 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              //
              currentScreen.add(screen.home);

              Navigator.pushNamed(context, HideCapitalScreen.routeName)
                  .then((value) {
                currentScreen.add(screen.home);
              });

              //
            },
            child: AnimatedCircularButton(
                color: [
                  Theme.of(context).cardColor,
                  Theme.of(context).cardColor
                ],
                Icon: Center(
                  child: SvgPicture.asset(
                    currentScreen.value == screen.home
                        ? "assets/newassets/homeSelected.svg"
                        : "assets/newassets/homeUnselectd.svg",
                  ),
                ),
                text: "Home"),
          ),
          GestureDetector(
            onTap: () {
              currentScreen.add(screen.dashboard);

              Navigator.pushNamed(context, DashBoardScreen.routeName)
                  .then((value) {
                currentScreen.add(screen.home);
              });
              ;
            },
            child: AnimatedCircularButton(
                color: [
                  Theme.of(context).cardColor,
                  Theme.of(context).cardColor
                ],
                Icon: Center(
                  child: SvgPicture.asset(
                      currentScreen.value == screen.dashboard
                          ? "assets/newassets/dashBordSelected.svg"
                          : "assets/newassets/dashBordUnselected.svg"),
                ),
                text: "Dashboard"),
          ),
          GestureDetector(
            onTap: () {
              //

              currentScreen.add(screen.setting);

              Navigator.pushNamed(context, SettingScreen.routeName)
                  .then((value) {
                currentScreen.add(screen.home);
              });
            },
            child: AnimatedCircularButton(
                color: [
                  Theme.of(context).cardColor,
                  Theme.of(context).cardColor
                ],
                Icon: Center(
                  child: SvgPicture.asset(
                    "assets/newassets/logout.svg",
                    color: currentScreen.value == screen.setting
                        ? Color(0xff912C8C)
                        : null,
                  ),
                ),
                text: "Setting"),
          ),
          GestureDetector(
            onTap: () {
              print("Log out");

              currentScreen.add(screen.logout);

              OnBackToLogout().Logout(
                  ctx: context,
                  title: "Confirmation Dialog",
                  content: "Do You Want to Logout?");
            },
            child: AnimatedCircularButton(
                color: [
                  Theme.of(context).cardColor,
                  Theme.of(context).cardColor
                ],
                Icon: Center(
                  child: SvgPicture.asset(
                    "assets/newassets/setting.svg",
                    color: currentScreen.value == screen.logout
                        ? Color(0xff912C8C)
                        : null,
                  ),
                ),
                text: "Logout"),
          ),
        ],
      ),
    );
  }
}

//Animated circular bar

class AnimatedCircularBar extends StatefulWidget {
  AnimatedCircularBar({
    this.radius,
    this.color1,
    this.offsetx,
    this.offsety,
    this.negativeOffsetx,
    this.negativeOffsety,
    this.child,
    this.color,
    this.blurradius,
    this.spreadradius,
    this.border,
    Key? key,
  }) : super(key: key);

  final double? radius;
  final Color? color, color1;
  final Widget? child;
  final BoxBorder? border;
  final double? offsetx, offsety;
  final double? negativeOffsetx, negativeOffsety;
  final double? blurradius, spreadradius;

  @override
  State<AnimatedCircularBar> createState() => _AnimatedCircularBarState();
}

class _AnimatedCircularBarState extends State<AnimatedCircularBar>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: widget.radius ?? 190.h,
      width: widget.radius ?? 190.w,
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
        shape: BoxShape.circle,
        border: widget.border ??
            Border.all(
              color: Theme.of(context).shadowColor,
              style: BorderStyle.solid,
              width: 1.5,
            ),
        boxShadow: [
          BoxShadow(
            // color: Colors.purple,
            color:
                widget.color ?? Theme.of(context).shadowColor.withOpacity(0.2),
            blurRadius: widget.blurradius ?? 03.0.w, // soften the shadow
            spreadRadius: widget.spreadradius ?? 04.0.h,
            offset: Offset(
              widget.negativeOffsetx ?? -02.0.h,
              widget.negativeOffsety ?? -03.0.w,
            ),
          ),
          BoxShadow(
            // color: Colors.blue,
            color:
                widget.color1 ?? Theme.of(context).shadowColor.withOpacity(0.2),
            blurRadius: widget.blurradius ?? 04.0, // soften the shadow
            spreadRadius: widget.spreadradius ?? 0.40,
            offset: Offset(
              widget.offsetx ?? 12.0.h,
              widget.offsety ?? 10.0.w,
            ),
          ),
        ],
      ),
      child: widget.child,
    );
  }
}

class CustomCaledner extends StatefulWidget {
  const CustomCaledner({Key? key}) : super(key: key);

  @override
  State<CustomCaledner> createState() => _CustomCalednerState();
}

class _CustomCalednerState extends State<CustomCaledner> {
  @override
  void initState() {
    super.initState();
  }

  var myFormat = DateFormat('dd-MM-yyyy');
  DateTime selectedDate = DateTime.now();

  Future<void> showDateTimePicker() async {
    DateTime? datePicked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (datePicked != null) {
      setState(() {
        selectedDate = datePicked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextButton(
          child: Text(
            selectedDate == ""
                ? "Select Date"
                : "${myFormat.format(selectedDate)}",
            style: Theme.of(context)
                .textTheme
                .bodyText1!
                .copyWith(fontSize: 13.41, fontWeight: FontWeight.w300),
          ),
          onPressed: () {
            setState(() {
              showDateTimePicker();
              print("$showDateTimePicker");
            });
            ;
          }),
    );
  }
}

class AnimatedTopBarTile extends StatefulWidget {
  const AnimatedTopBarTile({required this.notificationCount, Key? key})
      : super(key: key);
  final int notificationCount;
  @override
  State<AnimatedTopBarTile> createState() => _AnimatedTopBarTileState();
}

class _AnimatedTopBarTileState extends State<AnimatedTopBarTile>
    with SingleTickerProviderStateMixin {
  final _duration = Duration(milliseconds: 1500);
  late AnimationController _topBarController;
  late Animation<double> _intervaltween, _animateleft;

  @override
  void initState() {
    _topBarController = AnimationController(vsync: this, duration: _duration);
    _animateleft = Tween<double>(begin: -2.0, end: 0.0).animate(
        CurvedAnimation(parent: _topBarController, curve: Curves.easeInBack));
    _intervaltween = Tween<double>(begin: 2.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _topBarController,
        curve: Interval(
          0.5,
          1.0,
          curve: Curves.fastOutSlowIn,
        ),
      ),
    );

    _topBarController.forward();
    super.initState();
  }

  @override
  void dispose() {
    _topBarController.dispose();
    super.dispose();
  }

  ApiResponse<List<SendNotificationResponseData>>? data;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return AnimatedBuilder(
      animation: _topBarController.view,
      builder: (context, child) {
        return Padding(
          padding: EdgeInsets.only(left: 8.0, right: 08, bottom: 10, top: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Transform(
                    transform: Matrix4.translationValues(
                        _animateleft.value * size.width, 0.0, 0.0),
                    child: FittedBox(
                      child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          radius: 45.h,
                          child:
                              Image.asset("assets/images/logo_bg_removed.png")),
                    ),
                  ),
                  FittedBox(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      height: 15.h,
                      margin: EdgeInsets.only(top: 8.h, left: 04.w),
                      child: Image.asset(
                        "assets/images/text4x.png",
                      ),
                    ),
                  ),
                ],
              ),
              Transform(
                transform: Matrix4.translationValues(
                    _intervaltween.value * size.width, 0.0, 0.0),
                child: Padding(
                  padding: EdgeInsets.only(right: 12.w),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.1,
                    alignment: Alignment.center,
                    // color: Colors.red,
                    // margin: EdgeInsets.only(right: 12, left: 12, top: 08),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                            context, NotificationScreen.routeName);
                      },
                      child: Stack(
                        children: [
                          widget.notificationCount == 0
                              ? Positioned(
                                  child: Container(height: 18.h, width: 18.h))
                              : Positioned(
                                  top: 0.h,
                                  right: 0.h,
                                  child: Container(
                                    height: 18.h,
                                    width: 18.h,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.purple,
                                    ),
                                    child: Center(
                                        child: Text(
                                            widget.notificationCount.toString(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText2!
                                                .copyWith(
                                                    fontSize: 12.sp,
                                                    color: Colors.white))),
                                    // child: ListView.builder(
                                    //     itemCount: data?.data?.length ?? 0,
                                    //     itemBuilder: (context, index) {
                                    //       return Text(
                                    //         data?.data?[index].newMsgs.toString() ??
                                    //             "",
                                    //         style: Theme.of(context)
                                    //             .textTheme
                                    //             .bodyText2!
                                    //             .copyWith(fontSize: 10.sp),
                                    //       );
                                    //     }),
                                  ),
                                ),
                          FittedBox(
                            child: SvgPicture.asset(
                              "assets/svg/notification.svg",
                              height: 26.h,
                              width: 26.h,
                              color:
                                  Theme.of(context).textTheme.bodyText2!.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class AnimatedLongButton extends StatefulWidget {
  AnimatedLongButton(
      {this.text,
      this.fontsize,
      this.Prefixtext,
      this.color,
      this.width,
      this.textColor,
      this.child,
      Key? key,
      required this.isBgColorWhite})
      : super(key: key);
  final String? text;
  final List<Color>? color;
  final bool isBgColorWhite;
  final double? fontsize, width;
  final String? Prefixtext;
  final Color? textColor;
  final Widget? child;
  @override
  State<AnimatedLongButton> createState() => _AnimatedLongButtonState();
}

class _AnimatedLongButtonState extends State<AnimatedLongButton>
    with TickerProviderStateMixin {
  final _duration = Duration(milliseconds: 1000);
  late AnimationController _animationcontroller;

  //  _animateright;
  @override
  void initState() {
    _animationcontroller =
        AnimationController(vsync: this, duration: _duration);

    _animationcontroller.forward();
    super.initState();
  }

  @override
  void dispose() {
    _animationcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return AnimatedBuilder(
        animation: _animationcontroller.view,
        builder: (context, child) {
          return Container(
            height: isTablet() ? 100 : 50,
            width: widget.width ?? width * 0.83.w,
            alignment: Alignment.center,
            margin: EdgeInsets.symmetric(horizontal: 08.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurStyle: BlurStyle.outer,
                  blurRadius: 40.w,
                  spreadRadius: 0.7.h,
                  offset: Offset(3.h, 4.w),
                ),
              ],
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: widget.color ??
                    [Theme.of(context).cardColor, Theme.of(context).cardColor],
              ),
            ),
            child: widget.child ??
                Text(
                  widget.text ?? "".toUpperCase(),
                  softWrap: true,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: widget.fontsize ?? 18.sp,
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.w600,
                        color: widget.isBgColorWhite
                            ? widget.textColor ?? Colors.black
                            : Colors.white,
                      ),
                ),
          );
        });
  }
}

class AnimatedAlertDialog extends StatefulWidget {
  AnimatedAlertDialog(
      {this.begin,
      this.end,
      this.btn_begin,
      this.btn_end,
      this.color,
      this.color_v2,
      this.description,
      this.textcolor,
      this.iconcolor,
      this.title,
      Key? key})
      : super(key: key);

  final List<Color>? color, color_v2;
  final String? description;
  final AlignmentGeometry? begin;
  final AlignmentGeometry? end;
  final AlignmentGeometry? btn_begin;
  final AlignmentGeometry? btn_end;
  final Color? textcolor;
  final Color? iconcolor;
  final String? title;

  @override
  State<AnimatedAlertDialog> createState() => _AnimatedAlertDialogState();
}

class _AnimatedAlertDialogState extends State<AnimatedAlertDialog> {
  bool isWithdraw = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0.h),
      child: Container(
        height: isTablet() ? 350.h : 330.h,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: widget.begin ?? Alignment.topRight,
            end: widget.end ?? Alignment.bottomLeft,
            colors: widget.color ??
                [
                  Color(0xFF2C7FFF),
                  Color(0xFF6EFF98),
                ],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 15.h,
            ),
            Divider(
              height: 3.h,
              color: Colors.white.withOpacity(0.9),
              endIndent: 170.h,
              indent: 170.h,
              thickness: 4,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.0.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // GestureDetector(
                  //   onTap: () {
                  //     Navigator.pop(context);
                  //   },
                  //   child: Center(
                  //     child: Container(
                  //       height: 20.h,
                  //       width: 20.w,
                  //       child: Image.asset(
                  //         "assets/images/cross.png",
                  //         color: Colors.white,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  SizedBox(
                    height: 15,
                  )
                ],
              ),
            ),
            Text(
              widget.title ?? 'Alert',
              style: Theme.of(context).textTheme.headline6!.copyWith(
                    fontSize: 18.sp,
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.w800,
                    color: widget.textcolor ?? Colors.white,
                  ),
            ),
            SizedBox(
              height: 16.h,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  AnimatedCircularButton(
                    color: widget.color_v2 ??
                        [
                          Theme.of(context).cardColor,
                          Theme.of(context).cardColor
                        ],
                    iconColor: Colors.white,
                    Icon: Center(
                      child: Container(
                        height: 28.h,
                        width: 28.w,
                        child: SvgPicture.asset(
                          "assets/svg/exclamation.svg",
                          color: widget.iconcolor ?? Color(0xFF7F3F97),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 300.w,
                    height: isTablet() ? 75.h : 60.h,
                    child: Text(
                      widget.description ?? "",
                      maxLines: 2,
                      softWrap: true,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.visible,
                      style: Theme.of(context).textTheme.headline6!.copyWith(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                    ),
                  ),
                  Container(
                    height: isTablet() ? 60 : null,
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HideCapitalScreen(),
                          ),
                        );
                      },
                      child: AnimatedLongButton(
                        text: "CLOSE",
                        isBgColorWhite: true,
                      ),
                    ),
                  ),
                  Spacer(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NewMenuButton extends StatelessWidget {
  NewMenuButton(
      {Key? key,
      required this.asssetsName,
      required this.bgColor,
      required this.text,
      this.onPress})
      : super(key: key);

  String asssetsName;
  Color bgColor;
  void Function()? onPress;
  String text;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Card(
              color: bgColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 50,
                  width: 50,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: asssetsName.contains(".png")
                        ? Image.asset(
                            asssetsName,
                          )
                        : SvgPicture.asset(
                            asssetsName,
                          ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            text,
            style: TextStyle(
                fontSize: isTablet() ? 8.sp : 12, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}

//small circular animaated button
class AnimatedCircularButton extends StatefulWidget {
  AnimatedCircularButton(
      {this.begin,
      this.end,
      this.text,
      required this.Icon,
      this.radius = 15,
      this.color,
      this.iconColor,
      Key? key})
      : super(key: key);

  final String? text;
  final Widget Icon;
  final List<Color>? color;
  final AlignmentGeometry? begin;
  final AlignmentGeometry? end;
  final Color? iconColor;

  double radius;
  @override
  State<AnimatedCircularButton> createState() => _AnimatedCircularButtonState();
}

class _AnimatedCircularButtonState extends State<AnimatedCircularButton> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return FittedBox(
      child: Column(
        children: [
          Container(
            width: size.height <= 640 ? 40.h : 60.h,
            height: size.height <= 640 ? 40.h : 60.h,
            margin: EdgeInsets.symmetric(horizontal: 12.w),
            decoration: BoxDecoration(
              color: widget.iconColor,
              borderRadius: BorderRadius.circular(30),
            ),
            child: widget.Icon,
          ),
          SizedBox(
            width: 95.w,
            child: Text(
              widget.text ?? "",
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(overflow: TextOverflow.visible, height: 1.3),
              maxLines: 2,
              softWrap: true,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 22.h,
          ),
        ],
      ),
    );
  }
}

//Animated title tile
class AnimatedTitle extends StatefulWidget {
  AnimatedTitle({this.trailing, Key? key, this.data}) : super(key: key);

  final Widget? trailing;
  final DashboardResponseData? data;
  @override
  State<AnimatedTitle> createState() => _AnimatedTitleState();
}

class _AnimatedTitleState extends State<AnimatedTitle>
    with TickerProviderStateMixin {
  final _duration = Duration(milliseconds: 1500);

  late AnimationController _controller;
  late Animation<double> _animateleft, _animateopacity;

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: _duration);

    _animateleft = Tween<double>(begin: -1.0, end: 0.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.bounceIn));
    _animateopacity = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;

    AppModel model = ScopedModel.of<AppModel>(context);
    return Container(
      width: size,
      child: AnimatedBuilder(
          animation: _controller.view,
          builder: (context, child) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 22.0.w),
              child: ListTile(
                  contentPadding: EdgeInsets.all(0),
                  title: Transform(
                    transform: Matrix4.translationValues(
                        _animateleft.value * size, 0.0, 0.0),
                    child: AnimatedOpacity(
                      duration: _duration,
                      opacity: _animateopacity.value,
                      child: Text(
                        "Greetings!",
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            fontSize: 16.sp, fontWeight: FontWeight.w300),
                      ),
                    ),
                  ),
                  subtitle: Transform(
                    transform: Matrix4.translationValues(
                        _animateleft.value * size, 0.0, 0.0),
                    child: AnimatedOpacity(
                      duration: _duration,
                      opacity: _animateopacity.value,
                      child: Text(
                        widget.data?.fullName ?? "",
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w600,
                            color: model.isDarkTheme
                                ? Colors.white
                                : Color(0xff606161)),
                      ),
                    ),
                  ),
                  trailing: widget.trailing ?? null),
            );
          }),
    );
  }
}

//dashboard button
class DashboardBtn extends StatefulWidget {
  DashboardBtn(
      {this.begin,
      this.end,
      this.text,
      required this.Icon,
      this.color,
      Key? key})
      : super(key: key);

  final String? text;
  final Widget Icon;
  final List<Color>? color;
  final AlignmentGeometry? begin;
  final AlignmentGeometry? end;
  @override
  State<DashboardBtn> createState() => _DashboardBtnState();
}

class _DashboardBtnState extends State<DashboardBtn> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return FittedBox(
      child: Column(
        children: [
          Container(
            width: size.height <= 640 ? 65 : 70.h,
            height: size.height <= 640 ? 65 : 70.h,
            margin: EdgeInsets.symmetric(horizontal: 12.w),
            decoration: BoxDecoration(),
            child: widget.Icon,
          ),
          SizedBox(
            height: 9.h,
          ),
          FittedBox(
            child: SizedBox(
              width: 95.w,
              child: Text(
                widget.text ?? "",
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(overflow: TextOverflow.visible, height: 1.3),
                maxLines: 2,
                softWrap: true,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(
            height: 12,
          )
        ],
      ),
    );
  }
}
