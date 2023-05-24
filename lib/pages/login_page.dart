import 'package:admin_mobile_work_it/constance.dart';
import 'package:admin_mobile_work_it/store/controllers/account_ctrl.dart';
import 'package:admin_mobile_work_it/store/api_client.dart';
import 'package:admin_mobile_work_it/routes.dart';
import 'package:admin_mobile_work_it/service/api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nfc_manager/nfc_manager.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String?, String?> formData = {'username': null, 'password': null};
  final AccountCtrl accountController = Get.find();
  final ApiClient apiClient = Get.find();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    NfcManager.instance.stopSession();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Flexible(
                  flex: 1,
                  child: TextFormField(
                    decoration: const InputDecoration(
                        hintText: 'Логин',
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                          color: Colors.transparent,
                          width: 1,
                        )),
                        prefixIcon: Icon(Icons.account_circle_outlined)),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Логин не может быть пустым';
                      }
                      return null;
                    },
                    autofocus: true,
                    onSaved: (String? value) {
                      setState(() {
                        formData['username'] = value!;
                      });
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  obscureText: true,
                  decoration: const InputDecoration(
                      hintText: 'Пароль',
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                        color: Colors.transparent,
                        width: 1,
                      )),
                      prefixIcon: Icon(Icons.lock)),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Пароль не может быть пустым';
                    }
                    return null;
                  },
                  onSaved: (String? value) {
                    setState(() {
                      formData['password'] = value!;
                    });
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: Container(
                    height: 60,
                    width: 120,
                    margin: const EdgeInsets.symmetric(vertical: 50),
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          SERVER_IP = formData['server_ip']!;
                          accountController
                              .tryLoginIn(formData['username']!, formData['password']!)
                              .then((value) {
                            if (value) {
                              Get.offAndToNamed(RouterHelper.home);
                            }
                          });
                        }
                      },
                      child: const Text(
                        'Войти',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
