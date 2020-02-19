import 'dart:html';
import 'dart:io';
import 'dart:async';
import 'dart:ui';
import 'package:grpc/grpc_web.dart';

import 'package:maintemplate/features/grpc_web_example/blocs/message_events.dart';
import 'package:maintemplate/features/grpc_web_example/models/message_outgoing.dart';
import 'package:flutter/foundation.dart';


import 'package:maintemplate/features/grpc_web_example/api/v1/chat.pbgrpc.dart' as grpc;
import 'package:maintemplate/features/grpc_web_example/api/v1/google/protobuf/empty.pb.dart';
import 'package:maintemplate/features/grpc_web_example/api/v1/google/protobuf/wrappers.pb.dart';


/// ChatService client implementation
class ChatService {
  // _isolateSending is isolate to send chat messages
  // Isolate _isolateSending;

  // // Port to send message
  // SendPort _portSending;

  // // Port to get status of message sending
  // ReceivePort _portSendStatus;

  // // _isolateReceiving is isolate to receive chat messages
  // Isolate _isolateReceiving;

  // // Port to receive messages
  // ReceivePort _portReceiving;

  /// Event is raised when message has been sent to the server successfully
  final void Function(MessageSentEvent event) onMessageSent;

  /// Event is raised when message sending is failed
  final void Function(MessageSendFailedEvent event) onMessageSendFailed;

  /// Event is raised when message has been received from the server
  final void Function(MessageReceivedEvent event) onMessageReceived;

  /// Event is raised when message receiving is failed
  final void Function(MessageReceiveFailedEvent event) onMessageReceiveFailed;

  final channel = GrpcWebClientChannel.xhr(Uri.parse("http://localhost:8074"));

  /// Constructor
  ChatService(
      {this.onMessageSent,
      this.onMessageSendFailed,
      this.onMessageReceived,
      this.onMessageReceiveFailed});
      // : _portSendStatus = ReceivePort(),
      //   _portReceiving = ReceivePort();

  // Start threads to send and receive messages

  void start() {
    recv();
  }

  void recv() async {
    do {
      try {
        // create new client
        var stream = grpc.ChatServiceClient(channel).subscribe(Empty.create());
      
        await for (var message in stream) {
          onMessageReceived(MessageReceivedEvent(text: message.text));
        }
      } catch (e) {
        onMessageReceiveFailed(MessageReceiveFailedEvent(error: e.toString()));
      }
      // try to connect again
      await Future.delayed(const Duration(seconds: 5));
    } while (true);
  }

  void shutdown() {
  }

  /// Send message to the server
  void send(MessageOutgoing message) {
    var request = StringValue.create();
    request.value = message.text;
    grpc.ChatServiceClient(channel).send(request);
    onMessageSent(MessageSentEvent(id: message.id));
  }
}
