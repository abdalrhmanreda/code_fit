import 'package:flutter/material.dart';
import 'package:code_fit/blocked_and_maintance/ui/widgets/premium_button.dart';

class StatusActionButtons extends StatelessWidget {
  final bool isMaintenance;
  final VoidCallback onMaintenancePressed;
  final VoidCallback onBlockedPressed;
  final VoidCallback onContactSupportPressed;

  const StatusActionButtons({
    super.key,
    required this.isMaintenance,
    required this.onMaintenancePressed,
    required this.onBlockedPressed,
    required this.onContactSupportPressed,
  });

  @override
  Widget build(BuildContext context) {
    if (!isMaintenance) {
      // Blocked mode - show contact support button
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: PremiumButton(
              onPressed: onContactSupportPressed,
              icon: Icons.headset_mic_rounded,
              label: 'Contact Support',
              isPrimary: true,
            ),
          ),
        ],
      );
    }

    // Maintenance mode - show toggle buttons
    return Row(
      children: [
        Expanded(
          child: PremiumButton(
            onPressed: onMaintenancePressed,
            icon: Icons.build_circle_outlined,
            label: 'Maintenance',
            isPrimary: true,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: PremiumButton(
            onPressed: onBlockedPressed,
            icon: Icons.block_outlined,
            label: 'Blocked',
            isPrimary: false,
          ),
        ),
      ],
    );
  }
}
