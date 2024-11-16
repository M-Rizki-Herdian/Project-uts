import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'api_service.dart';
import 'santri_model.dart';

class SantriPage extends StatefulWidget {
  const SantriPage({super.key});

  @override
  _SantriPageState createState() => _SantriPageState();
}

class _SantriPageState extends State<SantriPage> {
  final ApiService apiService = ApiService();
  final TextEditingController namaController = TextEditingController();
  final TextEditingController tanggalLahirController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  File? _image;
  final picker = ImagePicker();
  bool _isFormVisible = false;
  String? _currentSantriId;

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future<void> _addOrUpdateSantri(String? id) async {
    String fotoUrl = _image != null ? _image!.path : '';

    final santri = Santri(
      id: id ?? '',
      nama: namaController.text,
      tanggalLahir: tanggalLahirController.text,
      alamat: alamatController.text,
      foto: fotoUrl,
    );

    if (id == null) {
      await apiService.createSantri(santri);
    } else {
      await apiService.updateSantri(santri);
    }
    _refreshPage();
    _clearFields();
  }

  void _clearFields() {
    namaController.clear();
    tanggalLahirController.clear();
    alamatController.clear();
    _image = null;
    _currentSantriId = null;
  }

  Future<void> _deleteSantri(String id) async {
    await apiService.deleteSantri(id);
    _refreshPage();
  }

  void _editSantri(Santri santri) {
    setState(() {
      namaController.text = santri.nama;
      tanggalLahirController.text = santri.tanggalLahir;
      alamatController.text = santri.alamat;
      _image = File(santri.foto);
      _currentSantriId = santri.id;
      _isFormVisible = true;
    });
  }

  void _refreshPage() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Santri'),
      ),
      body: Column(
        children: [
          if (_isFormVisible)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextField(
                    controller: namaController,
                    decoration: const InputDecoration(labelText: 'Nama'),
                  ),
                  TextField(
                    controller: tanggalLahirController,
                    decoration: const InputDecoration(labelText: 'Tanggal Lahir'),
                  ),
                  TextField(
                    controller: alamatController,
                    decoration: const InputDecoration(labelText: 'Alamat'),
                  ),
                  _image == null
                      ? const Text('No image selected.')
                      : Image.file(_image!, height: 100, width: 100),
                  TextButton.icon(
                    icon: const Icon(Icons.image),
                    label: const Text("Pilih Gambar"),
                    onPressed: _pickImage,
                  ),
                  ElevatedButton(
                    onPressed: () => _addOrUpdateSantri(_currentSantriId),
                    child: Text(_currentSantriId == null ? 'Tambah Data' : 'Perbarui Data'),
                  ),
                ],
              ),
            ),
          if (!_isFormVisible)
            Expanded(
              child: FutureBuilder<List<Santri>>(
                future: apiService.getSantri(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final santriList = snapshot.data!;
                  return ListView.builder(
                    itemCount: santriList.length,
                    itemBuilder: (context, index) {
                      final santri = santriList[index];
                      return ListTile(
                        leading: santri.foto.isNotEmpty
                            ? Image.file(
                                File(santri.foto),
                                height: 50,
                                width: 50,
                                fit: BoxFit.cover,
                              )
                            : const Icon(Icons.person, size: 50),
                        title: Text(santri.nama),
                        subtitle: Text(santri.alamat),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                _editSantri(santri);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => _deleteSantri(santri.id),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _isFormVisible = !_isFormVisible;
            if (!_isFormVisible) _clearFields();
          });
        },
        child: _isFormVisible ? const Icon(Icons.close) : const Icon(Icons.add),
      ),
    );
  }
}
