part of 'provider_profile_screen.dart';

Widget _buildGallery(WidgetRef ref, String providerId, List<dynamic> images) {
  return Container(
    width: double.infinity,
    margin: const EdgeInsets.symmetric(vertical: 6),
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: AppColors.border),
      boxShadow: const [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 4,
          offset: Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppText.bodyLg('Gallery', fontWeight: FontWeight.w700, color: AppColors.textPrimary),
            GestureDetector(
              onTap: () {
                ref.context.push(AppRoutes.providerGalleryPath(providerId));
              }, 
              child: AppText.labelMd('View gallery', color: AppColors.primary.withValues(alpha: 0.9),)
            ),
          ],
        ),
        12.verticalSpace,
        if (images.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: AppText.bodyMd('No gallery image found', color: AppColors.textSecondary),
            ),
          )
        else
          SizedBox(
            height: 90,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: images.length,
              separatorBuilder: (_, __) => 10.horizontalSpace,
              itemBuilder: (_, i) {
                final imageUrl = images[i];
                return GestureDetector(
                  onTap: () {
                    _showImageOverlay(ref.context, images, i);
                  },
                  child: Hero(
                    tag: imageUrl,
                    child: Container(
                      width: 90,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                        image: DecorationImage(
                          image: NetworkImage(imageUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    ),
  );
}

void _showImageOverlay(
  BuildContext context,
  List<dynamic> images,
  int initialIndex,
) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: "Gallery",
    barrierColor: Colors.black,
    transitionDuration: const Duration(milliseconds: 200),
    pageBuilder: (_, __, ___) {
      final controller = PageController(initialPage: initialIndex);

      return Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            PhotoViewGallery.builder(
              itemCount: images.length,
              pageController: controller,
              backgroundDecoration: const BoxDecoration(color: Colors.black),
              builder: (context, index) {
                return PhotoViewGalleryPageOptions(
                  imageProvider: NetworkImage(images[index]),
                  minScale: PhotoViewComputedScale.contained,
                  maxScale: PhotoViewComputedScale.covered * 3,
                );
              },
            ),

            // 🔥 Close button
            Positioned(
              top: 40,
              right: 20,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      );
    },
  );
}
