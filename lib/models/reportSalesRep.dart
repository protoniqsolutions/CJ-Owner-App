// lib/models/sales_rep.dart
import 'dart:ffi';

class ReportSalesRep {
  final String salesRepId;
  final String salesRepName;
  final double totalSales;
  final double totalMargin;
  final int numberOfInvoices;
  final SalesRepDetails salesRepDetails;

  ReportSalesRep({
    required this.salesRepId,
    required this.salesRepName,
    required this.totalSales,
    required this.totalMargin,
    required this.numberOfInvoices,
    required this.salesRepDetails,
  });

  factory ReportSalesRep.fromJson(Map<String, dynamic> json) {
    return ReportSalesRep(
      salesRepId: json['salesRepId'],
      salesRepName: json['salesRepName'],
      totalSales: json['totalSales'] * 1.0 ,
      totalMargin:  json['totalMargin'] * 1.0  ,
      numberOfInvoices: json['numberOfInvoices'],
      salesRepDetails: SalesRepDetails.fromJson(json['salesRepDetails']),
    );
  }
}

class SalesRepDetails {
  final String nic;
  final String address;
  final String dob;
  final String mobileNumber;
  final String email;

  SalesRepDetails({
    required this.nic,
    required this.address,
    required this.dob,
    required this.mobileNumber,
    required this.email,
  });

  factory SalesRepDetails.fromJson(Map<String, dynamic> json) {
    return SalesRepDetails(
      nic: json['nic'],
      address: json['address'],
      dob: json['dob'],
      mobileNumber: json['mobileNumber'],
      email: json['email'],
    );
  }
}
