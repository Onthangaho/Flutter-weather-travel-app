import 'package:flutter/material.dart';
class DailyForecastCard extends StatelessWidget {
  final String dayName;
  final String condition;
  final String temperature;
  final IconData weatherIcon;
// NEW: an optional callback for when the card is tapped.
// VoidCallback is a Dart type alias for: void Function()
// The '?' makes it nullable — if not provided, the card isn't interactive.
  final VoidCallback? onTap;
  const DailyForecastCard({
    super.key,
    required this.dayName,
    required this.condition,
    required this.temperature,
    required this.weatherIcon,
    this.onTap, // optional — no 'required' keyword
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // --- STEP 1: We need Material + InkWell for the ripple to work ---
    // InkWell's ripple effect is drawn on the nearest Material ancestor.
    // Without Material, the ripple is invisible.
    return Padding(
      // Margin moved to Padding because Container's margin
      // would sit outside the InkWell and block the ripple at the edges
      padding: const EdgeInsets.only(bottom: 12),

      child: Material(
        // Material provides the surface for InkWell's ripple animation.
        // We set its color to transparent and let the Container handle
        // the actual background color via BoxDecoration.
        color: Colors.transparent,

        // Clip the ripple to match our rounded corners
        borderRadius: BorderRadius.circular(12),

        child: InkWell(
          // --- STEP 2: The tap handler ---
          onTap: onTap, // fires the callback the parent provided

          // Match the ripple shape to the container's rounded corners
          borderRadius: BorderRadius.circular(12),

          // Customize the ripple color (optional)
          splashColor: colorScheme.primary.withValues(alpha: 0.1),

          // Customize the hover/press highlight color (optional)
          highlightColor: colorScheme.primary.withValues(alpha: 0.05),

          // --- STEP 3: The visual content (same Container as before) ---
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.shadow.withValues(alpha: 0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
              border: Border.all(
                color: colorScheme.outlineVariant.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dayName,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      condition,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                Icon(
                  weatherIcon,
                  size: 32,
                  color: colorScheme.primary,
                ),
                Text(
                  temperature,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}