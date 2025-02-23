import 'dart:ui';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:logger/logger.dart';

final Logger logger = Logger();

// buttons and TextField--------------------------------------------------->

Widget genderButton(String text, bool isSelected, VoidCallback onTap) {
  double baseWidth = 153;
  double selectedWidth = baseWidth + 20;

  return GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(vertical: 12),
      width: isSelected ? selectedWidth : baseWidth,
      decoration: BoxDecoration(
        color: isSelected ? Colors.green : Colors.grey[900],
        borderRadius: BorderRadius.circular(30),
      ),
      curve: Curves.easeInOut,
      alignment: Alignment.center,
      child: Text(
        text,
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
  );
}

InputDecoration buildInputDecoration(String label) {
  return InputDecoration(
    labelText: label,
    labelStyle: TextStyle(
      color: Color.fromRGBO(180, 177, 180, 1),
      fontFamily: 'Inter',
      fontSize: 14,
      fontWeight: FontWeight.w600,
    ),
    filled: true,
    fillColor: Colors.grey[900],
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(59),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: const BorderSide(color: Colors.green),
    ),
    contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  );
}

Widget customInputField(String hint, TextEditingController controller) {
  return TextField(
    controller: controller,
    style: const TextStyle(color: Colors.white, fontSize: 16),
    decoration: buildInputDecoration(hint),
  );
}

class CustomDropdownField extends StatefulWidget {
  final List<String> items;
  final TextEditingController controller;
  final String hint;
  final String svgIconPath;

  const CustomDropdownField({
    Key? key,
    required this.items,
    required this.controller,
    required this.hint,
    required this.svgIconPath,
  }) : super(key: key);

  @override
  CustomDropdownFieldState createState() => CustomDropdownFieldState();
}

