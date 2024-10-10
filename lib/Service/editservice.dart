class ProductService {
  Future<Product> getProductById(String id) async {
    // ทำการดึงข้อมูลสินค้าจาก API หรือฐานข้อมูล
    // ตัวอย่างข้อมูล:
    return Product(
      id: id,
      name: "ชื่อสินค้า",
      type: "ประเภท",
      price: 100,
      description: "รายละเอียดสินค้า",
      // ... เพิ่มข้อมูลตามที่ต้องการ
    );
  }

  Future<void> updateProduct(Product product) async {
    // ทำการอัปเดตข้อมูลสินค้าลงใน API หรือฐานข้อมูล
  }
}

// สมมุติให้มี Product class
class Product {
  String id;
  String name;
  String type;
  double price;
  String description;

  Product({required this.id, required this.name, required this.type, required this.price, required this.description});
}
