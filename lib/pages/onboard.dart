import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:recipeapp/pages/signup.dart';
import 'package:recipeapp/widget/content_model.dart';
import 'package:recipeapp/widget/widget_support.dart';
import 'package:video_player/video_player.dart';

class Onboard extends StatefulWidget {
  const Onboard({super.key});

  @override
  State<Onboard> createState() => _OnboardState();
}

class _OnboardState extends State<Onboard> {
  int currentIndex = 0;
  late VideoPlayerController _videoController;
  late ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    _videoController =
        VideoPlayerController.asset("assets/images/video.mp4")
          ..initialize().then((_) {
            setState(() {});
             _videoController.setVolume(0.0); // Mute the video
          })
          ..setLooping(true)
          ..play();

    _chewieController = ChewieController(
      videoPlayerController: _videoController,
      looping: true,
      autoPlay: true,
      showControls: false,
    );
  }

  @override
  void dispose() {
    _videoController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// **Arkaplanda Video**
          Positioned.fill(
            child:
                _videoController.value.isInitialized
                    ? Chewie(controller: _chewieController)
                    : Center(child: CircularProgressIndicator()),
          ),

          /// **Ön Planda Metinler ve Buton**
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.4), // Şeffaf karartma efekti
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /// **Başlık**
                  Text(
                    contents[currentIndex].title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20),

                  /// **Açıklama**
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      contents[currentIndex].description,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 40),

                  /// **Sonraki / Başla Butonu**
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (currentIndex < contents.length - 1) {
                          currentIndex++;
                        } else {
                          // Video oynatmayı durdur ve belleği temizle
                          _videoController.pause();
                          _videoController.dispose();
                          _chewieController.dispose();

                          // Yeni sayfaya yönlendir
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => Signup()),
                          );
                        }
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 40,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      currentIndex == contents.length - 1 ? "Başla" : "Sonraki",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
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
