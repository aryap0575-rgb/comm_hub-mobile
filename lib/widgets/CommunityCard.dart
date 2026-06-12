import 'package:flutter/material.dart';

class CommunityCard extends StatelessWidget {
  final String image;
  final String category;
  final String title;
  final String description;

  final VoidCallback? onSaveTap;
  final VoidCallback? onDetailTap;

  final bool isSaved;
  final bool isLoading;

  const CommunityCard({
    Key? key,
    required this.image,
    required this.category,
    required this.title,
    required this.description,
    this.onSaveTap,
    this.onDetailTap,
    this.isSaved = false,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gambar + Badge
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: Image.network(
                  image,
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 140,
                      width: double.infinity,
                      color: Colors.grey.shade200,
                      child: const Icon(
                        Icons.image_not_supported,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
              ),

              // Badge kategori
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFC6132C),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    category,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Judul
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Color(0xFF1F2937),
                  ),
                ),

                const SizedBox(height: 4),

                // Deskripsi
                Text(
                  description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 10),

                // Save + Selengkapnya
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: isLoading ? null : onSaveTap,
                      borderRadius: BorderRadius.circular(50),
                      child: Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: isSaved
                              ? const Color(0xFFC6132C).withOpacity(0.12)
                              : Colors.grey.withOpacity(0.08),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: isLoading
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Color(0xFFC6132C),
                                  ),
                                )
                              : Icon(
                                  isSaved
                                      ? Icons.bookmark
                                      : Icons.bookmark_border,
                                  size: 26,
                                  color: isSaved
                                      ? const Color(0xFFC6132C)
                                      : Colors.grey,
                                ),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: onDetailTap,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFC6132C),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text(
                        'Selengkapnya',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.white,
                        ),
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
