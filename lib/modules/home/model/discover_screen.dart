import 'package:flutter/material.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({Key? key}) : super(key: key);

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  String selectedCategory = 'Semua';

  final List<String> categories = [
    'Sosial & Kemanusiaan',
    'Pendidikan & Kepemudaan',
    'Keagamaan',
    'Ekonomi & Kewirausahaan',
    'Hobi & Olahraga',
    'Lingkungan',
  ];

  final List<Map<String, dynamic>> communities = [
    {
      'image': 'https://picsum.photos/seed/scholars/400/200',
      'category': 'Pendidikan',
      'name': 'Balikpapan Youth Scholars',
      'description':
          'Komunitas belajar pemuda Balikpapan yang berfokus pada pengembangan soft skills dan...',
      'members': '1.2k',
      'verified': true,
    },
    {
      'image': 'https://picsum.photos/seed/eco/400/200',
      'category': 'Lingkungan',
      'name': 'Eco-Warriors BPN',
      'description':
          'Gerakan pelestarian lingkungan pesisir Balikpapan melalui aksi nyata pembersihan pantai dan edukasi...',
      'members': '850',
      'verified': false,
    },
    {
      'image': 'https://picsum.photos/seed/creative/400/200',
      'category': 'Sosial',
      'name': 'Balikpapan Creative Hub',
      'description':
          'Wadah kolaborasi pelaku industri kreatif dan digital di Balikpapan untuk bertukar ide dan peluang bisnis...',
      'members': '2.4k',
      'verified': true,
    },
    {
      'image': 'https://picsum.photos/seed/sport/400/200',
      'category': 'Hobi & Olahraga',
      'name': 'BPN Sports Community',
      'description':
          'Komunitas olahraga aktif di Balikpapan, rutin mengadakan event lari, sepeda, dan futsal bersama...',
      'members': '980',
      'verified': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                decoration: InputDecoration(
                  hintText: 'Cari organisasi atau komunitas...',
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  fillColor: const Color(0xFFF5F5F5),
                  filled: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: categories.map((cat) {
                  final isSelected = selectedCategory == cat;
                  return GestureDetector(
                    onTap: () => setState(() => selectedCategory = cat),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color:
                            isSelected ? const Color(0xFFC6132C) : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: const Color(0xFFC6132C), width: 1),
                      ),
                      child: Text(
                        cat,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFFC6132C),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: Text(
            'Hasil Pencarian (${communities.length} found)',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Color(0xFF1F2937),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
            itemCount: communities.length,
            itemBuilder: (context, index) {
              final item = communities[index];
              return _CommunityListCard(item: item);
            },
          ),
        ),
      ],
    );
  }
}

class _CommunityListCard extends StatelessWidget {
  final Map<String, dynamic> item;
  const _CommunityListCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.network(
                  item['image'],
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 160,
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.image_not_supported,
                        color: Colors.grey),
                  ),
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFC6132C),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    item['category'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item['name'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                    ),
                    if (item['verified'])
                      const Icon(Icons.verified,
                          color: Color(0xFF22C55E), size: 18),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  item['description'],
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.people_outline,
                        size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      '${item['members']} Anggota',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const Spacer(),
                    const Icon(Icons.bookmark_border,
                        size: 20, color: Colors.grey),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFC6132C),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text(
                        'Lihat Detail',
                        style: TextStyle(fontSize: 12, color: Colors.white),
                      ),
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
