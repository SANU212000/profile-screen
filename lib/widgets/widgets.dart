import 'dart:ui';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:shimmer/shimmer.dart';

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

class CustomEllipse extends StatelessWidget {
  final double width;
  final double height;
  final Color backgroundColor;
  final double blurRadius;
  final double opacity;
  final double top;
  final double left;

  const CustomEllipse({
    Key? key,
    this.width = 262.11,
    this.height = 262.35,
    this.backgroundColor = const Color(0xFFE8CC9F),
    this.blurRadius = 400.0,
    this.opacity = 0.2,
    this.top = 98.96,
    this.left = -153.6,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(height / 2),
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                backgroundColor.withOpacity(opacity),
                backgroundColor.withOpacity(opacity * 0.8),
              ],
              stops: [0.0, 1.0],
            ),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: blurRadius, sigmaY: blurRadius),
            child: Container(
              color: Colors.transparent,
            ),
          ),
        ),
      ),
    );
  }
}

class GradientBorderWidget extends StatelessWidget {
  final double width;
  final double height;
  final Widget child;

  const GradientBorderWidget({
    super.key,
    this.width = 200.0,
    this.height = 200.0,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: CustomPaint(
        painter: GradientBorderPainter(),
        child: child,
      ),
    );
  }
}

class GradientBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.3
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color.fromARGB(0, 255, 255, 255),
          Color.fromARGB(255, 153, 153, 153),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRRect(
      RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height), Radius.circular(10)),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class DraggableFormCard extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController ageController;
  final TextEditingController locationController;

  const DraggableFormCard({
    Key? key,
    required this.nameController,
    required this.ageController,
    required this.locationController,
  }) : super(key: key);

  @override
  _DraggableFormCardState createState() => _DraggableFormCardState();
}

class _DraggableFormCardState extends State<DraggableFormCard> {
  String selectedGender = '';
  double childSize = 0.57;

