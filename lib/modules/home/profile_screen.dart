import 'package:flutter/material.dart';
import 'package:com.example.fincome_mobile_mobile/modules/home/daftar_komunitas_screen.dart';

class ProfileScreen extends StatelessWidget {
  final VoidCallback? onLogout;
  const ProfileScreen({Key? key, this.onLogout}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(height: 20),

          // PROFILE IMAGE
          Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFD90429), width: 3),
                ),
                child: const CircleAvatar(
                  radius: 45,
                  backgroundImage: NetworkImage("https://i.pravatar.cc/300"),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD90429),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(Icons.edit, size: 16, color: Colors.white),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // NAME
          const Text(
            "LOUDERMILK",
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          const Text(
            "loudermilk@gmail.com",
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),

          const SizedBox(height: 24),

          // LOGOUT BUTTON
          OutlinedButton.icon(
            onPressed: onLogout ?? () {},
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFFD90429),
              side: const BorderSide(color: Color(0xFFD90429), width: 2),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
            ),
            icon: const Icon(Icons.logout),
            label: const Text("Logout", style: TextStyle(fontSize: 16)),
          ),

          const SizedBox(height: 30),

          // SAVED COMMUNITY CARD
          _buildMenuCard(
            icon: Icons.bookmark_border,
            title: "Komunitas Tersimpan",
            subtitle: "Saved Community",
            backgroundColor: Colors.white,
            iconBg: const Color(0xFFF8E9EC),
          ),

          const SizedBox(height: 16),

          // REGISTER CARD
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const DaftarKomunitasScreen(),
                ),
              );
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFFD90429),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.add, color: Colors.white),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Daftarkan Komunitas Anda",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Register Your Community",
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward, color: Colors.white),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),

          // HELP CARD
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.help_outline, color: Colors.grey),
                    SizedBox(width: 10),
                    Text(
                      "Butuh bantuan?",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Padding(
                  padding: EdgeInsets.only(left: 34),
                  child: Text(
                    "Hubungi support kami via email",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 10),
                const Padding(
                  padding: EdgeInsets.only(left: 34),
                  child: Text(
                    "Contact Support ✉",
                    style: TextStyle(
                        color: Color(0xFFD90429), fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildMenuCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color backgroundColor,
    required Color iconBg,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF0D0D5)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFFD90429)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 17)),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }
}
