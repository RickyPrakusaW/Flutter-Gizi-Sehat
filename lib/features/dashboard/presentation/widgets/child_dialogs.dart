import 'package:flutter/material.dart';
import 'package:gizi_sehat_mobile_app/features/dashboard/data/models/child_model.dart';
import 'package:gizi_sehat_mobile_app/features/dashboard/data/services/child_service.dart';

class AddEditChildDialog extends StatefulWidget {
  final String userId;
  final ChildModel? child; // If null, it's add mode

  const AddEditChildDialog({super.key, required this.userId, this.child});

  @override
  State<AddEditChildDialog> createState() => _AddEditChildDialogState();
}

class _AddEditChildDialogState extends State<AddEditChildDialog> {
  late TextEditingController _nameController;
  String _gender = 'Laki-laki';
  DateTime _birthDate = DateTime.now();
  String _status = 'Normal';
  final ChildService _service = ChildService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.child != null) {
      _nameController = TextEditingController(text: widget.child!.name);
      _gender = widget.child!.gender;
      _birthDate = widget.child!.birthDate;
      _status = widget.child!.status;
    } else {
      _nameController = TextEditingController();
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _birthDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _birthDate = picked);
    }
  }

  Future<void> _saveChild() async {
    if (_nameController.text.trim().isEmpty) return;

    setState(() => _isLoading = true);
    try {
      final childData = ChildModel(
        id: widget.child?.id ?? '',
        name: _nameController.text.trim(),
        gender: _gender,
        birthDate: _birthDate,
        status: _status,
      );

      if (widget.child != null) {
        // Edit
        await _service.updateChild(widget.userId, childData);
      } else {
        // Add
        await _service.addChild(widget.userId, childData);
      }

      if (mounted) Navigator.pop(context);
    } catch (e) {
      debugPrint('Error saving child: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteChild() async {
    setState(() => _isLoading = true);
    try {
      await _service.deleteChild(widget.userId, widget.child!.id);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      debugPrint('Error deleting child: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.child != null ? 'Edit Data Anak' : 'Tambah Anak'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nama Anak'),
            ),
            const SizedBox(height: 16),
            const Text('Jenis Kelamin:'),
            Row(
              children: [
                Radio<String>(
                  value: 'Laki-laki',
                  groupValue: _gender,
                  onChanged: (val) => setState(() => _gender = val!),
                ),
                const Text('Laki-laki'),
                Radio<String>(
                  value: 'Perempuan',
                  groupValue: _gender,
                  onChanged: (val) => setState(() => _gender = val!),
                ),
                const Text('Perempuan'),
              ],
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: _pickDate,
              child: InputDecorator(
                decoration: const InputDecoration(labelText: 'Tanggal Lahir'),
                child: Text(
                  '${_birthDate.day}/${_birthDate.month}/${_birthDate.year}',
                ),
              ),
            ),
            if (widget.child != null) ...[
              const SizedBox(height: 16),
              const Text(
                'Status Gizi:',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              DropdownButton<String>(
                isExpanded: true,
                value: _status,
                items: ['Normal', 'Berisiko', 'Stunted', 'Wasted']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) => setState(() => _status = val!),
              ),
            ],
          ],
        ),
      ),
      actions: [
        if (widget.child != null)
          TextButton(
            onPressed: _isLoading ? null : _deleteChild,
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _saveChild,
          child: _isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Simpan'),
        ),
      ],
    );
  }
}
