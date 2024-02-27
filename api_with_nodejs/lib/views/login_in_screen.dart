import 'dart:convert';

import 'package:api_with_nodejs/components/field_components.dart';
import 'package:api_with_nodejs/extension/media_query_extension.dart';
import 'package:api_with_nodejs/viewModel/login_view_model.dart';
import 'package:api_with_nodejs/views/sign_in_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gap/gap.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

class LoginInScreen extends StatelessWidget {
  const LoginInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final form = GlobalKey<FormState>();
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    void onSave() async {
      final isValid = form.currentState!.validate();
      if (!isValid) {
        return;
      }
      if (isValid) {
        form.currentState!.save();
        final data = {
          "email": emailController.text.trim(),
          "password": passwordController.text.trim(),
        };
        await context.read<LoginViewModel>().login(jsonEncode(data),context);
        // Navigator.pushAndRemoveUntil(
        //     context,
        //     MaterialPageRoute(builder: (context) => const LoginInScreen()),
        //     (route) => false);
      }
    }

    return Consumer<LoginViewModel>(
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
                            height: context.height * 0.20,
                          ),
                          Text(
                            "Login",
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium!
                                .copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
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
                          const Gap(10),
                          const Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              "Forgot your password?",
                              style: TextStyle(
                                color: Colors.blue,
                              ),
                            ),
                          ),
                          const Gap(10),
                          GestureDetector(
                            onTap: () {
                              onSave();
                            },
                            child: Center(
                              child: Container(
                                  height: 50,
                                  width: context.width / 2,
                                  decoration: BoxDecoration(
                                      color: Colors.grey.shade400,
                                      borderRadius: BorderRadius.circular(18)),
                                  child: const Center(
                                    child: Text(
                                      "login",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )),
                            ),
                          ),
                          const Gap(10),
                          Center(
                            child: Text.rich(TextSpan(children: [
                              const TextSpan(
                                  text: "Dont's have an Account ",
                                  style: TextStyle(color: Colors.grey)),
                              TextSpan(
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const SignInScreen()),
                                          (route) => false);
                                    },
                                  text: "Sign-in",
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
}
