import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';
import 'package:provider/provider.dart';
import 'package:dropdown_search/dropdown_search.dart';
import '../Components/Drawer.dart';
import '../Model/CustomerAndProductModel.dart';
import '../Model/drop down db.dart';
import '../Repository/AddInvoiceRepo.dart';
import '../ViewModel/InvoiceByOrderFreeModel.dart';

class AddInvoiceScreen extends StatefulWidget {
  const AddInvoiceScreen({Key? key}) : super(key: key);

  @override
  _AddInvoiceScreenState createState() => _AddInvoiceScreenState();
}

class _AddInvoiceScreenState extends State<AddInvoiceScreen> {
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  late InvoiceProvider _invoiceProvider;
  final DropDownDb _dbHelper = DropDownDb();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeProvider();
    });
  }

  void _initializeProvider() async {
    _invoiceProvider = Provider.of<InvoiceProvider>(context, listen: false);
    await _retrieveDataFromLocalStorage();
  }

  Future<void> _retrieveDataFromLocalStorage() async {
    List<Map<String, dynamic>> customers = await _dbHelper.getCustomers();
    List<Map<String, dynamic>> products = await _dbHelper.getProducts();
    if (customers.isNotEmpty && products.isNotEmpty) {
      setState(() {
        _invoiceProvider.jsonCustomersResponse = customers;
        _invoiceProvider.jsonProductsResponse = products;
      });
    } else {
      _fetchData();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _connectivitySubscription.cancel();
  }

  Future<void> _fetchData() async {
    try {
      _invoiceProvider.loading();
      final productResponse = await http.get(Uri.parse(
          'https://a.thekhantraders.com/api/get_products.php?type=get'));
      final customerResponse = await http.get(Uri.parse(
          'https://a.thekhantraders.com/api/get_customers.php?type=get'));
      if (productResponse.statusCode == 200 &&
          customerResponse.statusCode == 200) {
        List<dynamic> products = jsonDecode(productResponse.body);
        List<dynamic> customers = jsonDecode(customerResponse.body);
        await _saveDataToLocalDatabase(customers, products);
        setState(() {
          _invoiceProvider.jsonCustomersResponse = customers;
          _invoiceProvider.jsonProductsResponse = products;
        });
      } else {
        throw Exception('Failed to fetch data');
      }
    } on http.ClientException catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No internet connection')));
    } on FormatException {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid response format')));
    } catch (e) {
      _invoiceProvider.loading();
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Failed to fetch data. Please try again later.')));
    }
  }

  Future<void> _saveDataToLocalDatabase(
      List<dynamic> customers, List<dynamic> products) async {
    await _dbHelper.deleteAllCustomers();
    await _dbHelper.deleteAllProducts();
    for (var customer in customers) {
      await _dbHelper.insertCustomer({
        'id': customer['id'],
        'name': customer['name'],
        'address': customer['address'],
        'phone': customer['phone'],
      });
    }
    for (var product in products) {
      await _dbHelper.insertProduct({
        'id': product['id'],
        'name': product['name'],
        'price': product['price'],
      });
    }
  }

  bool _isInvoiceReady = false;

  void _updateInvoiceReadyStatus() {
    setState(() {
      _isInvoiceReady = _invoiceProvider.selectedCustomer != 'Select' &&
          _invoiceProvider.selectedProducts.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    _invoiceProvider = Provider.of<InvoiceProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: const AppDrawer(),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Add Invoice',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        actions: [
          Consumer<InvoiceProvider>(builder: (context, value, _) {
            return ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
              onPressed: () async {
                _updateInvoiceReadyStatus();
                if (_isInvoiceReady) {
                  value.loading2();
                  try {
                    final selectedCustomer = _invoiceProvider
                        .jsonCustomersResponse
                        .firstWhere((customer) =>
                            customer['id'] == value.selectedCustomer);

                    await AddInvoiceRepo().addInvoiceApi(
                      subtotal: value.total_price,
                      cName: selectedCustomer['name'],
                      cAddress: value.customerAddressController.text,
                      cPhone: value.customerPhoneController.text,
                      products: value.selectedProducts,
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Added Successfully')));
                    setState(() {
                      _invoiceProvider.selectedCustomer = 'Select';
                      _invoiceProvider.customerAddressController.clear();
                      _invoiceProvider.customerPhoneController.clear();
                      _invoiceProvider.selectedProducts.clear();
                      _invoiceProvider.selectedProduct = 'Select';
                    });
                  } catch (error) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      backgroundColor: Colors.red,
                      content: Text(error.toString()),
                    ));
                  } finally {
                    value.loading2();
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    backgroundColor: Colors.red,
                    content: Text('First Add Invoice'),
                  ));
                }
                _invoiceProvider.totalprice();
              },
              child: value.isLoading2
                  ? const Center(
                      child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ))
                  : const Text(
                      'Send Invoice',
                      style: TextStyle(color: Colors.white),
                    ),
            );
          }),
          IconButton(
            icon: const Icon(
              Icons.refresh,
              color: Colors.white,
            ),
            onPressed: () async {
              _connectivitySubscription =
                  Connectivity().onConnectivityChanged.listen((result) async {
                if (result == ConnectivityResult.mobile ||
                    result == ConnectivityResult.wifi) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Refreshing')));
                  await _fetchData();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('No internet connection')));
                }
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Billed To:',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10.0),
              DropdownSearch<String>(
                items: _invoiceProvider.jsonCustomersResponse
                    .map((customer) => customer['name'].toString())
                    .toList(),
                selectedItem: _invoiceProvider.selectedCustomer == 'Select'
                    ? null
                    : _invoiceProvider.jsonCustomersResponse.firstWhere(
                        (customer) =>
                            customer['id'] ==
                            _invoiceProvider.selectedCustomer)['name'],
                onChanged: (String? newValue) {
                  final selectedCustomer = _invoiceProvider
                      .jsonCustomersResponse
                      .firstWhere((customer) => customer['name'] == newValue);
                  setState(() {
                    _invoiceProvider.selectedCustomer = selectedCustomer['id'];
                    _invoiceProvider.customerAddressController.text =
                        selectedCustomer['address'];
                    _invoiceProvider.customerPhoneController.text =
                        selectedCustomer['phone'];
                  });
                },
                dropdownDecoratorProps: const DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    labelText: 'Select Customer',
                    labelStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)),
                  ),
                ),
                popupProps: const PopupProps.menu(
                  searchFieldProps: TextFieldProps(
                      decoration: InputDecoration(
                        labelText: 'Search Customer',
                        labelStyle: TextStyle(color: Colors.black),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black)),
                      ),
                      cursorColor: Colors.black,
                      style: TextStyle(color: Colors.black)),
                  showSearchBox: true,
                ),
              ),
              const SizedBox(height: 10.0),
              TextFormField(
                style: const TextStyle(color: Colors.black),
                controller: _invoiceProvider.customerAddressController,
                decoration: const InputDecoration(
                  labelText: 'Address',
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)),
                ),
              ),
              const SizedBox(height: 10.0),
              TextFormField(
                style: const TextStyle(color: Colors.black),
                controller: _invoiceProvider.customerPhoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone',
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)),
                ),
              ),
              const SizedBox(height: 20.0),
              DropdownSearch<String>(
                items: _invoiceProvider.jsonProductsResponse
                    .map((product) => product['name'].toString())
                    .toList(),
                selectedItem: _invoiceProvider.selectedProduct == 'Select'
                    ? null
                    : _invoiceProvider.jsonProductsResponse.firstWhere(
                        (product) =>
                            product['id'] ==
                            _invoiceProvider.selectedProduct)['name'],
                onChanged: (String? newValue) {
                  setState(() {
                    final selectedProduct = _invoiceProvider
                        .jsonProductsResponse
                        .firstWhere((product) => product['name'] == newValue);
                    _invoiceProvider.selectedProduct = selectedProduct['id'];
                    final alreadyAdded = _invoiceProvider.selectedProducts
                        .any((product) => product.id == selectedProduct['id']);
                    if (!alreadyAdded) {
                      _invoiceProvider.selectedProducts.add(Product(
                        id: selectedProduct['id'],
                        name: selectedProduct['name'],
                        price: double.parse(selectedProduct['price']),
                      ));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                            'This product is already added to the invoice.'),
                      ));
                    }
                    _invoiceProvider.totalprice();
                  });
                },
                dropdownDecoratorProps: const DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    labelText: 'Select Product',
                    labelStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)),
                  ),
                ),
                popupProps: const PopupProps.menu(
                  searchFieldProps: TextFieldProps(
                      decoration: InputDecoration(
                        labelText: 'Search Product',
                        labelStyle: TextStyle(color: Colors.black),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black)),
                      ),
                      cursorColor: Colors.black,
                      style: TextStyle(color: Colors.black)),
                  showSearchBox: true,
                ),
              ),
              const SizedBox(height: 20.0),
              Consumer<InvoiceProvider>(builder: (context, value, _) {
                return Text(
                    textAlign: TextAlign.end, 'Sub Total=${value.total_price}');
              }),
              const SizedBox(height: 20.0),
              Container(
                padding: const EdgeInsets.all(8.0),
                child: Table(
                  children: [
                    TableRow(
                      children: [
                        TableCell(
                            child: Text(
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize:
                                  MediaQuery.sizeOf(context).width * 0.048),
                          'Name',
                        )),
                        TableCell(
                            child: Text(
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize:
                                  MediaQuery.sizeOf(context).width * 0.048),
                          'Unit',
                        )),
                        TableCell(
                            child: Text(
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize:
                                  MediaQuery.sizeOf(context).width * 0.048),
                          'Qty',
                        )),
                        TableCell(
                            child: Text(
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize:
                                  MediaQuery.sizeOf(context).width * 0.048),
                          'Total',
                        )),
                        TableCell(
                            child: Text(
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize:
                                  MediaQuery.sizeOf(context).width * 0.048),
                          'Action',
                        )),
                      ],
                    ),
                    for (var product in _invoiceProvider.selectedProducts)
                      TableRow(
                        children: [
                          TableCell(
                              child: Text(
                            product.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          )),
                          TableCell(child: Text(product.price.toString())),
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: TextFormField(
                              decoration: const InputDecoration(
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black)),
                                  border: UnderlineInputBorder(
                                      borderSide: BorderSide.none)),
                              initialValue: '${product.quantity}',
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                setState(() {
                                  product.quantity = int.tryParse(value) ?? 1;
                                  _invoiceProvider.totalprice();
                                });
                              },
                            ),
                          ),
                          TableCell(
                            child: Text(product.totalPrice().toString()),
                          ),
                          TableCell(
                            child: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  _invoiceProvider.selectedProducts
                                      .remove(product);
                                  _invoiceProvider.totalprice();
                                  _invoiceProvider.selectedProduct = 'Select';
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
