import 'package:decentralized_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Withdraw extends StatefulWidget {
  const Withdraw({super.key});

  @override
  State<Withdraw> createState() => _WithdrawState();
}

class _WithdrawState extends State<Withdraw> {
  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          backgroundColor: AppColors.backgroundColor,
          title: Text(
            "Deposit Funds",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          centerTitle: true,
        ),
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 16.sp),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "To deposit funds, enter your wallet address, the amount you wish to send, and an optional reason for the transaction. Make sure the address is correct before confirming your transfer.",
                ),
                SizedBox(height: 16.sp),
                Text(
                  "Address",
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w400),
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(border: OutlineInputBorder(), ),
                ),
                SizedBox(height: 16.sp),
                Text(
                  "Amount",
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w400),
                ),
                TextField(
                  keyboardType: TextInputType.numberWithOptions(),
                  decoration: InputDecoration(border: OutlineInputBorder()),
                ),
                SizedBox(height: 16.sp),
                Text(
                  "Reason",
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w400),
                ),
                TextField(
                  decoration: InputDecoration(border: OutlineInputBorder()),
                ),
                SizedBox(height: 16.sp),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accentColor,
                        ),
                        child: Text(
                          "Deposit",
                          style: TextStyle(color: Colors.white, fontSize: 16.sp),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}