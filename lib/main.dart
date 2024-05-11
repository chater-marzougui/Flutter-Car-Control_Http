import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_sensors/flutter_sensors.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Car Controller',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}
double screenHeight = 0,screenWidth = 0;

double _speed = 0;
double _showSpeed = (_speed/1.8).roundToDouble()/10;
String commonssid = "Infinix7" ;
String commonpass = "12345678";


class InputPage extends StatefulWidget {
  const InputPage({Key? key}) : super(key: key);

  @override
  // _InputPageState createState() => _InputPageState();
  State<InputPage> createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  final TextEditingController ssid = TextEditingController();
  final TextEditingController pass = TextEditingController();
  bool _showPassword = false;
  bool remember = false;

  void sendCommand(String command, String ssid, String pass) async {
    if (ssid.isEmpty){ssid = commonssid;}
    pass = (pass == "") ? commonpass : pass;
    Map<String, String> query = {'ssid': ssid, 'password': pass};
    var url = Uri.http("192.168.4.1", '/$command', query);
    //print(url);
    try {
      await http.get(url);
    } catch (e) {
      // Handle exceptions
    }
  }

  void _changePage() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MyHomePage()),
    );
    sendCommand('Wifi', ssid.text, pass.text);
    if (remember == true && ssid.text.isNotEmpty){
      commonpass = pass.text; // Get text from pass
      commonssid = ssid.text;}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connect to ESP Device'),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: 20),
              const Text(
                "Please connect to ESP-chater-HotSpot with the password: 12345678",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              const Text(
                "Enter the Wi-Fi details you want the ESP to connect to:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              TextField(
                controller: ssid,
                decoration: const InputDecoration(
                  labelText: 'Wi-Fi Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.wifi),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: pass,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _showPassword ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _showPassword = !_showPassword;
                      });
                    },
                  ),
                ),
                obscureText: !_showPassword,
              ),
              Row(
                children: [
                  Checkbox(
                    value: remember,
                    onChanged: (bool? value) {
                      setState(() {
                        remember = value ?? false;
                      }
                      );
                    },
                  ),
                  const Text('Remember Wifi'),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  //textStyle: const TextStyle(fontSize: 50),
                ),
                onPressed: _changePage,
                child: const Text('Connect',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController ipController = TextEditingController();

  void sendCommand(String command , int speed) async {
    Map<String , String> query = { 'turnon':speed.toString()};
    var url = Uri.http(ipController.text, '/$command',query);
    try {
      print(url);
      await http.get(url);
    } catch (e) {
      // Handle exceptions
      //await http.get(url);
      //print(e);
    }
  }
  void _changePage() async{
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ControlPage(ip: ipController.text)),
    );
    sendCommand('led', 1);
    await Future.delayed(const Duration(seconds: 2));
    sendCommand('led', 0);
  }
  var list = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leadingWidth: 90,
        foregroundColor: Colors.red,
        elevation: 0,
        toolbarHeight: 60,
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("lib/images/peakpx.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 300),
              TextField(
                controller: ipController,
                decoration: InputDecoration(
                  hintText: "Wait for E-mail",
                  labelText: 'IP Address',
                  labelStyle: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  hintStyle: const TextStyle(color: Colors.red, fontSize: 18, fontWeight: FontWeight.bold),
                  prefixIcon: const Icon(Icons.web, color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.red),
                  ),
                ),
                keyboardType: TextInputType.text,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: _changePage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    "Let's GO!!!",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                    ),
                  ),
                ),
                const SizedBox(height: 200),
                ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const InputPage(),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey,
                    padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    "change wifi password",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ControlPage extends StatefulWidget {
  final String ip;
  const ControlPage({super.key, required this.ip});

  @override
  State<ControlPage> createState() => _ControlPageState();
}

class _ControlPageState extends State<ControlPage> {
  bool isClicked = false;
  bool isClickedup = false;
  bool isClickedback = false;
  bool isClickedleft = false;
  bool isClickedright = false;
  bool turnL90 = false;
  bool turnR90 = false;
  int led(bool click){return click == true? 0 : 1;}

  int move(bool one, bool two){
    int mov = 0;
    if (one == true && two == false){mov = 1;}
    else if (one == false && two == true){mov = -1;}
    else if (one == two){mov = 0;}
    return mov;
  }
  void sendCommand(String command , int speed) async {
    if (command == "straightx"){isClickedleft = false;isClickedright = false;}
    if (command == "straighty"){isClickedup = false;isClickedback = false;}
    if (command == "stop"){isClickedleft = false;isClickedright = false;isClickedup = false;isClickedback = false;}
    if (command == "up") {isClickedup = true;isClickedback = false;}
    if (command == "back") {isClickedback = true;isClickedup = false;}
    if (command == "left") {isClickedleft = true;isClickedright = false;}
    if (command == "right") {isClickedright = true;isClickedleft = false;}
    int yaxis = move(isClickedup,isClickedback);
    int xaxis = move(isClickedright,isClickedleft);
    Map<String , String> query = { 'speed':speed.toString() , 'yaxis' : yaxis.toString() , 'xaxis' : xaxis.toString() };
    var url = Uri.http(widget.ip, '/MOVE',query);
    if(command == "led"){url = Uri.http(widget.ip, '/led', {"turnon" : led(isClicked).toString()});}
    print(url);
      await http.get(url);
  }

