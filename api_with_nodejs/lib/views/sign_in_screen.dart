import 'dart:io';

import 'package:api_with_nodejs/components/field_components.dart';
import 'package:api_with_nodejs/extension/media_query_extension.dart';
import 'package:api_with_nodejs/repository/register_repo.dart';
import 'package:api_with_nodejs/views/login_in_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final form = GlobalKey<FormState>();
    ValueNotifier<bool> isCheck = ValueNotifier<bool>(false);

    TextEditingController nameController = TextEditingController();

    TextEditingController emailController = TextEditingController();

    TextEditingController passwordController = TextEditingController();

    TextEditingController confirmPasswordController = TextEditingController();

    void onSave() async {
      final isValid = form.currentState!.validate();
      if (!isValid) {
        return;
      }
      if (isValid) {
        form.currentState!.save();
        await context.read<RegisterRepo>().registerApi(
              nameController.text,
              emailController.text,
              passwordController.text,
              confirmPasswordController.text,
            );
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginInScreen()),
            (route) => false);
      }
    }

    return Consumer<RegisterRepo>(
      builder: (context, value, _) => ModalProgressHUD(
        inAsyncCall: value.isLoading,
        progressIndicator: const SpinKitChasingDots(
          color: Colors.black,
        ),
        child: Container(
          height: context.height,
          width: context.width,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/bg-image.jpg"),
              fit: BoxFit.cover,
              opacity: 0.7,
            ),
          ),
          child: GestureDetector(
            onTap: () {
              // FocusScope.of(context).unfocus();
              print("as");
            },
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: SingleChildScrollView(
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Form(
                      key: form,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: context.height * 0.05,
                          ),
                          Text(
                            "Signin",
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium!
                                .copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const Gap(20),
                          Center(
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Consumer<RegisterRepo>(
                                  builder: (context, image, _) => Opacity(
                                    opacity: image.image == null ? 0.15 : 1,
                                    child: ClipOval(
                                      child: Container(
                                        width: 100,
                                        height: 100,
                                        decoration: image.image == null
                                            ? const BoxDecoration(
                                                color: Colors.black,
                                              )
                                            : BoxDecoration(
                                                color: Colors.black,
                                                image: DecorationImage(
                                                    image: FileImage(
                                                      File(image.image!.path),
                                                    ),
                                                    fit: BoxFit.cover),
                                              ),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: -10,
                                  right: -10,
                                  child: IconButton(
                                    onPressed: () async {
                                      context.read<RegisterRepo>().pickImage();
                                    },
                                    icon: const Icon(
                                      Icons.camera_alt_rounded,
                                      color: Colors.black,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          const Gap(20),
                          FieldComponents(
                            controller: nameController,
                            hintText: "Name",
                            iconData: Icons.person_outline,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Enter a name";
                              }
                              return null;
                            },
                          ),
                          const Gap(20),
                          FieldComponents(
                            controller: emailController,
                            hintText: "Email",
                            iconData: Icons.mail,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Enter a email";
                              } else if (!value.contains("@")) {
                                return "Enter a special Character";
                              }
                              return null;
                            },
                          ),
                          const Gap(20),
                          FieldComponents(
                            controller: passwordController,
                            hintText: "Password",
                            iconData: Icons.lock_outline_sharp,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Enter a password";
                              }
                              return null;
                            },
                          ),
                          const Gap(20),
                          FieldComponents(
                            controller: confirmPasswordController,
                            hintText: "Confirm Password",
                            iconData: Icons.lock_outline_sharp,
                            validator: (value) {
                              if (passwordController.text != value) {
                                return "Password does not match";
                              }
                              return null;
                            },
                          ),
                          const Gap(10),
                          Row(
                            children: [
                              ValueListenableBuilder(
                                  valueListenable: isCheck,
                                  builder: (context, value, _) {
                                    return Checkbox(
                                      value: isCheck.value,
                                      onChanged: (_) {
                                        isCheck.value = !isCheck.value;
                                      },
                                      activeColor: Colors.white,
                                      checkColor: Colors.black,
                                    );
                                  }),
                              RichText(
                                text: const TextSpan(children: [
                                  TextSpan(text: "I read and agree "),
                                  TextSpan(
                                      text: "Terms and conditions",
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold,
                                      )),
                                ]),
                              )
                            ],
                          ),
                          const Gap(10),
                          ValueListenableBuilder(
                            valueListenable: isCheck,
                            builder: (context, value, _) => Opacity(
                              opacity: checkisvalid(
                                      isCheck,
                                      nameController,
                                      emailController,
                                      passwordController,
                                      confirmPasswordController)
                                  ? 1
                                  : 0.4,
                              child: GestureDetector(
                                onTap: () {
                                  if (checkisvalid(
                                      isCheck,
                                      nameController,
                                      emailController,
                                      passwordController,
                                      confirmPasswordController)) {
                                    onSave();
                                  }
                                },
                                child: Center(
                                  child: Container(
                                      height: 50,
                                      width: context.width / 2,
                                      decoration: BoxDecoration(
                                          color: Colors.grey.shade400,
                                          borderRadius:
                                              BorderRadius.circular(18)),
                                      child: Center(
                                        child: Text(
                                          "Signin",
                                          style: TextStyle(
                                            color: checkisvalid(
                                              isCheck,
                                              nameController,
                                              emailController,
                                              passwordController,
                                              confirmPasswordController,
                                            )
                                                ? Colors.black
                                                : Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      )),
                                ),
                              ),
                            ),
                          ),
                          const Gap(10),
                          Center(
                            child: Text.rich(TextSpan(children: [
                              const TextSpan(
                                  text: "Already have an Account ",
                                  style: TextStyle(color: Colors.grey)),
                              TextSpan(
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const LoginInScreen()),
                                          (route) => false);
                                    },
                                  text: "Sign-up",
                                  style: const TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold)),
                            ])),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool checkisvalid(
    ValueNotifier<bool> isCheck,
    TextEditingController nameController,
    TextEditingController emailController,
    TextEditingController passwordController,
    TextEditingController confirmPasswordController,
  ) {
    return isCheck.value &&
        nameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        confirmPasswordController.text.isNotEmpty;
  }
}
