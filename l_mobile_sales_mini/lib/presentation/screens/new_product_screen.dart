import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:l_mobile_sales_mini/presentation/controllers/products_provider.dart';

import '../../data/models/products/product_model.dart';

class NewProductScreen extends ConsumerStatefulWidget {
  const NewProductScreen({super.key});

  @override
  ConsumerState<NewProductScreen> createState() => _NewProductScreenState();
}

class _NewProductScreenState extends ConsumerState<NewProductScreen> {
  bool hasEverything = false;
  bool isLoading = false;
  final GlobalKey<FormState> _newProductFormKey = GlobalKey();

  // Controllers
  final _nameCtrl = TextEditingController();
  final _skuCtrl = TextEditingController();
  final _categoryCtrl = TextEditingController();
  final _subcategoryCtrl = TextEditingController();
  final _descriptionCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _taxRateCtrl = TextEditingController();
  final _unitCtrl = TextEditingController();
  final _packagingCtrl = TextEditingController();
  final _minOrderQtyCtrl = TextEditingController();
  final _reorderLevelCtrl = TextEditingController();

  // Stock
  final _warehouseIdCtrl = TextEditingController();
  final _quantityCtrl = TextEditingController();
  final _reservedCtrl = TextEditingController();

  // Specifications
  final _viscosityCtrl = TextEditingController();
  final _baseTypeCtrl = TextEditingController();
  final _volumeCtrl = TextEditingController();
  final _applicationCtrl = TextEditingController();

  // Lists
  final _imagesCtrl = TextEditingController();
  final _relatedProductsCtrl = TextEditingController();

  bool _batchNumber = false;
  bool _serialNumber = false;

  List<Stock> getAllAvailableWarehouses(List<Product> products) {
    List<Stock> availableWarehouses = [];
    for (var product in products) {
      for (var stock in product.stock) {
        if (!availableWarehouses.any((element) => element.warehouseId == stock.warehouseId)) {
          availableWarehouses.add(stock);
        }
      }
    }
    return availableWarehouses;
  }

  void checkValid() {
    setState(() {
      hasEverything = _newProductFormKey.currentState!.validate();
    });
  }

