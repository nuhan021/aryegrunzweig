import 'package:aryegrunzweig/features/chat/individual_chat/models/chat_message_model.dart';
import 'package:aryegrunzweig/features/chat/individual_chat/models/chat_user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class IndividualChatController extends GetxController {
  late ChatUser chatUser;
  late TextEditingController messageController;
  late ScrollController scrollController;

  final messages = <ChatMessage>[].obs;
  final isTyping = false.obs;

  @override
  void onInit() {
    super.onInit();

    messageController = TextEditingController();
    scrollController = ScrollController();

    // Get the chat user from previous screen arguments
    if (Get.arguments != null) {
      chatUser = Get.arguments as ChatUser;
    } else {
      // Fallback to mock data if no arguments provided
      chatUser = ChatUser(
        id: '1',
        name: 'John Doe',
        company: 'Elite Central Vacuum',
        avatarInitials: 'JD',
      );
    }

    _loadMockMessages();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _loadMockMessages() {
    final now = DateTime.now();
    messages.assignAll([
      ChatMessage(
        id: '1',
        senderId: chatUser.id,
        senderName: chatUser.name,
        content:
            "Hi! I'm on my way to your location. Should arrive in about 15 minutes.",
        timestamp: now.subtract(const Duration(minutes: 5)),
        isOwn: false,
      ),
      ChatMessage(
        id: '2',
        senderId: 'current_user',
        senderName: 'You',
        content: 'Great! Thank you for letting me know.',
        timestamp: now.subtract(const Duration(minutes: 4)),
        isOwn: true,
      ),
      ChatMessage(
        id: '3',
        senderId: chatUser.id,
        senderName: chatUser.name,
        content:
            "I've reviewed the issue you described. I have all the necessary parts with me.",
        timestamp: now.subtract(const Duration(minutes: 3)),
        isOwn: false,
      ),
    ]);
  }

  void sendMessage(
    String content, {
    MessageType type = MessageType.text,
    String? imagePath,
  }) {
    if (content.trim().isEmpty && imagePath == null) return;

    final newMessage = ChatMessage(
      id: const Uuid().v4(),
      senderId: 'current_user',
      senderName: 'You',
      content: content.trim(),
      timestamp: DateTime.now(),
      isOwn: true,
      type: type,
      imagePath: imagePath,
    );

    messages.add(newMessage);
    messageController.clear();
    _scrollToBottom();

    // Simulate receiving a response after a delay
    Future.delayed(const Duration(milliseconds: 500), () {
      isTyping.value = true;
    });

    Future.delayed(const Duration(seconds: 2), () {
      isTyping.value = false;
      _addMockResponse();
    });
  }

  void _addMockResponse() {
    final mockResponses = [
      "That sounds great!",
      "I'll be there shortly.",
      "No problem at all.",
      "Let me check that for you.",
      "Perfect, I'm on my way.",
      "Thanks for the update!",
    ];

    final randomResponse =
        mockResponses[DateTime.now().microsecond % mockResponses.length];

    final response = ChatMessage(
      id: const Uuid().v4(),
      senderId: chatUser.id,
      senderName: chatUser.name,
      content: randomResponse,
      timestamp: DateTime.now(),
      isOwn: false,
    );

    messages.add(response);
    _scrollToBottom();
  }

  void setTyping(bool typing) {
    isTyping.value = typing;
  }

  @override
  void onClose() {
    messageController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}
