<<<<<<< HEAD
import 'package:com.example.fincome_mobile_mobile/modules/home/modules/authentication/models/daftar_organisasi_draft.dart';
=======
>>>>>>> 9f42fb3 (update)
import 'package:flutter/material.dart';
import 'daftar_komunitas_screen3.dart'; // sesuaikan path import-nya

class DaftarKomunitasScreen2 extends StatefulWidget {
<<<<<<< HEAD
  final DaftarOrganisasiDraft draft;
  const DaftarKomunitasScreen2({Key? key, required this.draft}) : super(key: key);
=======
  const DaftarKomunitasScreen2({Key? key}) : super(key: key);
>>>>>>> 9f42fb3 (update)

  @override
  State<DaftarKomunitasScreen2> createState() => _DaftarKomunitasScreen2State();
}

class _DaftarKomunitasScreen2State extends State<DaftarKomunitasScreen2> {
  // --- Struktur Departemen ---
  final List<Map<String, TextEditingController>> _departemenList = [];

  // --- Prestasi ---
  final List<Map<String, TextEditingController>> _prestasiList = [];

  // --- Kontak & Lokasi ---
  final TextEditingController _whatsappController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _lokasiController = TextEditingController();

  int _selectedNavIndex = 2; // Communities tab active

  @override
  void initState() {
    super.initState();
    // Start with one departemen and one prestasi entry
    _addDepartemen();
    _addPrestasi();
  }

  @override
  void dispose() {
    for (final item in _departemenList) {
      item['nama']!.dispose();
      item['penjelasan']!.dispose();
    }
    for (final item in _prestasiList) {
      item['nama']!.dispose();
      item['penjelasan']!.dispose();
    }
    _whatsappController.dispose();
    _emailController.dispose();
    _lokasiController.dispose();
    super.dispose();
  }

  void _addDepartemen() {
    setState(() {
      _departemenList.add({
        'nama': TextEditingController(),
        'penjelasan': TextEditingController(),
      });
    });
  }

  void _removeDepartemen(int index) {
    if (_departemenList.length <= 1) return;
    setState(() {
      _departemenList[index]['nama']!.dispose();
      _departemenList[index]['penjelasan']!.dispose();
      _departemenList.removeAt(index);
    });
  }

  void _addPrestasi() {
    setState(() {
      _prestasiList.add({
        'nama': TextEditingController(),
        'penjelasan': TextEditingController(),
      });
    });
  }

