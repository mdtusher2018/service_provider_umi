part of 'provider_profile_screen.dart';

Widget _buildGallery(WidgetRef ref) {
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
          itemCount: 4,
          separatorBuilder: (_, __) => 10.horizontalSpace,
          itemBuilder: (_, i) => Container(
            width: 90,
            decoration: BoxDecoration(
              color: AppColors.primaryFor(ref.watch(appRoleProvider)),
              borderRadius: 12.circular,
              border: Border.all(color: AppColors.border),
            ),
            child: Icon(
              Icons.image_outlined,
              color: AppColors.primaryFor(ref.watch(appRoleProvider)),
              size: 32,
            ),
          ),
        ),
      ),
    ],
  );
}
