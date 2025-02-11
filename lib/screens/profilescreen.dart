import 'package:flutter/material.dart';
import 'package:profilescreen/widgets/widgets.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          title: "Profile",
          onBackPressed: () => onBackPressed,
          onSharePressed: onSharePressed,
        ),
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Positioned.fill(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Positioned(
                    child: Image.asset(
                      'assets/images/Frame.png',
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  Positioned(
                    top: 739,
                    left: -178,
                    child: CustomPaint(
                      size: const Size(262, 262),
                      painter: CustomEllipsePainter(
                        radius: 300,
                        color: const Color.fromRGBO(232, 204, 159, 1),
                        angle: 1,
                      ),
                    ),
                  ),
                  Positioned(top: 0, child: SquareWithConnectedBoxes()),
                  Positioned(
                    top: 98,
                    left: -153,
                    child: CustomPaint(
                      size: const Size(262, 262),
                      painter: CustomEllipsePainter(
                        radius: 300,
                        color: const Color.fromRGBO(232, 204, 159, 1),
                        angle: 1,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 130,
                    left: 233,
                    child: CustomPaint(
                      size: const Size(162, 162),
                      painter: CustomEllipsePainter(
                        radius: 300,
                        color: const Color.fromRGBO(232, 204, 159, 1),
                        angle: 0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 40,
              left: MediaQuery.of(context).size.width / 2 - 125,
              child: Container(
                width: 250,
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/image2.png'),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            DraggableFormCard(
              nameController: nameController,
              ageController: ageController,
              locationController: locationController,
            ),
            Positioned(
              bottom: 10,
              left: 20,
              right: 20,
              child: SlideToActButton(
                labelText: 'Let’s save and roll!',
                onSubmit: () async {
                  print("Action Completed!");
                },
                backgroundColor: const Color.fromRGBO(109, 88, 247, 1),
              ),
=======
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/Frame.png',
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: [
              const SizedBox(height: 60),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
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
              const SizedBox(height: 40),
              Container(
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
            ],
          ),
          CustomEllipse(
            width: 262.1127014160156,
            height: 262.3527526855469,
            top: 739.29,
            left: -178.57,
          ),
          CustomEllipse(
              width: 262.1127014160156,
              height: 262.3527526855469,
              top: 98.96,
              left: -153.6,
              opacity: 0.2,
              blurRadius: -10),
          CustomEllipse(
            width: 262.1127014160156,
            height: 262.3527526855469,
            top: 130.35,
            left: 233.96,
            opacity: 0.9,
          ),
          DraggableFormCard(
            nameController: nameController,
            ageController: ageController,
            locationController: locationController,
          ),
          Positioned(
            bottom: 10,
            left: 20,
            right: 20,
            child: SlideToActButton(
              labelText: 'Let’s save and roll!',
              onSubmit: () async {
                print("Action Completed!");
              },
              backgroundColor: Color.fromRGBO(109, 88, 247, 1),
>>>>>>> 651e59ca1366adefdaa1faca18a66e27b4234b4f
            ),
          ],
        ),
      ),
    );
  }
}