  void _removePrestasi(int index) {
    if (_prestasiList.length <= 1) return;
    setState(() {
      _prestasiList[index]['nama']!.dispose();
      _prestasiList[index]['penjelasan']!.dispose();
      _prestasiList.removeAt(index);
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
                    // STRUKTUR DEPARTEMEN
                    _sectionCard(
                      title: "Struktur Departemen",
                      icon: Icons.corporate_fare_outlined,
                      onTambah: _addDepartemen,
                      tambahLabel: "Tambah Departemen",
                      child: Column(
                        children: List.generate(
                          _departemenList.length,
                          (index) => _departemenItem(index),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // PRESTASI
                    _sectionCard(
                      title: "Prestasi",
                      icon: Icons.emoji_events_outlined,
                      onTambah: _addPrestasi,
                      tambahLabel: "Tambah Prestasi",
                      child: Column(
                        children: List.generate(
                          _prestasiList.length,
                          (index) => _prestasiItem(index),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // KONTAK & LOKASI
                    _kontakLokasi(),

                    const SizedBox(height: 28),

                    // BUTTON SELANJUTNYA
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
<<<<<<< HEAD
                          final departemenData = _departemenList
                              .where((item) =>
                                  item['nama']!.text.trim().isNotEmpty ||
                                  item['penjelasan']!.text.trim().isNotEmpty)
                              .map((item) {
                            return {
                              "departemen": item['nama']!.text.trim(),
                              "detail_departemen":
                                  item['penjelasan']!.text.trim(),
                              "is_active": true,
                            };
                          }).toList();

                          final prestasiData = _prestasiList
                              .where((item) =>
                                  item['nama']!.text.trim().isNotEmpty ||
                                  item['penjelasan']!.text.trim().isNotEmpty)
                              .map((item) {
                            return {
                              "prestasi": item['nama']!.text.trim(),
                              "detail_prestasi":
                                  item['penjelasan']!.text.trim(),
                              "is_active": true,
                            };
                          }).toList();

                          String nomorWa = _whatsappController.text.trim();

                          if (nomorWa.startsWith('0')) {
                            nomorWa = nomorWa.substring(1);
                          }

                          final draftBaru = widget.draft.copyWith(
                            wa: "62$nomorWa",
                            email: _emailController.text.trim(),
                            lokasi: _lokasiController.text.trim(),
                            departemen: departemenData,
                            prestasi: prestasiData,
                          );

                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) =>
                                  DaftarKomunitasScreen3(draft: draftBaru),
=======
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const DaftarKomunitasScreen3(),
>>>>>>> 9f42fb3 (update)
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

            // BOTTOM NAVIGATION BAR
            _bottomNavBar(),
          ],
        ),
      ),
    );
  }

  // ─── Section card with "Tambah" button ───────────────────────────────────
  Widget _sectionCard({
    required String title,
    required IconData icon,
    required Widget child,
    required VoidCallback onTambah,
    required String tambahLabel,
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
            crossAxisAlignment: CrossAxisAlignment.center,
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
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3B3B3B),
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: onTambah,
                child: Row(
                  children: [
                    const Icon(Icons.add, color: Color(0xFFC3002F), size: 16),
                    const SizedBox(width: 2),
                    Text(
                      tambahLabel,
                      style: const TextStyle(
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
          child,
        ],
      ),
    );
  }

  // ─── Departemen item ──────────────────────────────────────────────────────
  Widget _departemenItem(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (index > 0)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: [
                Expanded(
                    child: Divider(color: Colors.grey.shade200, thickness: 1)),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => _removeDepartemen(index),
                  child: const Icon(Icons.remove_circle_outline,
                      color: Color(0xFFC3002F), size: 20),
                ),
              ],
            ),
          ),
        _buildLabel("NAMA DEPARTEMEN"),
        _customTextField(
          controller: _departemenList[index]['nama']!,
          hint: "Contoh: Divisi Media & Kreatif",
        ),
        const SizedBox(height: 14),
        _buildLabel("PENJELASAN DEPARTEMEN"),
        _customTextField(
          controller: _departemenList[index]['penjelasan']!,
          hint: "Jelaskan tugas dan fungsi dari departemen ini...",
          maxLines: 3,
        ),
        const SizedBox(height: 4),
      ],
    );
  }

  // ─── Prestasi item ────────────────────────────────────────────────────────
  Widget _prestasiItem(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (index > 0)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: [
                Expanded(
                    child: Divider(color: Colors.grey.shade200, thickness: 1)),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => _removePrestasi(index),
                  child: const Icon(Icons.remove_circle_outline,
                      color: Color(0xFFC3002F), size: 20),
                ),
              ],
            ),
          ),
        _buildLabel("NAMA PRESTASI"),
        _customTextField(
          controller: _prestasiList[index]['nama']!,
          hint: "Contoh: Juara 1 Lomba Lingkungan",
        ),
        const SizedBox(height: 14),
        _buildLabel("PENJELASAN PRESTASI"),
        _customTextField(
          controller: _prestasiList[index]['penjelasan']!,
          hint: "Deskripsikan pencapaian atau penghargaan yang diterima...",
          maxLines: 3,
        ),
        const SizedBox(height: 4),
      ],
    );
  }

  // ─── Kontak & Lokasi card ─────────────────────────────────────────────────
  Widget _kontakLokasi() {
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
                child: const Icon(Icons.contact_phone_outlined,
                    color: Colors.white, size: 18),
              ),
              const SizedBox(width: 12),
              const Text(
                "Kontak & Lokasi",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3B3B3B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // WhatsApp
          _buildLabel("WHATSAPP"),
          Row(
            children: [
              Container(
                height: 52,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  ),
                  border: Border.all(color: const Color(0xFFE5CACA)),
                ),
                alignment: Alignment.center,
                child: const Text(
                  "+62",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF3B3B3B),
                  ),
                ),
              ),
              Expanded(
                child: TextField(
                  controller: _whatsappController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: "8123456789",
                    hintStyle: TextStyle(color: Colors.grey.shade400),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.all(16),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                      borderSide: BorderSide(color: Color(0xFFE5CACA)),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                      borderSide: BorderSide(color: Color(0xFFE5CACA)),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                      borderSide:
                          BorderSide(color: Color(0xFFC3002F), width: 1.5),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Email
          _buildLabel("EMAIL ORGANISASI"),
          _customTextField(
            controller: _emailController,
            hint: "official@domain.com",
            keyboardType: TextInputType.emailAddress,
          ),

          const SizedBox(height: 20),

          // Lokasi
          _buildLabel("LOKASI SEKRETARIAT (ALAMAT LENGKAP)"),
          TextField(
            controller: _lokasiController,
            maxLines: 2,
            decoration: InputDecoration(
              hintText: "Jl. Sudirman No. 12, Balikpapan Kota",
              hintStyle: TextStyle(color: Colors.grey.shade400),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.all(16),
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 12, right: 8, top: 14),
                child: Icon(Icons.map_outlined,
                    color: Colors.grey.shade500, size: 20),
              ),
              prefixIconConstraints:
                  const BoxConstraints(minWidth: 0, minHeight: 0),
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
                borderSide:
                    const BorderSide(color: Color(0xFFC3002F), width: 1.5),
              ),
            ),
          ),
        ],
      ),
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

  // ─── Shared helpers ───────────────────────────────────────────────────────
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
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
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
}
