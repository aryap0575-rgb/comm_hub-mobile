import 'package:flutter/material.dart';

class DaftarKomunitasScreen3 extends StatefulWidget {
  const DaftarKomunitasScreen3({Key? key}) : super(key: key);

  @override
  State<DaftarKomunitasScreen3> createState() => _DaftarKomunitasScreen3State();
}

class _DaftarKomunitasScreen3State extends State<DaftarKomunitasScreen3> {
  // Simulasi list gambar yang sudah diupload (pakai index sebagai dummy)
  final List<String> _uploadedImages = [];
  int _selectedNavIndex = 2;

  void _addImage() {
    // TODO: Integrasikan dengan image_picker package
    // Contoh dummy — tambah placeholder
    setState(() {
      _uploadedImages.add('image_${_uploadedImages.length + 1}');
    });
  }

  void _removeImage(int index) {
    setState(() {
      _uploadedImages.removeAt(index);
    });
  }

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
                    // GALERI KEGIATAN CARD
                    Container(
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
                          // Header
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFC3002F),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.photo_library_outlined,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                "Galeri Kegiatan",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF3B3B3B),
                                ),
                              ),
                              const Spacer(),
                              GestureDetector(
                                onTap: _addImage,
                                child: Row(
                                  children: const [
                                    Icon(Icons.add,
                                        color: Color(0xFFC3002F), size: 16),
                                    SizedBox(width: 2),
                                    Text(
                                      "Tambah\nGambar",
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                        color: Color(0xFFC3002F),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          // Upload area label
                          const Text(
                            "UNGGAH GAMBAR",
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Upload box / grid
                          _uploadedImages.isEmpty
                              ? _emptyUploadBox()
                              : _imageGrid(),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // TERMS TEXT
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                          height: 1.5,
                        ),
                        children: [
                          const TextSpan(
                            text: "Dengan mendaftar, Anda menyetujui ",
                          ),
                          WidgetSpan(
                            child: GestureDetector(
                              onTap: () {
                                // TODO: buka halaman syarat & ketentuan
                              },
                              child: const Text(
                                "Syarat dan Ketentuan",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFFC3002F),
                                  decoration: TextDecoration.underline,
                                  decorationColor: Color(0xFFC3002F),
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ),
                          const TextSpan(
                            text: " FINDCOM untuk pengelolaan organisasi.",
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // BUTTON DAFTAR SEKARANG
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
                          // TODO: submit form pendaftaran komunitas
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              "Daftar Sekarang",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward,
                                color: Colors.white, size: 20),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),

            // BOTTOM NAVIGATION BAR
            _bottomNavBar(),
          ],
        ),
      ),
    );
  }

  // ─── Empty upload box ─────────────────────────────────────────────────────
  Widget _emptyUploadBox() {
    return GestureDetector(
      onTap: _addImage,
      child: Container(
        width: double.infinity,
        height: 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFFE5CACA),
            style: BorderStyle.solid,
          ),
          color: const Color(0xFFFAFAFA),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cloud_upload_outlined,
              size: 48,
              color: Colors.red.shade200,
            ),
            const SizedBox(height: 10),
            const Text(
              "Klik untuk unggah",
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFFC3002F),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "PNG, JPG atau WEBP\nMaks. 2MB",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Image grid (after upload) ────────────────────────────────────────────
  Widget _imageGrid() {
    return Column(
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: _uploadedImages.length,
          itemBuilder: (context, index) {
            return Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey.shade200,
                    border: Border.all(color: const Color(0xFFE5CACA)),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Center(
                      child: Icon(
                        Icons.image_outlined,
                        color: Colors.grey.shade400,
                        size: 36,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: GestureDetector(
                    onTap: () => _removeImage(index),
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Color(0xFFC3002F),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close,
                          color: Colors.white, size: 14),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 12),
        // Tombol tambah lagi setelah ada gambar
        GestureDetector(
          onTap: _addImage,
          child: Container(
            width: double.infinity,
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFE5CACA)),
              color: const Color(0xFFFAFAFA),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.add_photo_alternate_outlined,
                    color: Color(0xFFC3002F), size: 20),
                SizedBox(width: 8),
                Text(
                  "Tambah Gambar",
                  style: TextStyle(
                    color: Color(0xFFC3002F),
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ─── Bottom Navigation Bar ────────────────────────────────────────────────
  Widget _bottomNavBar() {
    final items = [
      {'icon': Icons.home_outlined, 'label': 'Home'},
      {'icon': Icons.explore_outlined, 'label': 'Explore'},
      {'icon': Icons.groups_outlined, 'label': 'Communities'},
      {'icon': Icons.person_outline, 'label': 'Profile'},
    ];

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFEAEAEA))),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (index) {
              final isActive = _selectedNavIndex == index;
              return GestureDetector(
                onTap: () => setState(() => _selectedNavIndex = index),
                behavior: HitTestBehavior.opaque,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      items[index]['icon'] as IconData,
                      color: isActive
                          ? const Color(0xFFC3002F)
                          : Colors.grey.shade500,
                      size: 24,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      items[index]['label'] as String,
                      style: TextStyle(
                        fontSize: 11,
                        color: isActive
                            ? const Color(0xFFC3002F)
                            : Colors.grey.shade500,
                        fontWeight:
                            isActive ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
