import 'dart:convert';

class Customer {
  final int? id;
  final String? salesOwner;
  final String customerName;
  final String companyName;
  final String? industry;
  final int? employees;
  final String customerType;
  final String status;
  final String? leadSource;
  final String? assignedTo;
  final String? mobileCode;
  final String mobileNumber;
  final String emailId;
  final String? country;
  final String? state;
  final String? city;
  final String? addressLine;
  final String gstNo;
  final String? paymentTerms;

  Customer({
    this.id,
    this.salesOwner,
    required this.customerName,
    required this.companyName,
    this.industry,
    this.employees,
    required this.customerType,
    required this.status,
    this.leadSource,
    this.assignedTo,
    this.mobileCode,
    required this.mobileNumber,
    required this.emailId,
    this.country,
    this.state,
    this.city,
    this.addressLine,
    required this.gstNo,
    this.paymentTerms,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'SalesOwner': salesOwner,
      'CustomerName': customerName,
      'CompanyName': companyName,
      'Industry': industry,
      'Employees': employees,
      'CustomerType': customerType,
      'Status': status,
      'LeadSource': leadSource,
      'AssignedTo': assignedTo,
      'MobileCode': mobileCode,
      'MobileNumber': mobileNumber,
      'EmailID': emailId,
      'Country': country,
      'State': state,
      'City': city,
      'AddressLine': addressLine,
      'GSTNo': gstNo,
      'PaymentTerms': paymentTerms,
    };
  }

  factory Customer.fromMap(Map<String, dynamic> map) {
    return Customer(
      id: map['id']?.toInt(),
      salesOwner: map['SalesOwner'] ?? map['username'], // Fallback for sales person
      customerName: map['CustomerName'] ?? map['LeadFirstName'] ?? '',
      companyName: map['CompanyName'] ?? '',
      industry: map['Industry'],
      employees: map['Employees']?.toInt(),
      customerType: map['CustomerType'] ?? 'Regular',
      status: map['Status'] ?? 'Active',
      leadSource: map['LeadSource'],
      assignedTo: map['AssignedTo'],
      mobileCode: map['MobileCode'],
      mobileNumber: map['MobileNumber'] ?? map['MobileNo'] ?? '',
      emailId: map['EmailID'] ?? map['Email'] ?? '',
      country: map['Country'],
      state: map['State'],
      city: map['City'],
      addressLine: map['AddressLine'] ?? map['Address'],
      gstNo: map['GSTNo'] ?? '',
      paymentTerms: map['PaymentTerms'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Customer.fromJson(String source) => Customer.fromMap(json.decode(source));
}
