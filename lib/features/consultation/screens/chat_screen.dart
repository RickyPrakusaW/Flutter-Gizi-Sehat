import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:gizi_sehat_mobile_app/features/consultation/services/chat_service.dart';
import 'package:provider/provider.dart';
import 'package:gizi_sehat_mobile_app/features/auth/state/auth_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gizi_sehat_mobile_app/core/services/cloudinary_service.dart';
import 'dart:io';

class ChatScreen extends StatefulWidget {
  final Map<String, dynamic> partner; // Doctor or Patient data

  const ChatScreen({super.key, required this.partner});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ChatService _chatService = ChatService();
  String? _roomId;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initChat();
  }

  Future<void> _initChat() async {
    final user = context.read<AuthProvider>().userModel;
    if (user != null) {
      // Determine IDs based on who is logged in
      String userId = user.id;
      // Partner ID passed in navigation
      String partnerId = widget.partner['id'];

      final roomId = await _chatService.getChatRoomId(userId, partnerId);
      if (mounted) {
        setState(() {
          _roomId = roomId;
          _isLoading = false;
        });
      }
    }
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty || _roomId == null) return;

    final user = context.read<AuthProvider>().userModel;
    if (user == null) return;

    _chatService.sendMessage(_roomId!, user.id, text);
    _controller.clear();

    _scrollToBottom();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null || _roomId == null) return;

    final user = context.read<AuthProvider>().userModel;
    if (user == null) return;

    // Show loading or optimistic update could be handled here
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Uploading Image...')));

    try {
      final cloudinaryService = CloudinaryService();
      final imageUrl =
          await cloudinaryService.uploadImage(File(pickedFile.path));

      if (imageUrl != null) {
        await _chatService.sendMessage(_roomId!, user.id, "",
            type: 'image', imageUrl: imageUrl);
        _scrollToBottom();
      }
    } catch (e) {
      debugPrint("Error uploading chat image: $e");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to send image: $e')));
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().userModel;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: widget.partner['image'] != null &&
                          widget.partner['image'].toString().startsWith('http')
                      ? CachedNetworkImageProvider(widget.partner['image'])
                      : const AssetImage('assets/images/placeholder.png')
                          as ImageProvider,
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.partner['name'] ?? 'User',
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Text(
                    'Online',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [],
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : StreamBuilder<QuerySnapshot>(
                    stream: _chatService.getMessages(_roomId!),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final docs = snapshot.data!.docs;

                      if (docs.isEmpty) {
                        return Center(
                          child: Text(
                            "Mulai percakapan dengan ${widget.partner['name']}",
                            style: TextStyle(color: Colors.grey.shade400),
                          ),
                        );
                      }

                      return ListView.builder(
                        controller: _scrollController,
                        reverse: true,
                        padding: const EdgeInsets.all(20),
                        itemCount: docs.length,
                        itemBuilder: (context, index) {
                          final data =
                              docs[index].data() as Map<String, dynamic>;
                          final isMe = data['senderId'] == user?.id;
                          final timestamp = data['createdAt'] as Timestamp?;
                          final time = timestamp != null
                              ? DateFormat('HH:mm').format(timestamp.toDate())
                              : '...';

                          return _buildMessageBubble(
                            data,
                            isMe,
                            time,
                          );
                        },
                      );
                    },
                  ),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(
      Map<String, dynamic> data, bool isMe, String time) {
    final type = data['type'] ?? 'text';
    final text = data['text'] ?? '';
    final imageUrl = data['imageUrl'];

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isMe ? const Color(0xFF5C9DFF) : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: isMe ? const Radius.circular(16) : Radius.zero,
            bottomRight: isMe ? Radius.zero : const Radius.circular(16),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (type == 'image' && imageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              )
            else
              Text(
                text,
                style: TextStyle(
                  color: isMe ? Colors.white : const Color(0xFF2D3748),
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            const SizedBox(height: 4),
            Text(
              time,
              style: TextStyle(
                color:
                    isMe ? Colors.white.withOpacity(0.7) : Colors.grey.shade400,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.add_photo_alternate,
                  color: Color(0xFF5C9DFF), size: 28),
              onPressed: _pickImage,
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F9FC),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    hintText: "Type a message...",
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  textCapitalization: TextCapitalization.sentences,
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: _sendMessage,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: Color(0xFF5C9DFF),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.send, color: Colors.white, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
