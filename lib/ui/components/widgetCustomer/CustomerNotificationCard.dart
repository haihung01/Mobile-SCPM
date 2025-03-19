import 'package:fe_capstone/main.dart';
import 'package:fe_capstone/models/CustomerNotification.dart';
import 'package:flutter/material.dart';

class CustomerNotificationCard extends StatelessWidget {
  final CustomerNotification notification;
  const CustomerNotificationCard({Key? key, required this.notification})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        padding: EdgeInsets.only(top: 5 * fem, bottom: 5 * fem),
        child: ListTile(
          title: Row(
            children: [
              Container(
                width: 100 * fem,
                height: 60 * fem,
                child: Image.network(
                  notification.image,
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8 * fem),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Từ: ${notification.fromBy}',
                        style: TextStyle(
                            fontSize: 16 * fem, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        notification.content,
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 15 * fem,
                            color: Colors.grey),
                      ),
                      Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            notification.date,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15 * fem,
                                color: Colors.grey),
                          )),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
