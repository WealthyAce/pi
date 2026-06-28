import 'package:flutter/material.dart';

// ---------------------------------------------------------------------------
// Data Model
// ---------------------------------------------------------------------------

class ChatMessage {
  final String text;
  final bool isUser;
  final String time;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.time,
  });
}

// ---------------------------------------------------------------------------
// Widget Utama
// ---------------------------------------------------------------------------

class NutritionChatView extends StatefulWidget {
  const NutritionChatView({super.key});

  @override
  State<NutritionChatView> createState() => _NutritionChatViewState();
}

class _NutritionChatViewState extends State<NutritionChatView> {
  // ---------------------------------------------------------------------------
  // Palet Warna
  // ---------------------------------------------------------------------------
  static const Color _primaryGreen   = Color(0xFF1A5F35); // Hijau tua gelembung user
  static const Color _accentGreen    = Color(0xFF00C853); // Hijau terang tombol nav & bot
  static const Color _bgLight        = Color(0xFFF8FAFC); // Background abu-abu sangat muda
  static const Color _sendBtnColor   = Color(0xFFA13D06); // Cokelat/oranye tombol kirim
  static const Color _navBorder      = Color(0xFFEEEEEE); // Border top bottom nav

  // ---------------------------------------------------------------------------
  // State
  // ---------------------------------------------------------------------------
  final List<ChatMessage> _messages = [
    ChatMessage(
      text: 'How can I improve my energy levels through diet?',
      isUser: true,
      time: '10:24 AM',
    ),
    ChatMessage(
      text:
          'Focus on complex carbohydrates and iron-rich foods like spinach and lentils. '
          'These provide sustained glucose release and oxygen transport.\n\n'
          'Would you like a meal plan recommendation for the rest of the week?',
      isUser: false,
      time: '10:25 AM',
    ),
  ];

  final TextEditingController _chatController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  String get _nowStr {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:'
        '${now.minute.toString().padLeft(2, '0')}';
  }

  void _handleSend() {
    final text = _chatController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(text: text, isUser: true, time: _nowStr));
      _chatController.clear();
    });
    _scrollToBottom();
    _sendPlaceholderReply(text);
  }

  Future<void> _sendPlaceholderReply(String userPrompt) async {
    // TODO: Ganti dengan integrasi Gemini API
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    setState(() {
      _messages.add(ChatMessage(
        text: "This is a placeholder response from Gemini. Ready to analyze: '$userPrompt'",
        isUser: false,
        time: _nowStr,
      ));
    });
    _scrollToBottom();
  }

  void _handleQuickReply(String text) {
    _chatController.text = text;
    _handleSend();
  }

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

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgLight,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: _primaryGreen),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              Navigator.of(context).pushReplacementNamed('/');
            }
          },
        ),
        title: const Text(
          'AI Nutritionist',
          style: TextStyle(
            color: _primaryGreen,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: Colors.grey.shade300,
              child: const Icon(Icons.person, color: Colors.white),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Penanda tanggal
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Text(
              'TODAY',
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w500,
                letterSpacing: 1.0,
                fontSize: 12,
              ),
            ),
          ),

          // Daftar pesan
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return msg.isUser
                    ? _buildUserBubble(msg)
                    : _buildAIBubble(msg);
              },
            ),
          ),

          // Quick Reply Pills
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildQuickReplyPill(
                    'Yes, show meal plan',
                    () => _handleQuickReply('Yes, show meal plan'),
                  ),
                  const SizedBox(width: 8),
                  _buildQuickReplyPill(
                    'More food examples',
                    () => _handleQuickReply('More food examples'),
                  ),
                ],
              ),
            ),
          ),

          // Input bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    spreadRadius: 1,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const SizedBox(width: 8),
                  IconButton(
                    icon: Icon(Icons.add_circle_outline,
                        color: Colors.grey.shade400, size: 28),
                    onPressed: () {},
                  ),
                  Expanded(
                    child: TextField(
                      controller: _chatController,
                      decoration: const InputDecoration(
                        hintText: 'Ask anything...',
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                      ),
                      onSubmitted: (_) => _handleSend(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 6.0),
                    child: GestureDetector(
                      onTap: _handleSend,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          color: _sendBtnColor,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.send,
                            color: Colors.white, size: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Navigation Bar
          Container(
            height: 65,
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                  top: BorderSide(color: _navBorder, width: 1)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(Icons.camera_alt_outlined, 'Camera', false),
                _buildNavItem(Icons.analytics_outlined, 'Stats', false),
                _buildNavItemActive(Icons.smart_toy, 'AI Hub'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Sub-Widgets
  // ---------------------------------------------------------------------------

  Widget _buildUserBubble(ChatMessage message) {
    return Align(
      alignment: Alignment.centerRight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            child: Container(
              margin: const EdgeInsets.only(top: 8, bottom: 4),
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                color: _primaryGreen,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
              ),
              child: Text(
                message.text,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
          Text(message.time,
              style: const TextStyle(color: Colors.grey, fontSize: 11)),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildAIBubble(ChatMessage message) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 8, right: 8),
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
              color: _accentGreen,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.smart_toy, color: Colors.white, size: 16),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 8, bottom: 4),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 5,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Text(
                    message.text,
                    style: const TextStyle(
                        color: Colors.black87, fontSize: 14, height: 1.4),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 4.0),
                  child: Text(message.time,
                      style:
                          const TextStyle(color: Colors.grey, fontSize: 11)),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickReplyPill(String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(width: 1, color: Colors.grey.shade200),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: _primaryGreen,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  /// Item non-aktif di bottom nav
  Widget _buildNavItem(IconData icon, String label, bool isActive) {
    final color =
        isActive ? _accentGreen : Colors.grey.shade400;
    return GestureDetector(
      onTap: () {
        if (label == 'Camera') {
          Navigator.pushNamed(context, '/scan');
        } else if (label == 'Stats') {
          Navigator.pushNamed(context, '/nutrition-detail');
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(label,
              style: TextStyle(
                  color: Colors.grey.shade500, fontSize: 11)),
        ],
      ),
    );
  }

  /// Pill aktif "AI Hub"
  Widget _buildNavItemActive(IconData icon, String label) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/'),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: _accentGreen,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 6),
            Text(label,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12)),
          ],
        ),
      ),
    );
  }
}