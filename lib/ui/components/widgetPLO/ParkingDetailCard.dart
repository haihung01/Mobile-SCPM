import 'package:fe_capstone/main.dart';
import 'package:flutter/material.dart';

class ParkingDetailCard extends StatelessWidget {
  final List<String> type;
  const ParkingDetailCard({Key? key, required this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          '61A-99999',
          style: TextStyle(
            fontSize: 26 * ffem,
            fontWeight: FontWeight.w700,
            height: 1.175 * ffem / fem,
            color: Color(0xffffffff),
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(15 * fem, 26 * fem, 14 * fem, 0),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if(!type.contains("Normal"))
            Container(
              margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 5 * fem),
              padding: EdgeInsets.fromLTRB(14 * fem, 14 * fem, 4 * fem, 10 * fem), // Adjusted padding
              width: 120 * fem,
              decoration: BoxDecoration(
                color: Color(0xffdcdada),
                borderRadius: BorderRadius.circular(6 * fem),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 20 * fem, // Reduced icon size
                    height: 20 * fem, // Reduced icon size
                    child: Icon(Icons.message),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 8 * fem),
                    child: Text(
                      'Nhắn tin',
                      style: TextStyle(
                        fontSize: 18 * ffem,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff000000),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 25 * fem),
              padding: EdgeInsets.fromLTRB(8 * fem, 0, 8 * fem, 16 * fem),
              width: 358 * fem,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(16 * fem),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(16 * fem, 30 * fem, 0, 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Phí gửi xe',
                          style: TextStyle(
                            fontSize: 15 * ffem,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff5b5b5b),
                          ),
                        ),
                        Spacer(),
                        Text(
                          '6.000đ',
                          style: TextStyle(
                            fontSize: 15 * ffem,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff000000),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(16 * fem, 25 * fem, 0, 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Trạng thái',
                          style: TextStyle(
                            fontSize: 15 * ffem,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff5b5b5b),
                          ),
                        ),
                        Spacer(),
                        Container(
                          width:  60* fem,
                          height: 20 * fem,
                          decoration: BoxDecoration(
                            color: Color(0xfff5e4e4),
                            borderRadius: BorderRadius.circular(100 * fem),
                          ),
                          child: Center(
                            child: Text(
                              'Trong bãi',
                              style: TextStyle(
                                fontSize: 14 * ffem,
                                fontWeight: FontWeight.w600,
                                color: Color(0xffcc5252),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Divider(
                      thickness: 1,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(16 * fem, 25 * fem, 0, 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Khách hàng',
                          style: TextStyle(
                            fontSize: 15 * ffem,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff5b5b5b),
                          ),
                        ),
                        Spacer(),
                        Text(
                          'Mai Hoàng Tâm',
                          style: TextStyle(
                            fontSize: 18 * ffem,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(16 * fem, 21 * fem, 0, 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Số điện thoại',
                          style: TextStyle(
                            fontSize: 13 * ffem,
                            fontWeight: FontWeight.w400,
                            height: 1.175 * ffem / fem,
                            color: Color(0xff5b5b5b),
                          ),
                        ),
                        Spacer(),
                        Text(
                          '0946219139',
                          style: TextStyle(
                            fontSize: 16 * ffem,
                            fontWeight: FontWeight.w600,
                            height: 1.2175 * ffem / fem,
                            color: Color(0xff000000),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Divider(
                      thickness: 1,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(16 * fem, 15 * fem, 0, 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Phương tiện',
                          style: TextStyle(
                            fontSize: 15 * ffem,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff5b5b5b),
                          ),
                        ),
                        Spacer(),
                        Text(
                          '45A-12345',
                          style: TextStyle(
                            fontSize: 15 * ffem,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff000000),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Divider(
                      thickness: 1,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(16 * fem, 21 * fem, 0, 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Vào bãi',
                          style: TextStyle(
                            fontSize: 15 * ffem,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff5b5b5b),
                          ),
                        ),
                        Spacer(),
                        Text(
                          '16/09/2023',
                          style: TextStyle(
                            fontSize: 15 * ffem,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff000000),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(16 * fem, 10 * fem, 0, 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Rời chỗ',
                          style: TextStyle(
                            fontSize: 15 * ffem,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff5b5b5b),
                          ),
                        ),
                        Spacer(),
                        Text(
                          '16/10/2023',
                          style: TextStyle(
                            fontSize: 15 * ffem,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff000000),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
