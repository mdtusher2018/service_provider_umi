part of '../../screens/chat_screen.dart';

// ─── Chat Options Sheet ───────────────────────────────────────
class _ChatOptionsSheet extends StatelessWidget {
  final VoidCallback onBlock;

  const _ChatOptionsSheet({required this.onBlock});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText.h3("Settings"),

          _OptionTile(
            icon: Icons.block_rounded,
            label: 'Block user',
            color: AppColors.error,
            onTap: onBlock,
          ),
        ],
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;
  final VoidCallback onTap;

  const _OptionTile({
    required this.icon,
    required this.label,
    this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: color ?? AppColors.textPrimary),
      title: AppText.bodyLg(label, color: color ?? AppColors.textPrimary),
      contentPadding: EdgeInsets.zero,
    );
  }
}