  void onGenderSelected(String gender) {
    setState(() {
      selectedGender = gender;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: DraggableScrollableSheet(
            initialChildSize: 0.61,
            minChildSize: 0.60,
            maxChildSize: 0.85,
            builder: (context, scrollController) {
              scrollController.addListener(() {
                if (scrollController.hasClients) {
                  setState(() {
                    childSize = scrollController.position.pixels /
                        scrollController.position.maxScrollExtent;
                  });
                }
              });
              return SizedBox(
                width: double.infinity,
                child: Card(
                  margin: EdgeInsets.zero,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  elevation: 10,
                  color: Colors.black,
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 12,
                          ),
                          Text(
                            "Hey, Tell me about you!",
                            style: TextStyle(
                              color: Color.fromRGBO(255, 255, 255, 1),
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Inter',
                            ),
                          ),
                          const SizedBox(height: 10),
                          SvgPicture.asset(
                            'assets/svgs/Vector.svg',
                            width: 49,
                            height: 6,
                          ),
                          const SizedBox(height: 25),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              genderButton("Male", selectedGender == "Male",
                                  () {
                                onGenderSelected("Male");
                              }),
                              const SizedBox(width: 15),
                              genderButton("Female", selectedGender == "Female",
                                  () {
                                onGenderSelected("Female");
                              }),
                            ],
                          ),
                          const SizedBox(height: 12),
                          customInputField(
                              "Your good name", widget.nameController),
                          const SizedBox(height: 12),
                          customInputField(
                              "How old are you?", widget.ageController),
                          const SizedBox(height: 12),
                          CustomDropdownField(
                            controller: widget.locationController,
                            items: [
                              "New York",
                              "London",
                              "Paris",
                              "Tokyo",
                              'Mumbai'
                            ],
                            hint: "Location",
                            svgIconPath:
                                'assets/svgs/tabler_location-filled.svg',
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        if (childSize > 0.7)
          Positioned(
            top: 10,
            left: 10,
            right: 10,
            height: 250,
            child: Container(
              color: Colors.black.withOpacity(0.7),
              child: Column(
                children: [
                  ClipOval(
                    child: Image.asset(
                      'assets/images/image2.png',
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "User Name",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
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

class CustomDropdownField extends StatefulWidget {
  final TextEditingController controller;
  final List<String> items;
  final String hint;
  final String svgIconPath;

  const CustomDropdownField({
    super.key,
    required this.controller,
    required this.items,
    this.hint = "Select an option",
    required this.svgIconPath,
  });

  @override
  _CustomDropdownFieldState createState() => _CustomDropdownFieldState();
}

class _CustomDropdownFieldState extends State<CustomDropdownField> {
  String? selectedValue;
  bool isExpanded = false;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        isExpanded = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 5),
      curve: Curves.easeInOut,
      height: isExpanded ? 80 : 65,
      child: DropdownButtonFormField<String>(
        focusNode: _focusNode,
        value: selectedValue,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[900],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32),
            borderSide: BorderSide.none,
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 14.0, horizontal: 20.0),
          suffixIcon: Padding(
            padding: const EdgeInsets.only(right: 20),
            child: SizedBox(
              width: 16,
              height: 16,
              child: SvgPicture.asset(
                widget.svgIconPath,
                fit: BoxFit.scaleDown,
              ),
            ),
          ),
        ),
        hint: Text(
          widget.hint,
          style: TextStyle(
            color: isExpanded ? Colors.white : Colors.white54,
            fontSize: isExpanded ? 18 : 15,
            fontWeight: isExpanded ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        dropdownColor: Colors.grey[900],
        style: const TextStyle(color: Colors.white),
        items: widget.items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(
              item,
              style: const TextStyle(color: Colors.white),
            ),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            selectedValue = newValue;
            widget.controller.text = newValue!;
          });
        },
        icon: const SizedBox.shrink(),
      ),
    );
  }
}

class SliderButton extends StatefulWidget {
  final String text;
  final VoidCallback onSlide;
  final Color backgroundColor;
  final Color sliderColor;
  final Color textColor;
  final TextStyle? textStyle;

  const SliderButton({
    Key? key,
    required this.text,
    required this.onSlide,
    this.backgroundColor = Colors.grey,
    this.sliderColor = Colors.white,
    this.textColor = Colors.black,
    this.textStyle,
  }) : super(key: key);

  @override
  _SliderButtonState createState() => _SliderButtonState();
}

class _SliderButtonState extends State<SliderButton>
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

                        print("Success tick shown");

                        Future.delayed(const Duration(seconds: 2), () {
                          if (mounted) {
                            setState(() {
                              _isCompleted = false;
                              _position = 0;
                            });

                            print("State reset after delay");
                          }
                        });
                      } else {
                        setState(() {
                          _position = 0;
                        });
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
    final GlobalKey<SlideActionState> _key = GlobalKey();

    return Padding(
      padding: const EdgeInsets.all(10),
      child: SizedBox(
        width: width,
        child: SlideAction(
          key: _key,
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
        colors: [color.withOpacity(0.5), color.withOpacity(0.0)],
        stops: [0.0, 0.8],
      ).createShader(Rect.fromCircle(
          center: Offset(size.width / 2, size.height / 2), radius: radius));

    canvas.drawCircle(Offset(size.width / 2, size.height / 2), radius, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
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

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback onBackPressed;
  final VoidCallback onSharePressed;

  const CustomAppBar({
    Key? key,
    required this.title,
    required this.onBackPressed,
    required this.onSharePressed,
  }) : super(key: key);

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
              color: Colors.white,
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
              color: Colors.white,
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
  print("Back pressed");
}

void onSharePressed() {
  print("Share pressed");
}

class ModelViewerWidget extends StatefulWidget {
  final String modelPath;

  const ModelViewerWidget({super.key, required this.modelPath});

  @override
  State<ModelViewerWidget> createState() => _ModelViewerWidgetState();
}

class _ModelViewerWidgetState extends State<ModelViewerWidget> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ModelViewer(
          src: widget.modelPath,
          alt: "A 3D model",
          ar: false,
          autoRotate: false,
          cameraControls: true,
          disableZoom: true,
          cameraOrbit: "0deg 90deg auto",
          minCameraOrbit: "auto 90deg auto",
          maxCameraOrbit: "auto 90deg auto",
        ),
      ],
    );
  }
}
