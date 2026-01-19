import 'package:cloud_firestore/cloud_firestore.dart';

class DoctorModel {
  final String id;
  final String name;
  final String specialty;
  final String? experience;
  final int patientStories;
  final int rating; // 1-100 percentage
  final String imageUrl;
  final String nextAvailable;
  final int price;
  final String about;
  final String alumni;
  final String strNumber;
  final String sipNumber;
  final String practiceLocation;

  // Schedules: {'2026-01-20': ['10:00', '11:00'], ...}
  final Map<String, List<String>> schedules;

  DoctorModel({
    required this.id,
    required this.name,
    required this.specialty,
    this.experience,
    this.patientStories = 0,
    this.rating = 0,
    required this.imageUrl,
    this.nextAvailable = 'Available Tomorrow',
    this.price = 0,
    this.about = '',
    this.alumni = '',
    this.strNumber = '',
    this.sipNumber = '',
    this.practiceLocation = '',
    this.schedules = const {},
  });

  factory DoctorModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return DoctorModel(
      id: doc.id,
      name: data['name'] ?? 'Unknown Doctor',
      specialty: data['specialist'] ?? 'General Practitioner',
      experience: data['experience_year'] != null
          ? '${data['experience_year']} Years'
          : null,
      patientStories: data['patient_stories_count'] ?? 0,
      rating: data['rating_percentage'] ?? 80,
      imageUrl: data['profile_image'] ?? '',
      nextAvailable: data['next_available'] ?? 'Available Soon',
      price: data['consultation_fee'] ?? 0,
      about: data['about'] ?? '',
      alumni: data['alumni'] ?? '',
      strNumber: data['str_number'] ?? '',
      sipNumber: data['sip_number'] ?? '',
      practiceLocation: data['practice_location'] ?? '',
      schedules: data['schedules'] != null
          ? Map<String, List<String>>.from((data['schedules'] as Map)
              .map((key, value) => MapEntry(key, List<String>.from(value))))
          : {},
    );
  }

  factory DoctorModel.fromMap(Map<String, dynamic> map) {
    return DoctorModel(
      id: map['doctorId'] ?? map['id'] ?? '',
      name: map['name'] ?? '',
      specialty: map['specialty'] ?? map['specialist'] ?? '',
      imageUrl: map['imageUrl'] ?? map['profile_image'] ?? '',
      rating: (map['rating'] is int)
          ? map['rating']
          : (map['rating'] as num?)?.toInt() ?? 0,
      price: (map['price'] is int)
          ? map['price']
          : int.tryParse(map['price'].toString()) ?? 0,
      patientStories:
          map['patientStories'] ?? map['patient_stories_count'] ?? 0,
      nextAvailable: map['nextAvailable'] ?? 'Available Soon',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'specialist': specialty,
      'experience_year': int.tryParse(experience?.split(' ')[0] ?? '0') ?? 0,
      'patient_stories_count': patientStories,
      'rating_percentage': rating,
      'profile_image': imageUrl,
      'next_available': nextAvailable,
      'consultation_fee': price,
      'about': about,
      'alumni': alumni,
      'str_number': strNumber,
      'sip_number': sipNumber,
      'practice_location': practiceLocation,
      'schedules': schedules,
    };
  }
}
