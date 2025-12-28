import '../../../data/models/products/product_model.dart';

int getItemStockTotals(List<Stock> stores) {
  return stores.fold<int>(0, (sum, store) => sum + store.quantity);
}