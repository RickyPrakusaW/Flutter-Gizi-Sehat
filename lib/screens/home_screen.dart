import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const kAccent = Color(0xFF5DB075);
  int _index = 0;

  final _pages = const [
    _BerandaView(),
    _JelajahView(),
    _ProfilView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GiziSehat'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black87,
      ),
      body: IndexedStack(index: _index, children: _pages),

      floatingActionButton: _index == 0
          ? FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: kAccent,
        icon: const Icon(Icons.add_a_photo_outlined),
        label: const Text('Scan Makanan'),
      )
          : null,

      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Beranda'),
          NavigationDestination(icon: Icon(Icons.explore_outlined), label: 'Jelajah'),
          NavigationDestination(icon: Icon(Icons.person_outline), label: 'Profil'),
        ],
      ),
    );
  }
}

/// ====== Halaman Beranda (placeholder) ======
class _BerandaView extends StatelessWidget {
  const _BerandaView();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        // Salam
        const Text('Halo 👋',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        const Text('Siap bantu kebutuhan gizi keluargamu hari ini?',
            style: TextStyle(color: Colors.grey)),

        const SizedBox(height: 16),

        // Kartu ringkas
        _InfoCard(
          title: 'Cek Gizi dari Foto',
          subtitle: 'Ambil gambar makanan, dapatkan estimasi kalori & nutrisi.',
          icon: Icons.camera_alt_outlined,
          onTap: () {},
        ),
        const SizedBox(height: 12),
        _InfoCard(
          title: 'Grafik Pertumbuhan Anak',
          subtitle: 'Pantau berat/tinggi badan sesuai kurva WHO.',
          icon: Icons.insights_outlined,
          onTap: () {},
        ),
        const SizedBox(height: 12),
        _InfoCard(
          title: 'Menu Sehat Harian',
          subtitle: 'Rekomendasi menu lokal sesuai anggaran.',
          icon: Icons.restaurant_menu_outlined,
          onTap: () {},
        ),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _InfoCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      elevation: 1,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF5DB075).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: const Color(0xFF5DB075)),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text(subtitle, style: const TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}

/// ====== Halaman Jelajah (placeholder) ======
class _JelajahView extends StatelessWidget {
  const _JelajahView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Konten Jelajah (artikel, resep, tips)'),
    );
  }
}

/// ====== Halaman Profil (placeholder) ======
class _ProfilView extends StatelessWidget {
  const _ProfilView();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const CircleAvatar(radius: 36, child: Icon(Icons.person, size: 36)),
        const SizedBox(height: 12),
        const Center(
            child: Text('Nama Pengguna',
                style: TextStyle(fontWeight: FontWeight.w600))),
        const SizedBox(height: 20),
        const ListTile(
          leading: Icon(Icons.settings_outlined),
          title: Text('Pengaturan'),
        ),
        const ListTile(
          leading: Icon(Icons.privacy_tip_outlined),
          title: Text('Privasi'),
        ),
        const ListTile(
          leading: Icon(Icons.help_outline),
          title: Text('Bantuan'),
        ),
      ],
    );
  }
}
