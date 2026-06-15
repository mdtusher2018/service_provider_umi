part of 'welcome_screen.dart';

Future<void> _close(WidgetRef ref) async {
  if (kIsWeb) {
    await dismissWebOverlay(ref);
  } else {
    if (ref.context.mounted) {
      Navigator.of(ref.context).pop();
    }
  }
}