  void doCreate() {
    if (!_newProductFormKey.currentState!.validate()) return;

    final product = Product(
      id: '',
      name: _nameCtrl.text.trim(),
      sku: _skuCtrl.text.trim(),
      category: _categoryCtrl.text.trim(),
      subcategory: _subcategoryCtrl.text.trim(),
      description: _descriptionCtrl.text.trim(),
      price: double.parse(_priceCtrl.text),
      taxRate: double.parse(_taxRateCtrl.text),
      unit: _unitCtrl.text.trim(),
      packaging: _packagingCtrl.text.trim(),
      minOrderQuantity: int.parse(_minOrderQtyCtrl.text),
      reorderLevel: int.parse(_reorderLevelCtrl.text),
      batchNumber: _batchNumber,
      serialNumber: _serialNumber,
      stock: [
        Stock(
          warehouseId: _warehouseIdCtrl.text.trim(),
          quantity: int.parse(_quantityCtrl.text),
          reserved: int.parse(_reservedCtrl.text),
        ),
      ],
      images: _imagesCtrl.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList(),
      relatedProducts: _relatedProductsCtrl.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList(),
      specifications: Specifications(
        viscosity: _viscosityCtrl.text.trim(),
        baseType: _baseTypeCtrl.text.trim(),
        volume: int.parse(_volumeCtrl.text),
        application: _applicationCtrl.text.trim(),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Product created successfully')),
    );
  }

  @override
  void dispose() {
    for (final c in [
      _nameCtrl,
      _skuCtrl,
      _categoryCtrl,
      _subcategoryCtrl,
      _descriptionCtrl,
      _priceCtrl,
      _taxRateCtrl,
      _unitCtrl,
      _packagingCtrl,
      _minOrderQtyCtrl,
      _reorderLevelCtrl,
      _warehouseIdCtrl,
      _quantityCtrl,
      _reservedCtrl,
      _viscosityCtrl,
      _baseTypeCtrl,
      _volumeCtrl,
      _applicationCtrl,
      _imagesCtrl,
      _relatedProductsCtrl,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(productsProvider);
    return productsAsync.when(
        data: (products) {
          return buildForm(context, products);
        },
        error: (e, st) => Center(child: Text('Error loading: $e')),
        loading: () => const Center(child: CircularProgressIndicator()),
    );
  }

  Widget buildForm(BuildContext context, List<Product> products) {
    return Form(
      key: _newProductFormKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          buildHeader(context),
          const SizedBox(height: 10),
          _field(_nameCtrl, 'Name', 'e.g. Premium Engine Oil'),
          _field(_skuCtrl, 'SKU', 'e.g. ENG-OIL-5W30'),
          _field(_categoryCtrl, 'Category', 'e.g. Lubricants'),
          _field(_subcategoryCtrl, 'Subcategory', 'e.g. Engine Oil'),
          _field(
            _descriptionCtrl,
            'Description',
            'Short product description',
            maxLines: 3,
          ),
          _number(_priceCtrl, 'Price', 'e.g. 50.00'),
          _number(_taxRateCtrl, 'Tax Rate', 'e.g. 10%'),
          _field(_unitCtrl, 'Unit', 'e.g. Liter'),
          _field(_packagingCtrl, 'Packaging', 'e.g. 5L Can'),
          _number(
            _minOrderQtyCtrl,
            'Min Order Quantity',
            'e.g. 10',
            isInt: true,
          ),
          _number(_reorderLevelCtrl, 'Reorder Level', 'e.g. 50', isInt: true),

          SwitchListTile(
            title: const Text('Batch Number'),
            value: _batchNumber,
            onChanged: (v) => setState(() => _batchNumber = v),
          ),
          SwitchListTile(
            title: const Text('Serial Number'),
            value: _serialNumber,
            onChanged: (v) => setState(() => _serialNumber = v),
          ),

          const Divider(),

          const Text('Stock', style: TextStyle(fontWeight: FontWeight.bold)),
          buildWarehouses(context, products),
          _number(_quantityCtrl, 'Quantity', 'e.g. 10', isInt: true),
          _number(_reservedCtrl, 'Reserved', 'e.g. 10', isInt: true),

          const Divider(),

          const Text(
            'Specifications',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          _field(_viscosityCtrl, 'Viscosity', 'e.g. 10%'),
          _field(_baseTypeCtrl, 'Base Type', 'e.g. Liquid'),
          _number(_volumeCtrl, 'Volume', 'e.g. 5L', isInt: true),
          _field(_applicationCtrl, 'Application', 'e.g. Engine'),

          const Divider(),

          _field(_imagesCtrl, 'Images (comma separated)', 'Image URLs'),
          _field(
            _relatedProductsCtrl,
            'Related Products (IDs, comma separated)',
            'Related Product IDs',
          ),

          const SizedBox(height: 24),
          buildCreateButton(context)
        ],
      ),
    );
  }

  Widget buildHeader(BuildContext context) {
    return Center(
      child: Text('New Product', style: TextTheme.of(context).bodyMedium),
    );
  }

  Widget _field(
    TextEditingController controller,
    String hint,
    String label, {
    int maxLines = 1,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(hint, style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 5),
          TextFormField(
            controller: controller,
            onChanged: (_) => checkValid(),
            validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
            decoration: InputDecoration(
              hintText: label,
              hintStyle: TextTheme.of(context).labelMedium,
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(14),
              ),
              filled: true,
              fillColor: Colors.grey[400],
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _number(
    TextEditingController controller,
    String hint,
    String label, {
    bool isInt = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(hint, style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 5),
          TextFormField(
            controller: controller,
            keyboardType: TextInputType.number,
            onChanged: (_) => checkValid(),
            validator: (v) {
              if (v == null || v.isEmpty) return 'Required';
              return isInt
                  ? int.tryParse(v) == null
                  ? 'Invalid number'
                  : null
                  : double.tryParse(v) == null
                  ? 'Invalid number'
                  : null;
            },
            decoration: InputDecoration(
              hintText: label,
              hintStyle: TextTheme.of(context).labelMedium,
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(14),
              ),
              filled: true,
              fillColor: Colors.grey[400],
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildWarehouses(BuildContext context, List<Product> products) {
    List<Stock> warehouses = getAllAvailableWarehouses(products);
    return Container(
      height: 60,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return buildWarehouse(context, warehouses[index]);
          },
          separatorBuilder: (context, index) => const Divider(),
          itemCount: warehouses.length
      ),
    );
  }

  Widget buildWarehouse(BuildContext context, Stock warehouse) {
    return Container();
  }

  Widget buildCreateButton(BuildContext context) {
    return InkWell(
      onTap: () {
        if (hasEverything) {
          doCreate();
        }
      },
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 30),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
            color: hasEverything ? Colors.blueAccent : Colors.grey[400],
            borderRadius: BorderRadius.circular(30)
        ),
        child: isLoading ? const Center(
          child: CircularProgressIndicator(color: Colors.green),
        ) : Text(
          'Create',
          style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
