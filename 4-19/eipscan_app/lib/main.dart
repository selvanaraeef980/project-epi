import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:eipscan_app/CameraWithRtmp.dart';
import 'package:eipscan_app/Dises.dart';
import 'package:eipscan_app/SettingScreen.dart';
import 'package:eipscan_app/accountPage.dart';
import 'package:eipscan_app/signup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
// ignore: unused_import
import 'information_page.dart';
import 'SettingScreen.dart';
import 'NotificationPage.dart';
import 'onboarding_page_model.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:camera/camera.dart';
import 'package:dio/dio.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initNotifications();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

Future<void> _initNotifications() async {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: OnboardingScreen(), 
    );
  }
}

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  List<OnboardingPageModel> onboardingPages = [
    OnboardingPageModel(
      imagePath: "assets/images/Health professional team-bro.png",
      title: "Episcan",
      description:
          "Begin your wellness journey today with Episcan, your trusted health partner.",
    ),
    OnboardingPageModel(
      imagePath: "assets/images/Virus-bro.png",
      title: "Early Cancer Screening",
      description:
          "Discover early signs of cancer with simple steps through our screening feature.",
    ),
    OnboardingPageModel(
      imagePath: "assets/images/Time management-pana.png",
      title: "Treatment Alarms",
      description:
          "Receive timely notifications for your treatment schedules, making sure you never miss a dose with our reminder system.",
    ),
    OnboardingPageModel(
      imagePath: "assets/images/Questions-pana.png",
      title: "General Information",
      description:
          "Explore detailed information on 7 types of cancer, understanding the differences and specifics of each to empower your knowledge.",
    )
  ];

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 229, 216),
      body: Column(
        children: [
          Container(
            height: screenHeight * 0.10,
          ),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: onboardingPages.length,
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
              },
              itemBuilder: (context, index) {
                return buildOnboardingPage(onboardingPages[index], context);
              },
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 30, top: 50),
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (_currentPage != onboardingPages.length - 1)
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {
                        _pageController.nextPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeIn,
                        );
                      },
                      child:
                          Text('Next', style: TextStyle(color: Colors.black)),
                    ),
                  ),
                if (_currentPage == onboardingPages.length - 1)
                  _buildButton(
                    label: 'Start Now',
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildOnboardingPage(
      OnboardingPageModel pageModel, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            pageModel.imagePath,
            height: _calculateImageHeight(context),
            width: _calculateImageWidth(context),
            fit: BoxFit.cover,
          ),
          SizedBox(height: 30),
          Text(
            pageModel.title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 15),
          Text(
            pageModel.description,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  double _calculateImageHeight(BuildContext context) {
    if (_currentPage == 2 || _currentPage == 3) {
      return MediaQuery.of(context).size.height * 0.3;
    } else {
      return MediaQuery.of(context).size.height * 0.4;
    }
  }

  double _calculateImageWidth(BuildContext context) {
    if (_currentPage == 2 || _currentPage == 3) {
      return MediaQuery.of(context).size.width * 0.6;
    } else {
      return MediaQuery.of(context).size.width * 0.8;
    }
  }

  Widget _buildButton(
      {required String label, required VoidCallback onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromARGB(255, 208, 120, 4),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
      ),
      child: Text(label, style: TextStyle(fontSize: 16)),
    );
  }
}

class OnboardingPageModel {
  final String imagePath;
  final String title;
  final String description;

  OnboardingPageModel({
    required this.imagePath,
    required this.title,
    required this.description,
  });
}

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 229, 216),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 100.0),
              Image.asset(
                'assets/images/1.png',
                width: 300.0,
                height: 250.0,
              ),
              const SizedBox(height: 30.0),
              const Text(
                'EIPSCAN',
                style: TextStyle(
                  color: Color.fromARGB(255, 231, 111, 13),
                  fontSize: 50,
                  fontFamily: 'Protest Revolution',
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 40.0),
              _buildButton(
                context: context,
                label: 'Login',
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginForm()),
                ),
              ),
              SizedBox(height: 20.0),
              _buildButton(
                context: context,
                label: 'Sign up',
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpForm()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton(
      {required BuildContext context,
      required String label,
      required VoidCallback onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: _buttonStyle(),
      child: Text(
        label,
        style: TextStyle(fontSize: 24),
      ),
    );
  }

  ButtonStyle _buttonStyle() {
    return ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
      minimumSize: const Size(200, 60),
      backgroundColor: Color.fromARGB(255, 208, 120, 4),
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      elevation: 10,
    ).copyWith(
      overlayColor: MaterialStateProperty.resolveWith<Color?>(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.pressed)) {
            return Colors.deepOrange[700];
          }
          return null;
        },
      ),
    );
  }
}

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Sign Up'),
          backgroundColor: Colors.deepOrange,
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            height: MediaQuery.of(context).size.height - 50,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Column(
                  children: const <Widget>[
                    SizedBox(height: 60.0),
                    Text(
                      "Sign up",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Create your account",
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    )
                  ],
                ),
                SignUpForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: LoginFormFields(onLoginSuccess: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Firstpage()),
          );
        }),
      ),
    );
  }
}

