import 'package:flutter/material.dart';
import 'package:profilescreen/widgets/widgets.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _ellipseController;

  @override
  void initState() {
    super.initState();
    // Initialize AnimationControllers
    _fadeController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..forward();

    _slideController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..forward();

    _ellipseController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    // Dispose of controllers when the widget is unmounted
    _fadeController.dispose();
    _slideController.dispose();
    _ellipseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Animated Fade In for Background Image
          AnimatedPositioned(
            duration: Duration(seconds: 2),
            curve: Curves.easeInOut,
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: Image.asset(
              'assets/images/Frame.png',
              fit: BoxFit.cover,
            ),
          ),

          // Animated Column Content
          Column(
            children: [
              const SizedBox(height: 60),
              FadeTransition(
                opacity: _fadeController,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon:
                          const Icon(Icons.arrow_back_ios, color: Colors.white),
                      onPressed: () {},
                    ),
                    const Text(
                      "Profile",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Inter',
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.share, color: Colors.white),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // Animated Container
              TweenAnimationBuilder(
                duration: Duration(seconds: 1),
                tween: Tween<double>(begin: 0.0, end: 1.0),
                builder: (context, double opacity, child) {
                  return Opacity(
                    opacity: opacity,
                    child: Container(
                      width: 340,
                      height: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: const DecorationImage(
                          image: AssetImage('assets/images/image2.png'),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),

          // Custom Ellipse Widgets with FadeIn and Slide effects
          CustomEllipse(
            width: 262.1127014160156,
            height: 262.3527526855469,
            top: 739.29,
            left: -178.57,
          ),
          AnimatedPositioned(
            duration: Duration(seconds: 2),
            curve: Curves.easeInOut,
            top: 98.96,
            left: -153.6,
            child: CustomEllipse(
              width: 262.1127014160156,
              height: 262.3527526855469,
              opacity: 0.2,
              blurRadius: 10,
            ),
          ),
          AnimatedPositioned(
            duration: Duration(seconds: 2),
            curve: Curves.easeInOut,
            top: 130.35,
            left: 233.96,
            child: CustomEllipse(
              width: 262.1127014160156,
              height: 262.3527526855469,
              opacity: 0.9,
            ),
          ),

          // Draggable Form with Fade In
          FadeTransition(
            opacity: _fadeController,
            child: DraggableFormCard(
              nameController: nameController,
              ageController: ageController,
              locationController: locationController,
            ),
          ),

          // Slide to Act Button with Slide Animation
          Positioned(
            bottom: 10,
            left: 20,
            right: 20,
            child: SlideTransition(
              position: Tween<Offset>(begin: Offset(0, 1), end: Offset(0, 0))
                  .animate(_slideController),
              child: SlideToActButton(
                labelText: 'Let’s save and roll!',
                onSubmit: () async {
                  print("Action Completed!");
                },
                backgroundColor: Color.fromRGBO(109, 88, 247, 1),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
