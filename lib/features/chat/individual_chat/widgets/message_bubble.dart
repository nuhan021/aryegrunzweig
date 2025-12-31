import 'dart:io';

import 'package:aryegrunzweig/core/common/styles/global_text_style.dart';
import 'package:aryegrunzweig/features/chat/individual_chat/models/chat_message_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MessageBubble extends StatelessWidget {
  final ChatMessage message;

  const MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    // Special layout for image messages
    if (message.type == MessageType.image && message.imagePath != null) {
      return _buildImageMessage(context);
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
      child: Column(
        crossAxisAlignment: message.isOwn
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(maxWidth: 280.w),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: ShapeDecoration(
              color: message.isOwn
                  ? const Color(0xFF1C4F50)
                  : const Color(0xFFF3F4F6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.r),
                  topRight: Radius.circular(16.r),
                  bottomLeft: Radius.circular(message.isOwn ? 16.r : 6.r),
                  bottomRight: Radius.circular(message.isOwn ? 6.r : 16.r),
                ),
              ),
            ),
            child: _buildMessageContent(message),
          ),
          SizedBox(height: 4.h),
          Text(
            message.getFormattedTime(),
            style: getTextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF697282),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageMessage(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
      child: Column(
        crossAxisAlignment: message.isOwn
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => _showFullImage(context),
            child: Container(
              constraints: BoxConstraints(maxWidth: 220.w),
              decoration: ShapeDecoration(
                color: message.isOwn
                    ? const Color(0xFF1C4F50)
                    : const Color(0xFFF3F4F6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16.r),
                    topRight: Radius.circular(16.r),
                    bottomLeft: Radius.circular(message.isOwn ? 16.r : 6.r),
                    bottomRight: Radius.circular(message.isOwn ? 6.r : 16.r),
                  ),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.r),
                  topRight: Radius.circular(16.r),
                  bottomLeft: Radius.circular(message.isOwn ? 16.r : 6.r),
                  bottomRight: Radius.circular(message.isOwn ? 6.r : 16.r),
                ),
                child: Image.file(
                  File(message.imagePath!),
                  width: 220.w,
                  height: 180.h,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 220.w,
                      height: 180.h,
                      color: Colors.grey[300],
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.broken_image,
                            size: 40.sp,
                            color: Colors.grey[600],
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'Image not available',
                            style: getTextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey[600]!,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            message.getFormattedTime(),
            style: getTextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF697282),
            ),
          ),
        ],
      ),
    );
  }

  void _showFullImage(BuildContext context) {
    if (message.imagePath == null) return;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.all(16.w),
        child: Stack(
          alignment: Alignment.center,
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(color: Colors.black.withValues(alpha: 0.9)),
            ),
            InteractiveViewer(
              panEnabled: true,
              minScale: 0.5,
              maxScale: 4.0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: Image.file(
                  File(message.imagePath!),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Positioned(
              top: 16.h,
              right: 16.w,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.close, color: Colors.white, size: 24.sp),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageContent(ChatMessage message) {
    switch (message.type) {
      case MessageType.text:
        return Text(
          message.content,
          style: getTextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
            color: message.isOwn ? Colors.white : const Color(0xFF101727),
            lineHeight: 1.5,
          ),
        );
      case MessageType.image:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.image,
              color: message.isOwn ? Colors.white : const Color(0xFF1C4F50),
              size: 20.sp,
            ),
            SizedBox(width: 8.w),
            Flexible(
              child: Text(
                message.content,
                style: getTextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: message.isOwn ? Colors.white : const Color(0xFF101727),
                  lineHeight: 1.5,
                ),
              ),
            ),
          ],
        );
      case MessageType.file:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.file_present,
              color: message.isOwn ? Colors.white : const Color(0xFF1C4F50),
              size: 20.sp,
            ),
            SizedBox(width: 8.w),
            Flexible(
              child: Text(
                message.content,
                style: getTextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: message.isOwn ? Colors.white : const Color(0xFF101727),
                  lineHeight: 1.5,
                ),
              ),
            ),
          ],
        );
    }
  }
}
