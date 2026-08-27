import 'package:flutter/material.dart';
import 'package:cityblockmap_mobile/core/theme/app_colors.dart';
import 'package:cityblockmap_mobile/core/theme/responsive.dart';

class ResponsiveFormCard extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final EdgeInsets? desktopPadding;
  final EdgeInsets? mobilePadding;

  const ResponsiveFormCard({
    super.key,
    required this.child,
    this.maxWidth = 460,
    this.desktopPadding,
    this.mobilePadding,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobile;
    final padding = isMobile
        ? (mobilePadding ?? const EdgeInsets.fromLTRB(24, 32, 24, 32))
        : (desktopPadding ?? const EdgeInsets.fromLTRB(48, 40, 48, 40));

    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(isMobile ? 16 : 24),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: AppColors.white,
              border: Border.all(color: AppColors.gray300),
              borderRadius: BorderRadius.circular(AppColors.radius),
              boxShadow: AppColors.shadowLg,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
