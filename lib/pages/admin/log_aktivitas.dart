import 'package:flutter/material.dart';

class LogAktivitas extends StatelessWidget {
  const LogAktivitas({super.key});

  @override
  Widget build(BuildContext context) {
    // Data dummy untuk list
    final List<Map<String, String>> logs = [
      {'user': 'Finel', 'action': 'Login', 'time': '13.25'},
      {'user': 'Finel', 'action': 'Menambahkan alat', 'time': '13.25'},
      {'user': 'Finel', 'action': 'Menambahkan alat', 'time': '13.25'},
      {'user': 'Finel', 'action': 'Menambahkan alat', 'time': '13.25'},
      {'user': 'Finel', 'action': 'Menambahkan alat', 'time': '13.25'},
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF746C6C), // Warna header abu-abu kecokelatan
        title: const Text(
          'Log aktivitas',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        centerTitle: false,
      ),
      body: Column(
        children: [
          // Search Bar Section
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              height: 45,
              decoration: BoxDecoration(
                color: const Color(0xFF746C6C),
                borderRadius: BorderRadius.circular(25),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Cari',
                  hintStyle: TextStyle(color: Colors.white70),
                  prefixIcon: Icon(Icons.search, color: Colors.white70),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
          ),

          // Log List Section
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: logs.length,
              itemBuilder: (context, index) {
                return _buildLogCard(logs[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogCard(Map<String, String> log) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 4), // Bayangan ke bawah
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                log['user']!,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF555555),
                ),
              ),
              Text(
                log['time']!,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                log['action']!,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF78B378), // Warna hijau admin
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'Admin',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}