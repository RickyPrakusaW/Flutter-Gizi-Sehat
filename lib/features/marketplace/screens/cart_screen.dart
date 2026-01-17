import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Keranjang Belanja')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildCartItem("Vitamin A Anak", "Rp 25.000", 2),
          _buildCartItem("Susu Formula", "Rp 150.000", 1),
          const Divider(),
          _buildSummaryRow("Subtotal", "Rp 200.000"),
          _buildSummaryRow("Biaya Kirim", "Rp 10.000"),
          const SizedBox(height: 16),
          _buildSummaryRow("Total", "Rp 210.000", isTotal: true),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/invoice');
          },
          child: const Text(
            'Checkout',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ),
    );
  }

  Widget _buildCartItem(String name, String price, int qty) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: Container(
          width: 50,
          color: Colors.grey[200],
          child: const Icon(Icons.image),
        ),
        title: Text(name),
        subtitle: Text('$price x $qty'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(icon: const Icon(Icons.remove), onPressed: () {}),
            Text('$qty'),
            IconButton(icon: const Icon(Icons.add), onPressed: () {}),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 16 : 14,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 16 : 14,
            ),
          ),
        ],
      ),
    );
  }
}
