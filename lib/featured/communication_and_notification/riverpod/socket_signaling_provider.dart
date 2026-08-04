import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    _socket.on('call:rejected', _handleCallRejected);
    _socket.on('call:ended', _handleCallEnded);
    _socket.on('call:cancelled', _handleCallCancelled);

    _isInitialized = true;
    AppLogger.success("SocketSignalingService initialized for $userId");
  }

  void _handleIncomingCall(dynamic raw) {
    try {
      // Data might be stringified JSON or a Map
      final Map<String, dynamic> payload = raw is String ? jsonDecode(raw) : Map<String, dynamic>.from(raw);
      
      final channelName = payload['channelName']?.toString() ?? '';
      final isVideoCall = (payload['isVideoCall'] as bool?) ?? true;
      final callerName = payload['callerName']?.toString() ?? 'Unknown Caller';
      final callerImage = payload['callerImage']?.toString();
      final callerId = payload['callerId']?.toString() ?? '';

      CallKitService.showIncomingCall(
        callId: channelName, // Using channelName as unique call ID
        callerId: callerId,
        callerName: callerName,
        callerImage: callerImage,
        channelId: channelName,
        isVideo: isVideoCall,
      );
    } catch (e, st) {
      AppLogger.error("Failed to parse call:incoming message: $e\n$st");
    }
  }

  void _handleCallRejected(dynamic raw) {
    CallKitService.endAllCalls();
  }

  void _handleCallEnded(dynamic raw) {
    CallKitService.endAllCalls();
  }

  void _handleCallCancelled(dynamic raw) {
    CallKitService.endAllCalls();
  }

  void initiateCall({
    required String targetUserId,
    required bool isVideoCall,
    required String callerName,
    required String? callerImage,
  }) {
    if (_currentUserId == null) return;

    final channelName = "${_currentUserId}_${DateTime.now().millisecondsSinceEpoch}";
    final payload = {
      'targetUserId': targetUserId,
      'callerId': _currentUserId,
      'channelName': channelName,
      'isVideoCall': isVideoCall,
      'callerName': callerName,
      'callerImage': callerImage,
    };

    _socket.emit('call:incoming', data: payload);
    AppLogger.success("Call initiated to $targetUserId on channel $channelName");
  }

  void endCall(String targetUserId) {
    final payload = {'targetUserId': targetUserId};
    _socket.emit('call:ended', data: payload);
    CallKitService.endAllCalls();
  }

  void cancelCall(String targetUserId) {
    final payload = {'targetUserId': targetUserId};
    _socket.emit('call:cancelled', data: payload);
    CallKitService.endAllCalls();
  }

  void dispose() {
    _socket.off('call:incoming', _handleIncomingCall);
    _socket.off('call:rejected', _handleCallRejected);
    _socket.off('call:ended', _handleCallEnded);
    _socket.off('call:cancelled', _handleCallCancelled);
    _isInitialized = false;
    _currentUserId = null;
  }
}
