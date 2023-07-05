import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:come_along_with_me/domain/entities/user_entity.dart';

class UserModel extends UserEntity{


UserModel (
{
  required final String uid,
  final String? name,
  final String? email,
  final String? profileUrl,
  final String? status,
  final String? phone,
  final String? password,
  final bool? isOnline,}
):super(
  uid: uid,
  name: name,
  email: email,
  profileUrl: profileUrl,
  status: status,
  phone: phone,
  password: password,
  isOnline: isOnline,
);

factory UserModel.fromSnapshot(DocumentSnapshot snapshot){
  return UserModel(
    uid: snapshot.get("uid"),
    name: snapshot.get("name"),
    email: snapshot.get("email"),
    profileUrl: snapshot.get("profileUrl"),
    status: snapshot.get("status"),
    phone: snapshot.get("phone"),
    password: snapshot.get("password"),
    isOnline: snapshot.get("isOnline"),
  );
}

Map<String, dynamic> toDocument(){
  return {
    "uid": uid,
    "name": name,
    "email": email,
    "profileUrl": profileUrl,
    "status": status,
    "phone": phone,
    "password": password,
    "isOnline": isOnline,
  };
}

}