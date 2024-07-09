import 'package:flutter/material.dart';
import 'package:inventory_managment/Screens/CustomerScreen.dart';
import 'package:inventory_managment/Screens/HomePage.dart';
import 'package:inventory_managment/Screens/InvoiceByOrderScreen.dart';
import 'package:inventory_managment/Screens/Invoices.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Screens/AddInvoiceScreen.dart';
import '../Screens/LoginView.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        iconTheme:
            const IconThemeData(color: Colors.red), // Change color to red
      ),
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.black,
              ),
              child: Text(
                'Khan Traders',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.home,
                color: Colors.black,
              ),
              title: const Text(
                'Home',
                style: TextStyle(color: Colors.black),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeView()),
                );
              },
            ),
            ListTile(
              leading: const ImageIcon(
                  AssetImage('images/add-invoice-icon.png'),
                  color: Colors.black),
              title: const Text(
                'Add Invoice',
                style: TextStyle(color: Colors.black),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AddInvoiceScreen()),
                );
              },
            ),
            ListTile(
              leading: const ImageIcon(AssetImage('images/invoice.png'),
                  color: Colors.black),
              title: const Text(
                'All Invoices',
                style: TextStyle(color: Colors.black),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const InvoiceScreen()),
                );
              },
            ),
            ListTile(
              leading: const ImageIcon(AssetImage('images/audit.png'),
                  color: Colors.black),
              title: const Text(
                'Search Invoice',
                style: TextStyle(color: Colors.black),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SearchInvoiceScreen()),
                );
              },
            ),
            ListTile(
              leading: const ImageIcon(AssetImage('images/img.png'),
                  color: Colors.black),
              title: const Text(
                'Customer',
                style: TextStyle(color: Colors.black),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CustomerScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.logout_outlined,
                color: Colors.black,
              ),
              title: const Text(
                'Logout',
                style: TextStyle(color: Colors.black),
              ),
              onTap: () async {
                final sp = await SharedPreferences.getInstance();
                sp.remove('userId').then((value) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginView()));
                });
                // Perform logout operation
              },
            ),
          ],
        ),
      ),
    );
  }
}
