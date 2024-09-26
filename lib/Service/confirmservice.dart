class  Confirm {
  final String status;
  final String date;
  final String place;


   Confirm({
    required this.status,
    required this.date,
    required this.place,

  });
}

// สร้างข้อมูลสินค้า
class Confirmservice {
  static  Confirm getConfirm() {
    return Confirm(
      status: '1',
      date: '25 ธ.ค. 2567 10:00',
      place:'วิศวกรรมศาสตร์ ECC',
    );
  }
}
