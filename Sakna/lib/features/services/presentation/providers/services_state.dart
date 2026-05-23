class ServicesState {
  final String? selectedCategoryId;
  final String? selectedSubCategoryId;
  final String searchQuery;
  final bool isDiagnosticsLoading;
  final String? diagnosticsResult;

  const ServicesState({
    this.selectedCategoryId,
    this.selectedSubCategoryId,
    this.searchQuery = '',
    this.isDiagnosticsLoading = false,
    this.diagnosticsResult,
  });

  ServicesState copyWith({
    String? Function()? selectedCategoryId,
    String? Function()? selectedSubCategoryId,
    String? searchQuery,
    bool? isDiagnosticsLoading,
    String? Function()? diagnosticsResult,
  }) {
    return ServicesState(
      selectedCategoryId: selectedCategoryId != null ? selectedCategoryId() : this.selectedCategoryId,
      selectedSubCategoryId: selectedSubCategoryId != null ? selectedSubCategoryId() : this.selectedSubCategoryId,
      searchQuery: searchQuery ?? this.searchQuery,
      isDiagnosticsLoading: isDiagnosticsLoading ?? this.isDiagnosticsLoading,
      diagnosticsResult: diagnosticsResult != null ? diagnosticsResult() : this.diagnosticsResult,
    );
  }
}
