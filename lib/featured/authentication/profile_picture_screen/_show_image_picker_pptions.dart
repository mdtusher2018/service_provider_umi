part of 'profile_picture_screen.dart';

final profileImageProvider = StateProvider<File?>((ref) => null);
final _picker = ImagePicker();

void _showPickerOptions(WidgetRef ref) {
  showModalBottomSheet(
    context: ref.context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          8.verticalSpace,
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.grey300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          16.verticalSpace,
          ListTile(
            leading: const Icon(Icons.photo_library_outlined),
            title: const Text('Choose from gallery'),
            onTap: () {
              Navigator.pop(ref.context);
              _pickImage(ref);
            },
          ),
          ListTile(
            leading: const Icon(Icons.camera_alt_outlined),
            title: const Text('Take a photo'),
            onTap: () {
              Navigator.pop(ref.context);
              _pickFromCamera(ref);
            },
          ),
          8.verticalSpace,
        ],
      ),
    ),
  );
}

Future<void> _pickImage(WidgetRef ref) async {
  final picked = await _picker.pickImage(
    source: ImageSource.gallery,
    maxWidth: 800,
    maxHeight: 800,
    imageQuality: 85,
  );

  if (picked != null) {
    ref.read(profileImageProvider.notifier).state = File(picked.path);
  }
}

Future<void> _pickFromCamera(WidgetRef ref) async {
  final picked = await _picker.pickImage(
    source: ImageSource.camera,
    maxWidth: 800,
    maxHeight: 800,
    imageQuality: 85,
  );

  if (picked != null) {
    ref.read(profileImageProvider.notifier).state = File(picked.path);
  }
}