  void turningCommand(String command) async {
    int c = command == 'right' ? 1 : 0 ;
    c = command == 'left' ? -1 : c ;
    Map<String , String> query = { 'side':command } ;
    var url = Uri.http(widget.ip, '/turn',query);
    if(command == "led"){url = Uri.http(widget.ip, '/led', {"turnon" : led(isClicked).toString()});}
    try {
      print(url);
      await http.get(url);
    } catch (e) {
      // Handle exceptions
      //await http.get(url);
      //print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(backgroundColor: Colors.transparent,leadingWidth: 90,
        foregroundColor: Colors.red,elevation: 0,toolbarHeight: 60,
      ),
      body: Stack(
        children:[
          RotatedBox(
            quarterTurns: 1,
            child: Container(
              decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("lib/images/carint2.png"),
                fit: BoxFit.fitWidth,
              ),
            ),),
          ),
          Padding(
          padding: const EdgeInsets.all(8.0),
          child:Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RotatedBox(
                    quarterTurns: 1, // Rotate the slider 90 degrees
                    child: SizedBox(
                      width: 400,
                      height: 80,
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          trackHeight: 6.0, // Custom track height
                          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 13.0),
                          thumbColor: Colors.lightBlueAccent,
                          activeTrackColor: Colors.lightBlueAccent,
                        ),
                        child: Slider.adaptive(
                          value: _speed,
                          min: 0,
                          max: 255,
                          label: _speed.round().toString(),
                          onChanged: (double value) {
                            setState(() {
                              _speed = value;
                              _showSpeed = (_speed/1.8).roundToDouble()/10;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      child: DecoratedBox(decoration: BoxDecoration(color: isClickedback ? Colors.white.withOpacity(0.4) : Colors.transparent,
                          borderRadius: BorderRadius.circular(120)),
                        child: const Icon(Icons.arrow_back_outlined,size: 120,
                          color :Colors.lightBlueAccent,
                        ),
                      ),
                      onLongPressDown:(command) => {setState(() {
                        isClickedback = true;
                      }),
                        sendCommand('back',_speed.toInt())},
                      onTap: () => {setState(() {
                        isClickedback = true;
                      }),sendCommand('straighty',_speed.toInt())},
                      onLongPressEnd: (command) => {setState(() {
                        isClickedback = false;
                      }),sendCommand('straighty',_speed.toInt())},
                      //on
                    ),
                    Stack(
                        children: [
                          const SizedBox(height: 120,),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => GyroControlPage(ip: widget.ip)),
                                );
                              });
                            },
                            child: RotatedBox(
                              quarterTurns: 1,
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                width: 100,
                                height: 50,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: isClicked ? Colors.blue : Colors.redAccent,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: const Text(
                                  "Gyro Mode",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),

                        ]
                    ),
                    GestureDetector(
                      child: DecoratedBox(decoration: BoxDecoration(color: isClickedleft ? Colors.white.withOpacity(0.4) : Colors.transparent
                          ,borderRadius: BorderRadius.circular(140)),
                          child: const Icon(Icons.arrow_upward_outlined,size: 140,
                            color :Colors.lightBlueAccent,)
                      ),
                      onLongPressDown:(command) => {setState(() {
                        isClickedleft = true;
                      }),
                        sendCommand('left',_speed.toInt())},
                      onTap: () => {setState(() {
                        isClickedleft = true;
                      }),sendCommand('straightx',_speed.toInt())},
                      onLongPressEnd: (command) => {setState(() {
                        isClickedleft = false;
                      }),sendCommand('straightx',_speed.toInt())},
                    ),
                    GestureDetector(
                      child: DecoratedBox(decoration: BoxDecoration(color: isClickedright ? Colors.white.withOpacity(0.4) : Colors.transparent
                          ,borderRadius: BorderRadius.circular(140)),
                        child: const Icon(Icons.arrow_downward_outlined,size: 140,
                          color :Colors.lightBlueAccent,
                        ),
                      ),
                      onLongPressDown:(command) => {setState(() {
                        isClickedright = true;
                      }),
                        sendCommand('right',_speed.toInt())},
                      onTap: () => {setState(() {
                        isClickedright = true;
                      }),sendCommand('straightx',_speed.toInt())},
                      onLongPressEnd: (command) => {setState(() {
                        isClickedright = false;
                      }),sendCommand('straightx',_speed.toInt())},
                    ),
                  ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onLongPressDown:(command) => {setState(() {
                      isClickedup = true;
                    }),
                      sendCommand('up',_speed.toInt())},
                    onTap: () => {setState(() {
                      isClickedup = true;
                    }),sendCommand('straighty',_speed.toInt())},
                    onLongPressEnd: (command) => {setState(() {
                      isClickedup = false;
                    }),sendCommand('straighty',_speed.toInt())},
                    child: DecoratedBox(decoration: BoxDecoration(color: isClickedup ? Colors.white.withOpacity(0.4) : Colors.transparent
                        ,borderRadius: BorderRadius.circular(120)),
                      child: const Icon(Icons.arrow_forward_outlined,size: 120,
                        color :Colors.lightBlueAccent,
                      ),
                    ),
                  ),
                  RotatedBox(
                    quarterTurns: 1,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 160,
                      height: 70,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: _showSpeed <= 1.4 ? Colors.blue :
                        _showSpeed <= 2.8 ? Colors.lightBlue :
                        _showSpeed <= 4.2 ? Colors.lightGreen :
                        _showSpeed <= 5.6 ? Colors.yellowAccent :
                        _showSpeed <= 7.0 ? Colors.orange :
                        _showSpeed <= 8.4 ? Colors.deepOrange :
                        _showSpeed <= 9.8 ? Colors.redAccent :
                        _showSpeed <= 11.2 ? Colors.red :
                        _showSpeed <= 12.6 ? Colors.red[700] :
                        Colors.red[900],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text("$_showSpeed Km/h",
                        style: const TextStyle(
                          color: Colors.white, // Change this color to your desired color
                          fontWeight: FontWeight.bold,
                          fontSize: 26,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTapDown: (_) {
                      setState(() {
                        turnL90 = true;
                      });
                      turningCommand("right");
                    },
                    onTapUp: (_) {
                      setState(() {
                        turnL90 = false;
                      });
                      // Your additional logic here
                      turningCommand('straight');
                    },
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: turnL90 ? Colors.white.withOpacity(0.4) : Colors.transparent,
                        borderRadius: BorderRadius.circular(120),
                      ),
                      child: const Icon(
                        Icons.keyboard_double_arrow_up_outlined,
                        size: 120,
                        color: Colors.lightBlueAccent,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTapDown: (_) {
                      setState(() {
                        turnR90 = true;
                      });
                      turningCommand("left");
                    },
                    onTapUp: (_) {
                      setState(() {
                        turnR90 = false;
                      });
                      // Your additional logic here
                      turningCommand('straight');
                    },
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: turnR90 ? Colors.white.withOpacity(0.4) : Colors.transparent,
                        borderRadius: BorderRadius.circular(120),
                      ),
                      child: const Icon(
                        Icons.keyboard_double_arrow_down_outlined,
                        size: 120,
                        color: Colors.lightBlueAccent,
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

class GyroControlPage extends StatefulWidget {
  final String ip;
  const GyroControlPage({super.key, required this.ip});

  @override
  State<GyroControlPage> createState() => _GyroControlPageState();
}

class _GyroControlPageState extends State<GyroControlPage> {
  bool turnL90 = false;
  bool turnR90 = false;
  bool toMove = false;
  bool isEnabled = false;
  bool isClicked = false;
  late Timer _commandTimer;
  double _accelData = 0.0;
  Uri lasturl = Uri.http("192.0.0.1");
  StreamSubscription? _accelSubscription;

  int led(bool click){return click == true? 0 : 1;}
  int move(bool one, bool two){
    int mov = 0;
    if (one == true && two == false){mov = 1;}
    else if (one == false && two == true){mov = -1;}
    else if (one == two){mov = 0;}
    return mov;
  }
  void sendCommand(double yrot , int speed) async {
    int x = yrot.ceil();
    x = x.abs() <8 ? 0 : x;
    int leftMspeed = x < 0 ? speed + x : speed;
    int rightMspeed = x > 0 ? speed - x : speed;
    Map<String , String> query = { 'RightMspeed':rightMspeed.toString() ,'LeftMspeed':leftMspeed.toString()};
    var url = Uri.http(widget.ip, '/GyroMOVE',query);
    if (lasturl != url){
      //await http.get(url);
      print(url);
    }
    lasturl = url ;
  }
  Future<void> _startAccelerometer() async {
    if (_accelSubscription != null) return;
    final stream = await SensorManager().sensorUpdates(
      sensorId: Sensors.ACCELEROMETER,
      interval: Sensors.SENSOR_DELAY_GAME,
    );
    _accelSubscription = stream.listen((sensorEvent) {
      setState(() {
        _accelData = sensorEvent.data[1] * (_speed/10) ;
      });
    });
  }

  void _stopAccelerometer() {
    if (_accelSubscription == null) return;
    _accelSubscription?.cancel();
    _accelSubscription = null;
  }

  void turningCommand(String command) async {
    int c = command == 'right' ? 1 : 0 ;
    c = command == 'left' ? -1 : c ;
    Map<String , String> query = { 'side':c.toString()} ;
    var url = Uri.http(widget.ip, '/turn',query);
    if(command == "led"){url = Uri.http(widget.ip, '/led', {"turnon" : led(isClicked).toString()});}
    if(command == "speed"){url = Uri.http(widget.ip, '/changespeed', {"speed" : _speed.toInt().toString()});}
    print(url);
    try {
      await http.get(url);
    }catch(e){
      print(e);
    }
  }

  @override
  void initState() {
    _startAccelerometer();
    _commandTimer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      if (isEnabled || toMove) {
        sendCommand(_accelData, _speed.toInt());
      }
    });
    super.initState();
  }
  @override
  void dispose() {
    _stopAccelerometer();
    _commandTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(backgroundColor: Colors.transparent,leadingWidth: 90,
        foregroundColor: Colors.red,elevation: 0,toolbarHeight: 60,
      ),
      body: Stack(
        children:[
          GestureDetector(
            onTapDown: (_) {
              setState(() {
                toMove = true;
              });
            },
            onTapUp: (_) {
              setState(() {
                toMove = false;
              });
            },
          ),
          RotatedBox(
            quarterTurns: 1,
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("lib/images/carint2.png"),
                  fit: BoxFit.fitWidth,
                ),
              ),),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child:Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                RotatedBox(
                  quarterTurns: 1, // Rotate the slider 90 degrees
                  child: SizedBox(
                    width: 400,
                    height: 88,
                    child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 6.0, // Custom track height
                        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 13.0),
                        thumbColor: Colors.lightBlueAccent,
                        activeTrackColor: Colors.lightBlueAccent,
                      ),
                      child: Slider.adaptive(
                        value: _speed,
                        min: 0,
                        max: 255,
                        label: _speed.round().toString(),
                        onChanged: (double value) {
                          setState(() {
                            _speed = value;
                            _showSpeed = (_speed/1.8).roundToDouble()/10;
                            turningCommand("speed");
                          });
                        },
                      ),
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const SizedBox(width: 50,height: 100),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ControlPage(ip: widget.ip)),
                          );
                        });
                      },
                      child: RotatedBox(
                        quarterTurns: 1,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: 100,
                          height: 50,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            "Button Control",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isEnabled = !isEnabled;
                        });
                      },
                      child: RotatedBox(
                        quarterTurns: 1,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: 100,
                          height: 50,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: isEnabled ? Colors.redAccent : Colors.blue,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            "Lock",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTapDown: (_) {
                        setState(() {
                          turnL90 = true;
                        });
                        turningCommand("left");
                      },
                      onTapUp: (_) {
                        setState(() {
                          turnL90 = false;
                        });
                        turningCommand('straight');
                      },
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: turnL90 ? Colors.white.withOpacity(0.4) : Colors.transparent,
                          borderRadius: BorderRadius.circular(120),
                        ),
                        child: const Icon(
                          Icons.keyboard_double_arrow_up_outlined,
                          size: 120,
                          color: Colors.lightBlueAccent,
                        ),
                      ),
                    ),
                    RotatedBox(
                      quarterTurns: 1,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: 160,
                        height: 70,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: _showSpeed <= 1.4 ? Colors.blue :
                          _showSpeed <= 2.8 ? Colors.lightBlue :
                          _showSpeed <= 4.2 ? Colors.lightGreen :
                          _showSpeed <= 5.6 ? Colors.yellowAccent :
                          _showSpeed <= 7.0 ? Colors.orange :
                          _showSpeed <= 8.4 ? Colors.deepOrange :
                          _showSpeed <= 9.8 ? Colors.redAccent :
                          _showSpeed <= 11.2 ? Colors.red :
                          _showSpeed <= 12.6 ? Colors.red[700] :
                          Colors.red[900],
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text("$_showSpeed Km/h",
                          style: const TextStyle(
                            color: Colors.white, // Change this color to your desired color
                            fontWeight: FontWeight.bold,
                            fontSize: 26,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTapDown: (_) {
                        setState(() {
                          turnR90 = true;
                        });
                        turningCommand("right");
                      },
                      onTapUp: (_) {
                        setState(() {
                          turnR90 = false;
                        });
                        turningCommand('straight');
                      },
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: turnR90 ? Colors.white.withOpacity(0.4) : Colors.transparent,
                          borderRadius: BorderRadius.circular(120),
                        ),
                        child: const Icon(
                          Icons.keyboard_double_arrow_down_outlined,
                          size: 120,
                          color: Colors.lightBlueAccent,
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