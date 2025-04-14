// lib/models/chat_message.dart
import 'enums.dart';
import 'consultationModal.dart';

class ChatMessage {
  final int? id;
  final int? consultationId;
  final String? content;
  final MessageSenderType? senderType;
  final DateTime? timestamp;
  final Consultation? consultation;

  ChatMessage({
    this.id,
    this.consultationId,
    this.content,
    this.senderType,
    this.timestamp,
    this.consultation,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] as int?,
      consultationId: json['consultation_id'] as int?,
      content: json['content'] as String?,
      senderType: json['sender_type'] != null
          ? messageSenderTypeFromString(json['sender_type'])
          : null,
      timestamp: json['timestamp'] != null
          ? DateTime.tryParse(json['timestamp'])
          : null,
      consultation: json['consultation'] != null
          ? Consultation.fromJson(json['consultation'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'consultation_id': consultationId,
      'content': content,
      'sender_type':
      senderType != null ? messageSenderTypeToString(senderType!) : null,
      'timestamp': timestamp?.toIso8601String(),
      'consultation': consultation?.toJson(),
    };
  }
}
