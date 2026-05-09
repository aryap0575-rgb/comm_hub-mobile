import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../utils/constants.dart';
import '../../../utils/k_images.dart';
import '../main_controller.dart';

class MyBottomNavigationBar extends StatelessWidget {
  const MyBottomNavigationBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = MainController();
    return Material(
      elevation: 9,
      color: const Color(0x00ffffff),
      shadowColor: blackColor,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        child: StreamBuilder(
          initialData: 0,
          stream: controller.naveListener.stream,
          builder: (_, AsyncSnapshot<int> index) {
            int selectedIndex = index.data ?? 0;
            return BottomNavigationBar(
              showUnselectedLabels: true,
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.white,

              selectedLabelStyle:
                  const TextStyle(fontSize: 14, color: redColor),
              unselectedLabelStyle:
                  const TextStyle(fontSize: 14, color: Color(0xff85959E)),
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(Kimages.homeIcon,
                      color: selectedIndex == 0 ? redColor : paragraphColor),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(Kimages.inboxIcon,
                      color: selectedIndex == 1 ? redColor : paragraphColor),
                  label: 'Inbox',
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(Kimages.orderIcon,
                      color: selectedIndex == 2 ? redColor : paragraphColor),
                  label: 'Order',
                ),
                BottomNavigationBarItem(
                  tooltip: 'Profile',
                  activeIcon:
                      SvgPicture.asset(Kimages.profileIcon, color: redColor),
                  icon: SvgPicture.asset(Kimages.profileIcon,
                      color: paragraphColor),
                  label: 'Profile',
                ),
              ],
              // type: BottomNavigationBarType.fixed,
              currentIndex: selectedIndex,
              onTap: (int index) {
                controller.naveListener.sink.add(index);
              },
            );
          },
        ),
      ),
    );
  }
}
