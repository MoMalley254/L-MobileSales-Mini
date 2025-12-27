import 'package:flutter/material.dart';

import '../widgets/common/appbar_widget.dart';
import '../widgets/common/bottom_navigation_widget.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  late String activeImagePath;
  final PageController _imagesController = PageController();
  final Map<String, dynamic> product = {
    'sku': 'QWERTYUIP',
    'name': 'Sample Item',
    'images': [
      'https://picsum.photos/400/300?1',
      'https://picsum.photos/400/300?2',
      'https://picsum.photos/400/300?3',
    ],
    'categories': ['Electronics', 'Gadgets', 'Samsung', 'Gallium Nitride'],
    'prices': [
      {'25/12/2025': 3400.00},
      {'18/11/2025': 3580.50},
      {'02/10/2025': 3350.75},
      {'15/07/2025': 3300.00},
      {'20/03/2025': 3250.25},
      {'10/12/2024': 3200.00},
      {'05/06/2024': 3150.50},
      {'12/01/2024': 3100.75},
      {'28/09/2023': 3050.00},
      {'14/04/2023': 3000.25},
    ],
    'stock': 12,
    'stores': [
      {
        'name': 'Area 51',
        'stock': 10,
        'location': 'Mojave, Nevada',
        'geoLocation': {'lat': 37.235, 'lng': -115.8111},
      },
      {
        'name': 'Bermuda Triangle',
        'stock': 7,
        'location': 'North Atlantic Ocean',
        'geoLocation': {'lat': 25.000, 'lng': -71.000},
      },
      {
        'name': 'Chernobyl Exclusion Zone',
        'stock': 0,
        'location': 'Chernobyl, Ukraine',
        'geoLocation': {'lat': 51.276, 'lng': 30.221},
      },
    ],
    'description':
        'This premium item is crafted with attention to detail and built to last. Its sleek design and high-quality materials make it both functional and stylish, perfect for everyday use or special occasions.',
  };

  int maxQty = 0;
  int cartQty = 0;
  final TextEditingController _cartQtyController = TextEditingController();

  void hasSwipedImage() {
    setState(() {
      activeImagePath =
          (product['images'] as List<String>)[_imagesController.page!.toInt()];
    });
  }

  void toggleActiveImage(String imagePath) {
    setState(() {
      activeImagePath = imagePath;
    });

    final images = product['images'] as List<String>;
    final pageIndex = images.indexWhere((img) => img == imagePath);

    if (pageIndex != -1) {
      _imagesController.jumpToPage(pageIndex);
    }
  }

  void navigateToCategory(String category) {
    print('Go to category page');
  }

  void updateCartQty(bool increase) {
    setState(() {
      cartQty = increase ? cartQty + 1 : cartQty - 1;
      cartQty = cartQty.clamp(0, maxQty);

      _cartQtyController.text = cartQty.toString();
    });
  }

  void setCartQty() {
    setState(() {
      cartQty = int.tryParse(_cartQtyController.text) ?? 0;
      cartQty = cartQty.clamp(0, maxQty);

      _cartQtyController.text = cartQty.toString();
    });
  }

  void addToCart() {
    print('Do add to cart');
  }

  @override
  void initState() {
    super.initState();
    activeImagePath = (product['images'] as List<String>).first;
    _imagesController.addListener(() {
      hasSwipedImage();
    });
    maxQty = product['stock'] ?? 99;
    cartQty = cartQty.clamp(0, maxQty);
    _cartQtyController.text = cartQty.toString();
  }

  @override
  Widget build(BuildContext context) {
    return buildProductBody(context);
  }

  Widget buildProductBody(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 1,
      width: double.infinity,
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary),
      child: SingleChildScrollView(
        child: Column(
          children: [
            buildProductImagesSection(context),
            const SizedBox(height: 20),
            buildProductIdentification(context),
            const SizedBox(height: 20),
            buildProductPrice(context),
            const SizedBox(height: 20),
            buildAddToCart(context),
            const SizedBox(height: 20),
            buildWarehouses(context),
            const SizedBox(height: 20),
            buildDescription(context),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget buildProductImagesSection(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .3,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).appBarTheme.backgroundColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(14),
          bottomRight: Radius.circular(14),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade400,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double mainImageContainerHeight = constraints.maxHeight * .7;
          final double secondaryImagesContainerHeight =
              constraints.maxHeight * .2;
          final double maxWidth = constraints.maxWidth;
          return Column(
            children: [
              buildMainImage(context, mainImageContainerHeight),
              const SizedBox(height: 10),
              buildSecondaryImages(
                context,
                secondaryImagesContainerHeight,
                maxWidth,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget buildMainImage(BuildContext context, double maxHeight) {
    List<String> productImages = product['images'] as List<String>;
    return SizedBox(
      height: maxHeight,
      child: PageView.builder(
        controller: _imagesController,
        itemCount: productImages.length,
        itemBuilder: (context, index) {
          return Image.network(productImages[index], fit: BoxFit.cover);
        },
      ),
    );
  }

  Widget buildSecondaryImages(
    BuildContext context,
    double maxHeight,
    double maxWidth,
  ) {
    List<String> productImages = product['images'] as List<String>;
    final double individualWidth = maxWidth / productImages.length;
    return Container(
      height: maxHeight,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: productImages.length,
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(width: 5);
        },
        itemBuilder: (context, index) {
          return buildSecondaryImage(
            context,
            productImages[index],
            individualWidth,
            maxHeight,
          );
        },
      ),
    );
  }

  Widget buildSecondaryImage(
    BuildContext context,
    String imagePath,
    double individualWidth,
    double maxHeight,
  ) {
    return InkWell(
      onTap: () => toggleActiveImage(imagePath),
      child: Opacity(
        opacity: activeImagePath == imagePath ? 1.0 : 0.4,
        child: SizedBox(
          width: individualWidth,
          height: maxHeight,
          child: Material(
            borderRadius: BorderRadius.circular(14),
            clipBehavior: Clip.antiAlias,
            child: Image.network(imagePath, fit: BoxFit.cover),
          ),
        ),
      ),
    );
  }

  Widget buildProductIdentification(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildProductName(context),
          const SizedBox(height: 5),
          buildProductSKU(context),
          const SizedBox(height: 5),
          buildProductCategories(context),
        ],
      ),
    );
  }

  Widget buildProductName(BuildContext context) {
    return Text(product['name'], style: TextTheme.of(context).bodyLarge);
  }

  Widget buildProductSKU(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextTheme.of(context).labelMedium,
        children: [
          TextSpan(text: 'SKU: '),
          TextSpan(
            text: product['sku'],
            style: TextTheme.of(
              context,
            ).labelMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget buildProductCategories(BuildContext context) {
    final List<String> categories = product['categories'];
    return SizedBox(
      height: 30,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (context, index) {
          return const SizedBox(width: 10);
        },
        itemBuilder: (context, index) {
          return buildProductCategory(context, categories[index]);
        },
      ),
    );
  }

  Widget buildProductCategory(BuildContext context, String category) {
    return InkWell(
      onTap: () => navigateToCategory(category),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(7),
        ),
        child: Text(
          category,
          style: TextTheme.of(
            context,
          ).labelMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget buildProductPrice(BuildContext context) {
    List<Map<String, dynamic>> prices =
        (product['prices'] as List<Map<String, dynamic>>);

    return Container(
      height: MediaQuery.of(context).size.height * .2,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).appBarTheme.backgroundColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(14),
          bottomRight: Radius.circular(14),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade400,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          buildProductPriceDetails(context, prices),
          const Spacer(),
          buildPriceTrend(context, prices),
          const Spacer(),
        ],
      ),
    );
  }

  Widget buildProductPriceDetails(
    BuildContext context,
    List<Map<String, dynamic>> prices,
  ) {
    final Map<String, dynamic> currentPriceMap = prices.first;
    double currentPrice = currentPriceMap.values.first;

    final Map<String, dynamic> immediatePreviousPriceMap = prices[1];
    double immediatePreviousPrice = immediatePreviousPriceMap.values.first;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        buildCurrentProductPrice(context, currentPrice),
        const Spacer(),
        buildCurrentLastPricesComparison(
          context,
          currentPrice,
          immediatePreviousPrice,
        ),
      ],
    );
  }

  Widget buildCurrentProductPrice(BuildContext context, double currentPrice) {
    return RichText(
      text: TextSpan(
        style: TextTheme.of(context).labelMedium,
        children: [
          TextSpan(text: 'Current Price \n Ksh.'),
          TextSpan(
            text: currentPrice.toStringAsFixed(2),
            style: TextTheme.of(context).bodyLarge,
          ),
        ],
      ),
    );
  }

  Widget buildCurrentLastPricesComparison(
    BuildContext context,
    double currentPrice,
    double immediatePreviousPrice,
  ) {
    double difference = currentPrice - immediatePreviousPrice;
    double percentage = 0;

    if (immediatePreviousPrice != 0) {
      percentage = (difference / immediatePreviousPrice) * 100;
    }

    Color color = percentage >= 0 ? Colors.green : Colors.red;
    Color bgColor = percentage >= 0 ? Colors.green[100]! : Colors.red[100]!;
    String sign = percentage >= 0 ? '+' : '';

    return Expanded(
      flex: 1,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7),
              color: bgColor,
            ),
            child: Text(
              '$sign${percentage.toStringAsFixed(2)}%',
              style: TextTheme.of(context).labelMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text('vs Previous', style: TextTheme.of(context).labelMedium),
        ],
      ),
    );
  }

  Widget buildPriceTrend(
    BuildContext context,
    List<Map<String, dynamic>> prices,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Price Trend', style: TextTheme.of(context).labelMedium),
        const SizedBox(height: 5),
        buildTrendGraph(context, prices),
      ],
    );
  }

  Widget buildTrendGraph(
    BuildContext context,
    List<Map<String, dynamic>> prices,
  ) {
    if (prices.isEmpty) return Container();

    List<Map<String, dynamic>> reversedPrices = prices.reversed.toList();
    List<double> percentageChanges = [];
    double previousPrice = 0;

    for (int i = 0; i < reversedPrices.length; i++) {
      final entry = reversedPrices[i];
      final price = entry.values.first as double;

      double change = 0;
      if (i != 0 && previousPrice != 0) {
        change = ((price - previousPrice).abs() / previousPrice) * 100;
      }
      percentageChanges.add(change);
      previousPrice = price;
    }

    double maxChange = percentageChanges.reduce((a, b) => a > b ? a : b);

    previousPrice = 0;
    List<Widget> segments = [];

    for (int i = 0; i < reversedPrices.length; i++) {
      final entry = reversedPrices[i];
      final date = entry.keys.first;
      final price = entry[date] as double;

      double change = percentageChanges[i];

      double segmentWidth = maxChange > 0
          ? ((change / maxChange) * 300).clamp(150, 200)
          : 150;

      Color color = (i == 0 || price >= previousPrice)
          ? Colors.green[500]!
          : Colors.red[500]!;

      final String symbol = (i == 0 || price >= previousPrice) ? '+' : '-';

      segments.add(
        Container(
          width: segmentWidth,
          height: 70,
          margin: const EdgeInsets.symmetric(horizontal: 1),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: RichText(
            text: TextSpan(
              style: TextTheme.of(context).labelMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              children: [
                TextSpan(text: '$date \n Ksh.'),
                TextSpan(
                  text:
                      '${price.toStringAsFixed(2)}($symbol${change.toStringAsFixed(2)}%)',
                ),
              ],
            ),
          ),
        ),
      );

      previousPrice = price;
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(children: segments.reversed.toList()),
    );
  }

  Widget buildAddToCart(BuildContext context) {
    return Form(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            Expanded(flex: 2, child: buildQuantitySection(context)),
            const SizedBox(width: 10),
            Expanded(flex: 2, child: buildAddToCartButton(context)),
          ],
        ),
      ),
    );
  }

  Widget buildQuantitySection(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).appBarTheme.backgroundColor,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Column(
        children: [
          buildMaxQtyLabel(context),
          Row(
            children: [
              buildQuantityButton(context, false),
              buildQuantityInput(context),
              buildQuantityButton(context, true),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildMaxQtyLabel(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextTheme.of(context).labelMedium,
        children: [
          TextSpan(text: 'Available : '),
          TextSpan(
            text: maxQty.toString(),
            style: TextTheme.of(
              context,
            ).labelMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget buildQuantityButton(BuildContext context, bool increase) {
    return IconButton(
      onPressed: () => updateCartQty(increase),
      icon: Icon(
        increase ? Icons.add : Icons.remove,
        size: 20,
        color: Colors.black,
      ),
    );
  }

  Widget buildQuantityInput(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Center(
        child: TextFormField(
          controller: _cartQtyController,
          onChanged: (String? value) {
            setCartQty();
          },
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintStyle: TextTheme.of(context).bodyMedium,
            filled: true,
            fillColor: Theme.of(context).appBarTheme.backgroundColor,
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
          ),
        ),
      ),
    );
  }

  Widget buildAddToCartButton(BuildContext context) {
    return InkWell(
      onTap: addToCart,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          color: Colors.green[500],
          borderRadius: BorderRadius.circular(7),
        ),
        child: Row(
          children: [
            Icon(Icons.add_shopping_cart, size: 20),
            const SizedBox(width: 5),
            Text(
              'Add To Cart',
              style: TextTheme.of(
                context,
              ).bodyMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildWarehouses(BuildContext context) {
    final List<Map<String, dynamic>> stores =
        product['stores'] as List<Map<String, dynamic>> ?? [];
    return Container(
      height: MediaQuery.of(context).size.height * .15,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: stores.isEmpty
          ? buildNoStores(context)
          : buildStores(context, stores),
    );
  }

  Widget buildNoStores(BuildContext context) {
    return Center(
      child: Text('No Stores found', style: TextTheme.of(context).bodyMedium),
    );
  }

  Widget buildStores(BuildContext context, List<Map<String, dynamic>> stores) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Stores', style: TextTheme.of(context).labelMedium),
        const SizedBox(height: 5),
        SizedBox(
          height: MediaQuery.of(context).size.height * .1,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: stores.length,
            separatorBuilder: (context, index) {
              return const SizedBox(width: 10);
            },
            itemBuilder: (context, index) {
              final store = stores[index];
              return buildStore(context, store);
            },
          ),
        ),
      ],
    );
  }

  Widget buildStore(BuildContext context, Map<String, dynamic> store) {
    return InkWell(
      child: Container(
        width: MediaQuery.of(context).size.width * .8,
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).appBarTheme.backgroundColor,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(14),
            bottomRight: Radius.circular(14),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade400,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            const SizedBox(width: 5),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    store['name'],
                    style: TextTheme.of(context).bodyMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    store['location'],
                    style: TextTheme.of(context).labelMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Text(
                    store['stock'].toString(),
                    style: TextTheme.of(context).bodyMedium,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.circle,
                        size: 15,
                        color: store['stock'] >= 10
                            ? Colors.green[500]!
                            : store['stock'] < 1
                            ? Colors.red[500]!
                            : Colors.deepOrange[500]!,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        store['stock'] >= 10
                            ? 'In Stock'
                            : store['stock'] < 1
                            ? 'Out'
                            : 'Low Stock',
                        style: TextTheme.of(context).labelMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: store['stock'] >= 10
                              ? Colors.green[500]!
                              : store['stock'] < 1
                              ? Colors.red[500]!
                              : Colors.deepOrange[500]!,
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
    );
  }

  Widget buildDescription(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Center(
        child: Text(
          product['description'],
          style: TextTheme.of(context).labelMedium,
        ),
      ),
    );
  }
}
