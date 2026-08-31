import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/services/storage_service.dart';
import '../../../../core/utils/helpers/app_helper.dart';
import '../data/chat_repository.dart';
import '../models/chat_message_model.dart';
import '../models/chat_user_model.dart';

class IndividualChatController extends GetxController {
  final ChatRepository _repository = Get.find<ChatRepository>();
  late ChatUser chatUser;
  late TextEditingController messageController;
  late ScrollController scrollController;

  final messages = <ChatMessage>[].obs;
  final isLoading = false.obs;
  final isSending = false.obs;
  final isTyping = false.obs;
  final errorMessage = ''.obs;
  final conversationId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    messageController = TextEditingController();
    scrollController = ScrollController();
    chatUser = ChatUser(
      id: '',
      name: 'Service conversation',
      company: 'Central Care',
      avatarInitials: 'CC',
    );
    final arguments = Get.arguments;
    if (arguments is ChatUser) {
      chatUser = arguments;
    } else if (arguments is Map) {
      final value = arguments['conversationId'];
      if (value is String) conversationId.value = value;
    }
    loadMessages();
  }

  Future<void> loadMessages() async {
    if (conversationId.value.isEmpty) {
      errorMessage.value = 'Conversation information is unavailable.';
      return;
    }
    if (isLoading.value) return;
    isLoading.value = true;
    errorMessage.value = '';
    final result = await _repository.messages(
      conversationId.value,
      currentUserId: StorageService.userId,
    );
    isLoading.value = false;
    if (!result.isSuccess || result.data == null) {
      errorMessage.value = result.errorMessage;
      return;
    }
    messages.assignAll(result.data!);
    _updatePeer();
    await _repository.markRead(conversationId.value);
    _scrollToBottom();
  }

  Future<void> sendMessage(
    String content, {
    MessageType type = MessageType.text,
    String? imagePath,
  }) async {
    if ((content.trim().isEmpty && imagePath == null) ||
        conversationId.value.isEmpty ||
        isSending.value) {
      return;
    }
    isSending.value = true;
    final result = await _repository.send(
      conversationId: conversationId.value,
      currentUserId: StorageService.userId,
      body: content,
      imagePath: imagePath,
    );
    isSending.value = false;
    if (!result.isSuccess || result.data == null) {
      AppHelperFunctions.showErrorSnackBar(result.errorMessage);
      return;
    }
    messages.add(result.data!);
    messageController.clear();
    _scrollToBottom();
  }

  void _updatePeer() {
    final peer = messages.firstWhereOrNull((message) => !message.isOwn);
    if (peer == null) return;
    final parts = peer.senderName.trim().split(RegExp(r'\s+'));
    chatUser = ChatUser(
      id: peer.senderId,
      name: peer.senderName,
      company: 'Service conversation',
      avatarInitials: parts
          .where((part) => part.isNotEmpty)
          .take(2)
          .map((part) => part[0].toUpperCase())
          .join(),
    );
    update();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!scrollController.hasClients) return;
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  void onClose() {
    messageController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}
