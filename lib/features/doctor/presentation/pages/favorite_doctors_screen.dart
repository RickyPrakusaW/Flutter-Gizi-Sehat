import 'package:flutter/material.dart';
import 'package:gizi_sehat_mobile_app/core/services/database_helper.dart';
import 'package:gizi_sehat_mobile_app/features/doctor/data/models/doctor_model.dart';
import 'package:gizi_sehat_mobile_app/features/doctor/presentation/widgets/doctor_card.dart';

class FavoriteDoctorsScreen extends StatefulWidget {
  const FavoriteDoctorsScreen({super.key});

  @override
  State<FavoriteDoctorsScreen> createState() => _FavoriteDoctorsScreenState();
}

class _FavoriteDoctorsScreenState extends State<FavoriteDoctorsScreen> {
  late Future<List<DoctorModel>> _favoritesFuture;

  @override
  void initState() {
    super.initState();
    _refreshFavorites();
  }

  void _refreshFavorites() {
    setState(() {
      _favoritesFuture = _loadFavorites();
    });
  }

  Future<List<DoctorModel>> _loadFavorites() async {
    final data = await DatabaseHelper.instance.getFavorites();
    return data.map((e) => DoctorModel.fromMap(e)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Favorite Doctors",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder<List<DoctorModel>>(
        future: _favoritesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final favoriteDoctors = snapshot.data ?? [];

          if (favoriteDoctors.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border,
                      size: 80, color: Colors.grey.shade300),
                  const SizedBox(height: 16),
                  Text(
                    "No saved doctors yet",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: favoriteDoctors.length,
            itemBuilder: (context, index) {
              return DoctorCard(doctor: favoriteDoctors[index]);
            },
          );
        },
      ),
    );
  }
}
