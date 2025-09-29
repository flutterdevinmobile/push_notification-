import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../blocs/resend_otp_bloc/resend_otp_bloc.dart';
import '../blocs/verify_otp_bloc/verify_otp_bloc.dart';

class VerifyOtpScreen extends StatefulWidget {
  final String phoneNumber;

  const VerifyOtpScreen({super.key, required this.phoneNumber});

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  String otpCode = "";
  int _secondsRemaining = 60;
  Timer? _timer;
  // ignore: unused_field
  bool _canResend = false;
  bool isError = false;

  @override
  void initState() {
    super.initState();
    _startOtpTimer();
  }

  void _startOtpTimer() {
    _secondsRemaining = 60;
    _canResend = false;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        _timer?.cancel();
        setState(() {
          _canResend = true;
        });
      }
    });
  }

  void _resendOtp() {
    context.read<ResendOtpBloc>().add(
          ResendOtpStarted(
            phoneNumber: widget.phoneNumber,
          ),
        );

    _startOtpTimer();
  }

  void _verifyOtp(currentLocale) {
    if (otpCode.length == 4) {
      context.read<VerifyOtpBloc>().add(
            VerifyOtpStarted(
              phoneNumber: widget.phoneNumber,
              otpCode: otpCode,
              lang: currentLocale.toString(),
            ),
          );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Locale currentLocale = context.locale;
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: BlocConsumer<VerifyOtpBloc, VerifyOtpState>(
          listener: (context, state) {
            state.whenOrNull(success: (model) {
              if (model.isNew == true) {
                context.push("/set-info");
              } else if (model.isNew == false) {
                context.go("/notification");
              }
            }, failure: (error) {
              setState(() {
                isError = true;
              });
              _timer?.cancel();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(error.message)),
              );
            });
          },
          builder: (context, state) {
            return Column(
              children: [
                Text(
                  "Введите код из SMS",
                  style: Theme.of(context).textTheme.displayLarge,
                  textAlign: TextAlign.center,
                ),
                12.verticalSpace,
                Text(
                  "Мы отправили SMS с кодом подтверждения на ваш номер ${widget.phoneNumber}",
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                63.verticalSpace,
                PinCodeTextField(
                  appContext: context,
                  autoFocus: true,
                  length: 4,
                  onChanged: (value) {
                    setState(() {
                      otpCode = value;
                    });
                    _verifyOtp(currentLocale);
                  },
                  enableActiveFill: true,
                  cursorColor: Colors.black,
                  keyboardType: TextInputType.number,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(12.r),
                    fieldHeight: 73.h,
                    fieldWidth: 73.w,
                    borderWidth: 1,
                    activeFillColor:
                        Theme.of(context).colorScheme.inverseSurface,
                    inactiveFillColor:
                        Theme.of(context).colorScheme.inverseSurface,
                    selectedFillColor:
                        Theme.of(context).colorScheme.inverseSurface,
                    activeColor: isError
                        ? Theme.of(context).colorScheme.error
                        : const Color(0xff85B4AA),
                    inactiveColor: isError
                        ? Theme.of(context).colorScheme.error
                        : const Color(0xffC2C2C2),
                    selectedColor: isError
                        ? Theme.of(context).colorScheme.error
                        : const Color(0xff85B4AA),
                  ),
                ),
                24.verticalSpace,
                TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size(0, 0),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: () {
                    _resendOtp();
                  },
                  child: RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                      children: [
                        TextSpan(
                          text: 'Отправить код повторно ',
                          style: const TextStyle(
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        TextSpan(
                          text: '00:$_secondsRemaining',
                          style: const TextStyle(
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
