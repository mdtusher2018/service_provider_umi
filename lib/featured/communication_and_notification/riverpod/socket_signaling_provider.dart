import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:service_provider_umi/core/logger/app_logger.dart';
import 'package:service_provider_umi/core/services/call_kit_service.dart';
import 'package:service_provider_umi/core/services/socket/socket_service.dart';

final socketSignalingProvider = Provider<SocketSignalingService>((ref) {
  return SocketSignalingService();
});

class SocketSignalingService {
  final _socket = SocketService.instance;
  String? _currentUserId;
  bool _isInitialized = false;

  void init(String userId) {
    if (_isInitialized && _currentUserId == userId) return;

    _currentUserId = userId;
    
    // Register listeners on the shared socket service
    _socket.on('call:incoming', _handleIncomingCall);
    _socket.on('call:accepted', _handleCallAccepted);
    _socket.on('call:rejected', _handleCallRejected);
    _socket.on('call:ended', _handleCallEnded);
    _socket.on('call:cancelled', _handleCallCancelled);

    _isInitialized = true;
    AppLogger.success("SocketSignalingService initialized for $userId");
  }

  Map<String, dynamic> _parsePayload(dynamic raw) {
    dynamic data = raw;
    if (raw is List && raw.isNotEmpty) data = raw.first;
    return data is String ? jsonDecode(data) : Map<String, dynamic>.from(data);
  }

  void _handleIncomingCall(dynamic raw) {
    try {
      final payload = _parsePayload(raw);
      
      final channelName = payload['channelName']?.toString() ?? '';
      
      // Determine if it's a video call based on type or isVideoCall boolean
      bool isVideoCall = false;
      if (payload.containsKey('type')) {
        isVideoCall = payload['type'] == 'video_call';
      } else if (payload.containsKey('isVideoCall')) {
        isVideoCall = payload['isVideoCall'] as bool;
      }

      String callerName = payload['callerName']?.toString() ?? 'Unknown Caller';
      String? callerImage = payload['callerImage']?.toString();

      if (payload['sender'] != null && payload['sender'] is Map) {
        final senderMap = payload['sender'] as Map;
        callerName = senderMap['name']?.toString() ?? callerName;
        callerImage = senderMap['profile']?.toString() ?? callerImage;
      }
      
      final status = payload['status']?.toString();
      // If status indicates call is no longer ringing, dismiss everything
      if (status == 'cancelled' || status == 'completed' || status == 'rejected') {
        _handleCallCancelled(raw);
        return;
      }
      
      // Only show incoming call when status is ringing (or no status)
      if (status != null && status != 'ringing') {
        return;
      }

      // Support both backend (senderId) and frontend (callerId) payload keys
      final callerId = payload['senderId']?.toString() ?? payload['callerId']?.toString() ?? '';
      final receiverId = payload['receiverId']?.toString() ?? payload['targetUserId']?.toString() ?? '';
      final historyId = payload['id']?.toString() ?? payload['_id']?.toString() ?? '';

      // Ignore if we are the caller (we shouldn't ring ourselves)
      if (callerId == _currentUserId) {
        return;
      }
      
      // Only process if we are the intended receiver
      if (receiverId.isNotEmpty && receiverId != _currentUserId) {
        return;
      }

      CallKitService.showIncomingCall(
        callId: channelName, // Using channelName as unique call ID for CallKit
        callerId: callerId,
        callerName: callerName,
        callerImage: callerImage,
        channelId: channelName,
        historyId: historyId,
        isVideo: isVideoCall,
      );
    } catch (e, st) {
      AppLogger.error("Failed to parse call:incoming message: $e\n$st");
    }
  }

  /// When the receiver accepts, the caller gets this event.
  /// Stop ringing on caller side — Agora's onUserJoined handles the rest.
  void _handleCallAccepted(dynamic raw) {
    AppLogger.success("Call accepted by remote user");
    FlutterRingtonePlayer.stop();
  }

  void _handleCallRejected(dynamic raw) {
    AppLogger.warning("Call rejected by remote user");
    FlutterRingtonePlayer.stop();
    CallKitService.endAllCalls();
    CallKitListenerService.popCallScreen();
  }

  void _handleCallEnded(dynamic raw) {
    AppLogger.warning("Call ended by remote user");
    FlutterRingtonePlayer.stop();
    CallKitService.endAllCalls();
    CallKitListenerService.popCallScreen();
  }

  void _handleCallCancelled(dynamic raw) {
    AppLogger.warning("Call cancelled by remote user");
    FlutterRingtonePlayer.stop();
    CallKitService.endAllCalls();
    CallKitListenerService.popCallScreen();
  }

  void dispose() {
    _socket.off('call:incoming', _handleIncomingCall);
    _socket.off('call:accepted', _handleCallAccepted);
    _socket.off('call:rejected', _handleCallRejected);
    _socket.off('call:ended', _handleCallEnded);
    _socket.off('call:cancelled', _handleCallCancelled);
    _isInitialized = false;
    _currentUserId = null;
  }
}
