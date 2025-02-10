import 'package:myproject/environment.dart';

class Categoryservice {
  Future<List<ProductCat>> getCategoryProducts() async {
    // จำลองข้อมูล
    await Future.delayed(const Duration(seconds: 1)); // จำลองเวลาโหลดข้อมูล
    return [
      ProductCat(
        imageUrl: 'assets/images/old_fan.png',
        title: 'พัดลม HATARI 16 นิ้ว',
        detail:
            'พัดลม HATARI ขนาด 16 นิ้ว พัดลมมือสองพร้อมใช้งาน สินค้าตามภาพครับ ทดสอบการใช้งานอย่างละเอียดแล้ว พัดแรงปกติครับ... ขนาด 16 นิ้ว สินค้ามือสองคุณภาพดี ยี่ห้อดี เช็คละเอียดทุกอุปกรณ์ หากสงสัยหรือ อยากขอรูปเพิ่มเติมทักแชทได้ครับ ใช้งานมาไม่นาน สภาพปกติไม่มีส่วนไหนชำรุด',
        types: 'เครื่องใช้ไฟฟ้า',
        price: '200',
        category: 'เครื่องใช้ไฟฟ้า',
      ),
      ProductCat(
        imageUrl: 'assets/images/tuyen.png',
        title: 'ตู้เย็น',
        detail: 'ตู้เย็นมือสอง ใช้งานมา 1 ปี',
        types: 'เครื่องใช้ไฟฟ้า',
        price: '1500',
        category: 'เครื่องใช้ไฟฟ้า',
      ),
      ProductCat(
        imageUrl: 'assets/images/old_fan.png',
        title: 'พัดลม HATARI 16 นิ้ว',
        detail:
            'พัดลม HATARI ขนาด 16 นิ้ว พัดลมมือสองพร้อมใช้งาน สินค้าตามภาพครับ ทดสอบการใช้งานอย่างละเอียดแล้ว พัดแรงปกติครับ... ขนาด 16 นิ้ว สินค้ามือสองคุณภาพดี ยี่ห้อดี เช็คละเอียดทุกอุปกรณ์ หากสงสัยหรือ อยากขอรูปเพิ่มเติมทักแชทได้ครับ ใช้งานมาไม่นาน สภาพปกติไม่มีส่วนไหนชำรุด',
        types: 'เครื่องใช้ไฟฟ้า',
        price: '200',
        category: 'เครื่องใช้ไฟฟ้า',
      ),
      ProductCat(
        imageUrl: 'assets/images/tuyen.png',
        title: 'ตู้เย็น',
        detail: 'ตู้เย็นมือสอง ใช้งานมา 1 ปี',
        types: 'เครื่องใช้ไฟฟ้า',
        price: '1500',
        category: 'เครื่องใช้ไฟฟ้า',
      ),
      ProductCat(
        imageUrl: 'assets/images/tuyen.png',
        title: 'ตู้เย็น',
        detail: 'ตู้เย็นมือสอง ใช้งานมา 1 ปี',
        types: 'เครื่องใช้ไฟฟ้า',
        price: '1500',
        category: 'เครื่องใช้ไฟฟ้า',
      ),
      ProductCat(
        imageUrl: 'assets/images/old_fan.png',
        title: 'พัดลม HATARI 16 นิ้ว',
        detail:
            'พัดลม HATARI ขนาด 16 นิ้ว พัดลมมือสองพร้อมใช้งาน สินค้าตามภาพครับ ทดสอบการใช้งานอย่างละเอียดแล้ว พัดแรงปกติครับ... ขนาด 16 นิ้ว สินค้ามือสองคุณภาพดี ยี่ห้อดี เช็คละเอียดทุกอุปกรณ์ หากสงสัยหรือ อยากขอรูปเพิ่มเติมทักแชทได้ครับ ใช้งานมาไม่นาน สภาพปกติไม่มีส่วนไหนชำรุด',
        types: 'เครื่องใช้ไฟฟ้า',
        price: '200',
        category: 'เครื่องใช้ไฟฟ้า',
      ),
      ProductCat(
        imageUrl: 'assets/images/tuyen.png',
        title: 'ตู้เย็น',
        detail: 'ตู้เย็นมือสอง ใช้งานมา 1 ปี',
        types: 'เครื่องใช้ไฟฟ้า',
        price: '1500',
        category: 'เครื่องใช้ไฟฟ้า',
      ),
      ProductCat(
        imageUrl: 'assets/images/old_fan.png',
        title: 'พัดลม HATARI 16 นิ้ว',
        detail:
            'พัดลม HATARI ขนาด 16 นิ้ว พัดลมมือสองพร้อมใช้งาน สินค้าตามภาพครับ ทดสอบการใช้งานอย่างละเอียดแล้ว พัดแรงปกติครับ... ขนาด 16 นิ้ว สินค้ามือสองคุณภาพดี ยี่ห้อดี เช็คละเอียดทุกอุปกรณ์ หากสงสัยหรือ อยากขอรูปเพิ่มเติมทักแชทได้ครับ ใช้งานมาไม่นาน สภาพปกติไม่มีส่วนไหนชำรุด',
        types: 'เครื่องใช้ไฟฟ้า',
        price: '200',
        category: 'เครื่องใช้ไฟฟ้า',
      ),
    ];
  }
}

class ProductCat {
  final String imageUrl;
  final String title;
  final String detail;
  final String price;
  final String category;
  final String types;

  ProductCat({
    required this.imageUrl,
    required this.title,
    required this.detail,
    required this.price,
    required this.category,
    required this.types,
  });

  factory ProductCat.fromJson(Map<String, dynamic> data) {
    print('aaa ${data['image']}');
    return ProductCat(
      imageUrl: '${Environment.imgUrl}/${data['image'][0]}',
      title: data['user']['name'], // ไม่มีข้อมูลใน JSON, คุณสามารถใส่ข้อมูล default หรือ null
      detail: data['user']['faculty'], // ไม่มีข้อมูลใน JSON, คุณสามารถใส่ข้อมูล default หรือ null
      price: data['id'].toString(),
      category: data['category'], // หรือเปลี่ยนให้ตรงกับ field ที่คุณต้องการ
      // detail: data['detail'],
      types: data['tag'],
    );
  }
}
