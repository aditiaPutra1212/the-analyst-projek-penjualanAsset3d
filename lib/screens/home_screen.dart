import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../services/auth_service.dart';
import '../models/product_model.dart';
import '../widgets/product_card.dart';
import 'cart_screen.dart';
import '../cart.dart';
import 'login_screen.dart';
import 'payment_result_screen.dart'; // <-- Tambahkan import

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<String> sliderImages = [
    'assets/img/slider1.jpg',
    'assets/img/slider2.jpg',
    'assets/img/slider3.jpg',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildHomeContent(User? user) {
    final List<Product> staticProducts = [
      Product(
          id: '1',
          name: '3D Lampu Meja',
          price: 120000,
          imageUrl: 'assets/img/produk1.jpg'),
      Product(
          id: '2',
          name: '3D Miniatur Mobil',
          price: 180000,
          imageUrl: 'assets/img/produk2.jpg'),
      Product(
          id: '3',
          name: '3D Hiasan Dinding',
          price: 95000,
          imageUrl: 'assets/img/produk3.jpg'),
      Product(
          id: '4',
          name: '3D Gantungan Kunci',
          price: 25000,
          imageUrl: 'assets/img/produk4.jpg'),
      Product(
          id: '5',
          name: '3D Karakter Anime',
          price: 200000,
          imageUrl: 'assets/img/produk5.jpg'),
      Product(
          id: '6',
          name: '3D Figur Pahlawan',
          price: 170000,
          imageUrl: 'assets/img/produk6.jpg'),
      Product(
          id: '7',
          name: '3D Trophy Custom',
          price: 150000,
          imageUrl: 'assets/img/produk7.jpg'),
      Product(
          id: '8',
          name: '3D Jam Dinding',
          price: 110000,
          imageUrl: 'assets/img/produk8.jpg'),
    ];

    return ListView(
      children: [
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SizedBox(
            height: 280,
            child: CarouselSlider(
              items: sliderImages.map((path) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    path,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                );
              }).toList(),
              options: CarouselOptions(
                height: 290,
                autoPlay: true,
                enlargeCenterPage: true,
                viewportFraction: 0.9,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Produk 3D Terbaru',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 8),
        ...staticProducts.map((product) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        product.imageUrl,
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      product.name,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Rp ${product.price.toStringAsFixed(0)}',
                      style: const TextStyle(fontSize: 16, color: Colors.green),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton.icon(
                          icon: const Icon(Icons.shopping_cart),
                          label: const Text('Keranjang'),
                          onPressed: () {
                            if (user == null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const LoginScreen()),
                              );
                            } else {
                              cartItems.add(
                                  product); // Tambah produk ke keranjang global

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        '${product.name} ditambahkan ke keranjang')),
                              );

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const CartScreen(),
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 46, 46, 46),
                          ),
                        ),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.payment),
                          label: const Text('Beli Sekarang'),
                          onPressed: () {
                            if (user == null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const LoginScreen()),
                              );
                            } else {
                              // Tambahkan produk ke keranjang
                              if (!cartItems.contains(product)) {
                                cartItems.add(product);
                              }

                              // Navigasi ke PaymentResultScreen
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>
                                        const PaymentResultScreen()),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[700],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildProfileContent(User? user) {
    if (user == null) {
      return Center(
        child: ElevatedButton.icon(
          icon: const Icon(Icons.login),
          label: const Text(
            'Login',
            style: TextStyle(fontSize: 16),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.indigo[900],
            foregroundColor: Colors.white,
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 5,
            shadowColor: Colors.indigoAccent,
          ),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const LoginScreen()));
          },
        ),
      );
    }

    return FutureBuilder<DocumentSnapshot>(
      future:
          FirebaseFirestore.instance.collection('users').doc(user.uid).get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Center(child: Text('Pengguna tidak ditemukan'));
        }

        final data = snapshot.data!.data() as Map<String, dynamic>? ?? {};
        final name = data['name'] ?? 'Pengguna';
        final email = data['email'] ?? user.email ?? '';
        final photo = data['photoUrl'] ??
            'https://ui-avatars.com/api/?name=${Uri.encodeComponent(name)}';

        return Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(photo),
                ),
                const SizedBox(height: 16),
                Text(
                  name,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  email,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  icon: const Icon(Icons.logout),
                  label: const Text('Logout'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo[900],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24.0, vertical: 12.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  onPressed: () async {
                    await Provider.of<AuthService>(context, listen: false)
                        .signOut();
                    if (context.mounted) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const HomeScreen()),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    final user = auth.currentUser;

    final screens = [
      _buildHomeContent(user),
      const CartScreen(),
      _buildProfileContent(user),
      const PaymentResultScreen(), // Halaman hasil pembayaran
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 83, 94, 216),
        title: Row(
          children: [
            const SizedBox(width: 8),
            const Text(
              'Produk 3D',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          if (user != null)
            FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return const SizedBox();
                }

                final data =
                    snapshot.data!.data() as Map<String, dynamic>? ?? {};
                final name = data['name'] ?? 'Pengguna';

                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Row(
                    children: [
                      Text(
                        'Halo, $name',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.person),
                    ],
                  ),
                );
              },
            ),
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              if (user == null) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()));
              } else {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const  CartScreen()));
              }
            },
          ),
        ],
      ),
      body: screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.indigo[900],
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Keranjang',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Pembayaran',
          ),
        ],
      ),
    );
  }
}
