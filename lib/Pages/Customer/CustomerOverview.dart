import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:salespersontracking/Models/customer_model.dart';
import 'package:salespersontracking/Pages/Customer/CustomerEdit.dart';
import 'package:salespersontracking/Style/Stylecustomer.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomerOverview extends StatelessWidget {
  final Customer customer;
  const CustomerOverview({super.key, required this.customer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FBFF),
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context),
          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildQuickActions(),
                _buildDetailsSections(),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CustomerEdit(customer: customer)),
        ),
        backgroundColor: Stylecustomer.CrmColor,
        icon: const Icon(Icons.edit, color: Colors.white),
        label: const Text("EDIT ACCOUNT", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 240,
      pinned: true,
      backgroundColor: Stylecustomer.CrmColor,
      leading: IconButton(
        icon: const Icon(CupertinoIcons.back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Stylecustomer.CrmColor, Color(0xFF0097A7)],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              Container(
                height: 90,
                width: 90,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: Center(
                  child: Text(
                    customer.customerName.isNotEmpty ? customer.customerName[0].toUpperCase() : 'C',
                    style: GoogleFonts.poppins(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                customer.customerName,
                style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              Text(
                customer.companyName,
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.white.withOpacity(0.8)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildActionButton(Icons.phone_outlined, "Call", () => _launchURL("tel:${customer.mobileNumber}")),
          _buildActionButton(Icons.email_outlined, "Email", () => _launchURL("mailto:${customer.emailId}")),
          _buildActionButton(Icons.location_on_outlined, "Map", () {}), // Add map logic if needed
          _buildActionButton(Icons.share_outlined, "Share", () {}),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Stylecustomer.CrmColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Stylecustomer.CrmColor, size: 24),
          ),
          const SizedBox(height: 6),
          Text(label, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black54)),
        ],
      ),
    );
  }

  Widget _buildDetailsSections() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoTitle("Business Details"),
          _buildDetailCard([
            _buildDetailRow("Industry", customer.industry ?? "Not Set"),
            _buildDetailRow("Customer Type", customer.customerType),
            _buildDetailRow("Lead Source", customer.leadSource ?? "Direct"),
            _buildDetailRow("Employees", customer.employees?.toString() ?? "0"),
          ]),
          const SizedBox(height: 24),
          _buildInfoTitle("Contact Information"),
          _buildDetailCard([
            _buildDetailRow("Mobile", "${customer.mobileCode ?? '+91'} ${customer.mobileNumber}"),
            _buildDetailRow("Email", customer.emailId),
            _buildDetailRow("Sales Owner", customer.salesOwner ?? "Unassigned"),
          ]),
          const SizedBox(height: 24),
          _buildInfoTitle("Location & Finance"),
          _buildDetailCard([
            _buildDetailRow("GST Number", customer.gstNo),
            _buildDetailRow("City", customer.city ?? "Not Set"),
            _buildDetailRow("Address", customer.addressLine ?? "No Address Provided"),
            _buildDetailRow("Payment Terms", customer.paymentTerms ?? "N/A"),
          ]),
        ],
      ),
    );
  }

  Widget _buildInfoTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 12),
      child: Text(
        title.toUpperCase(),
        style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w800, color: Colors.grey[400], letterSpacing: 1.5),
      ),
    );
  }

  Widget _buildDetailCard(List<Widget> children) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Text(label, style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[500], fontWeight: FontWeight.w500)),
          ),
          Expanded(
            flex: 5,
            child: Text(
              value,
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87, fontWeight: FontWeight.w600),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  void _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}
