import 'package:flutter/material.dart';
import '../../../../config/theme/app_colors.dart';
import '../widgets/search_input_header.dart';
import '../widgets/recent_searches_list.dart';
import '../widgets/popular_services_chips.dart';
import '../widgets/smart_suggestions_list.dart';
import '../widgets/search_results_list.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final List<String> _recentSearches = [
    'تنظيف منازل شامل',
    'طبيب أطفال زيارة منزلية',
    'صيانة تكييف مركزي',
  ];

  // Global searchable database items
  final List<Map<String, dynamic>> _searchableItems = [
    {
      'type': 'tech',
      'name': 'م. خالد عباس',
      'category': 'كهرباء',
      'bio': 'خبير صيانة كهربائية منذ 10 سنوات',
      'rating': '4.8',
      'reviews': '124',
      'price': '50 ر.س',
      'icon': Icons.electric_bolt,
      'avatarColor': Colors.blue,
    },
    {
      'type': 'tech',
      'name': 'أ. عماد السعدني',
      'category': 'سباكة',
      'bio': 'فني سباكة وتركيبات متكاملة وحل الأعطال المستعصية',
      'rating': '4.9',
      'reviews': '98',
      'price': '75 ر.س',
      'icon': Icons.plumbing,
      'avatarColor': Colors.orange,
    },
    {
      'type': 'tech',
      'name': 'د. منى سعيد',
      'category': 'طب أطفال',
      'bio': 'طبيبة أطفال متخصصة لتقديم زيارات منزلية ورعاية متكاملة',
      'rating': '4.7',
      'reviews': '45',
      'price': '200 ر.س',
      'icon': Icons.local_hospital_outlined,
      'avatarColor': Colors.red,
    },
    {
      'type': 'service',
      'name': 'تمريض منزلي متخصص',
      'category': 'قسم الخدمات الطبية • متاح اليوم',
      'icon': Icons.medical_services,
      'color': Colors.red,
    },
    {
      'type': 'service',
      'name': 'تأسيس كهرباء وصيانة أعطال',
      'category': 'قسم الصيانة المنزلية',
      'icon': Icons.bolt,
      'color': Colors.blue,
    },
    {
      'type': 'service',
      'name': 'تنسيق حدائق خارجية',
      'category': 'قسم العناية بالمرافق',
      'icon': Icons.local_florist,
      'color': Colors.green,
    },
    {
      'type': 'service',
      'name': 'تصليح تكييف',
      'category': 'قسم الصيانة المنزلية',
      'icon': Icons.ac_unit,
      'color': Colors.cyan,
    },
    {
      'type': 'service',
      'name': 'حقنة منزلية',
      'category': 'قسم الخدمات الطبية',
      'icon': Icons.vaccines,
      'color': Colors.red,
    },
    {
      'type': 'service',
      'name': 'تنظيف منازل شامل',
      'category': 'قسم النظافة والتعقيم',
      'icon': Icons.cleaning_services,
      'color': Colors.green,
    },
    {
      'type': 'service',
      'name': 'سباك شاطر',
      'category': 'قسم الصيانة المنزلية',
      'icon': Icons.water_drop,
      'color': Colors.orange,
    },
  ];

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

  List<Map<String, dynamic>> _getFilteredResults() {
    if (_searchQuery.trim().isEmpty) return [];

    final query = _searchQuery.trim().toLowerCase();
    return _searchableItems.where((item) {
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
    final filteredResults = _getFilteredResults();
    final isSearching = _searchQuery.trim().isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.background,
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
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
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
