import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../blocs/set_info_bloc/set_info_bloc.dart';

class SetInfoScreen extends StatefulWidget {
  const SetInfoScreen({super.key});

  @override
  State<SetInfoScreen> createState() => _SetInfoScreenState();
}

class _SetInfoScreenState extends State<SetInfoScreen> {
  bool isError = false;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  FocusNode nameFocusNode = FocusNode();

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    nameFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocConsumer<SetInfoBloc, SetInfoState>(
          listener: (context, state) {
            state.whenOrNull(success: (model) {
              context.go("/notification");
            }, failure: (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(e.message)),
              );
            });
          },
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  60.verticalSpace,
                  Text(
                    "Создание аккаунта",
                    style: Theme.of(context).textTheme.displayLarge,
                    textAlign: TextAlign.center,
                  ),
                  40.verticalSpace,
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Ваше имя",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                    ),
                  ),
                  6.verticalSpace,
                  TextField(
                    onChanged: (value) {
                      if (value.length > 2) {
                        setState(() {
                          isError = false;
                        });
                      }
                    },
                    focusNode: nameFocusNode,
                    controller: nameController,
                    style: TextStyle(
                      color: Color(0xFF1A1E25),
                      fontWeight: FontWeight.w400,
                      fontSize: 16.sp,
                    ),
                    decoration: InputDecoration(
                      hintText: "Ваше имя",
                      hintStyle: Theme.of(context).textTheme.bodyLarge,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(
                          color: isError
                              ? Theme.of(context).colorScheme.error
                              : const Color(0xffC2C2C2),
                          width: 1.w,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(
                            color: isError
                                ? Theme.of(context).colorScheme.error
                                : const Color(0xffC2C2C2),
                            width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(
                            color:
                                isError ? Colors.red : const Color(0xff85B4AA),
                            width: 1),
                      ),
                    ),
                  ),
                  16.verticalSpace,
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Кратко о себе (опционально)",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                    ),
                  ),
                  6.verticalSpace,
                  TextField(
                    controller: descriptionController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: "Информация для клиентов",
                      hintStyle: Theme.of(context).textTheme.bodyLarge,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide:
                            BorderSide(color: Color(0xffC2C2C2), width: 1.w),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide:
                            BorderSide(color: Color(0xffC2C2C2), width: 1.w),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide:
                            BorderSide(color: Color(0xff85B4AA), width: 1.w),
                      ),
                    ),
                  ),
                  28.verticalSpace,
                  SizedBox(
                    width: double.infinity,
                    height: 48.h,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                      ),
                      onPressed: () {
                        if (nameController.text.length > 2) {
                          context.read<SetInfoBloc>().add(
                                SetInfoStarted(
                                  name: nameController.text,
                                  description: descriptionController.text,
                                ),
                              );
                        } else {
                          setState(() {
                            nameFocusNode.requestFocus();
                          });
                          setState(() {
                            isError = true;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Пустое поле")),
                          );
                        }
                      },
                      child: state.maybeWhen(
                        orElse: () => Text(
                          "Продолжить",
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                        ),
                        inPrepare: () => CircularProgressIndicator(),
                      ),
                    ),
                  ),
                  20.verticalSpace,
                  Text.rich(
                    textAlign: TextAlign.center,
                    TextSpan(
                      text: 'Нажимая “Продолжить”, Вы принимаете ',
                      children: [
                        TextSpan(
                          text: 'Пользовательское соглашение',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                        ),
                        TextSpan(
                          text: ' и ',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                        TextSpan(
                          text: 'Политику конфиденциальности',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                        ),
                      ],
                    ),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                  ),
                  70.verticalSpace,
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Image.asset(
                      "assets/images/splash_logo.png",
                      width: 122.w,
                      height: 40.h,
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
