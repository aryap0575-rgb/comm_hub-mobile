import 'package:flutter/material.dart';
import 'daftar_komunitas_screen2.dart'; // sesuaikan path import-nya

class DaftarKomunitasScreen extends StatefulWidget {
  const DaftarKomunitasScreen({Key? key}) : super(key: key);

  @override
  State<DaftarKomunitasScreen> createState() => _DaftarKomunitasScreenState();
}

class _DaftarKomunitasScreenState extends State<DaftarKomunitasScreen> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController tentangController = TextEditingController();
  final TextEditingController visiController = TextEditingController();
  final TextEditingController misiController = TextEditingController();
  String? selectedKategori;

  final List<String> kategoriList = [
    "Pendidikan",
    "Sosial",
    "Lingkungan",
    "Teknologi",
    "Olahraga",
    "Keagamaan",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: SafeArea(
        child: Column(
          children: [
            // APPBAR
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(bottom: BorderSide(color: Color(0xFFEAEAEA))),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child:
                        const Icon(Icons.arrow_back, color: Color(0xFFC3002F)),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    "Daftar Komunitas Baru",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFC3002F),
                    ),
                  ),
                ],
              ),
            ),

            // CONTENT
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // IDENTITAS ORGANISASI
                    _sectionCard(
                      title: "Identitas Organisasi",
                      icon: Icons.badge_outlined,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: _uploadBox(
                                  title: "FOTO PROFIL",
                                  icon: Icons.add_photo_alternate_outlined,
                                  subtitle: "Upload Logo",
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _uploadBox(
                                  title: "SAMPUL",
                                  icon: Icons.cloud_upload_outlined,
                                  subtitle:
                                      "Rekomendasi\nPNG, JPG atau JPEG\nMaks. 2MB",
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          _buildLabel("NAMA ORGANISASI"),
                          _customTextField(
                            controller: namaController,
                            hint: "Contoh: Balikpapan Creative Hub",
                          ),
                          const SizedBox(height: 20),
                          _buildLabel("KATEGORI ORGANISASI"),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border:
                                  Border.all(color: const Color(0xFFE5CACA)),
                              color: Colors.white,
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: selectedKategori,
                                isExpanded: true,
                                hint: const Text("Pilih Kategori"),
                                items: kategoriList
                                    .map((e) => DropdownMenuItem(
                                        value: e, child: Text(e)))
                                    .toList(),
                                onChanged: (value) =>
                                    setState(() => selectedKategori = value),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          _buildLabel("TENTANG ORGANISASI"),
                          _customTextField(
                            controller: tentangController,
                            hint:
                                "Deskripsikan visi besar dan latar belakang organisasi Anda...",
                            maxLines: 5,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // VISI MISI
                    _sectionCard(
                      title: "Visi & Misi",
                      icon: Icons.trending_up,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          _buildLabel("VISI"),
                          _customTextField(
                            controller: visiController,
                            hint: "Apa tujuan jangka panjang organisasi?",
                            maxLines: 5,
                          ),
                          const SizedBox(height: 20),
                          _buildLabel("MISI"),
                          _customTextField(
                            controller: misiController,
                            hint:
                                "Langkah-langkah untuk mencapai visi tersebut...",
                            maxLines: 5,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),

                    // BUTTON — navigasi ke Screen 2
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFC3002F),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const DaftarKomunitasScreen2(),
                            ),
                          );
                        },
                        child: const Text(
                          "Selanjutnya",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE8D3D3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFC3002F),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: Colors.white, size: 18),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3B3B3B),
                ),
              ),
            ],
          ),
          child,
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _customTextField({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade400),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.all(16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFE5CACA)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFE5CACA)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFC3002F), width: 1.5),
        ),
      ),
    );
  }

  Widget _uploadBox({
    required String title,
    required IconData icon,
    required String subtitle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 140,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE5CACA)),
            color: const Color(0xFFFAFAFA),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 34, color: Colors.brown.shade300),
                const SizedBox(height: 10),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
