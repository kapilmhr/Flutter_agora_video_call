import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;

import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  bool _localUserJoined = false;
  bool _showStats = false;
  int _remoteUid = 0;
  List<int> remoteIds = [];
  RtcStats _stats = RtcStats();

  @override
  void initState() {
    initForAgora();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video call'),
      ),
      body: Stack(
        children: [
          getVideoWidget(),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              width: 100,
              height: 100,
              child: Center(
                child: _renderLocalPreview(),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: _showStats
          ? _statsView()
          : ElevatedButton(
        onPressed: () {
          setState(() {
            _showStats = true;
          });
        },
        child: Text("Show Stats"),
      ),
    );
  }

  Widget _statsView() {
    return Container(
      padding: EdgeInsets.all(20),
      color: Colors.white,
      child: _stats.cpuAppUsage == null
          ? CircularProgressIndicator()
          : Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("CPU Usage: " + _stats.cpuAppUsage.toString()),
          Text("Duration (seconds): " + _stats.totalDuration.toString()),
          Text("People on call: " + _stats.users.toString()),
          ElevatedButton(
            onPressed: () {
              _showStats = false;
              _stats.cpuAppUsage = null;
              setState(() {});
            },
            child: Text("Close"),
          )
        ],
      ),
    );
  }

  // current user video
  Widget _renderLocalPreview() {
    if (_localUserJoined) {
      return RtcLocalView.SurfaceView();
    } else {
      return Text(
        'Please join channel first',
        textAlign: TextAlign.center,
      );
    }
  }

  // remote user video
  Widget _renderRemoteVideo() {
    if (_remoteUid != 0) {
      return RtcRemoteView.SurfaceView(uid: _remoteUid);
    } else {
      return Text(
        'Please wait remote user join',
        textAlign: TextAlign.center,
      );
    }
  }

  Future<void> initForAgora() async {
    // retrieve permissions
    await [Permission.microphone, Permission.camera].request();

    // create the engine for communicating with agora
    RtcEngine engine = await RtcEngine.create(appId);

    // set up event handling for the engine
    engine.setEventHandler(RtcEngineEventHandler(
      joinChannelSuccess: (String channel, int uid, int elapsed) {
        print('$uid successfully joined channel: $channel ');
        setState(() {
          _localUserJoined = true;
        });
      },
      userJoined: (int uid, int elapsed) {
        print('remote user $uid joined channel');
        setState(() {
          remoteIds.add(uid);
          _remoteUid = uid;
        });
      },
      userOffline: (int uid, UserOfflineReason reason) {
        print('remote user $uid left channel');
        setState(() {
          remoteIds.remove(uid);
          _remoteUid = 0;
        });
      },
      rtcStats: (stats) {
        //updates every two seconds
        if (_showStats) {
          _stats = stats;
          setState(() {});
        }
      },
    ));
    // enable video
    await engine.enableVideo();

    await engine.joinChannel(token, 'video', null, 0);
  }

  Widget getVideoWidget() {
    if(remoteIds.length <= 2){
      return Column(
        children: [
          ...remoteIds.map((e) {
            return Expanded(child: RtcRemoteView.SurfaceView(uid: e));
          })
        ],
      );
    }else if(remoteIds.length > 2){
      return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (_, index) => Expanded(child: RtcRemoteView.SurfaceView(uid: remoteIds[index])),
        itemCount: remoteIds.length,
      );
    }else{
      return Center(
        child: Text(
          'Please wait remote user join',
          textAlign: TextAlign.center,
        ),
      );

    }
  }
}
const appId = "add-app-Id";
const token = "add-video-token";

