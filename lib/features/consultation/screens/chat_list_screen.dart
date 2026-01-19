import 'package:flutter/material.dart';
import 'package:gizi_sehat_mobile_app/app_router.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ChatListScreen extends StatelessWidget {
  final bool isDoctor; // To determine if showing list of patients or doctors

  const ChatListScreen({super.key, this.isDoctor = false});

  @override
  Widget build(BuildContext context) {
    // Mock Data
    final chatList = isDoctor
        ? [
            {
              'id': 'p1',
              'name': 'Bunda Sarah',
              'message': 'Terima kasih dok atas sarannya.',
              'time': '10:30',
              'unread': 2,
              'image': 'https://placehold.co/200x200/png?text=Bunda+S',
            },
            {
              'id': 'p2',
              'name': 'Bapak Joko',
              'message': 'Anak saya demam lagi dok.',
              'time': 'Yesterday',
              'unread': 0,
              'image': 'https://placehold.co/200x200/png?text=Pak+J',
            }
          ]
        : [
            {
              'id': 'd1',
              'name': 'Dr. Truluck Nik',
              'message': 'Baik bu, nanti dicek lagi ya.',
              'time': '09:41',
              'unread': 1,
              'image': 'https://placehold.co/200x200/png?text=Dr+Nik',
            },
            {
              'id': 'd2',
              'name': 'Dr. Tranquilli',
              'message': 'Sama-sama bu.',
              'time': 'Mon',
              'unread': 0,
              'image': 'https://placehold.co/200x200/png?text=Dr+Tran',
            }
          ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          isDoctor ? 'Chat Pasien' : 'Chat Dokter',
          style:
              const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        itemCount: chatList.length,
        separatorBuilder: (ctx, i) => Divider(color: Colors.grey.shade100),
        itemBuilder: (context, index) {
          final chat = chatList[index];
          return ListTile(
            contentPadding: EdgeInsets.zero,
            onTap: () {
              // Navigate to Chat Details
              Navigator.pushNamed(context, AppRouter.chat,
                  arguments: chat // Pass partner details
                  );
            },
            leading: Stack(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundImage:
                      CachedNetworkImageProvider(chat['image'] as String),
                ),
                if ((chat['unread'] as int) > 0)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                        border: Border.fromBorderSide(
                            BorderSide(color: Colors.white, width: 1.5)),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                    ),
                  ),
              ],
            ),
            title: Text(
              chat['name'] as String,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Color(0xFF2D3748),
              ),
            ),
            subtitle: Text(
              chat['message'] as String,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: (chat['unread'] as int) > 0
                    ? const Color(0xFF2D3748)
                    : Colors.grey.shade500,
                fontWeight: (chat['unread'] as int) > 0
                    ? FontWeight.w600
                    : FontWeight.normal,
              ),
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  chat['time'] as String,
                  style: TextStyle(
                    fontSize: 12,
                    color: (chat['unread'] as int) > 0
                        ? const Color(0xFF5C9DFF)
                        : Colors.grey.shade400,
                    fontWeight: (chat['unread'] as int) > 0
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
                if ((chat['unread'] as int) > 0) ...[
                  const SizedBox(height: 4),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFF5C9DFF),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      chat['unread'].toString(),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ]
              ],
            ),
          );
        },
      ),
    );
  }
}
