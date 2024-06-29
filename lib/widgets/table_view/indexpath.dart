class IndexPath {
  final int section;
  final int row;

  IndexPath({required this.section, required this.row});

  IndexPath copyWith({int? section, int? row}) {
    return IndexPath(
      section: section ?? this.section,
      row: row ?? this.row,
    );
  }

  @override
  bool operator ==(Object other) {
    if (other is! IndexPath) {
      return false;
    }
    return section == other.section && row == other.row;
  }

  @override
  int get hashCode => section.hashCode & row.hashCode;
}
