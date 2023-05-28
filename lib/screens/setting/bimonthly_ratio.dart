import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:theaccounts/bloc/dashboard_bloc.dart';
import 'package:theaccounts/model/ClosingRatioResponse.dart';
import 'package:theaccounts/networking/ApiResponse.dart';
import 'package:theaccounts/screens/dashboard/custom.widgets/custom_widgets.dart';
import 'package:theaccounts/screens/setting/components/setting.widgets.dart';
import 'package:theaccounts/screens/widgets/GlowSetting.dart';
import 'package:theaccounts/screens/widgets/loading_dialog.dart';
import 'package:theaccounts/utils/Const.dart';
import 'package:theaccounts/utils/utility.dart';

class BimonthlyRatioScreen extends StatefulWidget {
  const BimonthlyRatioScreen({Key? key}) : super(key: key);
  static const routeName = '/bi_monthly-screen';

  @override
  State<BimonthlyRatioScreen> createState() => _BimonthlyRatioScreenState();
}

class _BimonthlyRatioScreenState extends State<BimonthlyRatioScreen>
    with TickerProviderStateMixin {
  late DashboardBloc _bloc;
  ClosingRatioResponseData? data;
  @override
  void initState() {
    _bloc = DashboardBloc();
    _bloc.GetClosingRatioStream.listen((event) {
      if (event.status == Status.COMPLETED) {
        DialogBuilder(context).hideLoader();
        setState(() {
          data = event.data;
          print(data?.toJson());
        });
      } else if (event.status == Status.ERROR) {
        DialogBuilder(context).hideLoader();
        showSnackBar(context, event.message, true);
      } else if (event.status == Status.LOADING) {
        DialogBuilder(context).showLoader();
      }
    });
    _bloc.GetClosingRatioData();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    Size size = MediaQuery.of(context).size;
    double height = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return true;
      },
      child: Scaffold(
        bottomNavigationBar: AnimatedBottomBar(),
        body: Container(
          height: height,
          width: width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Flexible(
                  flex: 01,
                  child: Padding(
                    padding: EdgeInsets.only(top: 24.0.h),
                    child: CustomTopBar(topbartitle: "Bimonthly Ratio"),
                  )),
              Flexible(
                flex: 6,
                child: Padding(
                  padding: EdgeInsets.all(12.0.h),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Spacer(
                        flex: 3,
                      ),
                      GlowSetting(
                        color: Color(0xff92298D).withOpacity(0.1),
                        color1: Color(0xffBF40BF).withOpacity(0.7),
                        radius: size.height < 700 ? 155 : 180,
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'Rs.  ',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600),
                              ),
                              TextSpan(
                                text: Const.currencyFormatWithoutDecimal
                                    .format(data?.closingRatio?.toInt() ?? 0),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                        fontSize: 19.sp,
                                        fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Spacer(
                        flex: 1,
                      ),
                      Center(
                        child: Text(
                          data?.closingRatioText.toString() ?? "---",
                          style:
                              Theme.of(context).textTheme.bodyText2!.copyWith(
                                    fontSize: 14,
                                  ),
                        ),
                      ),
                      Spacer(
                        flex: 2,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
