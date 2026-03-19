// ignore_for_file: deprecated_member_use, file_names

import 'package:flutter/material.dart';
import 'package:khidma/features/task/helpers_list_page.dart';
import 'package:khidma/models/task_request.dart'; // موديل المهمة

class CreateTaskPage extends StatefulWidget {
  // مثال: "خدمات داخلية" / "خدمات خارجية" / "أخرى"
  final String category;

  const CreateTaskPage({super.key, required this.category});

  @override
  State<CreateTaskPage> createState() => _CreateTaskPageState();
}

class _CreateTaskPageState extends State<CreateTaskPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _serviceTypeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _hourlyPriceController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _hoursController = TextEditingController();

  bool _isUrgent = false;
  DateTime? _scheduledDate;

  String? _selectedService;
  final List<String> _serviceOptions = const [
    'تنظيف',
    'صيانة',
    'تسوق',
    'مرافقة',
    'أخرى',
  ];

  @override
  void initState() {
    super.initState();
    // السعر الافتراضي 50 جنيه
    _hourlyPriceController.text = '50';
    // عدد الساعات الافتراضي 1
    _hoursController.text = '1';
  }

  @override
  void dispose() {
    _serviceTypeController.dispose();
    _descriptionController.dispose();
    _hourlyPriceController.dispose();
    _locationController.dispose();
    _hoursController.dispose();
    super.dispose();
  }

  void _onSelectPrice(String value) {
    setState(() {
      _hourlyPriceController.text = value;
    });
  }

  void _onSelectHours(String value) {
    setState(() {
      _hoursController.text = value;
    });
  }

  void _onSelectLocation() {
    // هنا تقدر لاحقًا تربط بـ GPS أو خريطة
    setState(() {
      _locationController.text = 'موقعي الحالي';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم اختيار موقع تجريبي (يمكن ربطه بالخرائط لاحقًا)'),
      ),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final serviceType = _selectedService == 'أخرى' || _selectedService == null
        ? _serviceTypeController.text.trim()
        : _selectedService!;

    final hours = int.tryParse(_hoursController.text.trim()) ?? 1;

    final taskRequest = TaskRequest(
      category: widget.category,
      serviceType: serviceType,
      description: _descriptionController.text.trim(),
      hourlyPrice: double.tryParse(_hourlyPriceController.text.trim()) ?? 0,
      location: _locationController.text.trim(),
      hours: hours,
      isUrgent: _isUrgent,
      scheduledAt: _scheduledDate,
    );

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => HelpersListPage(taskRequest: taskRequest),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isOtherSelected =
        _selectedService == 'أخرى' || _selectedService == null;
    Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text('تفاصيل المهمة - ${widget.category}')),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'بيانات الخدمة',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 16),

                    /// نوع الخدمة (اختيار من قائمة)
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'نوع الخدمة',
                        border: OutlineInputBorder(),
                      ),
                      initialValue: _selectedService,
                      items: _serviceOptions
                          .map(
                            (s) => DropdownMenuItem(
                              value: s,
                              child: Text(s, textAlign: TextAlign.right),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedService = value;
                        });
                      },
                    ),
                    const SizedBox(height: 12),

                    /// حقل كتابة نوع الخدمة في حالة "أخرى"
                    if (isOtherSelected)
                      TextFormField(
                        controller: _serviceTypeController,
                        decoration: const InputDecoration(
                          labelText: 'اكتب نوع الخدمة',
                          border: OutlineInputBorder(),
                          hintText: 'مثال: جلي صحون، ترتيب مكتب...',
                        ),
                        validator: (value) {
                          if ((value == null || value.trim().isEmpty) &&
                              (_selectedService == null ||
                                  _selectedService == 'أخرى')) {
                            return 'من فضلك اكتب نوع الخدمة';
                          }
                          return null;
                        },
                        textAlign: TextAlign.right,
                      ),

                    if (isOtherSelected) const SizedBox(height: 16),

                    const Text(
                      'تفاصيل المهمة',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),

                    /// تفاصيل المهمة
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'وصف المهمة',
                        hintText: 'اشرح المطلوب من المساعد بشكل واضح...',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'من فضلك أدخل تفاصيل المهمة';
                        }
                        return null;
                      },
                      textAlign: TextAlign.right,
                    ),
                    const SizedBox(height: 16),

                    const Text(
                      'السعر بالساعة',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),

                    /// السعر بالساعة (اختيار + كتابة)
                    TextFormField(
                      controller: _hourlyPriceController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'السعر بالساعة (جنيه)',
                        hintText: 'مثال: 50',
                        border: OutlineInputBorder(),
                        suffixText: 'جنيه',
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'من فضلك أدخل السعر بالساعة';
                        }
                        if (double.tryParse(value) == null) {
                          return 'من فضلك أدخل رقم صحيح';
                        }
                        return null;
                      },
                      textAlign: TextAlign.right,
                    ),
                    const SizedBox(height: 8),

                    /// أزرار سريعة لاختيار السعر
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _PriceChoiceChip(
                          label: '50',
                          controller: _hourlyPriceController,
                          onSelect: _onSelectPrice,
                        ),
                        const SizedBox(width: 8),
                        _PriceChoiceChip(
                          label: '75',
                          controller: _hourlyPriceController,
                          onSelect: _onSelectPrice,
                        ),
                        const SizedBox(width: 8),
                        _PriceChoiceChip(
                          label: '100',
                          controller: _hourlyPriceController,
                          onSelect: _onSelectPrice,
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    /// خدمة عاجلة
                    SwitchListTile(
                      title: const Text(
                        'خدمة عاجلة (خلال ساعة)',
                        textAlign: TextAlign.right,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: const Text(
                        'سيتم إضافة 50% على السعر الأساسي',
                        textAlign: TextAlign.right,
                      ),
                      secondary: const Icon(Icons.bolt, color: Colors.amber),
                      value: _isUrgent,
                      onChanged: (val) {
                        setState(() {
                          _isUrgent = val;
                        });
                      },
                    ),

                    const SizedBox(height: 12),

                    /// جدولة الخدمة
                    ListTile(
                      title: Text(
                        _scheduledDate == null
                            ? 'جدولة الخدمة (اختياري)'
                            : 'موعد الخدمة: ${_scheduledDate.toString().substring(0, 16)}',
                        textAlign: TextAlign.right,
                      ),
                      trailing: const Icon(Icons.calendar_month),
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 30)),
                        );
                        if (date != null) {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          if (time != null) {
                            setState(() {
                              _scheduledDate = DateTime(
                                date.year,
                                date.month,
                                date.day,
                                time.hour,
                                time.minute,
                              );
                            });
                          }
                        }
                      },
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      'عدد الساعات',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),

                    /// عدد الساعات (حقل + تشيبس)
                    TextFormField(
                      controller: _hoursController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'عدد الساعات',
                        hintText: 'مثال: 1, 2, 3 ...',
                        border: OutlineInputBorder(),
                        suffixText: 'ساعة',
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'من فضلك أدخل عدد الساعات';
                        }
                        final parsed = int.tryParse(value);
                        if (parsed == null || parsed <= 0) {
                          return 'من فضلك أدخل عدد ساعات صحيح';
                        }
                        return null;
                      },
                      textAlign: TextAlign.right,
                    ),
                    const SizedBox(height: 8),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _HoursChoiceChip(
                          label: '1',
                          controller: _hoursController,
                          onSelect: _onSelectHours,
                        ),
                        const SizedBox(width: 8),
                        _HoursChoiceChip(
                          label: '2',
                          controller: _hoursController,
                          onSelect: _onSelectHours,
                        ),
                        const SizedBox(width: 8),
                        _HoursChoiceChip(
                          label: '3',
                          controller: _hoursController,
                          onSelect: _onSelectHours,
                        ),
                        const SizedBox(width: 8),
                        _HoursChoiceChip(
                          label: '4',
                          controller: _hoursController,
                          onSelect: _onSelectHours,
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      'موقع الخدمة',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),

                    /// حقل موقع الخدمة + زر تحديد الموقع
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _locationController,
                            decoration: const InputDecoration(
                              labelText: 'موقع الخدمة',
                              hintText: 'اكتب العنوان أو المنطقة...',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'من فضلك أدخل موقع الخدمة';
                              }
                              return null;
                            },
                            textAlign: TextAlign.right,
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton.filledTonal(
                          onPressed: _onSelectLocation,
                          icon: const Icon(Icons.location_on_outlined),
                          tooltip: 'تحديد الموقع',
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    /// زر إضافة مهمة
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: _submit,
                        icon: const Icon(Icons.check),
                        label: const Text('إضافة المهمة'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// زر اختيار سعر (Chip)
class _PriceChoiceChip extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final ValueChanged<String> onSelect;

  const _PriceChoiceChip({
    required this.label,
    required this.controller,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = controller.text.trim() == label;
    final theme = Theme.of(context);

    return ChoiceChip(
      label: Text('$label جنيه'),
      selected: isSelected,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.black87,
        fontSize: 13,
        fontWeight: FontWeight.w600,
      ),
      selectedColor: theme.colorScheme.primary,
      backgroundColor: theme.colorScheme.primary.withOpacity(0.06),
      onSelected: (_) => onSelect(label),
    );
  }
}

/// زر اختيار عدد الساعات (Chip)
class _HoursChoiceChip extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final ValueChanged<String> onSelect;

  const _HoursChoiceChip({
    required this.label,
    required this.controller,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = controller.text.trim() == label;
    final theme = Theme.of(context);

    return ChoiceChip(
      label: Text('$label ساعة'),
      selected: isSelected,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.black87,
        fontSize: 13,
        fontWeight: FontWeight.w600,
      ),
      selectedColor: theme.colorScheme.secondary,
      backgroundColor: theme.colorScheme.secondary.withOpacity(0.08),
      onSelected: (_) => onSelect(label),
    );
  }
}
