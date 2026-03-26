import 'package:flutter/material.dart';

/// Layout responsivo que se adapta a diferentes tamanhos de tela
class ResponsiveLayout extends StatelessWidget {
  final Widget mobileBody;
  final Widget? tabletBody;
  final Widget? desktopBody;

  const ResponsiveLayout({
    super.key,
    required this.mobileBody,
    this.tabletBody,
    this.desktopBody,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Mobile: < 600dp
        if (constraints.maxWidth < 600) {
          return mobileBody;
        }
        // Tablet: 600dp - 1200dp
        else if (constraints.maxWidth < 1200) {
          return tabletBody ?? mobileBody;
        }
        // Desktop: >= 1200dp
        else {
          return desktopBody ?? tabletBody ?? mobileBody;
        }
      },
    );
  }
}

/// Widget auxiliar para criar layouts em grid responsivos
class ResponsiveGrid extends StatelessWidget {
  final int childCount;
  final Widget Function(BuildContext, int) itemBuilder;
  final int mobileColumns;
  final int tabletColumns;
  final int desktopColumns;
  final double spacing;
  final double runSpacing;

  const ResponsiveGrid({
    super.key,
    required this.childCount,
    required this.itemBuilder,
    this.mobileColumns = 1,
    this.tabletColumns = 2,
    this.desktopColumns = 3,
    this.spacing = 16,
    this.runSpacing = 16,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int columns;
        if (constraints.maxWidth < 600) {
          columns = mobileColumns;
        } else if (constraints.maxWidth < 1200) {
          columns = tabletColumns;
        } else {
          columns = desktopColumns;
        }

        return Wrap(
          spacing: spacing,
          runSpacing: runSpacing,
          children: List.generate(
            childCount,
            (index) => SizedBox(
              width: (constraints.maxWidth - (spacing * (columns - 1))) / columns,
              child: itemBuilder(context, index),
            ),
          ),
        );
      },
    );
  }
}
