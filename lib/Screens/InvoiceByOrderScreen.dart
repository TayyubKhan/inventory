import 'package:flutter/material.dart';
import 'package:INVENTORY/Repository/InvoiceByOrder.dart';

import '../Components/Drawer.dart';
import '../Model/InvoicebyOrder.dart';

class SearchInvoiceScreen extends StatefulWidget {
  final String invoiceId;
  const SearchInvoiceScreen({super.key, this.invoiceId = ''});

  @override
  _SearchInvoiceScreenState createState() => _SearchInvoiceScreenState();
}

class _SearchInvoiceScreenState extends State<SearchInvoiceScreen> {
  final TextEditingController _orderIdController = TextEditingController();
  Order? order;
  List<Product> products = [];
  bool isLoading = false;
  void _startLoading() {
    setState(() {
      isLoading = true;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.invoiceId != '') {
      fetchInvoice();
    }
  }

  void fetchInvoice() async {
    String orderId;
    if (widget.invoiceId == '') {
      orderId = _orderIdController.text;
    } else {
      orderId = widget.invoiceId.toString();
    }
    _startLoading();
    await InvoiceByOrderRepo()
        .fetchInvoiceData(orderId)
        .onError((error, stackTrace) {
      _stopLoading();
      _handleFetchInvoiceError(error);
    }).then((value) {
      _stopLoading();
      final orderJson = value[0]; // Access the order object
      final productsJson = value[1]; // Access the list of products
      setState(() {
        order = Order.fromJson(orderJson);
        products =
            List<Product>.from(productsJson.map((x) => Product.fromJson(x)));
        print(products);
      });
    });
  }

  void _handleFetchInvoiceError(dynamic error) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: const Text('Failed to fetch invoice. Please try again.'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _stopLoading() {
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: const AppDrawer(),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Invoice Details',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              widget.invoiceId == ''
                  ? Column(
                      children: [
                        TextFormField(
                          keyboardType: TextInputType.number,
                          cursorColor: Colors.white,
                          style: const TextStyle(color: Colors.black),
                          controller: _orderIdController,
                          decoration: const InputDecoration(
                              labelStyle: TextStyle(color: Colors.black),
                              labelText: 'Enter Order ID',
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black87),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              )),
                        ),
                        const SizedBox(height: 16.0),
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                WidgetStateProperty.all(Colors.black),
                          ),
                          onPressed: fetchInvoice,
                          child: const Text(
                            'Get Invoice',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    )
                  : const SizedBox(),
              if (isLoading)
                const Center(
                    child: CircularProgressIndicator(
                  color: Colors.black,
                )),
              if (!isLoading && order != null) ...[
                const SizedBox(height: 16.0),
                const Text(
                  'Order Details:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8.0),
                DataTable(
                  dataRowMinHeight: MediaQuery.sizeOf(context).height * 0.07,
                  dataRowMaxHeight: MediaQuery.sizeOf(context).height * 0.075,
                  columns: const [
                    DataColumn(label: Text('Field')),
                    DataColumn(label: Text('Value')),
                  ],
                  rows: [
                    DataRow(cells: [
                      const DataCell(Text('Order ID')),
                      DataCell(Text(order!.orderId)),
                    ]),
                    DataRow(cells: [
                      const DataCell(Text('Customer Name')),
                      DataCell(Text(order!.customerName)),
                    ]),
                    DataRow(cells: [
                      const DataCell(Text('Customer Address')),
                      DataCell(Text(order!.customerAddress)),
                    ]),
                    DataRow(cells: [
                      const DataCell(Text('Customer Phone')),
                      DataCell(Text(order!.customerPhone)),
                    ]),
                    DataRow(cells: [
                      const DataCell(Text('Subtotal')),
                      DataCell(Text(order!.subtotal)),
                    ]),
                    DataRow(cells: [
                      const DataCell(Text('Total')),
                      DataCell(Text(order!.grandTotal)),
                    ]),
                    DataRow(cells: [
                      const DataCell(Text('Date')),
                      DataCell(Text(order!.date)),
                    ]),
                  ],
                ),
              ],
              if (!isLoading && products.isNotEmpty) ...[
                const SizedBox(height: 16.0),
                const Text(
                  'Products:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8.0),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Product Name')),
                      DataColumn(label: Text('Unit Price')),
                      DataColumn(label: Text('Quantity')),
                      DataColumn(label: Text('Total Price')),
                    ],
                    rows: products.map((product) {
                      return DataRow(cells: [
                        DataCell(Text(product.name)),
                        DataCell(Text(product.unitPrice.toString())),
                        DataCell(Text(product.quantity.toString())),
                        DataCell(Text(product.totalPrice.toString())),
                      ]);
                    }).toList(),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
