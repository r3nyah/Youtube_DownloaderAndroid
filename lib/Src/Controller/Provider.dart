import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class DataProvider extends ChangeNotifier{
  TextEditingController UrlController = TextEditingController();
  String videoId = '';
  String videoTitle = '';
  double progress = 0;
  int value = 0;
  bool start = false;

  Future<void> getVideoInfo(url) async {
    try{
      var youtubeInfo = YoutubeExplode();
      var video = await youtubeInfo.videos.get(url);
      videoId = video.id.toString();
      videoTitle = video.title;
      notifyListeners();
    }catch(e){
      videoId = '';
      videoTitle = '';
      notifyListeners();
    }
  }

  Future<void>downloadVideo(url)async{
    var permission = await Permission.storage.request();
    if(permission.isGranted){
      progress = 0;
      start = true;
      notifyListeners();
      var youtubeExplode = YoutubeExplode();
      var video = await youtubeExplode.videos.get(url);
      var manifest = await youtubeExplode.videos.streamsClient.getManifest(url);
      var streams = value > 0
        ? manifest.audio.withHighestBitrate()
        : manifest.muxed.withHighestBitrate();
      var audio = streams;
      var audioStream = youtubeExplode.videos.streamsClient.get(audio);
      Directory? directory = await getExternalStorageDirectory();
      String appDocPath = '';
      List<String> folders = directory!.path.split('/');
      for(int x = 1;x<folders.length;x++){
        String folder = folders[x];
        if(folder != "Android"){
          appDocPath += "/" + folder;
        }else{
          break;
        }
      }
      String sc_path = value>0?'Audio':'Video';
      String homePath = appDocPath + '/Ydown/';
      appDocPath = homePath + sc_path;
      directory = Directory(homePath);
      var directory1 = Directory(appDocPath);
      if(!await directory.exists()){
        directory.create();
        directory1.create();
      }else{
        if(!await directory1.exists()){
          directory1.create();
        }
      }
      String extension = value>0?'mp3':'mp4';
      var file = File('$appDocPath/${video.title}.$extension');
      if(file.existsSync()){
        file.deleteSync();
      }
      var output = file.openWrite(mode: FileMode.writeOnlyAppend);
      var size = audio.size.totalBytes;
      var count = 0;
      await for(final data in audioStream){
        count += data.length;
        double val = ((count / size));
        progress = val;
        notifyListeners();
        output.add(data);
      }
      start = false;
      notifyListeners();
    }else{
      await Permission.storage.request();
    }
  }
}