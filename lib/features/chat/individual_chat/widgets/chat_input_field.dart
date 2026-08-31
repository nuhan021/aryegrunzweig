import 'package:aryegrunzweig/core/common/styles/global_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatInputField extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onSend;
  final VoidCallback? onAttachmentTap;
  final bool isSending;

  const ChatInputField({
    super.key,
    required this.controller,
    required this.onSend,
    this.onAttachmentTap,
    this.isSending = false,
  });

  @override
  State<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x3F000000),
            blurRadius: 4,
            offset: Offset(0, 0),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        children: [
          // Attachment button
          GestureDetector(
            onTap: widget.isSending ? null : widget.onAttachmentTap,
            child: Container(
              decoration: ShapeDecoration(
                color: const Color(0xFFF3F4F6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100.r),
                ),
              ),
              child: Icon(
                Icons.attach_file,
                size: 20.sp,
                color: const Color(0xFF697282),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          // Text input field
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: ShapeDecoration(
                color: const Color(0xFFF3F4F6),
                shape: RoundedRectangleBorder(
                  side: const BorderSide(width: 1, color: Color(0xFFE5E7EB)),
                  borderRadius: BorderRadius.circular(16.r),
                ),
              ),
              child: TextField(
                enabled: !widget.isSending,
                controller: widget.controller,
                focusNode: _focusNode,
                maxLines: null,
                minLines: 1,
                style: getTextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF101727),
                ),
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  hintStyle: getTextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF697282),
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          // Send button
          GestureDetector(
            onTap: widget.isSending
                ? null
                : () {
                    widget.onSend(widget.controller.text);
                  },
            child: Container(
              width: 44.w,
              height: 44.w,
              decoration: ShapeDecoration(
                color: const Color(0xFFE5E7EB),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100.r),
                ),
              ),
              child: widget.isSending
                  ? Padding(
                      padding: EdgeInsets.all(12.w),
                      child: const CircularProgressIndicator(strokeWidth: 2.2),
                    )
                  : Icon(
                      Icons.send,
                      size: 20.sp,
                      color: const Color(0xFF697282),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
