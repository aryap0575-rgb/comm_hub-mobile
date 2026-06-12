import 'package:flutter/material.dart';

class GaleriKegiatanPage extends StatefulWidget {
  const GaleriKegiatanPage({Key? key}) : super(key: key);

  @override
  State<GaleriKegiatanPage> createState() => _GaleriKegiatanPageState();
}

class _GaleriKegiatanPageState extends State<GaleriKegiatanPage> {
  static const Color primaryRed = Color(0xFFD90429);
  static const Color bgColor = Color(0xFFFAFAFC);

  int selectedCategoryIndex = 0;
  int selectedBottomIndex = 0;

  static const List<String> categories = [
    'Semua',
    'Sosial',
    'Pendidikan',
    'Lingkungan',
    'Budaya',
  ];

  static const List<GalleryItem> items = [
    GalleryItem(
      title: 'Yayasan Balikpapan Hijau',
      date: '12 Okt 2023',
      category: 'Lingkungan',
      imageUrl:
          'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?w=600',
    ),
    GalleryItem(
      title: 'Komunitas Belajar',
      date: '05 Nov 2023',
      category: 'Pendidikan',
      imageUrl:
          'https://images.unsplash.com/photo-1509062522246-3755977927d7?w=600',
    ),
    GalleryItem(
      title: 'Bersih Kota Kita',
      date: '22 Sep 2023',
      category: 'Sosial',
      imageUrl:
          'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=600',
    ),
    GalleryItem(
      title: 'Dapur Berbagi',
      date: '15 Jan 2024',
      category: 'Sosial',
      imageUrl:
          'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?w=600',
    ),
    GalleryItem(
      title: 'Young Leaders ID',
      date: '02 Feb 2024',
      category: 'Pendidikan',
      imageUrl:
          'https://images.unsplash.com/photo-1556761175-4b46a572b786?w=600',
    ),
    GalleryItem(
      title: 'Festival Budaya',
      date: '10 Feb 2024',
      category: 'Budaya',
      imageUrl:
          'https://images.unsplash.com/photo-1533174072545-7a4b6ad7a6c3?w=600',
    ),
  ];

  List<GalleryItem> get filteredItems {
    final String selectedCategory = categories[selectedCategoryIndex];

    if (selectedCategory == 'Semua') {
      return items;
    }

    return items.where((item) {
      return item.category == selectedCategory;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: primaryRed,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        titleSpacing: 0,
        title: const Text(
          'Galeri Kegiatan',
          style: TextStyle(
            color: primaryRed,
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // TODO: fitur pencarian
            },
            icon: const Icon(
              Icons.search,
              color: Color(0xFF222222),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: ClipOval(
              child: Image.network(
                'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200',
                width: 32,
                height: 32,
                fit: BoxFit.cover,
                errorBuilder: imageErrorBuilder,
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: Colors.grey.withOpacity(0.18),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 22, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CategoryFilter(
              categories: categories,
              selectedIndex: selectedCategoryIndex,
              onSelected: (index) {
                setState(() {
                  selectedCategoryIndex = index;
                });
              },
            ),
            const SizedBox(height: 28),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredItems.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 18,
                crossAxisSpacing: 14,
                childAspectRatio: 0.68,
              ),
              itemBuilder: (context, index) {
                return GalleryCard(
                  item: filteredItems[index],
                );
              },
            ),
            const SizedBox(height: 30),
            const Center(
              child: Icon(
                Icons.keyboard_arrow_down,
                size: 22,
                color: Color(0xFFB7B7B7),
              ),
            ),
            const SizedBox(height: 4),
            Center(
              child: Text(
                'Menampilkan ${filteredItems.length} dari 48 foto',
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF333333),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(
              color: primaryRed.withOpacity(0.18),
              width: 1,
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: selectedBottomIndex,
          onTap: (index) {
            setState(() {
              selectedBottomIndex = index;
            });

            // TODO: arahkan ke halaman sesuai menu
          },
          backgroundColor: Colors.white,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: primaryRed,
          unselectedItemColor: const Color(0xFF222222),
          selectedFontSize: 10,
          unselectedFontSize: 10,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w700,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Beranda',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.explore),
              label: 'Discover',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bookmark_border),
              label: 'Saved',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: 'Account',
            ),
          ],
        ),
      ),
    );
  }
}

Widget imageErrorBuilder(
  BuildContext context,
  Object error,
  StackTrace? stackTrace,
) {
  return Container(
    color: Colors.grey.shade300,
    child: const Center(
      child: Icon(
        Icons.broken_image,
        color: Colors.grey,
        size: 28,
      ),
    ),
  );
}

class CategoryFilter extends StatelessWidget {
  const CategoryFilter({
    Key? key,
    required this.categories,
    required this.selectedIndex,
    required this.onSelected,
  }) : super(key: key);

  final List<String> categories;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  static const Color primaryRed = Color(0xFFD90429);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (context, index) {
          return const SizedBox(width: 10);
        },
        itemBuilder: (context, index) {
          final bool isSelected = selectedIndex == index;

          return GestureDetector(
            onTap: () {
              onSelected(index);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 22),
              decoration: BoxDecoration(
                color: isSelected ? primaryRed : const Color(0xFFF4F6FB),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isSelected ? primaryRed : const Color(0xFFE5E8F0),
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                categories[index],
                style: TextStyle(
                  color: isSelected ? Colors.white : const Color(0xFF333333),
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class GalleryCard extends StatelessWidget {
  const GalleryCard({
    Key? key,
    required this.item,
  }) : super(key: key);

  final GalleryItem item;

  static const Color primaryRed = Color(0xFFD90429);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.grey.withOpacity(0.12),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.045),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 7,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(18),
              ),
              child: Image.network(
                item.imageUrl,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: imageErrorBuilder,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 9, 10, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title.toUpperCase(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: primaryRed,
                      fontSize: 10.5,
                      height: 1.25,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        size: 12,
                        color: Color(0xFF777777),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          item.date,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color(0xFF555555),
                            fontSize: 10.5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GalleryItem {
  final String title;
  final String date;
  final String category;
  final String imageUrl;

  const GalleryItem({
    required this.title,
    required this.date,
    required this.category,
    required this.imageUrl,
  });
}
