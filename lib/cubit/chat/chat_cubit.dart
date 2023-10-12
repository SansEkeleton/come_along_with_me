import 'dart:io';

import 'package:come_along_with_me/domain/entities/text_message_entity.dart';
import 'package:come_along_with_me/domain/usercases/get_messages_usecase.dart';
import 'package:come_along_with_me/domain/usercases/send_text_message_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final SendTextMessageUseCase sendTextMessageUseCase;
  final GetMessageUseCase getMessageUseCase;
  ChatCubit({required this.getMessageUseCase,required this.sendTextMessageUseCase}) : super(ChatInitial());

  Future<void> getMessages({required String channelId})async{
    emit(ChatLoading());
    final streamResponse= getMessageUseCase.call(channelId);
    streamResponse.listen((messages) {
      emit(ChatLoaded(messages: messages));
    });
  }

  Future<void> sendTextMessage({required TextMessageEntity textMessageEntity,required String channelId})async{
    try{
      await sendTextMessageUseCase.call(textMessageEntity, channelId);
    }on SocketException catch(_){
      emit(ChatFailure());
    }catch(_){
      emit(ChatFailure());
    }
  }


}
