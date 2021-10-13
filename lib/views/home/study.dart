import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study/components/s_button.dart';
import 'package:study/providers/auth.dart';
import 'package:study/providers/language.dart';
import 'package:study/utils/colors.dart';
import 'package:study/widget/tab_navigator.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:url_launcher/url_launcher.dart';

class Study extends StatelessWidget {
  const Study({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of<Auth>(context, listen: false);
    final lesson = ModalRoute.of(context)!.settings.arguments as Lesson;
    final splitText = lesson.text.split('\n');
    final initial = splitText.removeAt(0);
    String url = YoutubePlayerController.convertUrlToId(lesson.video) ?? "";
    late YoutubePlayerController _controller = YoutubePlayerController(
      initialVideoId: url,
      params: const YoutubePlayerParams(autoPlay: false, color: "blue"),
    );
    void _launchURL(String url) async => await canLaunch(url)
        ? await launch(url)
        : throw 'Could not launch $url';
    bool load = false;

    return StatefulBuilder(builder: (context, setState) {
      finish() async {
        setState(() {
          load = true;
        });
        await auth.changeStatus(
            {"id": lesson.id, "type": "lesson", "status": "complete"}, context);
        setState(() {
          load = false;
        });
        TabNavigator.of(context).pop(context);
      }

      return SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FloatingActionButton(
                  mini: true,
                  elevation: 1,
                  // backgroundColor: Colors.transparent,
                  shape: CircleBorder(),
                  onPressed: () {
                    TabNavigator.of(context).pop(context);
                  },
                  child: Icon(Icons.chevron_left),
                ),
                Text(
                  lesson.title,
                  style: TextStyle(
                    color: Colors_Theme.blue_Theme[700],
                    fontSize: 27,
                  ),
                ),
                SizedBox()
              ],
            ),
            SizedBox(height: 20),
            Text(initial),
            SizedBox(height: 30),
            url != ''
                ? Container(
                    constraints: BoxConstraints(
                      maxWidth: 500,
                    ),
                    child: YoutubePlayerIFrame(
                      controller: _controller,
                    ),
                  )
                : SizedBox(),
            SizedBox(height: 30),
            Text(splitText.join('\n\n')),
            SizedBox(height: 25),
            Text(
              "Não pare ai!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 25),
            ...lesson.url.map(
              (e) => Column(
                children: [
                  TextButton(
                    onPressed: () {
                      _launchURL(e.toString());
                    },
                    child: Text(e.toString()),
                    style: TextButton.styleFrom(
                      primary: Colors_Theme.blue_Theme[700],
                    ),
                  ),
                  SizedBox(height: 15),
                ],
              ),
            ),
            load
                ? Container(
                    width: 40,
                    height: 40,
                    padding: const EdgeInsets.all(2.0),
                    child: const CircularProgressIndicator(),
                  )
                : s_button(
                    function: finish,
                    label: "Concluir",
                  ),
          ],
        ),
      );
    });
  }
}
