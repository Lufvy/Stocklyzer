import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stocklyzer/controller/themeController.dart';
import 'package:flutter_svg/svg.dart';

class Logo extends StatefulWidget {
  final themeController = Get.find<Themecontroller>();
  final double size;

  Logo({super.key, required this.size});

  @override
  State<Logo> createState() => _LogoState();
}

class _LogoState extends State<Logo> {
  @override
  Widget build(BuildContext context) {
    return widget.themeController.isDarkMode.value
        ? SvgPicture.asset(
            'assets/Logo.svg',
            width: widget.size,
            height: widget.size,
          )
        : ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [Color(0XFF01353D), Color(0XFF007283)],
              stops: [0.2, 0.75],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ).createShader(bounds),
            child: SvgPicture.asset(
              'assets/Logo.svg',
              colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
              width: widget.size,
              height: widget.size,
            ),
          );
  }
}
