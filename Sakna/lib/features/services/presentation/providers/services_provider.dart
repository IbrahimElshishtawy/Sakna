import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'services_state.dart';

class ServicesNotifier extends Notifier<ServicesState> {
  @override
  ServicesState build() {
    return const ServicesState();
  }

  void selectCategory(String? categoryId) {
    state = state.copyWith(
      selectedCategoryId: () => categoryId,
      selectedSubCategoryId: () => null, // Reset sub-category on main change
    );
  }

  void selectSubCategory(String? subCategoryId) {
    state = state.copyWith(
      selectedSubCategoryId: () => subCategoryId,
    );
  }

  void updateSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  Future<void> simulateDiagnostics(String applianceName) async {
    state = state.copyWith(
      isDiagnosticsLoading: true,
      diagnosticsResult: () => null,
    );

    // Simulate network/AI analysis delay
    await Future.delayed(const Duration(seconds: 2));

    String suggestion = '';
    if (applianceName.contains('غسالة')) {
      suggestion = 'تم رصد انسداد في مضخة الطرد أو اهتزاز غير متزن في الحلة الداخلية. ننصح بحجز خدمة "إصلاح صرف مياه الغسالة" أو "صيانة غسالات" فوراً.';
    } else if (applianceName.contains('ثلاجة')) {
      suggestion = 'يبدو أن هناك خللاً في عمل الثرموستات أو ضعفاً في شحن الفريون. نقترح حجز فني صيانة "تغيير ثرموستات" أو "شحن فريون ثلاجات".';
    } else if (applianceName.contains('تكييف') || applianceName.contains('مكيف')) {
      suggestion = 'تراكم الأتربة على الفلاتر والوحدة الخارجية يمنع تدفق الهواء البارد. ننصح بحجز خدمة "تنظيف وغسيل التكييف" لرفع كفاءة التبريد بنسبة 40%.';
    } else {
      suggestion = 'تم رصد خلل عام في التمديدات الميكانيكية للجهاز. يُفضل إرسال فني متخصص لفحص الدائرة الكهربائية ومعاينتها بدقة.';
    }

    state = state.copyWith(
      isDiagnosticsLoading: false,
      diagnosticsResult: () => suggestion,
    );
  }

  void clearDiagnostics() {
    state = state.copyWith(
      diagnosticsResult: () => null,
    );
  }
}

final servicesProvider = NotifierProvider<ServicesNotifier, ServicesState>(ServicesNotifier.new);
