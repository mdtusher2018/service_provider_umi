part of 'provider_profile_screen.dart';

Widget _buildGallery(WidgetRef ref, List<dynamic> images) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppText.h3('Gallery'),
          GestureDetector(onTap: () {}, child: AppText.labelMd('View gallery')),
        ],
      ),
      12.verticalSpace,
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
