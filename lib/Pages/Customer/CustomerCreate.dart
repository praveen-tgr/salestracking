import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:salespersontracking/Models/customer_model.dart';
import 'package:salespersontracking/Providers/Customer/customer_provider.dart';
import 'package:salespersontracking/Style/Stylecustomer.dart';
import 'package:salespersontracking/Validation/ToastMessage.dart';
import 'package:animated_custom_dropdown/custom_dropdown.dart';

class CustomerCreate extends ConsumerStatefulWidget {
  const CustomerCreate({super.key});

  @override
  ConsumerState<CustomerCreate> createState() => _CustomerCreateState();
}

class _CustomerCreateState extends ConsumerState<CustomerCreate> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers
  final _customerNameController = TextEditingController();
  final _companyNameController = TextEditingController();
  final _industryController = TextEditingController();
  final _employeesController = TextEditingController();
  final _customerTypeController = TextEditingController();
  final _statusController = TextEditingController();
  final _leadSourceController = TextEditingController();
  final _assignedToController = TextEditingController();
  final _mobileNumberController = TextEditingController();
  final _emailIdController = TextEditingController();
  final _countryController = TextEditingController(text: "India");
  final _stateController = TextEditingController();
  final _cityController = TextEditingController();
  final _addressLineController = TextEditingController();
  final _gstNoController = TextEditingController();
  final _paymentTermsController = TextEditingController();

  bool _isSaving = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Create Account", style: GoogleFonts.poppins(fontWeight: FontWeight.w700, color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(icon: const Icon(CupertinoIcons.back, color: Colors.black), onPressed: () => Navigator.pop(context)),
      ),
      body: _isSaving 
        ? const Center(child: CircularProgressIndicator(color: Stylecustomer.CrmColor))
        : Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader("Basic Information", Icons.info_outline),
                  _buildTwoColumnRow(
                    _buildTextField("Customer Name*", _customerNameController, isRequired: true),
                    _buildTextField("Company Name*", _companyNameController, isRequired: true),
                  ),
                  _buildTwoColumnRow(
                    _buildLookupDropdown("Industry", "Industry", _industryController),
                    _buildTextField("Employees", _employeesController, keyboardType: TextInputType.number),
                  ),
                  
                  const SizedBox(height: 24),
                  _buildSectionHeader("Classification", Icons.category_outlined),
                  _buildTwoColumnRow(
                    _buildLookupDropdown("Customer Type*", "Customer Type", _customerTypeController),
                    _buildLookupDropdown("Status*", "Status", _statusController),
                  ),
                  _buildTwoColumnRow(
                    _buildLookupDropdown("Lead Source", "Lead Source", _leadSourceController),
                    _buildLookupDropdown("Assigned To", "Sales Owner", _assignedToController),
                  ),

                  const SizedBox(height: 24),
                  _buildSectionHeader("Contact Details", Icons.contact_phone_outlined),
                  _buildTwoColumnRow(
                    _buildTextField("Mobile Number*", _mobileNumberController, isRequired: true, keyboardType: TextInputType.phone),
                    _buildTextField("E-mail Id*", _emailIdController, isRequired: true, keyboardType: TextInputType.emailAddress),
                  ),

                  const SizedBox(height: 24),
                  _buildSectionHeader("Location", Icons.location_on_outlined),
                  _buildTwoColumnRow(
                    _buildTextField("Country", _countryController, readOnly: true),
                    _buildTextField("State", _stateController),
                  ),
                  _buildTwoColumnRow(
                    _buildTextField("City", _cityController),
                    _buildTextField("Address Line", _addressLineController),
                  ),

                  const SizedBox(height: 24),
                  _buildSectionHeader("Financial Details", Icons.account_balance_outlined),
                  _buildTwoColumnRow(
                    _buildTextField("GST No*", _gstNoController, isRequired: true),
                    _buildLookupDropdown("Payment Terms", "Payment Terms", _paymentTermsController),
                  ),

                  const SizedBox(height: 40),
                  _buildActionButtons(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Stylecustomer.CrmColor),
          const SizedBox(width: 8),
          Text(
            title.toUpperCase(),
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: Stylecustomer.CrmColor,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(width: 8),
          const Expanded(child: Divider()),
        ],
      ),
    );
  }

  Widget _buildTwoColumnRow(Widget left, Widget right) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 600) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: left),
                const SizedBox(width: 16),
                Expanded(child: right),
              ],
            );
          } else {
            return Column(
              children: [
                left,
                const SizedBox(height: 16),
                right,
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool isRequired = false, TextInputType? keyboardType, bool readOnly = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black54)),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF4F7FA),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            readOnly: readOnly,
            style: GoogleFonts.poppins(fontSize: 14),
            validator: (value) {
              if (isRequired && (value == null || value.isEmpty)) {
                return 'Required';
              }
              return null;
            },
            decoration: InputDecoration(
              hintText: "Enter $label",
              hintStyle: GoogleFonts.poppins(color: Colors.grey[400], fontSize: 13),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLookupDropdown(String label, String category, TextEditingController controller) {
    final lookupAsync = ref.watch(customerLookupsProvider(category));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black54)),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF4F7FA),
            borderRadius: BorderRadius.circular(12),
          ),
          child: lookupAsync.maybeWhen(
            data: (items) => CustomDropdown<String>(
              hintText: "Select $label",
              items: items.isEmpty ? ["Default"] : items,
              onChanged: (value) => controller.text = value ?? "",
              decoration: CustomDropdownDecoration(
                closedFillColor: Colors.transparent,
                expandedFillColor: Colors.white,
                closedBorderRadius: BorderRadius.circular(12),
                hintStyle: GoogleFonts.poppins(color: Colors.grey[400], fontSize: 13),
                headerStyle: GoogleFonts.poppins(fontSize: 14),
              ),
            ),
            orElse: () => const Padding(
              padding: EdgeInsets.all(12.0),
              child: Text("Loading...", style: TextStyle(fontSize: 12)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: _saveCustomer,
            style: ElevatedButton.styleFrom(
              backgroundColor: Stylecustomer.CrmColor,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              elevation: 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.check_circle_outline, color: Colors.white),
                const SizedBox(width: 8),
                Text("SAVE ACCOUNT", style: GoogleFonts.poppins(fontWeight: FontWeight.w700, color: Colors.white)),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(15),
          ),
          child: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close, color: Colors.grey),
            padding: const EdgeInsets.all(16),
          ),
        ),
      ],
    );
  }

  void _saveCustomer() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSaving = true);
      
      final customer = Customer(
        customerName: _customerNameController.text,
        companyName: _companyNameController.text,
        industry: _industryController.text,
        employees: int.tryParse(_employeesController.text),
        customerType: _customerTypeController.text,
        status: _statusController.text.isEmpty ? "Active" : _statusController.text,
        leadSource: _leadSourceController.text,
        assignedTo: _assignedToController.text,
        mobileNumber: _mobileNumberController.text,
        emailId: _emailIdController.text,
        country: _countryController.text,
        state: _stateController.text,
        city: _cityController.text,
        addressLine: _addressLineController.text,
        gstNo: _gstNoController.text,
        paymentTerms: _paymentTermsController.text,
      );

      try {
        await ref.read(customerProvider.notifier).addCustomer(customer);
        SuccessToast.showToast(context: context, title: "Success", description: "Customer created successfully");
        Navigator.pop(context);
      } catch (e) {
        ErrorToast.showToast(context: context, title: "Error", description: e.toString());
      } finally {
        setState(() => _isSaving = false);
      }
    }
  }
}
