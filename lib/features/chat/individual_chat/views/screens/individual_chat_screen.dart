import 'package:aryegrunzweig/core/common/styles/global_text_style.dart';
import 'package:aryegrunzweig/core/common/widgets/custom_app_bar.dart';
import 'package:aryegrunzweig/core/utils/helpers/app_helper.dart';
import 'package:aryegrunzweig/features/chat/individual_chat/controllers/individual_chat_controller.dart';
import 'package:aryegrunzweig/features/chat/individual_chat/models/chat_message_model.dart';
import 'package:aryegrunzweig/features/chat/individual_chat/widgets/chat_input_field.dart';
import 'package:aryegrunzweig/features/chat/individual_chat/widgets/message_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class IndividualChatScreen extends StatelessWidget {
  const IndividualChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(IndividualChatController());

    return GetBuilder<IndividualChatController>(
      init: controller,
      builder: (ctrl) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            // top: false,
            // bottom: false,
            child: Column(
              children: [
                // Header
                CustomAppBar(
                  title: ctrl.chatUser.name,
                  subtitle: ctrl.chatUser.company,
                ),

                // Messages list
                Expanded(
                  child: Obx(() {
                    if (ctrl.isLoading.value && ctrl.messages.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (ctrl.errorMessage.value.isNotEmpty &&
                        ctrl.messages.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 24.w),
                              child: Text(
                                ctrl.errorMessage.value,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            TextButton(
                              onPressed: ctrl.loadMessages,
                              child: const Text('Try again'),
                            ),
                          ],
                        ),
                      );
                    }
                    if (ctrl.messages.isEmpty) {
                      return Center(
                        child: Text(
                          'No messages yet',
                          style: getTextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF697282),
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                      controller: ctrl.scrollController,
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      itemCount:
                          ctrl.messages.length + (ctrl.isTyping.value ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == ctrl.messages.length &&
                            ctrl.isTyping.value) {
                          return Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 24.w,
                              vertical: 8.h,
                            ),
                            child: Row(children: [_buildTypingIndicator()]),
                          );
                        }

                        final message = ctrl.messages[index];
                        return MessageBubble(message: message);
                      },
                    );
                  }),
                ),

                // Input field
                Obx(
                  () => ChatInputField(
                    controller: ctrl.messageController,
                    isSending: ctrl.isSending.value,
                    onSend: ctrl.sendMessage,
                    onAttachmentTap: () {
                      _showAttachmentOptions(context, ctrl);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Widget _buildTypingIndicator() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: ShapeDecoration(
        color: const Color(0xFFF3F4F6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.r),
            topRight: Radius.circular(16.r),
            bottomLeft: Radius.circular(6.r),
            bottomRight: Radius.circular(16.r),
          ),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          3,
          (index) => Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            child: AnimatedOpacity(
              opacity: (index % 2 == 0) ? 1.0 : 0.5,
              duration: Duration(milliseconds: 500 + (index * 100)),
              child: Container(
                width: 6.w,
                height: 6.w,
                decoration: const BoxDecoration(
                  color: Color(0xFF697282),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showAttachmentOptions(
    BuildContext context,
    IndividualChatController controller,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Share',
              style: getTextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF101727),
              ),
            ),
            SizedBox(height: 24.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildAttachmentOption(
                  icon: Icons.camera_alt,
                  label: 'Camera',
                  onTap: () async {
                    Navigator.pop(context);
                    await _pickImage(ImageSource.camera, controller);
                  },
                ),
                _buildAttachmentOption(
                  icon: Icons.image,
                  label: 'Gallery',
                  onTap: () async {
                    Navigator.pop(context);
                    await _pickImage(ImageSource.gallery, controller);
                  },
                ),
                _buildAttachmentOption(
                  icon: Icons.file_present,
                  label: 'Files',
                  onTap: () {
                    Navigator.pop(context);
                    _showFilePickerMessage(context);
                  },
                ),
              ],
            ),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachmentOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 60.w,
            height: 60.w,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Icon(icon, size: 28.sp, color: const Color(0xFF1C4F50)),
          ),
          SizedBox(height: 8.h),
          Text(
            label,
            style: getTextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF495565),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage(
    ImageSource source,
    IndividualChatController controller,
  ) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: source,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        // Send image message with the file path
        controller.sendMessage(
          'Image',
          type: MessageType.image,
          imagePath: pickedFile.path,
        );
      }
    } catch (e) {
      AppHelperFunctions.showErrorSnackBar('Error: ${e.toString()}');
    }
  }

  void _showFilePickerMessage(BuildContext context) {
    AppHelperFunctions.showSnackBar('File picker functionality coming soon');
  }
}
