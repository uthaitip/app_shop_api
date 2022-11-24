import 'package:flutter/material.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/card.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screens/auth_screen.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/screens/edit_product.dart';
import 'package:shop_app/screens/orders_screen.dart';
import 'package:shop_app/screens/product_detail_screen.dart';
import 'package:shop_app/screens/products_overview_screen.dart';
import 'package:shop_app/screens/splash_screen.dart';
import 'package:shop_app/screens/user_product_screens.dart';
import './providers/products.dart';
import 'package:provider/provider.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (_) => Products(null, [], null),
          update: (context, auth, previous) => Products(
              auth.token, previous == null ? [] : previous.items, auth.userId),
        ),
        // update: (ctx, auth, product) => Products(
        //     auth.token!, product!.items == null ? [] : product.items)),

        // ChangeNotifierProxyProvider<Auth,Products>(
        //   //ถ้าเติม .value เปลี่ยน create: (ctx)=> Product()
        //   // value: Products(),
        //   // create: ((context) => Products()),
        //   update: (context,auth) => Products(auth.token!),
        // ),
        ChangeNotifierProvider(
          // create: ((context) => Cart()),
          create: (context) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (context) => Orders(null, [], null),
          update: (context, auth, previous) => Orders(
              auth.token, previous == null ? [] : previous.orders, auth.userId),
        )
        // ChangeNotifierProvider.value(
        //   value: Cart(),
        // ),
      ],
      child: Consumer<Auth>(
        builder: (context, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "MyShop",
          theme: ThemeData(primarySwatch: Colors.purple, fontFamily: 'Lato'
              // colorScheme: ColorScheme(
              //   primary: Colors.deepOrange
              // )
              // colorScheme: Theme
              ),
          home: auth.isAuth!
              ? ProductsOverviewScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (context, snapshot) =>
                      snapshot.connectionState == ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen()),
          // home: ProductsOverviewScreen(),
          routes: {
            ProductDetailScreen.routeName: (context) =>
                const ProductDetailScreen(),
            CartScreen.routeName: (context) => CartScreen(),
            OrderScreen.routerName: (context) => OrderScreen(),
            UserProductScreen.routeName: (context) => UserProductScreen(),
            EditProductScreen.routeName: (context) => EditProductScreen(),
            AuthScreen.routeName: (context) => AuthScreen(),
          },
        ),
      ),
    );
  }
}

// class MyHomePage extends StatelessWidget {
//   const MyHomePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('MyShop'),
//       ),
//       body: ProductsOverviewScreen(),
//     );
//   }
// }
