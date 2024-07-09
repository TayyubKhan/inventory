
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for clipboard functionality

import '../Components/Drawer.dart';
import '../Model/InvoiceModel.dart';
import '../Repository/InvoiceRepo.dart';

class InvoiceScreen extends StatefulWidget {
  const InvoiceScreen({super.key});

  @override
  State<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  final InvoiceRepo _invoiceRepo = InvoiceRepo();
  late Future<List<Invoices>> _futureInvoices;

  @override
  void initState() {
    super.initState();
    _futureInvoices = _invoiceRepo.fetchInvoices();
  }

  Future<void> _refreshInvoices() async {
    try {
      final invoices = await _invoiceRepo.refreshInvoices();
      setState(() {
        _futureInvoices = Future.value(invoices);
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to refresh invoices: $error'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Invoices',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: InkWell(
                onTap: _refreshInvoices, // Call the refresh method
                child: const Icon(
                  Icons.refresh,
                )),
          )
        ],
      ),
      drawer: const AppDrawer(),
      body: RefreshIndicator(
        color: Colors.white,
        onRefresh: _refreshInvoices,
        child: FutureBuilder<List<Invoices>>(
          future: _futureInvoices,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.black,
                  ));
            } else if (snapshot.hasError) {
              return const Center(child: Text('Try again later'));
            } else if (snapshot.hasData) {
              final List<Invoices> invoices = snapshot.data!;
              return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columnSpacing: MediaQuery.of(context).size.width * 0.2,
                    columns: const <DataColumn>[
                      DataColumn(
                        label: SizedBox(
                          child: Text('Order ID'),
                        ),
                      ),
                      DataColumn(
                        label: SizedBox(child: Text('Discount')),
                      ),
                      DataColumn(
                        label: SizedBox(
                          child: Text('Subtotal'),
                        ),
                      ),
                      DataColumn(
                        label: SizedBox(
                          child: Text('Grand Total'),
                        ),
                      ),
                      DataColumn(
                        label: SizedBox(
                          child: Text('Customer Name'),
                        ),
                      ),
                      DataColumn(
                        label: SizedBox(
                          child: Text('Customer Address'),
                        ),
                      ),
                      DataColumn(
                        label: SizedBox(
                          child: Text('Customer Phone'),
                        ),
                      ),
                      DataColumn(
                        label: SizedBox(
                          child: Text('Date'),
                        ),
                      ),
                    ],
                    rows: invoices
                        .map((invoice) => DataRow(
                      cells: <DataCell>[
                        DataCell(
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Clipboard.setData(ClipboardData(
                                      text: invoice.orderId ?? ''));
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text(
                                        'Order ID copied to clipboard'),
                                  ));
                                },
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.content_copy,
                                      color: Colors.black,
                                    ),
                                    const SizedBox(
                                        width:
                                        4), // Adjust spacing as needed
                                    Text(invoice.orderId ?? ''),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        DataCell(Text(invoice.discount ?? '')),
                        DataCell(Text(invoice.subtotal ?? '')),
                        DataCell(Text(invoice.grandTotal ?? '')),
                        DataCell(Text(invoice.cName ?? '')),
                        DataCell(Text(invoice.cAddress ?? '')),
                        DataCell(Text(invoice.cPhone ?? '')),
                        DataCell(Text(invoice.date ?? '')),
                      ],
                    ))
                        .toList(),
                  ),
                ),
              );
            } else {
              return const Center(child: Text('Refresh Please'));
            }
          },
        ),
      ),
    );
  }
}
