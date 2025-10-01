import 'package:flutter/material.dart';

class MyPlace extends StatelessWidget {
  const MyPlace({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          block1(), block2(), block3(), block4()
        ],
      ),
    );
  }
  Widget block1() {
    var src = "https://images.unsplash.com/photo-1705823637026-92c0ef6d6222?q=80&w=1174&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D";
    return Image.network(src);
  }
  
  Widget block2() {
    return Padding(
      padding: const EdgeInsets.all(20.0), // thêm khoảng cách đẹp
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: block2_1()), // chữ bên trái
          block2_2(),                  // sao bên phải
        ],
      ),
    );
  }

 Widget block2_1() {
    const title = "Thành phố Huế";
    const subtitle = "Việt Nam";
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black, // tiêu đề nổi bật
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey, // phụ đề nhạt
          ),
        ),
      ],
    );
  }

  Widget block2_2() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: const [
        Icon(Icons.star, color: Colors.red, size: 20),
        SizedBox(width: 6),
        Text(
          '5.0',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget block3() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        buildButton(Icons.call, "CALL"),
        buildButton(Icons.near_me, "ROUTE"),
        buildButton(Icons.share, "SHARE"),
      ],
    );
  }

  Widget buildButton(IconData icon, String label) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(icon, color: Colors.blue),
      const SizedBox(height: 8),
      Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: Colors.blue,
        ),
      ),
    ],
  );
}
  
  Widget block4() {
    var data = "Huế là một trong sáu thành phố trực thuộc trung ương của Việt Nam và là tỉnh lỵ của tỉnh Thừa Thiên Huế. Thành phố này từng là kinh đô của Việt Nam dưới triều đại Tây Sơn và triều Nguyễn, từ năm 1802 đến 1945. Huế nổi tiếng với các di sản văn hóa, trong đó có Quần thể di tích Cố đô Huế, được UNESCO công nhận là di sản thế giới vào năm 1993.";
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Text(data),
      );
  }

}