class CustomDropdownFieldState extends State<CustomDropdownField>
    with SingleTickerProviderStateMixin {
  bool isExpanded = false;
  String? selectedValue;
  late AnimationController _animationController;
  late Animation<double> _heightAnimation;
  late Animation<double> _iconRotation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    double maxDropdownHeight = (widget.items.length * 48.0).clamp(0.0, 250.0);

    _heightAnimation =
        Tween<double>(begin: 0.0, end: maxDropdownHeight).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _iconRotation = Tween<double>(begin: 0.0, end: 1.4).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  void toggleDropdown() {
    setState(() {
      isExpanded = !isExpanded;
      if (isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  void selectItem(String item) {
    setState(() {
      selectedValue = item;
      widget.controller.text = item;
      toggleDropdown();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(6.0),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(14),
              bottomRight: Radius.circular(14),
            ),
            child: AnimatedBuilder(
              animation: _heightAnimation,
              builder: (context, child) {
                return SizedBox(
                  height: _heightAnimation.value,
                  child: child,
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[850],
                  borderRadius: BorderRadius.circular(30),
                ),
                child: ListView(
                  padding: EdgeInsets.only(top: 50, left: 20),
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  children: widget.items.map((String item) {
                    return ListTile(
                      title: Text(
                        item,
                        style: const TextStyle(color: Colors.white),
                      ),
                      onTap: () => selectItem(item),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: toggleDropdown,
          behavior: HitTestBehavior.opaque,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: IgnorePointer(
                    child: TextFormField(
                      controller: widget.controller,
                      readOnly: true,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        hintText: widget.hint,
                        hintStyle: const TextStyle(color: Colors.white54),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                RotationTransition(
                  turns: _iconRotation,
                  child: SvgPicture.asset(
                    widget.svgIconPath,
                    width: 18,
                    height: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// shapes eclipse boxes------------------------------------------------------------>

class PositionableBox extends StatelessWidget {
  final double? left;
  final double? right;
  final double? top;
  final double? bottom;
  final double width;
  final double height;
  final double opacity;

  const PositionableBox({
    super.key,
    this.left = 70,
    this.right = 70,
    this.top,
    this.bottom,
    this.width = 100,
    this.height = 30,
    this.opacity = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      right: right,
      top: top,
      bottom: bottom,
      child: Opacity(
        opacity: opacity,
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}

class SquareWithConnectedBoxes extends StatelessWidget {
  final double size;

  const SquareWithConnectedBoxes({
    super.key,
    this.size = 500.0,
  });

  @override
  Widget build(BuildContext context) {
    int boxesPerRow = 13;
    return Center(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            width: 1.3,
            color: Colors.transparent,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromRGBO(255, 255, 255, 0.021),
                  Color.fromRGBO(153, 153, 153, 0),
                ],
                stops: [0.0, 1.0],
              ),
            ),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: boxesPerRow,
                crossAxisSpacing: 0.0,
                mainAxisSpacing: 0.0,
              ),
              itemCount: 200,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color.fromRGBO(153, 153, 153, 0.05),
                      width: 1.0,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

// drag and  fixed forms------------------------------------------------------------------------------------>

class StaticFormCard extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController ageController;
  final TextEditingController locationController;
  final Function(String) onGenderChanged; // Callback function

  const StaticFormCard({
    super.key,
    required this.nameController,
    required this.ageController,
    required this.locationController,
    required this.onGenderChanged, // Pass callback
  });

  @override
  StaticFormCardState createState() => StaticFormCardState();
}

class StaticFormCardState extends State<StaticFormCard> {
  String selectedGender = '';

  void onGenderSelected(String gender) {
    setState(() {
      selectedGender = gender;
    });
    widget.onGenderChanged(gender); // Notify parent
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context)
            .unfocus(); // Dismiss keyboard when tapping outside
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Card(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40),
              topRight: Radius.circular(40),
            ),
          ),
          elevation: 10,
          color: Colors.black,
          child: Padding(
            padding: const EdgeInsets.all(0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 0),
                const Text(
                  "Hey, Tell me about you!",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 10),
                SvgPicture.asset(
                  'assets/svgs/Vector.svg',
                  width: 55,
                  height: 8,
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    genderButton("Male", selectedGender == "Male", () {
                      onGenderSelected("Male");
                    }),
                    const SizedBox(width: 15),
                    genderButton("Female", selectedGender == "Female", () {
                      onGenderSelected("Female");
                    }),
                  ],
                ),
                const SizedBox(height: 20),
                customInputField("Your good name", widget.nameController),
                const SizedBox(height: 15),
                customInputField("How old are you?", widget.ageController),
                const SizedBox(height: 10),
                CustomDropdownField(
                  controller: widget.locationController,
                  items: ["New York", "London", "Paris", "Tokyo", 'Mumbai'],
                  hint: "Location",
                  svgIconPath: 'assets/svgs/tabler_location-filled.svg',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// SliderButtons -------------------------------------------------------->

class SliderButton extends StatefulWidget {
  final String text;
  final VoidCallback onSlide;
  final Color backgroundColor;
  final Color sliderColor;
  final Color textColor;
  final TextStyle? textStyle;

  const SliderButton({
    super.key,
    required this.text,
    required this.onSlide,
    this.backgroundColor = Colors.grey,
    this.sliderColor = Colors.white,
    this.textColor = Colors.black,
    this.textStyle,
  });

  @override
  SliderButtonState createState() => SliderButtonState();
}

class SliderButtonState extends State<SliderButton>
    with SingleTickerProviderStateMixin {
  double _position = 0;
  bool _isCompleted = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  double _scaleValue = 1.0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 2.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );
  }

  void _resetPosition() {
    Animation<double> resetAnimation = Tween<double>(begin: _position, end: 0)
        .animate(CurvedAnimation(
            parent: _animationController, curve: Curves.easeOut));

    _animationController.duration = const Duration(milliseconds: 300);
    _animationController.reset();

    resetAnimation.addListener(() {
      setState(() {
        _position = resetAnimation.value;
      });
    });

    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    double maxWidth = MediaQuery.of(context).size.width - 80;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 600),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(scale: animation, child: child),
        );
      },
      child: _isCompleted
          ? ScaleTransition(
              scale: _scaleAnimation,
              child: Container(
                key: const ValueKey("success"),
                width: 40,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(30),
                ),
                alignment: Alignment.center,
                child: const Text(
                  "✔",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          : Container(
              key: const ValueKey("slider"),
              width: maxWidth,
              height: 60,
              decoration: BoxDecoration(
                color: widget.backgroundColor,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Stack(
                children: [
                  Center(
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 600),
                      opacity: _isCompleted ? 0.0 : 1.0,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 30),
                        child: Text(
                          widget.text,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: widget.textColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTapDown: (_) {
                      setState(() {
                        _scaleValue = 1.1;
                      });
                    },
                    onTapUp: (_) {
                      setState(() {
                        _scaleValue = 2.0;
                      });
                    },
                    onHorizontalDragUpdate: (details) {
                      if (!_isCompleted) {
                        setState(() {
                          _position += details.primaryDelta!;
                          if (_position < 0) _position = 0;
                          if (_position > maxWidth - 60) {
                            _position = maxWidth - 60;
                          }
                        });
                      }
                    },
                    onHorizontalDragEnd: (details) {
                      if (_position > maxWidth * 0.75) {
                        setState(() {
                          _position = maxWidth - 60;
                          _isCompleted = true;
                        });

                        _animationController.forward();
                        widget.onSlide();

                        logger.i("Success tick shown");

                        Future.delayed(const Duration(seconds: 4), () {
                          if (mounted) {
                            _animationController.reverse();
                            setState(() {
                              _isCompleted = false;
                            });

                            _resetPosition(); // Animate reset
                            logger.i("State reset after delay");
                          }
                        });
                      } else {
                        _resetPosition();
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 10,
                        top: 5,
                      ),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                        margin: EdgeInsets.only(left: _position),
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: const Color(0xFF0057FF),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 6,
                              spreadRadius: 2,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Transform.scale(
                            scale: _scaleValue,
                            child: SvgPicture.asset(
                              'assets/svgs/arrow-up.svg',
                              width: 24,
                              height: 24,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

class SlideToActButton extends StatelessWidget {
  final String labelText;
  final Color backgroundColor;
  final Color sliderButtonColor;
  final String sliderButtonIcon;
  final Future<void> Function() onSubmit;
  final double height;
  final double borderRadius;
  final double sliderButtonSize;
  final bool reversed;
  final Duration animationDuration;
  final double width;

  const SlideToActButton({
    super.key,
    required this.labelText,
    required this.onSubmit,
    this.backgroundColor = Colors.blue,
    this.sliderButtonColor = Colors.white,
    this.sliderButtonIcon = 'assets/svgs/Group 44.svg', // Path to your SVG
    this.height = 60,
    this.width = double.infinity,
    this.borderRadius = 80,
    this.sliderButtonSize = 20,
    this.reversed = false,
    this.animationDuration = const Duration(seconds: 1),
  });

  @override
  Widget build(BuildContext context) {
    final GlobalKey<SlideActionState> key = GlobalKey();

    return Padding(
      padding: const EdgeInsets.all(10),
      child: SizedBox(
        width: width,
        child: SlideAction(
          key: key,
          onSubmit: onSubmit,
          height: height,
          borderRadius: borderRadius,
          innerColor: backgroundColor,
          outerColor: sliderButtonColor,
          sliderButtonIcon: SizedBox(
            width: sliderButtonSize,
            height: sliderButtonSize,
            child: Transform.scale(
              scale: 2,
              child: SvgPicture.asset(
                sliderButtonIcon,
                fit: BoxFit.contain,
              ),
            ),
          ),
          sliderButtonIconSize: sliderButtonSize,
          animationDuration: animationDuration,
          child: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Center(
              child: Text(
                labelText,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  fontFamily: 'Inter',
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomEllipsePostion extends StatelessWidget {
  final double width;
  final double height;
  final double top;
  final double bottom;
  final double left;
  final double right;
  final BoxFit fit;

  const CustomEllipsePostion({
    super.key,
    this.width = 262.1127014160156,
    this.height = 262.3527526855469,
    this.top = 0.0,
    this.bottom = 0.0,
    this.left = 0.0,
    this.right = 0.0,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: SvgPicture.asset(
        'assets/ellipse/Ellipse.svg',
        width: width,
        height: height,
        fit: fit,
      ),
    );
  }
}

class CustomEllipsePainter extends CustomPainter {
  final double radius;
  final Color color;
  final double angle;

  CustomEllipsePainter({
    required this.radius,
    required this.color,
    required this.angle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.fill
      ..shader = RadialGradient(
        colors: [
          color.withValues(alpha: 0.4),
          color.withValues(alpha: 0.0),
        ],
        stops: [0.0, 1],
      ).createShader(Rect.fromCircle(
          center: Offset(size.width / 2, size.height / 2), radius: radius));

    canvas.drawCircle(Offset(size.width / 2, size.height / 2), radius, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback onBackPressed;
  final VoidCallback onSharePressed;

  const CustomAppBar({
    super.key,
    required this.title,
    required this.onBackPressed,
    required this.onSharePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color.fromARGB(148, 0, 0, 0),
            Colors.transparent,
          ],
        ),
      ),
      padding: const EdgeInsets.only(top: 40, left: 26, right: 26, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: onBackPressed,
            child: SvgPicture.asset(
              'assets/svgs/downbutton.svg',
              colorFilter:
                  const ColorFilter.mode(Colors.white, BlendMode.srcIn),
              width: 24,
              height: 24,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              fontFamily: 'Inter',
            ),
          ),
          GestureDetector(
            onTap: onSharePressed,
            child: SvgPicture.asset(
              'assets/svgs/shareicon.svg',
              colorFilter:
                  const ColorFilter.mode(Colors.white, BlendMode.srcIn),
              width: 20,
              height: 20,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}

void onBackPressed() {
  logger.i("Back pressed");
}

void onSharePressed() {
  logger.i("Share pressed");
}

//  3d model screen-------------------------------------------------------------------->

class ModelViewerWidget extends StatefulWidget {
  final String modelPath;
  final bool isInteractive;
  final String scale;
  final String cameraOrbit;
  final String cameraTarget;

  const ModelViewerWidget({
    super.key,
    required this.modelPath,
    this.isInteractive = true,
    this.scale = "1 1 1",
    this.cameraOrbit = "0deg 90deg auto",
    this.cameraTarget = "auto auto auto",
  });

  @override
  State<ModelViewerWidget> createState() => _ModelViewerWidgetState();
}

class _ModelViewerWidgetState extends State<ModelViewerWidget> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _simulateLoading();
  }

  @override
  void didUpdateWidget(covariant ModelViewerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.modelPath != widget.modelPath) {
      setState(() {
        _isLoading = true;
      });
      _simulateLoading();
    }
  }

  void _simulateLoading() {
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.center, children: [
      AnimatedScale(
        scale: _isLoading ? 0.8 : 1.0,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOutBack,
        child: AnimatedOpacity(
          opacity: _isLoading ? 0.0 : 1.0,
          duration: const Duration(milliseconds: 500),
          child: ModelViewer(
            loading: Loading.lazy,
            src: widget.modelPath,
            alt: "A 3D model",
            ar: false,
            autoRotate: !widget.isInteractive,
            cameraControls: widget.isInteractive,
            disableZoom: false,
            disablePan: false,
            disableTap: false,
            rotationPerSecond: "40deg",
            cameraTarget: widget.cameraTarget,
            cameraOrbit: widget.cameraOrbit,
            minCameraOrbit: "auto 90deg auto",
            maxCameraOrbit: "auto 90deg auto",
          ),
        ),
      ),
      if (_isLoading)
        Positioned.fill(
          child: Shimmer.fromColors(
            baseColor: Color.fromRGBO(0, 0, 0, 0.2), // Black with 20% opacity
            highlightColor: Color.fromRGBO(255, 255, 255, 0.4),
            child: Center(
              child: ClipPath(
                clipper: ModelClipper(), // Custom shape
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.fromRGBO(
                            128, 128, 128, 0.1), // Grey with 10% opacity
                        Color.fromRGBO(
                            255, 255, 255, 0.3), // White with 30% opacity
                        Color.fromRGBO(
                            128, 128, 128, 0.1), // Grey with 10% opacity
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
    ]);
  }
}

class ModelClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.moveTo(size.width * 0.5, 0);
    path.lineTo(size.width, size.height * 0.25);
    path.lineTo(size.width * 0.75, size.height);
    path.lineTo(size.width * 0.25, size.height);
    path.lineTo(0, size.height * 0.25);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class CustomPaintStackwith3dModel extends StatefulWidget {
  final String modelPath;

  const CustomPaintStackwith3dModel({super.key, required this.modelPath});

  @override
  CustomPaintStackwith3dModelState createState() =>
      CustomPaintStackwith3dModelState();
}

class CustomPaintStackwith3dModelState
    extends State<CustomPaintStackwith3dModel> {
  late String _currentModelPath;

  @override
  void initState() {
    super.initState();
    _currentModelPath = widget.modelPath;
  }

  @override
  void didUpdateWidget(covariant CustomPaintStackwith3dModel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.modelPath != widget.modelPath) {
      setState(() {
        _currentModelPath = widget.modelPath;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        _buildCustomPaintStack(),
        Positioned(
          top: 70,
          left: MediaQuery.of(context).size.width / 2 - 115,
          child: SizedBox(
            width: 230,
            height: 352,
            child: ModelViewerWidget(
              key: ValueKey(_currentModelPath),
              modelPath: _currentModelPath,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCustomPaintStack() {
    return Container(
      color: Colors.black,
      child: Stack(
        fit: StackFit.expand,
        children: [
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
          Positioned(
            top: -100,
            child: SquareWithConnectedBoxes(),
          ),
          Positioned(
            top: 98,
            left: -153,
            child: CustomPaint(
              size: const Size(262, 262),
              painter: CustomEllipsePainter(
                radius: 300,
                color: const Color.fromRGBO(232, 204, 159, 1),
                angle: 2,
              ),
            ),
          ),
          Positioned(
            top: 180,
            left: 10,
            right: 10,
            child: CustomPaint(
              size: const Size(250, 250),
              painter: CustomEllipsePainter(
                radius: 100,
                color: const Color.fromARGB(245, 175, 122, 8),
                angle: 1,
              ),
            ),
          ),
          Positioned(
            top: 230,
            left: 333,
            child: CustomPaint(
              size: const Size(262, 262),
              painter: CustomEllipsePainter(
                radius: 300,
                color: const Color.fromARGB(122, 221, 176, 104),
                angle: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AnimatedModelViewerWidget extends StatelessWidget {
  final bool isVisible;
  final String modelPath;
  final Animation<double> animation;

  const AnimatedModelViewerWidget({
    super.key,
    required this.isVisible,
    required this.modelPath,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 400),
      opacity: isVisible ? 1.0 : 0.0,
      child: AnimatedScale(
        scale: isVisible ? 1.1 : 0.8,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutBack,
        child: AnimatedSlide(
          offset: isVisible ? Offset.zero : const Offset(0, 0.2),
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOut,
          child: Center(
            child: AnimatedBuilder(
              animation: animation,
              builder: (context, child) {
                return Transform.scale(
                  scale: animation.value,
                  child: ClipOval(
                    child: Container(
                      color: Colors.yellow,
                      width: 200,
                      height: 200,
                      child: ModelViewerWidget(
                        key: ValueKey(modelPath),
                        modelPath: modelPath,
                        cameraOrbit: "0deg 90deg 3.7m",
                        isInteractive: false,
                        cameraTarget: "0m 1.1m 0m",
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
