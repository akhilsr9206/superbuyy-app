import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import 'package:superbuyy/screens/month/month_screen.dart';
import 'package:superbuyy/screens/week/week_screen.dart';

import '../provider/dark_theme_provider.dart';
import '../widgets/text_widget.dart';

class ListScreen extends StatelessWidget {
  static const routeName = '/ListScreen';
  const ListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    final Color color = themeState.getDarkTheme ? Colors.white : Colors.black;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: RichText(
                    text: const TextSpan(
                      text: 'My Lists',
                      style: TextStyle(
                        color: Colors.cyan,
                        fontSize: 27,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                const SizedBox(height: 20),
                const Divider(thickness: 2),
                const SizedBox(height: 20),
                _listTiles(
                  title: 'Monthly Lists',
                  icon: IconlyBold.document,
                  onPressed: () {
                    Navigator.pushNamed(context, MonthlistScreen.routeName);
                  },
                  color: color,
                ),
                const SizedBox(height: 20),
                _listTiles(
                  title: 'Weekly Lists',
                  icon: IconlyBold.document,
                  onPressed: () {
                    Navigator.pushNamed(context, WeeklistScreen.routeName);
                  },
                  color: color,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _listTiles({
    required String title,
    required IconData icon,
    required Function onPressed,
    required Color color,
  }) {
    return ListTile(
      title: TextWidget(
        text: title,
        color: color,
        textSize: 22,
      ),
      leading: Icon(icon),
      trailing: const Icon(IconlyLight.arrowRight2),
      onTap: () {
        onPressed();
      },
    );
  }
}
