class Santri {
  final String id;
  final String nama;
  final String tanggalLahir;
  final String alamat;
  final String foto;

  Santri({required this.id, required this.nama, required this.tanggalLahir, required this.alamat, required this.foto});

  factory Santri.fromJson(Map<String, dynamic> json) {
    return Santri(
      id: json['id'],
      nama: json['nama'],
      tanggalLahir: json['tanggalLahir'],
      alamat: json['alamat'],
      foto: json['foto'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nama': nama,
      'tanggalLahir': tanggalLahir,
      'alamat': alamat,
      'foto': foto,
    };
  }
}
