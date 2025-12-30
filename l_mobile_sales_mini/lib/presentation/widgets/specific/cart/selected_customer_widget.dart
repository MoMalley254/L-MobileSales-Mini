import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../data/models/customers/customer_model.dart';

class SelectedCustomerWidget extends StatelessWidget {
  final Customer customer;
  final bool showFullDetails;
  const SelectedCustomerWidget({super.key, required this.customer, required this.showFullDetails});

  final String sampleImage = '';

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(top: 5, bottom: 20),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: showFullDetails ? buildCustomerInfo(context, customer) : buildMinimalInfo(context, customer),
      ),
    );
  }

  // Customer info column
  Widget buildCustomerInfo(BuildContext context, Customer customer) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Name and category
        buildHead(context, customer),
        const SizedBox(height: 5),
        buildPhone(context, customer),
        const SizedBox(height: 5),
        buildEmailRow(customer.email),
        const SizedBox(height: 5),
        buildAddressRow(customer.physicalAddress, customer.location),
        const SizedBox(height: 5),
        buildTaxInfo(customer.taxId),
      ],
    );
  }

  Widget buildHead(BuildContext context, Customer customer) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: buildCustomerName(context, customer.name)),
        buildCategoryIndicator(customer.category),
      ],
    );
  }

  Widget buildPhone(BuildContext context, Customer customer) {
    return Row(
      children: [
        buildContactPerson(context, customer.contactPerson),
        const SizedBox(width: 5),
        buildPhoneRow(context, customer.phone),
      ],
    );
  }

  Widget buildCustomerName(BuildContext context, String customerName) {
    return Text(
      customerName,
      style: Theme.of(context).textTheme.bodyMedium,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget buildCategoryIndicator(String category) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.blueAccent,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        category,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget buildContactPerson(BuildContext context, String contactPerson) {
    return Text(contactPerson, style: TextTheme.of(context).labelMedium,);
  }

  Widget buildPhoneRow(BuildContext context, String phone) {
    return Text(phone, style: TextTheme.of(context).labelMedium,);
  }

  Widget buildEmailRow(String email) {
    return Row(
      children: [
        const Icon(Icons.email, size: 16),
        const SizedBox(width: 5),
        Expanded(child: Text(email)),
      ],
    );
  }

  Widget buildAddressRow(PhysicalAddress address, Location location) {
    return Row(
      children: [
        const Icon(Icons.location_on, size: 16),
        const SizedBox(width: 5),
        Expanded(
          child: Text('${address.building}, ${address.street}, ${address.city}'),
        ),
        IconButton(
          icon: const Icon(Icons.edit, size: 20, color: Colors.red),
          onPressed: () {
            //Change address
          },
        )
      ],
    );
  }

  Widget buildTaxInfo(String taxId) {
    return Row(
      children: [
        const Icon(Icons.badge, size: 16),
        const SizedBox(width: 5),
        Text('Tax ID: $taxId'),
      ],
    );
  }

  Widget buildMinimalInfo(BuildContext context, Customer customer) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildHead(context, customer),
        const SizedBox(height: 5),
        buildPhone(context, customer),
      ],
    );
  }
}
