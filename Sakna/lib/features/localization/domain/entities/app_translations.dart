class AppTranslations {
  static const Map<String, Map<String, String>> _keys = {
    'ar': {
      'welcome_title': 'مرحباً بك في خدمة سكنى',
      'welcome_subtitle': 'نخبة من الفنيين والكوادر الطبية في خدمتك بلمسة واحدة.',
      'login': 'تسجيل الدخول',
      'create_account': 'إنشاء حساب جديد',
      'welcome_back': 'أهلاً بك،',
      'user_name': 'أحمد محمد',
      'all_services': 'جميع الخدمات',
      'main_categories': 'التصنيفات الرئيسية',
      'search_hint': 'ابحث عن خدمة، فني، أو عقار...',
      'popular_services': 'الخدمات الشائعة',
      'subscription_packages': 'باقات الاشتراك',
      'residential_properties': 'العقارات السكنية',
      'details': 'التفاصيل',
      'theme_dark': 'الوضع الداكن',
      'theme_light': 'الوضع المضيء',
      'lang_en': 'English',
      'lang_ar': 'عربي',
      'home': 'الرئيسية',
      'services': 'الخدمات',
      'chat': 'الدردشة',
      'profile': 'الحساب',
      
      // Category translations
      'cat_maintenance': 'الصيانة',
      'cat_cleaning': 'خدمات منزلية',
      'cat_medical': 'خدمات طبية',
      'cat_cleaning_deep': 'تنظيف',
      'cat_real_estate': 'عقارات',
      'cat_finishing': 'تشطيبات',
      'cat_moving': 'نقل عفش',
      'cat_companies': 'شركات',
      'cat_office': 'خدمات مكاتب',
      
      // Sub-services and other details
      'technicians_count': 'فني متخصص جاهز لخدمتك',
      'properties_count': 'عقار متاح للبيع والإيجار',
      'package_subscriber': 'مشترك مفعل حالياً',
      'ai_diagnostics': 'فحص الأعطال بالذكاء الاصطناعي',
      'ai_diagnostics_desc': 'قم بتصوير المشكلة وسيقوم نظامنا بتحديد العطل مجاناً وتحديد الفني المناسب.',
      'start_diagnostic': 'ابدأ الفحص الذكي الآن',
    },
    'en': {
      'welcome_title': 'Welcome to Sakna Service',
      'welcome_subtitle': 'A premium group of technicians and medical staff at your service in one touch.',
      'login': 'Login',
      'create_account': 'Create New Account',
      'welcome_back': 'Welcome back,',
      'user_name': 'Ahmad Mohammad',
      'all_services': 'All Services',
      'main_categories': 'Main Categories',
      'search_hint': 'Search for service, technician, or property...',
      'popular_services': 'Popular Services',
      'subscription_packages': 'Subscription Packages',
      'residential_properties': 'Residential Properties',
      'details': 'Details',
      'theme_dark': 'Dark Mode',
      'theme_light': 'Light Mode',
      'lang_en': 'English',
      'lang_ar': 'عربي',
      'home': 'Home',
      'services': 'Services',
      'chat': 'Chat',
      'profile': 'Profile',
      
      // Category translations
      'cat_maintenance': 'Maintenance',
      'cat_cleaning': 'Home Services',
      'cat_medical': 'Medical Services',
      'cat_cleaning_deep': 'Deep Cleaning',
      'cat_real_estate': 'Real Estate',
      'cat_finishing': 'Finishing',
      'cat_moving': 'Furniture Moving',
      'cat_companies': 'Companies',
      'cat_office': 'Office Services',
      
      // Sub-services and other details
      'technicians_count': 'specialized technicians ready',
      'properties_count': 'properties available',
      'package_subscriber': 'active subscribers',
      'ai_diagnostics': 'AI Fault Diagnosis',
      'ai_diagnostics_desc': 'Photograph the problem and our AI will detect the fault and assign the best technician for free.',
      'start_diagnostic': 'Start Smart Diagnostic',
    }
  };

  static String translate(String langCode, String key) {
    final Map<String, String>? langMap = _keys[langCode];
    if (langMap == null) return key;
    return langMap[key] ?? key;
  }
}
