import 'dart:async';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

// --- КОНСТАНТЫ AGORA ---
// appId остается константой, так как он уникален для вашего приложения.
const String appId = "2ef6fb981a01460d916cb37c51a9306a";

// --- СТРАНИЦА ВИДЕОЗВОНКА (AGORA) ---

class VideoCallPage extends StatefulWidget {
  final String channelName; // Имя канала, уникальное для чата
  final String token;       // Токен доступа для этого канала

  const VideoCallPage({
    Key? key,
    required this.channelName,
    required this.token,
  }) : super(key: key);

  @override
  State<VideoCallPage> createState() => _VideoCallPageState();
}

class _VideoCallPageState extends State<VideoCallPage> {
  late RtcEngine _engine;
  int? _remoteUid;
  bool _localUserJoined = false;
  bool _isInitializing = true; // Флаг для отслеживания инициализации
  bool _muted = false;
  bool _videoDisabled = false;

  @override
  void initState() {
    super.initState();
    _initializeAgoraSdk();
  }

  @override
  void dispose() {
    _disposeAgoraSdk();
    super.dispose();
  }

  // 1. ИНИЦИАЛИЗАЦИЯ И ПОДКЛЮЧЕНИЕ
  Future<void> _initializeAgoraSdk() async {
    // Запрашиваем разрешения на микрофон и камеру
    await [Permission.microphone, Permission.camera].request();

    // Создаем и инициализируем движок Agora
    _engine = createAgoraRtcEngine();
    await _engine.initialize(const RtcEngineContext(
      appId: appId,
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ));

    // Устанавливаем обработчики событий
    _setupEventHandlers();

    // Включаем видео и предпросмотр
    await _engine.enableVideo();
    await _engine.startPreview();

    // Присоединяемся к каналу, используя переданные channelName и token
    await _joinChannel();

    if (mounted) {
      setState(() {
        _isInitializing = false;
      });
    }
  }

  // 2. УСТАНОВКА ОБРАБОТЧИКОВ СОБЫТИЙ
  void _setupEventHandlers() {
    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          debugPrint("✅ Локальный пользователь ${connection.localUid} присоединился к каналу ${connection.channelId}");
          if (mounted) setState(() => _localUserJoined = true);
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          debugPrint("👤 Удаленный пользователь $remoteUid присоединился");
          if (mounted) setState(() => _remoteUid = remoteUid);
        },
        onUserOffline: (RtcConnection connection, int remoteUid, UserOfflineReasonType reason) {
          debugPrint("❌ Удаленный пользователь $remoteUid покинул канал");
          if (mounted) setState(() => _remoteUid = null);
        },
        onError: (ErrorCodeType code, String message) {
          debugPrint("❗️ Ошибка Agora: $code, Сообщение: $message");
        },
      ),
    );
  }

  // 3. ПРИСОЕДИНЕНИЕ К КАНАЛУ
  Future<void> _joinChannel() async {
    // Устанавливаем роль клиента на вещателя для отправки видео/аудио
    await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);

    await _engine.joinChannel(
      token: widget.token,
      channelId: widget.channelName,
      options: const ChannelMediaOptions(),
      uid: 0, // uid = 0, Agora назначает UID автоматически
    );
  }

  // 4. ОЧИСТКА РЕСУРСОВ
  Future<void> _disposeAgoraSdk() async {
    if (_engine != null) {
      await _engine.leaveChannel();
      await _engine.release();
    }
  }

  // --- ЛОГИКА КНОПОК УПРАВЛЕНИЯ ---

  void _onCallEnd() {
    Navigator.of(context).pop();
  }

  void _onToggleMute() {
    setState(() {
      _muted = !_muted;
    });
    _engine.muteLocalAudioStream(_muted);
  }

  void _onToggleVideo() {
    setState(() {
      _videoDisabled = !_videoDisabled;
    });
    _engine.muteLocalVideoStream(_videoDisabled);
    _engine.enableLocalVideo(!_videoDisabled);
  }

  void _onSwitchCamera() {
    _engine.switchCamera();
  }

  // --- СБОРКА ИНТЕРФЕЙСА (UI) ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Stack(
          children: <Widget>[
            _buildVideoViews(),
            _buildToolbar(),
          ],
        ),
      ),
    );
  }

  // ОСНОВНОЕ ОКНО С ВИДЕО
  Widget _buildVideoViews() {
    if (_isInitializing || !_localUserJoined) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.white),
            SizedBox(height: 20),
            Text("Подключение...", style: TextStyle(color: Colors.white)),
          ],
        ),
      );
    }

    if (_remoteUid != null) {
      // Оба пользователя в чате
      return Stack(
        children: [
          // Видео удаленного пользователя на весь экран
          AgoraVideoView(
            controller: VideoViewController.remote(
              rtcEngine: _engine,
              canvas: VideoCanvas(uid: _remoteUid!),
              connection: RtcConnection(channelId: widget.channelName),
            ),
          ),
          // Локальное видео в углу
          Positioned(
            left: 16,
            top: 40,
            child: SizedBox(
              width: 120,
              height: 180,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: _videoDisabled
                    ? Container(color: Colors.black54, child: Icon(Icons.videocam_off, color: Colors.white, size: 40))
                    : AgoraVideoView(
                  controller: VideoViewController(
                    rtcEngine: _engine,
                    canvas: const VideoCanvas(uid: 0),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      // Только локальный пользователь, ждем собеседника
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 200,
            height: 200,
            child: Icon(Icons.person_search, color: Colors.white70, size: 100),
          ),
          Text(
            "Ожидание собеседника...",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          SizedBox(height: 150), // Отступ для панели управления
        ],
      );
    }
  }

  // ПАНЕЛЬ ИНСТРУМЕНТОВ
  Widget _buildToolbar() {
    if (_isInitializing) return const SizedBox.shrink(); // Не показывать панель при инициализации

    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _buildToolbarButton(_onToggleMute, _muted ? Icons.mic_off : Icons.mic, _muted),
          const SizedBox(width: 20),
          // Кнопка ЗАВЕРШИТЬ ВЫЗОВ (особый стиль)
          RawMaterialButton(
            onPressed: _onCallEnd,
            shape: const CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.redAccent,
            padding: const EdgeInsets.all(15.0),
            child: const Icon(Icons.call_end, color: Colors.white, size: 35.0),
          ),
          const SizedBox(width: 20),
          _buildToolbarButton(_onToggleVideo, _videoDisabled ? Icons.videocam_off : Icons.videocam, _videoDisabled),
          const SizedBox(width: 20),
          _buildToolbarButton(_onSwitchCamera, Icons.switch_camera, false),
        ],
      ),
    );
  }

  // Вспомогательный виджет для создания кнопок панели
  Widget _buildToolbarButton(VoidCallback onPressed, IconData icon, bool isActive) {
    return RawMaterialButton(
      onPressed: onPressed,
      shape: const CircleBorder(),
      elevation: 2.0,
      fillColor: isActive ? Colors.indigoAccent : Colors.white,
      padding: const EdgeInsets.all(12.0),
      child: Icon(
        icon,
        color: isActive ? Colors.white : Colors.indigoAccent,
        size: 20.0,
      ),
    );
  }
}
