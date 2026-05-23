import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/theme/app_colors.dart';
import '../widgets/filters_bottom_sheet.dart';

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
            _buildSearchInputHeader(),

            // Body Area
            Expanded(
              child: isSearching
                  ? _buildSearchResults(filteredResults)
                  : _buildDefaultSearchContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchInputHeader() {
    final isSearching = _searchQuery.trim().isNotEmpty;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      color: Colors.white,
      child: Row(
        children: [
          // Back chevron button
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.greyLight),
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_forward, color: AppColors.textPrimary, size: 20),
              onPressed: () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                } else {
                  context.go('/home');
                }
              },
            ),
          ),
          const SizedBox(width: 12),
          
          // Search entry input box
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: AppColors.greyLight.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, color: AppColors.textSecondary, size: 22),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: _onSearchChanged,
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.rtl,
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 14,
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'إبحث عن خدمة، طبيبة، أو فني...',
                        hintTextDirection: TextDirection.rtl,
                        hintStyle: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                  
                  // Clear button (X) when typing, otherwise settings icon
                  if (isSearching)
                    IconButton(
                      icon: const Icon(Icons.close, color: AppColors.textSecondary, size: 18),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          _searchQuery = '';
                        });
                      },
                    )
                  else
                    IconButton(
                      icon: const Icon(Icons.tune, color: AppColors.textSecondary, size: 18),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) => const FiltersBottomSheet(),
                        );
                      },
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultSearchContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Recent Searches ("البحث الأخير")
          if (_recentSearches.isNotEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'البحث الأخير',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    fontFamily: 'Cairo',
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _recentSearches.clear();
                    });
                  },
                  child: const Text(
                    'مسح الكل',
                    style: TextStyle(
                      color: AppColors.accent,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Column(
              children: _recentSearches.map((search) {
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.history, color: AppColors.textSecondary, size: 20),
                  title: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      search,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ),
                  onTap: () => _triggerSearch(search),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
          ],

          // 2. Popular Services ("خدمات شائعة")
          const Text(
            'خدمات شائعة',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              fontFamily: 'Cairo',
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildPopularServiceChip('تصليح تكييف', Icons.ac_unit),
              _buildPopularServiceChip('حقنة منزلية', Icons.vaccines),
              _buildPopularServiceChip('سباك شاطر', Icons.water_drop),
              _buildPopularServiceChip('تنظيف عميق', Icons.cleaning_services),
            ],
          ),
          const SizedBox(height: 32),

          // 3. Smart Suggestions ("اقتراحات ذكية")
          const Text(
            'اقتراحات ذكية',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              fontFamily: 'Cairo',
            ),
          ),
          const SizedBox(height: 12),
          _buildSmartSuggestionCard(
            title: 'تمريض منزلي متخصص',
            subtitle: 'قسم الخدمات الطبية • متاح اليوم',
            icon: Icons.medical_services_outlined,
            color: Colors.red,
          ),
          const SizedBox(height: 12),
          _buildSmartSuggestionCard(
            title: 'تأسيس كهرباء وصيانة أعطال',
            subtitle: 'قسم الصيانة المنزلية',
            icon: Icons.electric_bolt_outlined,
            color: Colors.blue,
          ),
          const SizedBox(height: 12),
          _buildSmartSuggestionCard(
            title: 'تنسيق حدائق خارجية',
            subtitle: 'قسم العناية بالمرافق',
            icon: Icons.local_florist_outlined,
            color: Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _buildPopularServiceChip(String label, IconData icon) {
    return GestureDetector(
      onTap: () => _triggerSearch(label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.greyLight),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.01),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.primary, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
                fontFamily: 'Cairo',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSmartSuggestionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return GestureDetector(
      onTap: () => _triggerSearch(title),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.015),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                // Icon circle leading
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 22),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Icon(
              Icons.arrow_outward,
              color: AppColors.textSecondary,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults(List<Map<String, dynamic>> results) {
    if (results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off_outlined, size: 64, color: AppColors.textSecondary.withValues(alpha: 0.4)),
            const SizedBox(height: 16),
            const Text(
              'لا توجد نتائج مطابقة لبحثك',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textSecondary,
                fontFamily: 'Cairo',
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'تأكد من كتابة الكلمة بشكل صحيح أو جرب كلمات أخرى',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
                fontFamily: 'Cairo',
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final item = results[index];
        if (item['type'] == 'tech') {
          return _buildTechResultCard(item);
        } else {
          return _buildServiceResultCard(item);
        }
      },
    );
  }

  Widget _buildTechResultCard(Map<String, dynamic> tech) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.015),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Technician icon avatar details
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: tech['avatarColor'].withValues(alpha: 0.1),
                ),
                child: Center(
                  child: Icon(tech['icon'], color: tech['avatarColor'], size: 28),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                tech['price'],
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                  fontFamily: 'Cairo',
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          
          // Bio details & button
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      tech['name'],
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.greyLight.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        tech['category'],
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      '${tech['rating']} (${tech['reviews']} تقييم)',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  tech['bio'],
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    height: 1.4,
                    fontFamily: 'Cairo',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceResultCard(Map<String, dynamic> service) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.01),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: service['color'].withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(service['icon'], color: service['color'], size: 22),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service['name'],
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                      fontFamily: 'Cairo',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    service['category'],
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Icon(
            Icons.arrow_outward,
            color: AppColors.textSecondary,
            size: 18,
          ),
        ],
      ),
    );
  }
}
