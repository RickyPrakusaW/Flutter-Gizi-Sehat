import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegionModel {
  final String id;
  final String name;

  RegionModel({required this.id, required this.name});

  factory RegionModel.fromJson(Map<String, dynamic> json) {
    return RegionModel(id: json['id'] ?? '', name: json['name'] ?? '');
  }
}

class IndonesianLocationSelector extends StatefulWidget {
  final Function(String provinceName, String cityName, String districtName)
  onLocationSelected;
  final String? initialProvince;
  final String? initialCity;
  final String? initialDistrict;

  const IndonesianLocationSelector({
    super.key,
    required this.onLocationSelected,
    this.initialProvince,
    this.initialCity,
    this.initialDistrict,
  });

  @override
  State<IndonesianLocationSelector> createState() =>
      _IndonesianLocationSelectorState();
}

class _IndonesianLocationSelectorState
    extends State<IndonesianLocationSelector> {
  // Data Lists
  List<RegionModel> _provinces = [];
  List<RegionModel> _cities = [];
  List<RegionModel> _districts = [];

  // Selections (Objects)
  RegionModel? _selectedProvince;
  RegionModel? _selectedCity;
  RegionModel? _selectedDistrict;

  // Loading States
  bool _isLoadingProvinces = false;
  bool _isLoadingCities = false;
  bool _isLoadingDistricts = false;

  @override
  void initState() {
    super.initState();
    _fetchProvinces();
  }

  /// 1. Fetch Provinces
  Future<void> _fetchProvinces() async {
    setState(() => _isLoadingProvinces = true);
    try {
      final response = await http.get(
        Uri.parse(
          'https://www.emsifa.com/api-wilayah-indonesia/api/provinces.json',
        ),
      );

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        setState(() {
          _provinces = data.map((json) => RegionModel.fromJson(json)).toList();

          if (widget.initialProvince != null && _provinces.isNotEmpty) {
            try {
              final match = _provinces.firstWhere(
                (p) =>
                    p.name.toUpperCase() ==
                    widget.initialProvince!.toUpperCase(),
              );
              _selectedProvince = match;
              if (_selectedProvince != null) {
                _fetchCities(_selectedProvince!.id);
              }
            } catch (e) {
              debugPrint('Initial province match failed ($e)');
            }
          }
        });
      }
    } catch (e) {
      debugPrint('Error fetching provinces: $e');
    } finally {
      if (mounted) setState(() => _isLoadingProvinces = false);
    }
  }

  /// 2. Fetch Cities
  Future<void> _fetchCities(String provinceId) async {
    setState(() {
      _isLoadingCities = true;
      _cities = [];
      _districts = [];
      _selectedCity = null;
      _selectedDistrict = null;
    });

    try {
      final response = await http.get(
        Uri.parse(
          'https://www.emsifa.com/api-wilayah-indonesia/api/regencies/$provinceId.json',
        ),
      );

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        setState(() {
          _cities = data.map((json) => RegionModel.fromJson(json)).toList();

          if (widget.initialCity != null && _cities.isNotEmpty) {
            try {
              final match = _cities.firstWhere(
                (c) =>
                    c.name.toUpperCase() == widget.initialCity!.toUpperCase(),
              );
              _selectedCity = match;
              if (_selectedCity != null) {
                _fetchDistricts(_selectedCity!.id);
              }
            } catch (e) {
              debugPrint('Initial city match failed ($e)');
            }
          }
        });
      }
    } catch (e) {
      debugPrint('Error fetching cities: $e');
    } finally {
      if (mounted) setState(() => _isLoadingCities = false);
    }
  }

  /// 3. Fetch Districts (Kecamatan)
  Future<void> _fetchDistricts(String regencyId) async {
    setState(() {
      _isLoadingDistricts = true;
      _districts = [];
      _selectedDistrict = null;
    });

    try {
      final response = await http.get(
        Uri.parse(
          'https://www.emsifa.com/api-wilayah-indonesia/api/districts/$regencyId.json',
        ),
      );

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        setState(() {
          _districts = data.map((json) => RegionModel.fromJson(json)).toList();

          if (widget.initialDistrict != null && _districts.isNotEmpty) {
            try {
              final match = _districts.firstWhere(
                (d) =>
                    d.name.toUpperCase() ==
                    widget.initialDistrict!.toUpperCase(),
              );
              _selectedDistrict = match;
            } catch (e) {
              debugPrint('Initial district match failed ($e)');
            }
          }
        });
      }
    } catch (e) {
      debugPrint('Error fetching districts: $e');
    } finally {
      if (mounted) setState(() => _isLoadingDistricts = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- Dropdown Provinsi ---
        DropdownButtonFormField<RegionModel>(
          decoration: InputDecoration(
            labelText: 'Provinsi',
            hintText: 'Pilih Provinsi',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
          initialValue: _selectedProvince,
          isExpanded: true,
          items: _provinces.map((province) {
            return DropdownMenuItem(
              value: province,
              child: Text(province.name, overflow: TextOverflow.ellipsis),
            );
          }).toList(),
          onChanged: _isLoadingProvinces
              ? null
              : (val) {
                  if (val != null) {
                    setState(() {
                      _selectedProvince = val;
                      _selectedCity = null;
                      _selectedDistrict = null;
                    });
                    _fetchCities(val.id);
                    widget.onLocationSelected(val.name, '', '');
                  }
                },
        ),

        const SizedBox(height: 16),

        // --- Dropdown Kota ---
        DropdownButtonFormField<RegionModel>(
          decoration: InputDecoration(
            labelText: 'Kota / Kabupaten',
            hintText: 'Pilih Kota',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
          initialValue: _selectedCity,
          isExpanded: true,
          items: _cities.map((city) {
            return DropdownMenuItem(
              value: city,
              child: Text(city.name, overflow: TextOverflow.ellipsis),
            );
          }).toList(),
          onChanged: (_selectedProvince == null || _isLoadingCities)
              ? null
              : (val) {
                  if (val != null) {
                    setState(() {
                      _selectedCity = val;
                      _selectedDistrict = null;
                    });
                    _fetchDistricts(val.id);
                    widget.onLocationSelected(
                      _selectedProvince!.name,
                      val.name,
                      '',
                    );
                  }
                },
        ),

        const SizedBox(height: 16),

        // --- Dropdown Kecamatan ---
        DropdownButtonFormField<RegionModel>(
          decoration: InputDecoration(
            labelText: 'Kecamatan',
            hintText: 'Pilih Kecamatan',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
          initialValue: _selectedDistrict,
          isExpanded: true,
          items: _districts.map((district) {
            return DropdownMenuItem(
              value: district,
              child: Text(district.name, overflow: TextOverflow.ellipsis),
            );
          }).toList(),
          onChanged: (_selectedCity == null || _isLoadingDistricts)
              ? null
              : (val) {
                  if (val != null) {
                    setState(() {
                      _selectedDistrict = val;
                      // Final callback
                      widget.onLocationSelected(
                        _selectedProvince!.name,
                        _selectedCity!.name,
                        val.name,
                      );
                    });
                  }
                },
          icon: _isLoadingDistricts
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.arrow_drop_down),
        ),
      ],
    );
  }
}
