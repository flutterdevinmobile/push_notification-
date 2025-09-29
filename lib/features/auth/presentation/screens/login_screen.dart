import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_intl_phone_field/flutter_intl_phone_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../blocs/login_bloc/login_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController numberController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String completeNumber = '';
  @override
  void dispose() {
    super.dispose();
    numberController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding:
            EdgeInsets.only(left: 16.w, right: 16.w, top: 72.h, bottom: 24.h),
        child: SingleChildScrollView(
          child: BlocConsumer<LoginBloc, LoginState>(
            listener: (context, state) {
              state.whenOrNull(
                success: (model) {
                  context.push('/verify-otp', extra: completeNumber);
                },
              );
            },
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    spacing: 12,
                    children: [
                      // Title
                      Text(
                        "welcome".tr(),
                        style: Theme.of(context).textTheme.displayLarge,
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        "log_in_desc".tr(),
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  64.verticalSpace,
                  Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "phone_number".tr(),
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(
                                color:
                                    // ignore: deprecated_member_use
                                    Theme.of(context).colorScheme.onBackground,
                              ),
                        ),
                      ),
                      8.verticalSpace,
                      Form(
                        key: formKey,
                        child: IntlPhoneField(
                          controller: numberController,
                          decoration: InputDecoration(
                            counterText: '',
                            contentPadding: EdgeInsets.all(16.w),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                  color: Color(0xffC2C2C2), width: 1),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                  color: Color(0xffC2C2C2), width: 1),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                  color: Color(0xff85B4AA), width: 1),
                            ),
                          ),
                          showDropdownIcon: false,
                          flagsButtonPadding:
                              const EdgeInsets.only(left: 16, right: 8),
                          initialCountryCode: 'UZ',
                          onChanged: (phone) {
                            completeNumber = phone.completeNumber;
                          },
                          validator: (phone) {
                            if (phone!.completeNumber.isEmpty) {
                              return 'empty_field'.tr();
                            } else if (phone.completeNumber.length < 13) {
                              return 'invalid_format'.tr();
                            }
                            return null;
                          },
                        ),
                      ),
                      28.verticalSpace,
                      SizedBox(
                        width: double.infinity,
                        height: 48.h,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF004D40),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                          ),
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              context.read<LoginBloc>().add(
                                  LoginStarted(phoneNumber: completeNumber));
                            }
                          },
                          child: state.maybeWhen(
                            inPrepare: () => CircularProgressIndicator(),
                            orElse: () => Text(
                              "continue".tr(),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                  ),
                            ),
                          ),
                        ),
                      ),
                      16.verticalSpace,
                    ],
                  ),

                  32.verticalSpace,
                  Divider(color: Colors.grey.shade300),
                  32.verticalSpace,

                  InkWell(
                    onTap: () {
                      context.go("/home");
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "without_registration".tr(),
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.tertiary,
                              ),
                        ),
                        SizedBox(width: 4.w),
                        Icon(
                          Icons.arrow_forward,
                          size: 16.sp,
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                      ],
                    ),
                  ),

                  165.verticalSpace,
                  // Logo
                  Image.asset(
                    "assets/images/splash_logo.png",
                    width: 122.w,
                    height: 40.h,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
