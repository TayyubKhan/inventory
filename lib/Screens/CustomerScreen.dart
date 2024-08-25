import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Components/Drawer.dart';
import '../Model/customer_model.dart';
import '../ViewModel/CustomerVIewModel.dart';

class CustomerScreen extends StatefulWidget {
  const CustomerScreen({super.key});

  @override
  State<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  late Future<List<CustomerModel>> _futureCustomers;
  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final CustomerProvider provider =
        Provider.of<CustomerProvider>(context, listen: false);
    _futureCustomers = provider.fetchCustomers(searchController.text);
  }

  Future<void> _refreshInvoices() async {
    try {
      final CustomerProvider provider =
          Provider.of<CustomerProvider>(context, listen: false);
      final customer = await provider.getFromApi();
      setState(() {
        _futureCustomers = Future.value(customer);
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to refresh invoices: $error'),
      ));
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    searchController.dispose();
  }

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
                provider.getFromApi();
              },
              child: const Icon(Icons.refresh),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                Provider.of<CustomerProvider>(context, listen: false)
                    .updateSearchQuery(value);
              },
              decoration: const InputDecoration(
                  hintText: 'Search Customer/Address',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black))),
            ),
          ),
          Flexible(
            child: Consumer<CustomerProvider>(builder: (context, value, _) {
              return FutureBuilder<List<CustomerModel>>(
                future: value.fetchCustomers(searchController.text),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          itemCount: value.filteredCustomers.length,
                          itemBuilder: (context, index) {
                            final customer = provider.filteredCustomers[index];
                            return buildCustomerCard(customer);
                          });
                    } else {
                      return const Center(child: Text('No Data'));
                    }
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.black),
                    );
                  } else {
                    return Container(); // Placeholder widget
                  }
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}

Widget buildCustomerCard(CustomerModel customer) {
  return Card(
    margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
