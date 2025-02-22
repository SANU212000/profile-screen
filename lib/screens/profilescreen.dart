import 'package:flutter/material.dart';
import 'package:profilescreen/widgets/widgets.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  late AnimationController _animationController;
  late Animation<double> _animation;
  late ScrollController _scrollController;
  bool _isModelVisible = true;

  @override
  void initState() {
    super.initState();

    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.8, end: 0.9).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _scrollController = ScrollController();
    _scrollController.addListener(_handleScroll);
  }

  String selectedGender = "Male";
  String modelPath = "assets/3d_model/base_basic_shaded.glb";

  void _handleScroll() {
    if (_scrollController.offset > 150 && !_isModelVisible) {
      setState(() {
        _isModelVisible = true;
      });
    } else if (_scrollController.offset <= 150 && _isModelVisible) {
      setState(() {
        _isModelVisible = false;
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void updateModelBasedOnGender(String gender) {
    setState(() {
      selectedGender = gender;
      modelPath = gender == "Male"
          ? "assets/3d_model/base_basic_shaded.glb"
          : "assets/3d_model/female_model.glb";
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
    print("Updated model path: $modelPath");
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
                  child: Container(
                    color: Colors.black,
                    child: Column(
                      children: [
                        StaticFormCard(
                          nameController: nameController,
                          ageController: ageController,
                          locationController: locationController,
                          onGenderChanged: updateModelBasedOnGender,
                        ),
                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 500),
                          opacity: _isModelVisible ? 1.0 : 0.0,
                          child: AnimatedScale(
                            scale: _isModelVisible ? 1.1 : 0.8,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeOutBack,
                            child: AnimatedSlide(
                              offset: _isModelVisible
                                  ? Offset.zero
                                  : const Offset(0, 0.2),
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeOut,
                              child: Center(
                                child: AnimatedBuilder(
                                  animation: _animation,
                                  builder: (context, child) {
                                    return Transform.scale(
                                      scale: _animation.value,
                                      child: ClipOval(
                                        child: Container(
                                          color: Colors.yellow,
                                          width: 200,
                                          height: 200,
                                          child: ModelViewerWidget(
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
                        ),
                        const SizedBox(height: 150),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            PositionableBox(
              bottom: 1,
            ),
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: SlideToActButton(
                labelText: 'Let’s save and roll!',
                onSubmit: () async {
                  print("Action Completed!");
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
