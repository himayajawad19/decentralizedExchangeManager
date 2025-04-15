import 'package:decentralized_app/dashboard/bloc/dashboard_bloc.dart';
import 'package:decentralized_app/dashboard/features/deposit/deposit.dart';
import 'package:decentralized_app/dashboard/features/withdraw/withdraw.dart';
import 'package:decentralized_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final DashboardBloc dashboardBloc = DashboardBloc();
  @override
  void initState() {
    dashboardBloc.add(DashboardInitialFetchEvent());
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        title: Text(
          "Crypto Bank",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
  
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 16.sp),
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 8.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/logo.svg',
                    height: 50.h,
                    width: 50.w,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    "10 ETH",
                    style: TextStyle(
                      color: AppColors.secondaryColor,
                      fontSize: 40.sp,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                           Navigator.push(context, MaterialPageRoute(builder: (context)=> Deposit()));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accentColor,
                        ),
                        child: Text(
                          "Deposit",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(context, 

                          MaterialPageRoute(builder: (context)=> Withdraw()));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accentColor,
                        ),
                        child: Text(
                          "Withdraw",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Transactions",
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: 3, // total number of items
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        leading: SvgPicture.asset(
                    'assets/logo.svg',
                    height: 30.h,
                    width: 30.w,
                  ), 
                  onTap: () {
                    
                  },
                  hoverColor: AppColors.secondaryColor,
                  subtitle: Text("0x78cc7Cb693a106F067b7E404ae01EF068bfe5d8e\nNFT Purchase") ,
                        title: Text(" 1 ETH"),
                        tileColor: AppColors.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            10,
                          ), 
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
