import 'package:decentralized_app/dashboard/bloc/dashboard_bloc.dart';
import 'package:decentralized_app/dashboard/features/deposit/deposit.dart';
import 'package:decentralized_app/dashboard/features/withdraw/withdraw.dart';
import 'package:decentralized_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    super.initState();
  }
  @override
  void dispose() {
  dashboardBloc.close();
  super.dispose();
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
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(onPressed: (){
            
          }, icon: Icon(Icons.wb_sunny_outlined, size: 25,)),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: (){
            
              },
              icon: Icon(Icons.notifications_none_outlined,size: 25),),
          )
        ],
      ),
      body: 
      BlocConsumer<DashboardBloc, DashboardState>(
        bloc: dashboardBloc,
        listener: (context, state) {
        },
        builder: (context, state) {
         switch(state.runtimeType){
            case DashboardLoadingState:
            return Center(child: CircularProgressIndicator());
            case DashboardSuccessState:
            final successState = state as DashboardSuccessState;
            return Container(
            margin: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 16.sp),
            child: Center(
              child: 
              SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 8.h),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(140, 255, 172, 64),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: 
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
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
                                  "${successState.balance} ETH",
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
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => Deposit(dashboardBloc: dashboardBloc,),
                                          ),
                                        );
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
                                        Navigator.push(
                                          context,
                                            
                                          MaterialPageRoute(
                                            builder: (context) => Withdraw(dashboardBloc: dashboardBloc,),
                                          ),
                                        );
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
                          ],
                        ),
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
                    
                       ListView.builder(
                        shrinkWrap: true,
                        itemCount: successState.transactions.length, // total number of items
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              leading: SvgPicture.asset(
                                'assets/logo.svg',
                                height: 30.h,
                                width: 30.w,
                              ),
                              onTap: () {},
                              hoverColor: AppColors.secondaryColor,
                              subtitle: Text(
                                "${successState.transactions[index].address}\n${successState.transactions[index].reason}",
                              ),
                              title: Text("${successState.transactions[index].amount} ETH"),
                              tileColor: AppColors.primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          );
                        },
                      ),
                    
                  ],
                ),
              ),
            ),
          );
          case DashboardErrorState:
         return Center(child: Text("Error"),);
           default:
          return SizedBox();
          }
        },
      ),
    );
  }
}
