import 'package:come_along_with_me/domain/entities/user_entity.dart';
import 'package:flutter/material.dart';

class SingleItemUserWidget extends StatelessWidget {
  final VoidCallback onTap;
  final UserEntity user;

  const SingleItemUserWidget({
    Key? key,
    required this.onTap,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  height: 55,
                  width: 55,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    
                  ),
                ),
                SizedBox(width: 10,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10,),
                      Text(
                        "${user.name}",
                        style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "${user.status}",
                        style: TextStyle(fontSize: 14, color: Colors.black.withOpacity(.7), fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 10,),
                      Container(
                        margin: EdgeInsets.only(right: 10),
                        child: Divider(thickness: 1.50, color: Colors.black.withOpacity(.3)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
