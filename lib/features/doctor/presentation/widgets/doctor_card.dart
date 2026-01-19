import 'package:flutter/material.dart';
import 'package:gizi_sehat_mobile_app/features/doctor/data/models/doctor_model.dart';
import 'package:gizi_sehat_mobile_app/app_router.dart';
import 'package:gizi_sehat_mobile_app/core/services/database_helper.dart';

class DoctorCard extends StatefulWidget {
  final DoctorModel doctor;

  const DoctorCard({super.key, required this.doctor});

  @override
  State<DoctorCard> createState() => _DoctorCardState();
}

class _DoctorCardState extends State<DoctorCard> {
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkFavorite();
  }

  Future<void> _checkFavorite() async {
    final isFav = await DatabaseHelper.instance.isFavorite(widget.doctor.id);
    if (mounted) {
      setState(() {
        _isFavorite = isFav;
      });
    }
  }

  Future<void> _toggleFavorite() async {
    if (_isFavorite) {
      await DatabaseHelper.instance.removeFavorite(widget.doctor.id);
    } else {
      await DatabaseHelper.instance.addFavorite({
        'id': widget.doctor.id,
        'name': widget.doctor.name,
        'specialty': widget.doctor.specialty,
        'imageUrl': widget.doctor.imageUrl,
        'rating': widget.doctor.rating,
        'price': widget.doctor.price,
      });
    }
    setState(() {
      _isFavorite = !_isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                    image: widget.doctor.imageUrl.isNotEmpty
                        ? DecorationImage(
                            image: NetworkImage(widget.doctor.imageUrl),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: widget.doctor.imageUrl.isEmpty
                      ? const Icon(Icons.person, size: 40, color: Colors.grey)
                      : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              widget.doctor.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2D3748),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          GestureDetector(
                            onTap: _toggleFavorite,
                            child: Icon(
                              _isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: Colors.red,
                              size: 24,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.doctor.specialty,
                        style: const TextStyle(
                          color: Color(0xFF5C9DFF),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (widget.doctor.experience != null)
                        Text(
                          widget.doctor.experience!,
                          style: TextStyle(
                              color: Colors.grey.shade500, fontSize: 13),
                        ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          _buildDotInfo(
                              Colors.green, '${widget.doctor.rating}%'),
                          const SizedBox(width: 16),
                          _buildDotInfo(Colors.green,
                              '${widget.doctor.patientStories} Patient Stories'),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Next Available',
                      style: TextStyle(
                        color: Color(0xFF5C9DFF),
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.doctor.nextAvailable,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRouter.doctorDetail,
                        arguments: widget.doctor);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5C9DFF),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                  ),
                  child: const Text(
                    'Book Now',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDotInfo(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
        ),
      ],
    );
  }
}
