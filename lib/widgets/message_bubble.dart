import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/message_model.dart';
import '../services/supabase_service.dart';
import '../utils/constants.dart';

class MessageBubble extends StatelessWidget {
  final MessageModel message;
  final bool isMe;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isMe,
  });

  Color _parseColor(String colorString) {
    try {
      final hexColor = colorString.replaceAll('#', '');
      return Color(int.parse('FF$hexColor', radix: 16));
    } catch (e) {
      return AppColors.surface;
    }
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    if (difference.inDays > 0) {
      return DateFormat('MMM dd, hh:mm a').format(dateTime);
    } else {
      return DateFormat('hh:mm a').format(dateTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    final avatarColor = _parseColor(message.avatarColor ?? '#6B7280');
    final username = message.username ?? 'Unknown';
    final initial = username.isNotEmpty ? username[0].toUpperCase() : '?';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isMe) ...[
            Container(
              width: AppConstants.avatarSize,
              height: AppConstants.avatarSize,
              decoration: BoxDecoration(
                color: avatarColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: avatarColor.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  initial,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                if (!isMe)
                  Padding(
                    padding: const EdgeInsets.only(left: 12, bottom: 4),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          username,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _formatTime(message.createdAt),
                          style: const TextStyle(
                            color: AppColors.textHint,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                GestureDetector(
                  onLongPress: isMe
                      ? () {
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: AppColors.backgroundLight,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                            ),
                            builder: (context) => SafeArea(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListTile(
                                    leading: const Icon(Icons.delete, color: AppColors.error),
                                    title: const Text('Delete Message', style: TextStyle(color: AppColors.textPrimary)),
                                    onTap: () async {
                                      Navigator.pop(context);
                                      final confirm = await showDialog<bool>(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          backgroundColor: AppColors.backgroundLight,
                                          title: const Text('Delete Message', style: TextStyle(color: AppColors.textPrimary)),
                                          content: const Text('Are you sure?', style: TextStyle(color: AppColors.textSecondary)),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.pop(context, false),
                                              child: const Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () => Navigator.pop(context, true),
                                              style: TextButton.styleFrom(foregroundColor: AppColors.error),
                                              child: const Text('Delete'),
                                            ),
                                          ],
                                        ),
                                      );
                                      if (confirm == true) {
                                        try {
                                          await SupabaseService().deleteMessage(message.id);
                                          if (context.mounted) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(
                                                content: Text('Message deleted'),
                                                backgroundColor: AppColors.success,
                                                duration: Duration(seconds: 2),
                                              ),
                                            );
                                          }
                                        } catch (e) {
                                          if (context.mounted) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text('Failed to delete: $e'),
                                                backgroundColor: AppColors.error,
                                              ),
                                            );
                                          }
                                        }
                                      }
                                    },
                                  ),
                                  const SizedBox(height: 10),
                                ],
                              ),
                            ),
                          );
                        }
                      : null,
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.7,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      gradient: isMe
                          ? const LinearGradient(
                              colors: [AppColors.primary, AppColors.primaryDark],
                            )
                          : null,
                      color: isMe ? null : AppColors.surface.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(AppConstants.messageBubbleRadius),
                        topRight: const Radius.circular(AppConstants.messageBubbleRadius),
                        bottomLeft: Radius.circular(isMe ? AppConstants.messageBubbleRadius : 4),
                        bottomRight: Radius.circular(isMe ? 4 : AppConstants.messageBubbleRadius),
                      ),
                      border: isMe ? null : Border.all(color: AppColors.border.withValues(alpha: 0.3)),
                      boxShadow: [
                        BoxShadow(
                          color: isMe
                              ? AppColors.primary.withValues(alpha: 0.2)
                              : Colors.black.withValues(alpha: 0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      message.content,
                      style: TextStyle(
                        color: isMe ? Colors.white : AppColors.textPrimary,
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                  ),
                ),
                if (isMe)
                  Padding(
                    padding: const EdgeInsets.only(top: 4, right: 12),
                    child: Text(
                      _formatTime(message.createdAt),
                      style: const TextStyle(
                        color: AppColors.textHint,
                        fontSize: 11,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}