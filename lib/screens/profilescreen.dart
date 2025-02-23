import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:profilescreen/widgets/widgets.dart';

final Logger logger = Logger();

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  late final AnimationController _animationController;
  late final Animation<double> _animation;
  late final ScrollController _scrollController;

  bool _isModelVisible = true;
  String selectedGender = "Male";
  String modelPath = "assets/3d_model/base_basic_shaded.glb";

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.8, end: 0.9).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _scrollController = ScrollController()..addListener(_handleScroll);
  }

  void _handleScroll() {
    bool newVisibility = _scrollController.offset > 150;
    if (newVisibility != _isModelVisible) {
      setState(() {
        _isModelVisible = newVisibility;
      });
    }
  }

  void updateModelBasedOnGender(String gender) {
    if (selectedGender != gender) {
      setState(() {
        selectedGender = gender;
        modelPath = gender == "Male"
            ? "assets/3d_model/base_basic_shaded.glb"
            : "assets/3d_model/female2.glb";
      });
      logger.i("Updated model path: $modelPath");
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    nameController.dispose();
    ageController.dispose();
    locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        extendBodyBehindAppBar: true,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: CustomAppBar(
            title: "Profile",
            onBackPressed: onBackPressed,
            onSharePressed: onSharePressed,
          ),
        ),
        body: Stack(
          children: [
            CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverAppBar(
                  expandedHeight: 260,
                  backgroundColor: Colors.transparent,
                  pinned: true,
                  toolbarHeight: 50,
                  flexibleSpace: FlexibleSpaceBar(
                    background: SizedBox(
                      height: 260,
                      child: CustomPaintStackwith3dModel(modelPath: modelPath),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      StaticFormCard(
                        nameController: nameController,
                        ageController: ageController,
                        locationController: locationController,
                        onGenderChanged: updateModelBasedOnGender,
                      ),
                      AnimatedModelViewerWidget(
                        isVisible: _isModelVisible,
                        modelPath: modelPath,
                        animation: _animation,
                      ),
                      const SizedBox(height: 150),
                    ],
                  ),
                ),
              ],
            ),
            const PositionableBox(
              bottom: 1,
            ),
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: SlideToActButton(
                labelText: 'Let’s save and roll!',
                onSubmit: () async {
                  logger.i("Action Completed!");

                  nameController.clear();
                  ageController.clear();
                  locationController.clear();
                },
                backgroundColor: const Color(0xFF7660FD),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
