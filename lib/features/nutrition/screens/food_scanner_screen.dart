import 'package:flutter/material.dart';

class FoodScannerScreen extends StatefulWidget {
  const FoodScannerScreen({super.key});

  @override
  State<FoodScannerScreen> createState() => _FoodScannerScreenState();
}

class _FoodScannerScreenState extends State<FoodScannerScreen> {
  bool _isScanning = false;
  bool _hasResult = false;

  void _scanFood() async {
    setState(() {
      _isScanning = true;
    });
    // Simulate API delay
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() {
        _isScanning = false;
        _hasResult = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Food Scanner')),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.black,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Camera Placeholder
                  const Center(
                    child: Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 64,
                    ),
                  ),
                  if (_isScanning) const CircularProgressIndicator(),
                  if (_hasResult) _buildResultOverlay(),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(onPressed: () {}, icon: const Icon(Icons.flash_on)),
                FloatingActionButton(
                  onPressed: _scanFood,
                  backgroundColor: Colors.white,
                  child: const Icon(Icons.camera, color: Colors.black),
                ),
                IconButton(onPressed: () {}, icon: const Icon(Icons.image)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultOverlay() {
    return Container(
      margin: const EdgeInsets.all(32),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.green),
              const SizedBox(width: 8),
              const Text(
                "Nasi Tim Ayam",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => setState(() => _hasResult = false),
              ),
            ],
          ),
          const Divider(),
          _buildNutriRow("Kalori", "320 kkal"),
          _buildNutriRow("Protein", "12g (Cukup)"),
          _buildNutriRow("Zat Besi", "High"),
          const SizedBox(height: 16),
          const Text(
            "Saran AI:",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const Text(
            "Tambahkan sayur bayam untuk serat lebih banyak.",
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                setState(() => _hasResult = false);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Ditambahkan ke Jadwal Makan')),
                );
              },
              child: const Text('Tambah ke Jadwal'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNutriRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
