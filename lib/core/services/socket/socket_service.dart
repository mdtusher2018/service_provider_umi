import 'dart:async';
import 'dart:developer';
import 'package:socket_io_client/socket_io_client.dart' as IO;

/// Connection state of the socket
enum SocketConnectionState {
  disconnected,
  connecting,
  connected,
  reconnecting,
  error,
}

/// A robust, reusable Socket.IO service.
/// Independent of any feature — drop into any project.
///
/// Usage:
///   final socket = SocketService.instance;
///   socket.init(baseUrl: 'https://your-server.com', token: 'jwt_token');
///   socket.on('event_name', (data) => ...);
///   socket.emit('event_name', data);
class SocketService {
  SocketService._();
  static final SocketService instance = SocketService._();

  IO.Socket? _socket;

  // ─── State stream ───────────────────────────────────────────────────────────
  final _stateController = StreamController<SocketConnectionState>.broadcast();
  Stream<SocketConnectionState> get connectionStream => _stateController.stream;

  SocketConnectionState _state = SocketConnectionState.disconnected;
  SocketConnectionState get state => _state;
  bool get isConnected => _state == SocketConnectionState.connected;

  // ─── Listener registry ──────────────────────────────────────────────────────
  /// event → list of handlers registered via [on]
  final Map<String, List<Function(dynamic)>> _listeners = {};

  /// Pending emits queued while socket is reconnecting
  final List<_PendingEmit> _pendingQueue = [];

  // ─── Init / Connect ─────────────────────────────────────────────────────────
  /// Call once (or again after [dispose]) to initialise the socket.
  ///
  /// [autoReconnect]   – socket.io built-in reconnection
  /// [reconnectDelay]  – ms between reconnect attempts
  /// [maxReconnects]   – 0 = unlimited
  void init({
    required String baseUrl,
    required String token,
    bool autoReconnect = true,
    int reconnectDelay = 2000,
    int maxReconnects = 0,
    Map<String, dynamic>? extraHeaders,
    Map<String, dynamic>? extraAuth,
  }) {
    _socket?.dispose();

    _socket = IO.io(
      baseUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .enableReconnection()
          .setReconnectionDelay(reconnectDelay)
          .setAuth({'token': token, ...?extraAuth})
          .setExtraHeaders({'Authorization': 'Bearer $token', ...?extraHeaders})
          .build(),
    );

    _attachCoreListeners();
  }

  // ─── Core lifecycle listeners ────────────────────────────────────────────────
  void _attachCoreListeners() {
    final s = _socket!;

    s.onConnect((_) {
      _updateState(SocketConnectionState.connected);
      log('[SocketService] Connected — id: ${s.id}');
      _flushPendingQueue();
      _reRegisterListeners();
    });

    s.onDisconnect((reason) {
      _updateState(SocketConnectionState.disconnected);
      log('[SocketService] Disconnected — reason: $reason');
    });

    s.onReconnect((_) {
      _updateState(SocketConnectionState.connected);
      log('[SocketService] Reconnected');
      _flushPendingQueue();
    });

    s.onReconnectFailed((_) {
      _updateState(SocketConnectionState.error);
      log('[SocketService] Reconnection failed permanently');
    });

    s.onError((err) {
      _updateState(SocketConnectionState.error);
      log('[SocketService] Error: $err', error: err);
    });

    s.onConnectError((err) {
      _updateState(SocketConnectionState.error);
      log('[SocketService] Connect error: $err', error: err);
    });
  }

  // ─── Public API ──────────────────────────────────────────────────────────────

  /// Subscribe to a socket event.
  /// Safe to call before [init] — listeners are stored and applied on connect.
  void on(String event, Function(dynamic) handler) {
    _listeners.putIfAbsent(event, () => []).add(handler);
    _socket?.on(event, handler);
  }

  /// Subscribe to an event, receive exactly one emission, then auto-unsubscribe.
  void once(String event, Function(dynamic) handler) {
    _socket?.once(event, handler);
  }

  /// Remove a specific handler for an event.
  void off(String event, [Function(dynamic)? handler]) {
    if (handler != null) {
      _listeners[event]?.remove(handler);
      _socket?.off(event, handler);
    } else {
      _listeners.remove(event);
      _socket?.off(event);
    }
  }

  /// Emit an event.
  /// If not connected and [queueIfOffline] is true, the emit is queued
  /// and replayed once the socket reconnects.
  void emit(
    String event, {
    dynamic data,
    Function(dynamic)? ack,
    bool queueIfOffline = false,
  }) {
    if (!isConnected) {
      if (queueIfOffline) {
        _pendingQueue.add(_PendingEmit(event, data, ack));
        log('[SocketService] Queued emit "$event" (offline)');
      } else {
        log('[SocketService] Dropped emit "$event" — socket not connected');
      }
      return;
    }

    if (ack != null) {
      _socket?.emitWithAck(event, data, ack: ack);
    } else {
      _socket?.emit(event, data);
    }
    log('[SocketService] Emitted "$event"');
  }

  /// Update the auth token (e.g. after token refresh) and reconnect.
  void updateToken(String newToken) {
    _socket?.auth = {'token': newToken};
    reconnect();
  }

  /// Manually reconnect.
  void reconnect() {
    _socket?.connect();
  }

  /// Disconnect the socket without disposing the service.
  void disconnect() {
    _socket?.disconnect();
  }

  /// Fully tear down. Call [init] again to reuse.
  void dispose() {
    _socket?.dispose();
    _socket = null;
    _listeners.clear();
    _pendingQueue.clear();
    _updateState(SocketConnectionState.disconnected);
  }

  // ─── Helpers ─────────────────────────────────────────────────────────────────
  void _updateState(SocketConnectionState s) {
    if (_state == s) return;
    _state = s;
    _stateController.add(s);
  }

  /// Re-attach stored listeners after a reconnect (socket.io clears them).
  void _reRegisterListeners() {
    for (final entry in _listeners.entries) {
      for (final handler in entry.value) {
        _socket?.on(entry.key, handler);
      }
    }
  }

  void _flushPendingQueue() {
    if (_pendingQueue.isEmpty) return;
    log('[SocketService] Flushing ${_pendingQueue.length} queued emits');
    final copy = List<_PendingEmit>.from(_pendingQueue);
    _pendingQueue.clear();
    for (final p in copy) {
      emit(p.event, data: p.data, ack: p.ack);
    }
  }
}

class _PendingEmit {
  final String event;
  final dynamic data;
  final Function(dynamic)? ack;
  _PendingEmit(this.event, this.data, this.ack);
}
