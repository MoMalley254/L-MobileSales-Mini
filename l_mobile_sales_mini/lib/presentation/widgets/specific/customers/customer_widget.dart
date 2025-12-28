import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../data/models/customers/customer_model.dart';

class CustomerWidget extends StatelessWidget {
  final Customer customer;
  const CustomerWidget({super.key, required this.customer});

  final String sampleImage = '';

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(top: 5, bottom: 20),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildCustomerLogo(context, sampleImage),
            const SizedBox(width: 10),
            Expanded(child: buildCustomerInfo(context, customer)),
          ],
        ),
      ),
    );
  }

  // Customer logo
  Widget buildCustomerLogo(BuildContext context, String customerLogo) {
    return customerLogo.isNotEmpty ? SizedBox(
      width: MediaQuery.of(context).size.width * 0.2,
      child: Image.network(
        customerLogo,
        height: 50,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const SizedBox.shrink(),
      ),
    ) : const SizedBox.shrink();
  }

  // Customer info column
  Widget buildCustomerInfo(BuildContext context, Customer customer) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Name and category
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: buildCustomerName(context, customer.name)),
            buildCategoryIndicator(customer.category),
          ],
        ),
        const SizedBox(height: 5),
        buildContactPerson(customer.contactPerson),
        const SizedBox(height: 5),
        buildPhoneRow(customer.phone),
        const SizedBox(height: 5),
        buildEmailRow(customer.email),
        const SizedBox(height: 5),
        buildAddressRow(customer.physicalAddress, customer.location),
        const SizedBox(height: 5),
        buildTaxInfo(customer.taxId),
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

  Widget buildContactPerson(String contactPerson) {
    return Row(
      children: [
        const Icon(Icons.person, size: 16),
        const SizedBox(width: 5),
        Expanded(child: Text(contactPerson)),
      ],
    );
  }

  Widget buildPhoneRow(String phone) {
    return Row(
      children: [
        const Icon(Icons.phone, size: 16),
        const SizedBox(width: 5),
        Expanded(child: Text(phone)),
        IconButton(
          icon: const Icon(Icons.call, size: 20, color: Colors.green),
          onPressed: () => launchUrl(Uri.parse('tel:$phone')),
        ),
      ],
    );
  }

  Widget buildEmailRow(String email) {
    return Row(
      children: [
        const Icon(Icons.email, size: 16),
        const SizedBox(width: 5),
        Expanded(child: Text(email)),
        IconButton(
          icon: const Icon(Icons.send, size: 20, color: Colors.blue),
          onPressed: () => launchUrl(Uri.parse('mailto:$email')),
        ),
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
          icon: const Icon(Icons.map, size: 20, color: Colors.red),
          onPressed: () {
            final lat =  location.latitude ?? 0;
            final lng =  location.longitude ?? 0;
            launchUrl(Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng'));
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
}
