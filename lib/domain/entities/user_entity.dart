import 'package:equatable/equatable.dart';

class UserEntity extends Equatable{

  final String? uid;
  final String? name;
  final String? email;
  final String? profileUrl;
  final String? status;
  final String? phone;
  final String? password;
  final bool? isOnline;

  const UserEntity({
    this.uid, 
    this.name, 
    this.email, 
    this.profileUrl, 
    this.status, 
    this.phone, 
    this.password, 
    this.isOnline}
    );
    
      @override
      // TODO: implement props
      List<Object?> get props => [
        uid, 
        name, 
        email, 
        profileUrl,
        status, 
        phone, 
        password, 
        isOnline
      ];
}