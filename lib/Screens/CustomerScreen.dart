
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
                child: const Icon(
                  Icons.refresh,
                )),
          )
        ],
      ),
      body: FutureBuilder<List<CustomerModel>>(
        future: provider.fetchCustomers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              // Build your DataTable here with snapshot.data
              return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('ID')),
                      DataColumn(label: Text('Name')),
                      DataColumn(label: Text('Owner')),
                      DataColumn(label: Text('Phone')),
                      DataColumn(label: Text('Area')),
                      DataColumn(label: Text('Address')),
                    ],
                    rows: snapshot.data!
                        .map(
                          (data) => DataRow(cells: [
                        DataCell(Text(data.id.toString() ?? '')),
                        DataCell(Text(data.name ?? '')),
                        DataCell(SelectableText(data.owner ?? '')),
                        DataCell(SelectableText(data.phone ?? '')),
                        DataCell(Text(data.area ?? '')),
                        DataCell(Text(data.address?.toString() ?? '')),
                      ]),
                    )
                        .toList(),
                  ),
                ),
              );
            } else {
              return const Center(child: Text('No Data'));
            }
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.black),
            );
          } else {
            return Container();
          }
        },
      ),

    );
  }
}
