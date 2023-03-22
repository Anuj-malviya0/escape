import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
// class SecondPageRoute extends CupertinoPageRoute {
//   SecondPageRoute() : super(builder: (BuildContext context) => SettingsPage());

//   // OPTIONAL IF YOU WISH TO HAVE SOME EXTRA ANIMATION WHILE ROUTING
//   @override
//   Widget buildPage(BuildContext context, Animation<double> animation,
//       Animation<double> secondaryAnimation) {
//     return FadeTransition(opacity: animation, child: SettingsPage());
//   }
// }
final Uri gmail = Uri.parse("mailto:anujmalviya850@gmail.com");
final Uri github = Uri.parse("https://github.com/Anuj-malviya0/escape");



Future<void> _launchUrl(site) async {
  if (!await launchUrl(site,mode: LaunchMode.externalApplication)) {
    throw Exception('Could not launch $site');
  }
}
class ThemeModel extends ChangeNotifier {
  bool isDarkMode = false;

  ThemeModel() {
    loadTheme();
  }

  void toggleTheme(bool isDark) async {
    isDarkMode = isDark;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', isDarkMode);
  }

  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    isDarkMode = prefs.getBool('isDarkMode') ?? false;
    notifyListeners();
  }
}


class SettingsPage extends StatefulWidget {
  final ThemeModel themeModel;

  const SettingsPage({Key? key, required this.themeModel}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
    color: (Theme.of(context).brightness == Brightness.dark)? Colors.black:Colors.white, // <-- SEE HERE
  ),
        title: Text('Settings',style: TextStyle(fontFamily: "FontsFree",color: (Theme.of(context).brightness == Brightness.dark)
              ? Colors.black
              : Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,

         systemOverlayStyle: SystemUiOverlayStyle(
        // Status bar color
        statusBarColor: Colors.transparent,
        // Status bar brightness (optional)
        statusBarIconBrightness: (Theme.of(context).brightness == Brightness.dark)? Brightness.dark: Brightness.light, // For Android (dark icons)
        statusBarBrightness: Brightness.light, // For iOS (dark icons)
      ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            RadioListTile(
              activeColor: (Theme.of(context).brightness == Brightness.dark)
                    ? Colors.black
                    : Colors.white,
              title: const Text('Dark'),
              value: false,
              groupValue: !widget.themeModel.isDarkMode,
              onChanged: (bool? value) {
                if (value != null) {
                  widget.themeModel.toggleTheme(!value);
                }
              },
            ),
            RadioListTile(
              activeColor: (Theme.of(context).brightness == Brightness.dark)
                    ? Colors.black
                    : Colors.white,
              
              title: const Text('Light'),
              value: false,
              groupValue: widget.themeModel.isDarkMode,
              onChanged: (bool? value) {
                if (value != null) {
                  widget.themeModel.toggleTheme(value);
                }
              },
            ),
            const SizedBox(height: 25,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(

                children:  [
                  
                  Text('Eisenhower Decision Matrix',style: TextStyle(fontSize: 35,fontWeight: FontWeight.w500,fontFamily:'FontBold'),),
                  
                Text('The Eisenhower Decision Matrix is a productivity tool that helps individuals prioritize their tasks based on their level of urgency and importance. The matrix is divided into four categories: "Urgent and Important," "Important but Not Urgent," "Urgent but Not Important," and "Neither Urgent nor Important." By assigning each task to a category, individuals can better focus their time and energy on the most critical tasks, while avoiding distractions and unnecessary work.'
                ,style: TextStyle(fontSize:20),), Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: (Theme.of(context).brightness == Brightness.dark)
                    ? Image.asset('assets/drawing.png')
                    :  Image.asset('assets/drawing_d.png'),
                  
                ),
                Text("Escape the habit of procrastination with our app 😉.",style: TextStyle(fontFamily: 'FontBold',fontSize: 35,fontWeight: FontWeight.w500),),
                SizedBox(height: 25,),
                Row(
                  
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    FloatingActionButton.extended(heroTag: "btn1",onPressed: (){_launchUrl(github);},icon: Icon(Icons.code),label: Text("Source Code"),backgroundColor: Colors.grey[500],elevation: 0,),
                    // FloatingActionButton.extended(heroTag: "btn2",onPressed: (){_launchUrl(linkedin);},icon: Icon(Icons.inbox),label: Text("Linkedin"),),
                    FloatingActionButton.extended(heroTag: "btn2",onPressed: (){_launchUrl(gmail);},icon: Icon(Icons.mail),label: Text("Contact"),backgroundColor: Colors.grey[500],elevation: 0,)
                  ],
                )
                ],
                
              ),
            )
          ],
        ),
      ),
    );
  }
}

