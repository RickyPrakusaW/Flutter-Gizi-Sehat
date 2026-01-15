import 'package:flutter/material.dart';
import 'package:gizi_sehat_mobile_app/core/constants/app_colors.dart';
import 'package:gizi_sehat_mobile_app/core/services/gemini_service.dart';
import 'package:intl/intl.dart';

/// Model untuk pesan chat
class ChatMessage {
  final String id;
  final String content;
  final bool isFromUser;
  final DateTime timestamp;

  ChatMessage({
    required this.id,
    required this.content,
    required this.isFromUser,
    required this.timestamp,
  });
}

/// Model untuk quick question button
class QuickQuestion {
  final String id;
  final String text;
  final IconData icon;

  const QuickQuestion({
    required this.id,
    required this.text,
    required this.icon,
  });
}

/// Screen chatbot asisten gizi AI
/// Menampilkan interface chat interaktif dengan quick questions dan input pesan
class AssistantPage extends StatefulWidget {
  const AssistantPage({super.key});

  @override
  State<AssistantPage> createState() => _AssistantPageState();
}

class _AssistantPageState extends State<AssistantPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  final GeminiService _geminiService = GeminiService();
  bool _isLoading = false;

  /// List pertanyaan cepat yang tersedia
  final List<QuickQuestion> _quickQuestions = const [
    QuickQuestion(
      id: 'mpasi',
      text: 'MPASI 9-11 bulan',
      icon: Icons.child_care,
    ),
    QuickQuestion(
      id: 'protein',
      text: 'Cek asupan protein',
      icon: Icons.restaurant_menu,
    ),
    QuickQuestion(
      id: 'picky',
      text: 'Anak susah makan sayur',
      icon: Icons.warning_amber_rounded,
    ),
    QuickQuestion(
      id: 'budget',
      text: 'Menu sehat murah',
      icon: Icons.message,
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Tambahkan welcome message saat pertama kali dibuka
    _addWelcomeMessage();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  /// Menambahkan welcome message dari AI
  void _addWelcomeMessage() {
    setState(() {
      _messages.add(
        ChatMessage(
          id: 'welcome',
          content:
              'Halo! Saya asisten gizi virtual GiziSehat. Saya siap membantu Anda dengan pertanyaan seputar gizi dan tumbuh kembang anak. Ada yang bisa saya bantu hari ini?',
          isFromUser: false,
          timestamp: DateTime.now(),
        ),
      );
    });
    // Auto scroll ke bawah setelah welcome message
    _scrollToBottom();
  }

  /// Mengirim pesan user dan mendapatkan response dari AI
  /// Menggunakan Google Gemini AI untuk generate response
  Future<void> _sendMessage(String message) async {
    if (message.trim().isEmpty || _isLoading) return;

    // Tambahkan pesan user
    final userMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: message.trim(),
      isFromUser: true,
      timestamp: DateTime.now(),
    );

    setState(() {
      _messages.add(userMessage);
      _isLoading = true;
    });
    _messageController.clear();
    _scrollToBottom();

    try {
      // Kirim ke Gemini AI dan dapatkan response
      final aiResponse = await _geminiService.sendMessage(message);

      if (mounted) {
        setState(() {
          _messages.add(
            ChatMessage(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              content: aiResponse,
              isFromUser: false,
              timestamp: DateTime.now(),
            ),
          );
          _isLoading = false;
        });
        _scrollToBottom();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _messages.add(
            ChatMessage(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              content: 'Maaf, terjadi kesalahan saat memproses pesan Anda. Silakan coba lagi.',
              isFromUser: false,
              timestamp: DateTime.now(),
            ),
          );
          _isLoading = false;
        });
        _scrollToBottom();
      }
    }
  }


  /// Handle quick question button click
  void _handleQuickQuestion(QuickQuestion question) {
    _sendMessage(question.text);
  }

  /// Scroll ke pesan terbaru
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  /// Format waktu menjadi HH:mm
  String _formatTime(DateTime dateTime) {
    return DateFormat('HH:mm').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Column(
        children: [
          // Header Section
          _buildHeader(theme, isDark),

          // Quick Questions Section
          _buildQuickQuestionsSection(theme, isDark),

          // Chat Messages Section
          Expanded(
            child: _buildChatMessages(theme, isDark),
          ),

          // Input Bar Section
          _buildInputBar(theme, isDark),
        ],
      ),
    );
  }

  /// Membangun header dengan icon robot dan judul
  Widget _buildHeader(ThemeData theme, bool isDark) {
    return SafeArea(
      bottom: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          border: Border(
            bottom: BorderSide(
              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            // Icon Robot
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.accent.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.smart_toy_outlined,
                color: AppColors.accent,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            // Title dan Subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Asisten Gizi AI',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                    ),
                  ),
                  Text(
                    'Dokter Gizi Virtual',
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Membangun section quick questions dengan buttons
  Widget _buildQuickQuestionsSection(ThemeData theme, bool isDark) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pertanyaan cepat:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _quickQuestions.map((question) {
              return _buildQuickQuestionButton(question, theme, isDark);
            }).toList(),
          ),
        ],
      ),
    );
  }

  /// Membangun button untuk quick question
  Widget _buildQuickQuestionButton(
    QuickQuestion question,
    ThemeData theme,
    bool isDark,
  ) {
    return InkWell(
      onTap: () => _handleQuickQuestion(question),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.darkSurface
              : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              question.icon,
              size: 16,
              color: AppColors.accent,
            ),
            const SizedBox(width: 6),
            Text(
              question.text,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Membangun area chat messages dengan scroll
  Widget _buildChatMessages(ThemeData theme, bool isDark) {
    if (_messages.isEmpty) {
      return Center(
        child: Text(
          'Mulai percakapan dengan Asisten Gizi',
          style: TextStyle(
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.lightTextSecondary,
          ),
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: _messages.length + (_isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _messages.length && _isLoading) {
          // Menampilkan typing indicator saat AI sedang memproses
          return _buildTypingIndicator(theme, isDark);
        }
        final message = _messages[index];
        return _buildChatBubble(message, theme, isDark);
      },
    );
  }

  /// Membangun typing indicator saat AI sedang memproses pesan
  Widget _buildTypingIndicator(ThemeData theme, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.accent.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.smart_toy_outlined,
              size: 18,
              color: AppColors.accent,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : Colors.grey.shade200,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
                bottomLeft: Radius.circular(4),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Mengetik...',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Membangun chat bubble untuk setiap pesan
  Widget _buildChatBubble(ChatMessage message, ThemeData theme, bool isDark) {
    final isUser = message.isFromUser;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) ...[
            // Avatar AI (hanya untuk pesan AI)
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.accent.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.smart_toy_outlined,
                size: 18,
                color: AppColors.accent,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isUser
                    ? AppColors.accent
                    : (isDark
                        ? AppColors.darkSurface
                        : Colors.grey.shade200),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isUser ? 16 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!isUser)
                    Text(
                      'Asisten Gizi',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                      ),
                    ),
                  if (!isUser) const SizedBox(height: 4),
                  Text(
                    message.content,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: isUser
                          ? Colors.white
                          : (isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.lightTextPrimary),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatTime(message.timestamp),
                    style: TextStyle(
                      fontSize: 11,
                      color: isUser
                          ? Colors.white.withOpacity(0.7)
                          : (isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isUser) const SizedBox(width: 8),
        ],
      ),
    );
  }

  /// Membangun input bar di bagian bawah
  Widget _buildInputBar(ThemeData theme, bool isDark) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          border: Border(
            top: BorderSide(
              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            // Camera Button
            InkWell(
              onTap: () {
                // TODO: Implement camera functionality
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Fitur kamera akan segera tersedia'),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(24),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.darkSurface
                      : Colors.grey.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.camera_alt_outlined,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                  size: 20,
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Text Input
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.darkSurface
                      : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: 'Tanya tentang gizi anak...',
                    hintStyle: TextStyle(
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                      fontSize: 14,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  style: TextStyle(
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                    fontSize: 14,
                  ),
                  maxLines: null,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (value) {
                    _sendMessage(value);
                  },
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Send Button
            InkWell(
              onTap: _isLoading ? null : () {
                _sendMessage(_messageController.text);
              },
              borderRadius: BorderRadius.circular(24),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _isLoading
                      ? AppColors.accent.withOpacity(0.5)
                      : AppColors.accent,
                  shape: BoxShape.circle,
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 20,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}