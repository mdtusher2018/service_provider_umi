import 'package:flutter/material.dart';
import 'app_colors.dart';

enum AvatarSize { xs, sm, md, lg, xl }

/// Circular avatar with image, initials fallback, and optional verified badge
class AppAvatar extends StatelessWidget {
  final String? imageUrl;
  final String? name;
  final AvatarSize size;

  final bool isOnline;
  final Color? backgroundColor;
  final VoidCallback? onTap;
  final double? customSize;
  final Widget? isFavorite;

  const AppAvatar({
    super.key,
    this.imageUrl,
    this.name,
    this.size = AvatarSize.md,

    this.isOnline = false,
    this.backgroundColor,
    this.onTap,
    this.customSize,
    this.isFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final avatarSize = customSize ?? _sizeValue;

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: avatarSize,
            height: avatarSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: backgroundColor ?? AppColors.primaryLight,
              border: Border.all(color: AppColors.white, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipOval(child: _buildContent(avatarSize)),
          ),
          if (isFavorite != null)
            Positioned(right: -4, bottom: -4, child: isFavorite!),
          if (isOnline)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: AppColors.success,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.white, width: 1.5),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildContent(double size) {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return Image.network(
        imageUrl!,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildInitials(size),
        loadingBuilder: (_, child, progress) {
          if (progress == null) return child;
          return Container(color: AppColors.primaryLight);
        },
      );
    }
    return _buildInitials(size);
  }

  Widget _buildInitials(double size) {
    final initials = _getInitials();
    return Container(
      color: backgroundColor ?? AppColors.primaryLight,
      child: Center(
        child: Text(
          initials,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: size * 0.35,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }

  String _getInitials() {
    if (name == null || name!.isEmpty) return '?';
    final parts = name!.trim().split(' ');
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  double get _sizeValue {
    switch (size) {
      case AvatarSize.xs:
        return 24;
      case AvatarSize.sm:
        return 36;
      case AvatarSize.md:
        return 48;
      case AvatarSize.lg:
        return 64;
      case AvatarSize.xl:
        return 96;
    }
  }
}