// ignore: must_be_immutable

class LoginFormFields extends StatefulWidget {
  final Function onLoginSuccess;

  const LoginFormFields({Key? key, required this.onLoginSuccess})
      : super(key: key);

  @override
  _LoginFormFieldsState createState() => _LoginFormFieldsState();
}

class _LoginFormFieldsState extends State<LoginFormFields> {
  String? email;
  String? password;

  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Align(
            alignment: Alignment.topCenter,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              width: double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const SizedBox(height: 20.0),
                  const Text(
                    "Login",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Welcome back!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 50.0),
                  TextField(
                    onChanged: (value) {
                      email = value;
                    },
                    decoration: _textFieldDecoration(
                      hintText: 'Email',
                      icon: Icons.email,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  TextField(
                    onChanged: (value) {
                      password = value;
                    },
                    obscureText: true,
                    decoration: _textFieldDecoration(
                      hintText: 'Password',
                      icon: Icons.lock,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  _forgotPassword(context),
                  const SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        final UserCredential userCredential =
                            await auth.signInWithEmailAndPassword(
                                email: email!, password: password!);
                        if (userCredential.user != null) {
                          widget.onLoginSuccess();
                        }
                      } on FirebaseAuthException catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(e.message ?? "An error occurred")),
                        );
                      }
                    },
                    child: const Text("Login", style: TextStyle(fontSize: 20)),
                    style: _buttonStyle(),
                  ),
                  const SizedBox(height: 20.0),
                  _signup(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _textFieldDecoration(
      {required String hintText, required IconData icon}) {
    return InputDecoration(
      hintText: hintText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: Colors.grey.shade800, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: Colors.deepOrange.shade800, width: 2),
      ),
      filled: true,
      fillColor: Colors.grey.shade200,
      prefixIcon: Icon(icon, color: Color.fromRGBO(136, 83, 3, 1)),
    );
  }

  ButtonStyle _buttonStyle() {
    return ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
      minimumSize: const Size(200, 60),
      backgroundColor: Colors.orange,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ).copyWith(
      overlayColor: MaterialStateProperty.resolveWith<Color?>(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.pressed)) {
            return Colors.deepOrange;
          }
          return null;
        },
      ),
    );
  }

  Widget _forgotPassword(BuildContext context) {
    return TextButton(
      onPressed: () => _showForgotPasswordDialog(context),
      child: const Text(
        "Forgot password?",
        style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
      ),
    );
  }

  void _showForgotPasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String? resetEmail;
        return AlertDialog(
          title: Text("Forgot Password"),
          content: TextField(
            onChanged: (value) {
              resetEmail = value;
            },
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(hintText: "Enter your email"),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Send"),
              onPressed: () {
                if (resetEmail != null) {
                  _sendPasswordResetLink(resetEmail!);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _sendPasswordResetLink(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Password reset link has been sent to your email")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred. Please try again")),
      );
    }
  }

  Widget _signup(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SignUpForm()),
        );
      },
      child: RichText(
        textAlign: TextAlign.center,
        text: const TextSpan(
          text: 'Don\'t have an account? ',
          style: TextStyle(
            color: Colors.black,
            fontSize: 15,
          ),
          children: <TextSpan>[
            TextSpan(
                text: 'Sign Up',
                style: TextStyle(
                    color: Colors.orange, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

class Firstpage extends StatefulWidget {
  @override
  _FirstpageState createState() => _FirstpageState();
}

class _FirstpageState extends State<Firstpage> {
  String? _selectedImagePath;
  final List<String> imageUrls = [
    "https://media.istockphoto.com/id/1637354459/photo/ovarian-cancer-cells-closeup-view-3d-illustration.jpg?s=2048x2048&w=is&k=20&c=R9HEVewfbRfz4_VD8T-nKufPFEyENCuKar9IxSoMvXw=",
    "https://media.istockphoto.com/id/2135551600/photo/car-t-cell-therapy-in-non-hodgkin-lymphoma-closeup-view-3d-illustration.webp?s=2048x2048&w=is&k=20&c=1Sqa6eSxnPZOY8XgPmaLxVXfvOyAvUDO212QcxDanF0=",
    "https://media.istockphoto.com/id/1204174267/photo/virus-infected-blood-cells.jpg?s=2048x2048&w=is&k=20&c=dPAh_fIGeOAguPPxs5Pps2ou-zNQAwG39QZJuCp4CHc=",
    "https://media.istockphoto.com/id/522696027/photo/cancer-cell.jpg?s=2048x2048&w=is&k=20&c=kIGJ8K1H5iYIlFrJKmGtAEf2-LjyvA78XuU4goG4Cn8=",
  ];

  late Timer _timer;
  File? _selectedImage;
  String _predictionResult = '';

  final List<String> classNames = [
    'Actinic keratosis',
    'Basal Cell Carcinoma',
    'Benign Keratosis-like Lesions',
    'Dermatofibroma',
    'Melanoma',
    'Melanocytic Nevi',
    'Vascular Lesions'
  ];

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 2), (timer) {
      setState(() {});
    });
  }

  Future<void> pickImageGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        _selectedImagePath = pickedFile.path;
      });
    } else {
      print('No image selected');
    }
  }

  Future<void> captureImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        _selectedImagePath = pickedFile.path;
      });
    } else {
      print('No image captured');
    }
  }

  Future<void> uploadImage() async {
    if (_selectedImage == null) {
      print('Please select an image first!');
      return;
    }

    try {
      var dio = Dio();
      dio.options.connectTimeout = Duration(minutes: 5);

      FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(_selectedImage!.path),
      });

      var response =
          await dio.post('http://192.168.1.6:8000/upload', data: formData);

      if (response.statusCode == 200) {
        print('Image uploaded successfully!');
      } else {
        print('Error uploading image: ${response.statusCode}');
      }
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  Future<void> predictImage() async {
    if (_selectedImage == null) {
      print('Please select an image first!');
      return;
    }

    try {
      var dio = Dio();
      dio.options.connectTimeout = Duration(minutes: 5);

      FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(_selectedImage!.path),
      });

      var response =
          await dio.post('http://192.168.1.6:8000/predict', data: formData);

      if (response.statusCode == 200) {
        var data = response.data;
        setState(() {
          if (data.containsKey('prediction')) {
            _predictionResult = data['prediction'];
          } else if (data.containsKey('error')) {
            _predictionResult = data['error'];
          } else {
            _predictionResult = 'Please enter a valid image for prediction';
          }
        });
      } else {
        print('Error predicting image: ${response.statusCode}');
        setState(() {
          _predictionResult = 'Please enter a valid image for prediction';
        });
      }
    } catch (e) {
      print('Error predicting image: $e');
      setState(() {
        _predictionResult = 'Please enter a valid image for prediction';
      });
    }
  }

  void navigateToInformationPage(String prediction) {
    Widget page;
    switch (prediction) {
      case 'Actinic keratosis':
        page = ActinicKeratosisPage();
        break;
      case 'Basal Cell Carcinoma':
        page = BasalCellCarcinomaPage();
        break;
      case 'Benign Keratosis-like Lesions':
        page = KeratosisisesPage();
        break;
      case 'Dermatofibroma':
        page = DermatofibromaPage();
        break;
      case 'Melanoma':
        page = MelanomaPage();
        break;
      case 'Melanocytic Nevi':
        page = MyHomePage(title: 'Melanocytes');
        break;
      case 'Vascular lesions ':
        page = VascularlesionsPage();
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Unknown prediction: $prediction')),
        );
        return;
    }

    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 209, 207, 207),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AnimatedTextKit(
                  animatedTexts: [
                    TypewriterAnimatedText(
                      'Welcome to EPISCAN!',
                      textAlign: TextAlign.center,
                      textStyle: const TextStyle(
                        fontSize: 30.0,
                        color: Color.fromARGB(136, 54, 54, 54),
                        fontWeight: FontWeight.bold,
                      ),
                      speed: const Duration(milliseconds: 200),
                    ),
                  ],
                  pause: const Duration(milliseconds: 1000),
                ),
                const SizedBox(height: 50),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 160,
                      height: 160,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                    ),
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: _selectedImagePath != null &&
                              _selectedImagePath!.isNotEmpty
                          ? FileImage(File(_selectedImagePath!))
                          : NetworkImage(imageUrls[0]) as ImageProvider,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: pickImageGallery,
                  child: Text(
                    "Pick Image",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 40),
                    backgroundColor: Colors.orange,
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: captureImage,
                  child: Text(
                    "Camera",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 40),
                    backgroundColor: Colors.orange,
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    uploadImage();
                    predictImage();
                  },
                  child: Text(
                    "Result",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 40),
                    backgroundColor: Colors.orange,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Prediction Result: $_predictionResult',
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 10),
                if (_predictionResult.isNotEmpty)
                  ElevatedButton(
  onPressed: () => navigateToInformationPage(_predictionResult),
  child: Text(
    "More Info",
    style: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 16,
    ),
  ),
  style: ButtonStyle(
    minimumSize: MaterialStateProperty.all(Size(double.infinity, 40)),
    backgroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
      if (states.contains(MaterialState.pressed)) {
        return Colors.orange;
      }
      return Colors.grey;
    }),
  ),
),

              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: 0,
        height: 50.0,
        items: const <Widget>[
          Icon(Icons.home, size: 30, color: Colors.white),
          Icon(Icons.info, size: 30, color: Colors.white),
          Icon(Icons.alarm, size: 30, color: Colors.white),
          Icon(Icons.settings, size: 30, color: Colors.white),
        ],
        animationCurve: Curves.easeInOut,
        color: Color.fromARGB(135, 36, 36, 36),
        backgroundColor: Colors.white,
        onTap: (index) {
          print('Tapped on item $index');
          switch (index) {
            case 0:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Firstpage()),
              );
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => InformationPage()),
              );
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationPage()),
              );
              break;
            case 3:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
              break;
          }
        },
      ),
    );
  }
}
