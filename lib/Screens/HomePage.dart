import 'package:flutter/material.dart';
import 'package:INVENTORY/Repository/InvoiceByOrder.dart';
import 'package:INVENTORY/Screens/AddInvoiceScreen.dart';
import 'package:INVENTORY/Screens/CustomerScreen.dart';
import 'package:INVENTORY/Screens/InvoiceByOrderScreen.dart';
import 'package:INVENTORY/Screens/Invoices.dart';
import 'package:INVENTORY/Screens/LoginView.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.black,
          automaticallyImplyLeading: false,
          title: const Text(
            'Home',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          actions: [
            InkWell(
              onTap: () async {
                final sp = await SharedPreferences.getInstance();
                sp.remove('userId').then((value) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginView()));
                });
              },
              child: const Padding(
                padding: EdgeInsets.only(right: 15.0),
                child: Icon(
                  Icons.logout_outlined,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 16.0,
              crossAxisSpacing: 16.0,
              children: [
                _buildButton(context, 'images/invoice.png', 'All Invoices', () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const InvoiceScreen()));
                }),
                _buildButton(context, 'images/img.png', 'Customers', () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CustomerScreen()));
                }),
                _buildButton(
                    context, 'images/add-invoice-icon.png', 'Add Invoice', () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddInvoiceScreen()));
                }),
                _buildButton(context, 'images/audit.png', 'Search Invoice', () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SearchInvoiceScreen()));
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButton(
      BuildContext context, String icon, String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black38),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ImageIcon(
              AssetImage(icon),
              size: 48.0,
              color: Colors.black,
            ),
            const SizedBox(height: 8.0),
            Text(
              text,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: HomeView(),
  ));
}
