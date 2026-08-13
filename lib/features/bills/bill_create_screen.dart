import 'package:factrack_mobile/core/utils/field_validators.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/utils/custom_text_filed.dart';
import '../../widgets/section_card.dart';
import 'bill_provider.dart';

class BillCreateScreen extends StatefulWidget {
  const BillCreateScreen({super.key});

  @override
  State<BillCreateScreen> createState() => _BillCreateScreenState();
}

class _BillCreateScreenState extends State<BillCreateScreen> {
  final _formKey = GlobalKey<FormState>();

  String? _type;
  DateTime? _period;
  DateTime? _deadline;
  late final TextEditingController _priceTotalController;
  late final TextEditingController _previousIndexController;
  late final TextEditingController _newIndexController;
  late final TextEditingController _totalConsumptionController;

  late final FocusNode _priceTotalFocus;
  late final FocusNode _previousIndexFocus;
  late final FocusNode _newIndexFocus;
  late final FocusNode _totalConsumptionFocus;

  bool _paid = false;
  bool _loading = false;

  @override
  void initState() {
    _priceTotalController = TextEditingController();
    _previousIndexController = TextEditingController();
    _newIndexController = TextEditingController();
    _totalConsumptionController = TextEditingController();
    _priceTotalFocus = FocusNode();
    _previousIndexFocus = FocusNode();
    _newIndexFocus = FocusNode();
    _totalConsumptionFocus = FocusNode();
    super.initState();

  }

  @override
  void dispose() {
    _priceTotalController.dispose();
    _previousIndexController.dispose();
    _newIndexController.dispose();
    _totalConsumptionController.dispose();
    _priceTotalFocus.dispose();
    _previousIndexFocus.dispose();
    _newIndexFocus.dispose();
    _totalConsumptionFocus.dispose();
    super.dispose();
  }

  Future<void> _pickDate(bool isPeriod) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        if (isPeriod) _period = picked;
        else _deadline = picked;
      });
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'jj/mm/aaaa';
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  String _toApiDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_period == null || _deadline == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez sélectionner les dates.')),
      );
      return;
    }

    setState(() => _loading = true);

    await context.read<BillProvider>().createBill({
      'type': _type,
      'period': _toApiDate(_period!),
      'deadline': _toApiDate(_deadline!),
      'price_total': _priceTotalController.text,
      'previous_index': _previousIndexController.text,
      'new_index': _newIndexController.text,
      'total_consumption': _totalConsumptionController.text,
      'paid': _paid,
    });

    if (!mounted) return;
    setState(() => _loading = false);

    final error = context.read<BillProvider>().error;
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: Theme.of(context).colorScheme.error),
      );
      context.read<BillProvider>().clearError();
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                'Ajouter une facture',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                'Complétez les informations ci-dessous pour enregistrer une nouvelle facture.',
                style: TextStyle(color: Theme.of(context).colorScheme.tertiary, fontSize: 13),
              ),
              const SizedBox(height: 24),

              // Type
              SectionCard(
                children: [
                  Text('Type', style: TextStyle(color: Theme.of(context).colorScheme.tertiary, fontSize: 12)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.bolt_outlined),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                    ),
                    hint: const Text('---------'),
                    value: _type,
                    items: const [
                      DropdownMenuItem(value: 'SONABEL', child: Text('SONABEL — Électricité')),
                      DropdownMenuItem(value: 'ONEA', child: Text('ONEA — Eau')),
                    ],
                    onChanged: (val) => setState(() => _type = val),
                    validator: (val) => FieldValidation().billTypeValidator(value: val),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Dates
              SectionCard(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Période', style: TextStyle(color: Theme.of(context).colorScheme.tertiary, fontSize: 12)),
                            const SizedBox(height: 8),
                            GestureDetector(
                              onTap: () => _pickDate(true),
                              child: InputDecorator(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                  suffixIcon: const Icon(Icons.calendar_today_outlined),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                                ),
                                child: Text(_formatDate(_period), style: const TextStyle(fontSize: 13)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Date limite', style: TextStyle(color: Theme.of(context).colorScheme.tertiary, fontSize: 12)),
                            const SizedBox(height: 8),
                            GestureDetector(
                              onTap: () => _pickDate(false),
                              child: InputDecorator(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                  suffixIcon: const Icon(Icons.calendar_today_outlined),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                                ),
                                child: Text(_formatDate(_deadline), style: const TextStyle(fontSize: 13)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Montants
              SectionCard(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          controller: _priceTotalController,
                          focusNode: _priceTotalFocus,
                          label: 'Prix total',
                          prefixIcon: Icons.payments_outlined,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          validator: (val) => FieldValidation().priceValidator(value: val),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: CustomTextField(
                          controller: _totalConsumptionController,
                          focusNode: _totalConsumptionFocus,
                          label: 'Consommation',
                          prefixIcon: Icons.speed_outlined,
                          keyboardType: TextInputType.number,
                          validator: (val) => FieldValidation().consumptionValidator(value: val),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          controller: _previousIndexController,
                          focusNode: _previousIndexFocus,
                          label: 'Ancien index',
                          prefixIcon: Icons.arrow_downward_outlined,
                          keyboardType: TextInputType.number,
                          validator: (val) => FieldValidation().previousIndexValidator(value: val),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: CustomTextField(
                          controller: _newIndexController,
                          focusNode: _newIndexFocus,
                          label: 'Nouveau index',
                          prefixIcon: Icons.arrow_upward_outlined,
                          keyboardType: TextInputType.number,
                          validator: (val) => FieldValidation().newIndexValidator(value: val),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Payée
              SectionCard(
                children: [
                  CheckboxListTile(
                    value: _paid,
                    onChanged: (val) => setState(() => _paid = val ?? false),
                    title: const Text('Facture déjà payée'),
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Boutons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Annuler'),
                  ),
                  const SizedBox(width: 12),
                  FilledButton(
                    onPressed: _loading ? null : _submit,
                    child: _loading
                        ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                        : const Text('Enregistrer'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    ),
    );
  }
}