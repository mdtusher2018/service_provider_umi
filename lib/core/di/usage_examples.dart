// ─────────────────────────────────────────────────────────────
//  How to read AppRole anywhere in the app
// ─────────────────────────────────────────────────────────────

// ── 1. In any ConsumerWidget / ConsumerStatefulWidget ─────────
//
// class MyWidget extends ConsumerWidget {
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final role = ref.watch(appRoleProvider);
//
//     return Text(
//       role == AppRole.provider ? 'Provider' : 'User',
//     );
//   }
// }

// ── 2. In a button / gesture callback ────────────────────────
//
// ElevatedButton(
//   onPressed: () {
//     final role = ref.read(appRoleProvider); // use read in callbacks
//   },
// )

// ── 3. Switch role (e.g. "Switch to professional" button) ────
//
// ref.read(appRoleProvider.notifier).switchRole();

// ── 4. Check role in a provider / notifier ───────────────────
//
// final isProvider = ref.watch(appRoleProvider) == AppRole.provider;

// ── 5. In AppButton (already wired) ──────────────────────────
//
// The AppButton reads appRoleProvider in its build() method,
// so it automatically shows teal (user) or blue (provider).
