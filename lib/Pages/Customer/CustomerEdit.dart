import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:salespersontracking/Models/customer_model.dart';
import 'package:salespersontracking/Providers/Customer/customer_provider.dart';
import 'package:salespersontracking/Style/Stylecustomer.dart';
import 'package:salespersontracking/Validation/ToastMessage.dart';
import 'package:animated_custom_dropdown/custom_dropdown.dart';

class CustomerEdit extends ConsumerStatefulWidget {
  final Customer customer;
  const CustomerEdit({super.key, required this.customer});

  @override
  ConsumerState<CustomerEdit> createState() => _CustomerEditState();
}

class _CustomerEditState extends ConsumerState<CustomerEdit> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers
  late TextEditingController _customerNameController;
  late TextEditingController _companyNameController;
  late TextEditingController _industryController;
  late TextEditingController _employeesController;
  late TextEditingController _customerTypeController;
  late TextEditingController _statusController;
  late TextEditingController _leadSourceController;
  late TextEditingController _assignedToController;
  late TextEditingController _mobileNumberController;
  late TextEditingController _emailIdController;
  late TextEditingController _stateController;
  late TextEditingController _cityController;
  late TextEditingController _addressLineController;
  final _gstNoController = TextEditingController();
  final _paymentTermsController = TextEditingController();

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _customerNameController = TextEditingController(text: widget.customer.customerName);
    _companyNameController = TextEditingController(text: widget.customer.companyName);
    _industryController = TextEditingController(text: widget.customer.industry);
    _employeesController = TextEditingController(text: widget.customer.employees?.toString());
    _customerTypeController = TextEditingController(text: widget.customer.customerType);
    _statusController = TextEditingController(text: widget.customer.status);
    _leadSourceController = TextEditingController(text: widget.customer.leadSource);
    _assignedToController = TextEditingController(text: widget.customer.assignedTo);
    _mobileNumberController = TextEditingController(text: widget.customer.mobileNumber);
    _emailIdController = TextEditingController(text: widget.customer.emailId);
    _stateController = TextEditingController(text: widget.customer.state);
    _cityController = TextEditingController(text: widget.customer.city);
    _addressLineController = TextEditingController(text: widget.customer.addressLine);
    _gstNoController.text = widget.customer.gstNo;
    _paymentTermsController.text = widget.customer.paymentTerms ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Edit Account", style: GoogleFonts.poppins(fontWeight: FontWeight.w700, color: Colors.black)),
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
                    _buildTextField("State", _stateController),
                    _buildTextField("City", _cityController),
                  ),
                  _buildTextField("Address Line", _addressLineController),

                  const SizedBox(height: 24),
                  _buildSectionHeader("Finance", Icons.account_balance_outlined),
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

  Widget _buildTextField(String label, TextEditingController controller, {bool isRequired = false, TextInputType? keyboardType}) {
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
              hintText: controller.text.isEmpty ? "Select $label" : controller.text,
              items: items.isEmpty ? [controller.text.isEmpty ? "Default" : controller.text] : items,
              onChanged: (value) => controller.text = value ?? "",
              decoration: CustomDropdownDecoration(
                closedFillColor: Colors.transparent,
                expandedFillColor: Colors.white,
                closedBorderRadius: BorderRadius.circular(12),
                hintStyle: GoogleFonts.poppins(color: Colors.black87, fontSize: 14),
                headerStyle: GoogleFonts.poppins(fontSize: 14),
              ),
            ),
            orElse: () => Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(controller.text.isEmpty ? "Loading..." : controller.text, style: const TextStyle(fontSize: 14)),
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
            onPressed: _updateCustomer,
            style: ElevatedButton.styleFrom(
              backgroundColor: Stylecustomer.CrmColor,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              elevation: 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.update, color: Colors.white),
                const SizedBox(width: 8),
                Text("UPDATE ACCOUNT", style: GoogleFonts.poppins(fontWeight: FontWeight.w700, color: Colors.white)),
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

  void _updateCustomer() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSaving = true);
      
      final updatedCustomer = Customer(
        id: widget.customer.id,
        customerName: _customerNameController.text,
        companyName: _companyNameController.text,
        industry: _industryController.text,
        employees: int.tryParse(_employeesController.text),
        customerType: _customerTypeController.text,
        status: _statusController.text,
        leadSource: _leadSourceController.text,
        assignedTo: _assignedToController.text,
        mobileNumber: _mobileNumberController.text,
        emailId: _emailIdController.text,
        country: widget.customer.country,
        state: _stateController.text,
        city: _cityController.text,
        addressLine: _addressLineController.text,
        gstNo: _gstNoController.text,
        paymentTerms: _paymentTermsController.text,
      );

      try {
        await ref.read(customerProvider.notifier).updateCustomer(updatedCustomer);
        SuccessToast.showToast(context: context, title: "Updated", description: "Customer details updated");
        Navigator.pop(context); // Pop edit
        Navigator.pop(context); // Pop overview to refresh data (since notifier will invalidate list)
      } catch (e) {
        ErrorToast.showToast(context: context, title: "Error", description: e.toString());
      } finally {
        setState(() => _isSaving = false);
      }
    }
  }
}
