import 'package:flutter/material.dart';
import 'package:last_telemedicine/auth/auth_service.dart';
import 'package:last_telemedicine/components/DividerLine.dart';
import 'package:last_telemedicine/themes/AppColors.dart';

import '../../components/Checkbox.dart';
import '../../components/Appbar/CustomAppBar.dart';
import '../../components/Notification.dart';

class CoveredRegisterDoctor extends StatefulWidget {
  const CoveredRegisterDoctor({super.key});

  @override
  State<CoveredRegisterDoctor> createState() => _CoveredRegisterDoctorState();

}
class _CoveredRegisterDoctorState extends State<CoveredRegisterDoctor> {

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();

  bool get _isFormValid {
    return
        _nameController.text.trim().isNotEmpty &&
        _phoneController.text.trim().isNotEmpty &&
        _pwController.text.trim().isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    // цветовая палитра



    // общий отступ по горизонтали
    const horizontalPadding = 10.0;
    const dividerOfContinue = 10.0;

    void register(BuildContext context) async  {
      final _auth =AuthService();

      final phone_num = _phoneController.text;
      final pass = _pwController.text;
      final name = _nameController.text.split(" ")[0];
      String? surname;
      try {
        surname = _nameController.text.split(" ")[1];
      } catch (e) {
        surname = "";
      }


      final email = '${phone_num}@doctor.com';

      debugPrint('DEBUG: email="$email", pass length=${pass.length}');

      try {
        await _auth.signUpDoctorWithEmailPassword(pseudoemail: email , password: pass, phone: phone_num, name: name, surname: surname);

        Navigator.of(context).popUntil((route) => route.isFirst);
      }

      // catch errors
      catch (e) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(e.toString()),
          ),
        );
      }

    }


    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        titleText: 'Этой страницы не существует',
        backgroundColor: Colors.white,
      ),


      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),


              // Заголовок
              const Text(
                'Регистрация ВРАЧА',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'SF Pro Display',
                  fontSize: 32,
                  fontWeight: FontWeight.w300,
                  color: AppColors.primaryText,
                ),
              ),

              const SizedBox(height: 18),





              const SizedBox(height: 80),

              // Divider before first field (как в макете)
              DividerLine(),

              // Поле: Имя и Фамилия
              TextFormField(
                onChanged: (_) => setState(() {}),
                controller: _nameController,
                decoration: const InputDecoration(
                  hintText: 'Имя и Фамилия врача',
                  hintStyle: TextStyle(
                    fontFamily: 'SF Pro Display',
                    color: AppColors.addLightText,
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.fromLTRB(10, 20, 0, 20),
                ),
                style: const TextStyle(
                  fontFamily: 'SF Pro Display',
                  fontSize: 20,
                ),
              ),

              DividerLine(),


              // Телефон: +7 и поле
              Container(
                // сделать палку снизу
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: AppColors.greyDivider, width: 1),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          right: BorderSide(color: AppColors.greyDivider, width: 1),
                        ),
                      ),
                      width: 72,
                      padding: const EdgeInsets.symmetric(vertical: 20), // размер палка справа от +7
                      alignment: Alignment.center,
                      // граница между кодом и полем — реализована визуально через контейнер
                      child: Center(
                        child: const Text(
                          '+7',
                          style: TextStyle(
                            fontFamily: 'SF Pro Display',
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: TextFormField(
                        onChanged: (_) => setState(() {}),
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          hintText: 'Ваш номер телефона',
                          hintStyle: TextStyle(
                            fontFamily: 'SF Pro Display',
                            color: AppColors.addLightText,
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.fromLTRB(20, 20, 0, 20),
                        ),
                        style: const TextStyle(
                          fontFamily: 'SF Pro Display',
                          color: AppColors.primaryText,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),


              // Пароль
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: AppColors.greyDivider, width: 1),
                  ),
                ),
                child: TextFormField(
                  onChanged: (_) => setState(() {}),
                  controller: _pwController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: 'Пароль',
                    hintStyle: TextStyle(
                      fontFamily: 'SF Pro Display',
                      color: Colors.grey,
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.fromLTRB(10, 20, 0, 20),
                  ),
                  style: const TextStyle(
                    fontFamily: 'SF Pro Display',
                    fontSize: 20,
                  ),
                ),
              ),

              const SizedBox(height: 20),




            ],
          ),

        ),




      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
        child: SizedBox(
          height: 64,
          child: ElevatedButton(
            onPressed: () {
              if (_isFormValid) {
                register(context);
              } else {
                showCustomNotification(context, 'Пожалуйста, заполните все поля!');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _isFormValid
                  ? AppColors.additionalAccent
                  : const Color(0xFFFDF4F7),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            child: Text(
              'Продолжить',
              style: TextStyle(
                fontFamily: 'SF Pro Display',
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: _isFormValid
                    ? AppColors.mainColor
                    : const Color(0xFFFDA0AF),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
