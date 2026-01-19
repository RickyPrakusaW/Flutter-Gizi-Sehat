import 'package:flutter/material.dart';
import 'package:gizi_sehat_mobile_app/app_router.dart';
import 'package:gizi_sehat_mobile_app/features/doctor/data/services/doctor_service.dart';
import 'package:gizi_sehat_mobile_app/features/doctor/data/models/doctor_model.dart';
import 'package:gizi_sehat_mobile_app/features/doctor/presentation/widgets/doctor_card.dart';

class DoctorListScreen extends StatefulWidget {
  const DoctorListScreen({super.key});

  @override
  State<DoctorListScreen> createState() => _DoctorListScreenState();
}

class _DoctorListScreenState extends State<DoctorListScreen> {
  final TextEditingController _searchController = TextEditingController();
  final DoctorService _doctorService = DoctorService();
  final ScrollController _scrollController = ScrollController();

  List<DoctorModel> _allDoctors = [];
  List<DoctorModel> _filteredDoctors = [];
  bool _isLoading = true;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _loadDoctors();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !_isLoading &&
        _hasMore) {
      _loadDoctors();
    }
  }

  Future<void> _loadDoctors() async {
    if (_isLoading && _allDoctors.isNotEmpty) return;

    setState(() => _isLoading = true);

    try {
      final doctors = await _doctorService.getDoctors();

      setState(() {
        if (doctors.isEmpty) {
          _hasMore = false;
        } else {
          _allDoctors.addAll(doctors);
          _hasMore = _doctorService.hasMore;
        }

        _filterDoctors(_searchController.text);
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading doctors: $e');
      setState(() => _isLoading = false);
    }
  }

  void _filterDoctors(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredDoctors = List.from(_allDoctors);
      } else {
        _filteredDoctors = _allDoctors.where((doc) {
          final name = doc.name.toLowerCase();
          final specialty = doc.specialty.toLowerCase();
          final q = query.toLowerCase();
          return name.contains(q) || specialty.contains(q);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Find Doctors',
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite, color: Colors.red),
            onPressed: () =>
                Navigator.pushNamed(context, AppRouter.favoriteDoctors),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF5C9DFF).withOpacity(0.15),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                onChanged: _filterDoctors,
                decoration: InputDecoration(
                  prefixIcon:
                      const Icon(Icons.search, color: Color(0xFF5C9DFF)),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.close,
                              size: 18, color: Colors.grey),
                          onPressed: () {
                            _searchController.clear();
                            _filterDoctors('');
                          },
                        )
                      : null,
                  hintText: 'Cari dokter atau spesialis...',
                  hintStyle: TextStyle(color: Colors.grey.shade400),
                  border: InputBorder.none,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                ),
              ),
            ),
          ),

          // List
          Expanded(
            child: _isLoading && _allDoctors.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : _filteredDoctors.isEmpty
                    ? const Center(child: Text("Tidak ada dokter ditemukan"))
                    : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(20),
                        itemCount: _filteredDoctors.length + (_hasMore ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == _filteredDoctors.length) {
                            return const Center(
                                child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(),
                            ));
                          }
                          final doctor = _filteredDoctors[index];
                          return DoctorCard(doctor: doctor);
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
