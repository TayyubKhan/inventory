import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Components/Drawer.dart';
import '../Model/customer_model.dart';
import '../ViewModel/CustomerVIewModel.dart';

class CustomerScreen extends StatefulWidget {
  @override
  State<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CustomerProvider>(context);
    return Scaffold(
      drawer: const AppDrawer(),
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'All Customers',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: InkWell(
              onTap: () async {
                await provider.getFromApi();
                setState(() {});
              },
              child: const Icon(Icons.refresh),
            ),
          )
        ],
      ),
      body: FutureBuilder<List<CustomerModel>>(
        future: provider.fetchCustomers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final customer = snapshot.data![index];
                  return _buildCustomerCard(customer);
                },
              );
            } else {
              return const Center(child: Text('No Data'));
            }
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.black),
            );
          } else {
            return Container(); // Placeholder widget
          }
        },
      ),
    );
  }

  Widget _buildCustomerCard(CustomerModel customer) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID: ${customer.id ?? ''}'),
            Text('Name: ${customer.name ?? ''}'),
            Text('Owner: ${customer.owner ?? ''}'),
            Text('Phone: ${customer.phone ?? ''}'),
            Text('Area: ${customer.area ?? ''}'),
            Text('Address: ${customer.address ?? ''}'),
          ],
        ),
      ),
    );
  }
}
