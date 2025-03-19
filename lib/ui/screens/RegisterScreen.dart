import 'package:fe_capstone/main.dart';
import 'package:fe_capstone/ui/CustomerUI/HomeScreen.dart';
import 'package:fe_capstone/ui/components/FooterComponent.dart';
import 'package:fe_capstone/ui/components/HeaderComponent.dart';
import 'package:fe_capstone/ui/screens/LoginScreen.dart';
import 'package:fe_capstone/ui/screens/OTPScreen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            const HeaderComponent(),
            Positioned(
              left: 10 * fem,
              right: 10 * fem,
              top: 189 * fem,
              child: Container(
                margin: EdgeInsets.only(top: 20 * fem),
                padding: EdgeInsets.fromLTRB(
                    20 * fem, 47 * fem, 20 * fem, 24 * fem),
                width: 362 * fem,
                decoration: BoxDecoration(
                  color: const Color(0xffffffff),
                  borderRadius: BorderRadius.circular(26 * fem),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0x1e000000),
                      offset: Offset(0 * fem, 0 * fem),
                      blurRadius: 25 * fem,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(
                          0 * fem, 0 * fem, 0 * fem, 25 * fem),
                      child: Text(
                        'ĐĂNG KÝ',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 40 * ffem,
                          fontWeight: FontWeight.w600,
                          height: 1.175 * ffem / fem,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(
                          0 * fem, 0 * fem, 0 * fem, 18 * fem),
                      padding: EdgeInsets.fromLTRB(
                          20.5 * fem, 0, 20.5 * fem, 0),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: Theme.of(context).primaryColor),
                        borderRadius: BorderRadius.circular(30 * fem),
                      ),
                      child: TextFormField(
                        style: TextStyle(
                          fontSize: 20 * ffem,
                          fontWeight: FontWeight.w600,
                          height: 1.175 * ffem / fem,
                          color: Color(0xff000000),
                        ),
                        decoration: InputDecoration(
                          hintText: 'Họ và tên',
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            color: Color(0xffa3a3a3),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(
                          0 * fem, 0 * fem, 0 * fem, 18 * fem),
                      padding: EdgeInsets.fromLTRB(
                          20.5 * fem, 0, 20.5 * fem, 0),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: Theme.of(context).primaryColor),
                        borderRadius: BorderRadius.circular(30 * fem),
                      ),
                      child: TextFormField(
                        style: TextStyle(
                          fontSize: 20 * ffem,
                          fontWeight: FontWeight.w600,
                          height: 1.175 * ffem / fem,
                          color: Color(0xff000000),
                        ),
                        decoration: InputDecoration(
                          hintText: 'Số điện thoại',
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            color: Color(0xffa3a3a3),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(
                          0 * fem, 0 * fem, 0 * fem, 18 * fem),
                      padding: EdgeInsets.fromLTRB(
                          20.5 * fem, 0, 20.5 * fem, 0),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: Theme.of(context).primaryColor),
                        borderRadius: BorderRadius.circular(30 * fem),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: TextFormField(
                              obscureText: isPasswordVisible
                                  ? false
                                  : true,
                              style: TextStyle(
                                fontSize: 20 * ffem,
                                fontWeight: FontWeight.w600,
                                height: 1.175 * ffem / fem,
                                color: Color(0xff000000),
                              ),
                              decoration: InputDecoration(
                                hintText: 'Mật khẩu',
                                border: InputBorder.none,
                                hintStyle: TextStyle(
                                  color: Color(0xffa3a3a3),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            child: IconButton(
                              icon: Icon(
                                isPasswordVisible
                                    ? Icons
                                    .visibility // Hiển thị khi mật khẩu ẩn
                                    : Icons
                                    .visibility_off, // Hiển thị khi mật khẩu hiển thị
                              ),
                              onPressed: () {
                                setState(() {
                                  isPasswordVisible =
                                  !isPasswordVisible; // Đảo ngược trạng thái
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(
                          0 * fem, 0 * fem, 0 * fem, 18 * fem),
                      padding: EdgeInsets.fromLTRB(
                          20.5 * fem, 0, 20.5 * fem, 0),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: Theme.of(context).primaryColor),
                        borderRadius: BorderRadius.circular(30 * fem),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: TextFormField(
                              obscureText: isConfirmPasswordVisible
                                  ? false
                                  : true, // Ẩn mật khẩu
                              style: TextStyle(
                                fontSize: 20 * ffem,
                                fontWeight: FontWeight.w600,
                                height: 1.175 * ffem / fem,
                                color: Color(0xff000000),
                              ),
                              decoration: InputDecoration(
                                hintText: 'Xác nhận mật khẩu',
                                border: InputBorder.none,
                                hintStyle: TextStyle(
                                  color: Color(0xffa3a3a3),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            child: IconButton(
                              icon: Icon(
                                isConfirmPasswordVisible
                                    ? Icons
                                    .visibility // Hiển thị khi mật khẩu ẩn
                                    : Icons
                                    .visibility_off, // Hiển thị khi mật khẩu hiển thị
                              ),
                              onPressed: () {
                                setState(() {
                                  isConfirmPasswordVisible =
                                  !isConfirmPasswordVisible; // Đảo ngược trạng thái
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OTPScreen(type: 1),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(9 * fem),
                        ),
                        elevation: 10 * fem,
                      ),
                      child: Container(
                        width: 322 * fem,
                        height: 42 * fem,
                        child: Center(
                          child: Text(
                            'ĐĂNG KÝ',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16 * ffem,
                              fontWeight: FontWeight.w600,
                              height: 1.175 * ffem / fem,
                              color: Color(0xffffffff),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                        margin: EdgeInsets.fromLTRB(
                            0 * fem, 35 * fem, 3 * fem, 0 * fem),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: 16 * ffem,
                              fontWeight: FontWeight.w600,
                              height: 1.175 * ffem / fem,
                              color: Theme.of(context).primaryColor,
                            ),
                            children: [
                              TextSpan(
                                text: 'Bạn đã có tài khoản?  ',
                              ),
                              TextSpan(
                                text: 'Đăng Nhập',
                                style: TextStyle(
                                  fontSize: 16 * ffem,
                                  fontWeight: FontWeight.w600,
                                  height: 1.175 * ffem / fem,
                                  color: Color(0xff5767f5),
                                  decoration: TextDecoration
                                      .underline, // Thêm gạch chân
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              LoginScreen()),
                                    );
                                  },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 750 * fem,
              child: Container(
                width: mq.width,
                child: Align(
                  alignment: Alignment.center,
                  child: FooterComponent(),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
