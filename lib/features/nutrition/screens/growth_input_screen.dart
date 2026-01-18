import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:gizi_sehat_mobile_app/features/dashboard/data/models/child_model.dart';
import 'package:gizi_sehat_mobile_app/features/nutrition/models/child_model.dart'; // For GrowthRecord
import 'package:gizi_sehat_mobile_app/features/nutrition/services/growth_service.dart';
import 'package:gizi_sehat_mobile_app/features/auth/state/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:gizi_sehat_mobile_app/app_router.dart';

class GrowthInputScreen extends StatefulWidget {
  final ChildModel? child; // Passed if coming from ChildPage

  const GrowthInputScreen({super.key, this.child});

  @override
  State<GrowthInputScreen> createState() => _GrowthInputScreenState();
}

class _GrowthInputScreenState extends State<GrowthInputScreen> {
  String _selectedGender = 'Laki-laki'; // String to match Dashboard ChildModel
  final TextEditingController _ageCtrl = TextEditingController(text: '9');
  final TextEditingController _weightCtrl = TextEditingController(text: '8.5');
  final TextEditingController _heightCtrl = TextEditingController(text: '72.0');

  @override
  void initState() {
    super.initState();
    if (widget.child != null) {
      _selectedGender = widget.child!.gender; // "Laki-laki" or "Perempuan"
      // Calculate age approx
      final now = DateTime.now();
      final diff = now.difference(widget.child!.birthDate).inDays;
      final months = (diff / 30).floor();
      _ageCtrl.text = months.toString();
    }
  }

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _ageCtrl.dispose();
    _weightCtrl.dispose();
    _heightCtrl.dispose();
    super.dispose();
  }

  Future<void> _calculateAndSave() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final auth = context.read<AuthProvider>();
      if (auth.userModel == null) {
        throw Exception('User belum login');
      }

      // Pastikan ada child yang dipilih
      if (widget.child == null) {
        throw Exception('Tidak ada data anak yang dipilih untuk dihitung!');
      }

      final age = int.parse(_ageCtrl.text);
      final weight = double.parse(_weightCtrl.text);
      final height = double.parse(_heightCtrl.text);

      final growthService = GrowthService();
      final targetChild = widget.child!;

      // Simpan Record Pertumbuhan ke Child yang sudah ada
      // Path: users/{uid}/children/{childId}/growth_records

      final recordId = FirebaseFirestore.instance
          .collection('users')
          .doc(auth.userModel!.id)
          .collection('children')
          .doc(targetChild.id)
          .collection('growth_records')
          .doc()
          .id;

      final record = GrowthRecord(
        id: recordId,
        childId: targetChild.id,
        date: DateTime.now(),
        ageInMonths: age,
        weight: weight,
        height: height,
      );

      // Save record & update last stats of existing child
      await growthService.addGrowthRecord(auth.userModel!.id, record);

      if (!mounted) return;

      // Navigasi ke Result Screen
      Navigator.pushNamed(
        context,
        AppRouter.growthResult,
        arguments: {
          'child': targetChild,
          'record': record,
        },
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Kalkulator Perhitungan'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Status Perkembangan Gizi Anak',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF8BC34A), // Light Green as per design ref
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Anak Anda :',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _GenderSelector(
                    gender: 'Laki-laki',
                    isSelected: _selectedGender == 'Laki-laki',
                    onTap: () => setState(() => _selectedGender = 'Laki-laki'),
                  ),
                  const SizedBox(width: 48),
                  _GenderSelector(
                    gender: 'Perempuan',
                    isSelected: _selectedGender == 'Perempuan',
                    onTap: () => setState(() => _selectedGender = 'Perempuan'),
                  ),
                ],
              ),
              const SizedBox(height: 48),
              _buildInputRow(
                label: 'Usia Anak (0-60 bulan)',
                controller: _ageCtrl,
                suffix: 'Bulan',
                hint: '0',
              ),
              const SizedBox(height: 16),
              _buildInputRow(
                label: 'Berat Badan Anak',
                controller: _weightCtrl,
                suffix: 'Kg',
                hint: '0.0',
              ),
              const SizedBox(height: 16),
              _buildInputRow(
                label: 'Tinggi Badan Anak',
                controller: _heightCtrl,
                suffix: 'Cm',
                hint: '0.0',
              ),
              const SizedBox(height: 24),
              const Text(
                'Note: Jika anak Anda belum bisa berdiri, pengukuran dilakukan dengan cara berbaring.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 32),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _calculateAndSave,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8BC34A), // Green button
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              'Hitung',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward),
                          ],
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputRow({
    required String label,
    required TextEditingController controller,
    required String suffix,
    required String hint,
  }) {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: Text(
            label,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 3,
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: hint,
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                  validator: (val) {
                    if (val == null || val.isEmpty) return 'Wajib';
                    if (double.tryParse(val) == null) return 'Angka';
                    return null;
                  },
                ),
              ),
              Container(
                width: 60,
                height: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFF8BC34A),
                  borderRadius:
                      const BorderRadius.horizontal(right: Radius.circular(4)),
                ),
                margin: const EdgeInsets.only(
                    left: 0), // Adjust if integrating to field
                // Based on image reference, the button is separate or attached.
                // Standard UI: Field [ 9 ] [ Bulan (Green Box) ]
                child: Text(
                  suffix,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _GenderSelector extends StatelessWidget {
  final String gender;
  final bool isSelected;
  final VoidCallback onTap;

  const _GenderSelector({
    required this.gender,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Using default Icons as placeholders for the custom vectors
    final icon = gender == 'Laki-laki' ? Icons.face : Icons.face_3;
    final label = gender;
    // Colors based on gender (Brownish skin tone / Hair color in illustration)
    // We'll use simple shapes to mimic the "Head" look

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? Colors.orange.shade100 : Colors.transparent,
              border: isSelected
                  ? Border.all(color: Colors.orange, width: 2)
                  : null,
            ),
            padding: const EdgeInsets.all(8),
            child: FittedBox(
              child: Icon(
                icon,
                color: gender == 'Laki-laki'
                    ? Colors.brown
                    : Colors.brown.shade800,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
