import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../config/theme/theme_provider.dart';
import '../../../localization/presentation/providers/localization_providers.dart';
import '../widgets/search_input_header.dart';
import '../widgets/recent_searches_list.dart';
import '../widgets/popular_services_chips.dart';
import '../widgets/smart_suggestions_list.dart';
import '../widgets/search_results_list.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final List<String> _recentSearches = [
    'تنظيف منازل شامل',
    'طبيب أطفال زيارة منزلية',
    'صيانة تكييف مركزي',
  ];

  // Dynamic searchable database items based on selected language
  List<Map<String, dynamic>> _getSearchableItems(dynamic t) {
    final isAr = t.isArabic;
    return [
      {
        'type': 'tech',
        'name': isAr ? 'م. خالد عباس' : 'Eng. Khaled Abbas',
        'category': isAr ? 'كهرباء' : 'Electrical',
        'bio': isAr ? 'خبير صيانة كهربائية منذ 10 سنوات' : 'Electrical maintenance expert for 10 years',
        'rating': '4.8',
        'reviews': '124',
        'price': isAr ? '50 ج.م' : '50 EGP',
        'icon': Icons.electric_bolt,
        'avatarColor': Colors.blue,
      },
      {
        'type': 'tech',
        'name': isAr ? 'أ. عماد السعدني' : 'Mr. Emad El-Saadany',
        'category': isAr ? 'سباكة' : 'Plumbing',
        'bio': isAr ? 'فني سباكة وتركيبات متكاملة وحل الأعطال المستعصية' : 'Professional plumbing, installations & complex fault resolution',
        'rating': '4.9',
        'reviews': '98',
        'price': isAr ? '75 ج.م' : '75 EGP',
        'icon': Icons.plumbing,
        'avatarColor': Colors.orange,
      },
      {
        'type': 'tech',
        'name': isAr ? 'د. منى سعيد' : 'Dr. Mona Said',
        'category': isAr ? 'طب أطفال' : 'Pediatrics',
        'bio': isAr ? 'طبيبة أطفال متخصصة لتقديم زيارات منزلية ورعاية متكاملة' : 'Specialized pediatric doctor for home visits and integrated care',
        'rating': '4.7',
        'reviews': '45',
        'price': isAr ? '200 ج.م' : '200 EGP',
        'icon': Icons.local_hospital_outlined,
        'avatarColor': Colors.red,
      },
      {
        'type': 'service',
        'name': t.translate('specialized_nursing'),
        'category': t.translate('medical_dept_today'),
        'icon': Icons.medical_services,
        'color': Colors.red,
      },
      {
        'type': 'service',
        'name': t.translate('electrical_setup'),
        'category': t.translate('maintenance_dept'),
        'icon': Icons.bolt,
        'color': Colors.blue,
      },
      {
        'type': 'service',
        'name': t.translate('landscaping'),
        'category': t.translate('facilities_care_dept'),
        'icon': Icons.local_florist,
        'color': Colors.green,
      },
      {
        'type': 'service',
        'name': t.translate('ac_repair'),
        'category': t.translate('maintenance_dept'),
        'icon': Icons.ac_unit,
        'color': Colors.cyan,
      },
      {
        'type': 'service',
        'name': t.translate('home_injection'),
        'category': t.translate('medical_dept_today'),
        'icon': Icons.vaccines,
        'color': Colors.red,
      },
      {
        'type': 'service',
        'name': t.translate('deep_clean_short'),
        'category': t.translate('cat_cleaning'),
        'icon': Icons.cleaning_services,
        'color': Colors.green,
      },
      {
        'type': 'service',
        'name': t.translate('plumber_shater'),
        'category': t.translate('maintenance_dept'),
        'icon': Icons.water_drop,
        'color': Colors.orange,
      },
    ];
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value;
    });
  }

  void _triggerSearch(String query) {
    _searchController.text = query;
    setState(() {
      _searchQuery = query;
      if (!_recentSearches.contains(query)) {
        _recentSearches.insert(0, query);
        if (_recentSearches.length > 5) {
          _recentSearches.removeLast();
        }
      }
    });
  }

  List<Map<String, dynamic>> _getFilteredResults(dynamic t) {
    if (_searchQuery.trim().isEmpty) return [];

    final query = _searchQuery.trim().toLowerCase();
    final items = _getSearchableItems(t);
    return items.where((item) {
      final name = item['name'].toString().toLowerCase();
      final category = item['category'].toString().toLowerCase();
      final bio = item['bio'] != null ? item['bio'].toString().toLowerCase() : '';
      
      return name.contains(query) || 
             category.contains(query) || 
             bio.contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final themeColors = ref.watch(themeColorsProvider);
    final t = ref.watch(translationProvider);
    
    final filteredResults = _getFilteredResults(t);
    final isSearching = _searchQuery.trim().isNotEmpty;

    return Scaffold(
      backgroundColor: themeColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Custom Search Input Header (Second screenshot layout)
            SearchInputHeader(
              controller: _searchController,
              onChanged: _onSearchChanged,
              query: _searchQuery,
              onClear: () {
                _searchController.clear();
                setState(() {
                  _searchQuery = '';
                });
              },
            ),

            // Body Area
            Expanded(
              child: isSearching
                  ? SearchResultsList(results: filteredResults)
                  : SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.only(
                        left: 20.0,
                        right: 20.0,
                        top: 16.0,
                        bottom: 110.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RecentSearchesList(
                            history: _recentSearches,
                            onClearAll: () {
                              setState(() {
                                _recentSearches.clear();
                              });
                            },
                            onTapItem: _triggerSearch,
                          ),
                          PopularServicesChips(onTapChip: _triggerSearch),
                          SmartSuggestionsList(onTapItem: _triggerSearch),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
