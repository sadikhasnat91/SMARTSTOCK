import 'package:flutter/material.dart';
import 'package:smart_stock/core/theme/app_colors.dart';
import 'package:smart_stock/core/theme/app_text_styles.dart';

class AppDataTable extends StatefulWidget {
  final List<String> columns;
  final List<List<Widget>> rows;
  final List<double>? columnWidths;
  final bool sortable;

  const AppDataTable({
    super.key,
    required this.columns,
    required this.rows,
    this.columnWidths,
    this.sortable = false,
  });

  @override
  State<AppDataTable> createState() => _AppDataTableState();
}

class _AppDataTableState extends State<AppDataTable> {
  int? _sortColumn;
  bool _sortAscending = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        // 3D Header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFFAFCFB), Color(0xFFF1F6F3)],
            ),
            border: Border(bottom: BorderSide(color: AppColors.border, width: 1.2)),
          ),
          child: Row(
            children: List.generate(widget.columns.length, (i) {
              final width = widget.columnWidths?[i];
              final header = GestureDetector(
                onTap: widget.sortable
                    ? () {
                        setState(() {
                          if (_sortColumn == i) {
                            _sortAscending = !_sortAscending;
                          } else {
                            _sortColumn = i;
                            _sortAscending = true;
                          }
                        });
                      }
                    : null,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.columns[i],
                      style: AppTextStyles.labelSmall.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textSecondary,
                        letterSpacing: 0.2,
                      ),
                    ),
                    if (widget.sortable)
                      Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: Icon(
                          _sortColumn == i
                              ? (_sortAscending
                                  ? Icons.arrow_upward_rounded
                                  : Icons.arrow_downward_rounded)
                              : Icons.unfold_more_rounded,
                          size: 14,
                          color: _sortColumn == i
                              ? AppColors.primary
                              : AppColors.textMuted,
                        ),
                      ),
                  ],
                ),
              );
              if (width != null) {
                return SizedBox(width: width, child: header);
              }
              return Expanded(child: header);
            }),
          ),
        ),
        // Rows
        ...List.generate(widget.rows.length, (rowIndex) {
          final row = widget.rows[rowIndex];
          return Container(
            decoration: BoxDecoration(
              color: rowIndex.isOdd ? const Color(0xFFF9FBFA) : AppColors.surface,
              border: const Border(
                bottom: BorderSide(color: AppColors.divider, width: 1),
              ),
            ),
            child: InkWell(
              onTap: () {},
              hoverColor: AppColors.primarySurface.withValues(alpha: 0.5),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
                child: Row(
                  children: List.generate(row.length, (colIndex) {
                    final width = widget.columnWidths?[colIndex];
                    if (width != null) {
                      return SizedBox(width: width, child: row[colIndex]);
                    }
                    return Expanded(child: row[colIndex]);
                  }),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}

class TablePagination extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int pageSize;
  final void Function(int) onPageChanged;

  const TablePagination({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.pageSize,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final start = (currentPage - 1) * pageSize + 1;
    final end = (currentPage * pageSize).clamp(0, totalItems);

    final isMobile = MediaQuery.of(context).size.width < 600;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border, width: 1)),
      ),
      child: isMobile
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$start–$end of $totalItems',
                  style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w600),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _PageBtn(
                      icon: Icons.chevron_left_rounded,
                      enabled: currentPage > 1,
                      onTap: () => onPageChanged(currentPage - 1),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        '$currentPage / $totalPages',
                        style: AppTextStyles.labelSmall.copyWith(fontWeight: FontWeight.w700),
                      ),
                    ),
                    _PageBtn(
                      icon: Icons.chevron_right_rounded,
                      enabled: currentPage < totalPages,
                      onTap: () => onPageChanged(currentPage + 1),
                    ),
                  ],
                ),
              ],
            )
          : Row(
              children: [
                Text(
                  'Showing $start–$end of $totalItems entries',
                  style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                _PageBtn(
                  icon: Icons.chevron_left_rounded,
                  enabled: currentPage > 1,
                  onTap: () => onPageChanged(currentPage - 1),
                ),
                const SizedBox(width: 4),
                ...List.generate(
                  totalPages.clamp(0, 5),
                  (i) {
                    final page = i + 1;
                    final isActive = page == currentPage;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: InkWell(
                        onTap: () => onPageChanged(page),
                        borderRadius: BorderRadius.circular(8),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            gradient: isActive ? AppColors.primaryGradient : null,
                            color: isActive ? null : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                            border: isActive ? null : Border.all(color: AppColors.border, width: 1),
                            boxShadow: isActive ? AppColors.shadow3DButton : null,
                          ),
                          child: Center(
                            child: Text(
                              '$page',
                              style: AppTextStyles.labelSmall.copyWith(
                                color: isActive ? Colors.white : AppColors.textSecondary,
                                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 4),
                _PageBtn(
                  icon: Icons.chevron_right_rounded,
                  enabled: currentPage < totalPages,
                  onTap: () => onPageChanged(currentPage + 1),
                ),
              ],
            ),
    );
  }
}

class _PageBtn extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  const _PageBtn({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: enabled ? AppColors.surface : AppColors.secondaryBackground,
          border: Border.all(color: AppColors.border, width: 1),
          borderRadius: BorderRadius.circular(8),
          boxShadow: enabled ? AppColors.shadow3DSubtle : null,
        ),
        child: Icon(
          icon,
          size: 17,
          color: enabled ? AppColors.textPrimary : AppColors.textMuted,
        ),
      ),
    );
  }
}
