import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:l_mobile_sales_mini/presentation/widgets/specific/product/product_description_widget.dart';
import 'package:l_mobile_sales_mini/presentation/widgets/specific/product/product_identification_widget.dart';
import 'package:l_mobile_sales_mini/presentation/widgets/specific/product/product_price_trend_widget.dart';
import 'package:l_mobile_sales_mini/presentation/widgets/specific/product/product_stores_widget.dart';
import 'package:l_mobile_sales_mini/presentation/widgets/specific/product/related_products_widget.dart';

import '../../core/utils/inventory/stock_utils.dart';
import '../../data/models/products/product_model.dart';
import '../controllers/products_provider.dart';
import '../widgets/common/appbar_widget.dart';
import '../widgets/common/bottom_navigation_widget.dart';

class ProductScreen extends ConsumerStatefulWidget {
  final String productId;
  const ProductScreen({super.key, required this.productId});

  @override
  ConsumerState<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends ConsumerState<ProductScreen> {
  late String activeImagePath;
  final PageController _imagesController = PageController();
  final List<String> sampleImages = [
    'https://picsum.photos/400/300?1',
    'https://picsum.photos/400/300?2',
    'https://picsum.photos/400/300?3',
  ];
  final List<Map<String, double>> samplePrices = [
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
  ];

  int maxQty = 0;
  int cartQty = 0;
  final TextEditingController _cartQtyController = TextEditingController();

  void hasSwipedImage() {
    setState(() {
      // activeImagePath = product.images[_imagesController.page!.toInt()];
      activeImagePath = sampleImages[_imagesController.page!.toInt()];
    });
  }

  void toggleActiveImage(String imagePath) {
    setState(() {
      activeImagePath = imagePath;
    });

    // final images = product.images;
    // final pageIndex = images.indexWhere((img) => img == imagePath);

    final pageIndex = sampleImages.indexWhere((img) => img == imagePath);
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
    _imagesController.addListener(() {
      hasSwipedImage();
    });
    _cartQtyController.text = cartQty.toString();
  }

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(productsProvider);
    ref.listen<AsyncValue<List<Product>>>(productsProvider, (_, next) {
      if (next.hasError) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(next.error.toString())));
      }
    });

    final allProducts = productsAsync.value ?? [];
    final Product product = allProducts.firstWhere(
      (p) => p.id == widget.productId,
    );

    //In production use actual images
    // activeImagePath = item.images.first;
    activeImagePath = sampleImages.first;

    maxQty = getItemStockTotals(product.stock);
    cartQty = cartQty.clamp(0, maxQty);
    return buildProductBody(context, product);
  }

  Widget buildProductBody(BuildContext context, Product product) {
    return Container(
      height: MediaQuery.of(context).size.height * 1,
      width: double.infinity,
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary),
      child: SingleChildScrollView(
        child: Column(
          children: [
            buildProductImagesSection(context, product.images),
            const SizedBox(height: 20),
            ProductIdentificationWidget(product: product),
            const SizedBox(height: 20),
            buildProductPrice(context, product.price),
            const SizedBox(height: 20),
            buildAddToCart(context),
            const SizedBox(height: 20),
            buildWarehouses(context, product.stock),
            const SizedBox(height: 20),
            ProductDescriptionWidget(productDescription: product.description),
            const SizedBox(height: 20,),
            RelatedProductsWidget(relatedProductsIds: product.relatedProducts),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget buildProductImagesSection(
    BuildContext context,
    List<String> productImages,
  ) {
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
              buildMainImage(context, mainImageContainerHeight, productImages),
              const SizedBox(height: 10),
              buildSecondaryImages(
                context,
                secondaryImagesContainerHeight,
                maxWidth,
                productImages,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget buildMainImage(
    BuildContext context,
    double maxHeight,
    List<String> productImages,
  ) {
    return SizedBox(
      height: maxHeight,
      child: PageView.builder(
        controller: _imagesController,
        itemCount: sampleImages.length, //Use sample images for now
        itemBuilder: (context, index) {
          return Image.network(sampleImages[index], fit: BoxFit.cover);
        },
      ),
    );
  }

  Widget buildSecondaryImages(
    BuildContext context,
    double maxHeight,
    double maxWidth,
    List<String> productImages,
  ) {
    final double individualWidth =
        maxWidth / sampleImages.length; //Sample images
    return Container(
      height: maxHeight,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: sampleImages.length, //Sample images
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(width: 5);
        },
        itemBuilder: (context, index) {
          return buildSecondaryImage(
            context,
            sampleImages[index], //Sample images
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
            child: Image.network(
              imagePath,
              fit: BoxFit.cover,
            ), //Production use image.asset if saved locally
          ),
        ),
      ),
    );
  }

  Widget buildProductPrice(BuildContext context, double productPrice) {
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
          buildProductPriceDetails(context, productPrice),
          const Spacer(),
          buildPriceTrend(context, productPrice),
          const Spacer(),
        ],
      ),
    );
  }

  Widget buildProductPriceDetails(BuildContext context, double productPrice) {
    double currentPrice = productPrice;

    final Map<String, dynamic> immediatePreviousPriceMap =
        samplePrices[1]; //Sample prices
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

  Widget buildPriceTrend(BuildContext context, double productPrice) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Price Trend', style: TextTheme.of(context).labelMedium),
        const SizedBox(height: 5),
        ProductPriceTrendWidget(prices: samplePrices), //Sample prices
      ],
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

  Widget buildWarehouses(BuildContext context, List<Stock> productStores) {
    return Container(
      height: MediaQuery.of(context).size.height * .15,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: productStores.isEmpty
          ? buildNoStores(context)
          : ProductStoresWidget(stores: productStores),
    );
  }

  Widget buildNoStores(BuildContext context) {
    return Center(
      child: Text('No Stores found', style: TextTheme.of(context).bodyMedium),
    );
  }
}
