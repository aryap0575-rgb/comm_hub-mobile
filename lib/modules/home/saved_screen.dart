import 'package:flutter/material.dart';

class SavedScreen extends StatelessWidget {
  const SavedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Tersimpan",
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Color(0xFFD90429),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Komunitas dan organisasi yang Anda ikuti atau tandai.",
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
          const SizedBox(height: 24),
          _communityCard(
            image: "https://picsum.photos/seed/hijau/400/200",
            category: "LINGKUNGAN",
            categoryColor: Colors.green,
            title: "Balikpapan Hijau Lestari",
            location: "Balikpapan Selatan",
            updated: "Diperbarui 2 hari lalu",
          ),
          const SizedBox(height: 16),
          _communityCard(
            image: "https://picsum.photos/seed/belajar/400/200",
            category: "PENDIDIKAN",
            categoryColor: Colors.blue,
            title: "Rumah Belajar Borneo",
            location: "Balikpapan Tengah",
            updated: "Diperbarui 1 minggu lalu",
          ),
          const SizedBox(height: 16),
          _communityCard(
            image: "https://picsum.photos/seed/relawan/400/200",
            category: "SOSIAL",
            categoryColor: Colors.orange,
            title: "Relawan Berbagi Balikpapan",
            location: "Balikpapan Utara",
            updated: "Diperbarui 3 hari lalu",
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _communityCard({
    required String image,
    required String category,
    required Color categoryColor,
    required String title,
    required String location,
    required String updated,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE57373)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(18),
                ),
                child: Image.network(
                  image,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 180,
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.image_not_supported,
                        color: Colors.grey),
                  ),
                ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Color(0xFFD90429),
                    shape: BoxShape.circle,
                  ),
                  child:
                      const Icon(Icons.bookmark, color: Colors.white, size: 20),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: categoryColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    category,
                    style: TextStyle(
                      color: categoryColor,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFD90429),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined,
                        size: 18, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(location,
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 15)),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(),
                Row(
                  children: [
                    Expanded(
                      child: Text(updated,
                          style: const TextStyle(
                              color: Colors.grey, fontSize: 13)),
                    ),
                    const Icon(Icons.delete_outline,
                        color: Color(0xFFD90429), size: 18),
                    const SizedBox(width: 4),
                    const Text(
                      "Hapus",
                      style: TextStyle(
                          color: Color(0xFFD90429),
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
