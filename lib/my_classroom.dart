import 'package:flutter/material.dart';

// --- Lớp mô hình dữ liệu (Không có 'teacher') ---
class ClassInfo {
  final String title;
  final String code;
  final int students;
  final String imageUrl;

  const ClassInfo({
    required this.title,
    required this.code,
    required this.students,
    required this.imageUrl,
  });
}

// --- Màn hình chính (Danh sách lớp học) ---
class MyClassroom extends StatelessWidget {
  const MyClassroom({super.key});

  @override
  Widget build(BuildContext context) {
    // Dữ liệu mẫu
    final classes = <ClassInfo>[
      const ClassInfo(
        title: 'XML và ứng dụng - Nhóm 1',
        code: '2025-2026.1.TIN4583.001',
        students: 58,
        imageUrl:
            'https://images.unsplash.com/photo-1523580846011-d3a5bc25702b?fit=crop&w=800&q=80',
      ),
      const ClassInfo(
        title: 'Lập trình ứng dụng cho các t…',
        code: '2025-2026.1.TIN4403.006',
        students: 55,
        imageUrl:
            'https://images.unsplash.com/photo-1519681393784-d120267933ba?fit=crop&w=800&q=80',
      ),
      const ClassInfo(
        title: 'Lập trình ứng dụng cho các t…',
        code: '2025-2026.1.TIN4403.005',
        students: 52,
        imageUrl:
            'https://images.unsplash.com/photo-1529101091764-c3526daf38fe?fit=crop&w=800&q=80',
      ),
      const ClassInfo(
        title: 'Lập trình ứng dụng cho các t…',
        code: '2025-2026.1.TIN4403.004',
        students: 50,
        imageUrl:
            'https://images.unsplash.com/photo-1496307042754-b4aa456c4a2d?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=800&q=80',
      ),
      const ClassInfo(
        title: 'Lập trình ứng dụng cho các t…',
        code: '2025-2026.1.TIN4403.003',
        students: 52,
        imageUrl:
            'https://images.unsplash.com/photo-1522075469751-3a6694fb2f61?fit=crop&w=800&q=80',
      ),
    ];

    // Cấu hình màn hình
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lớp học'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text('Tìm kiếm')));
            },
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: classes.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, i) => ClassCard(info: classes[i]),
      ),
    );
  }
}

// --- 4. Thẻ lớp học (ClassCard) ---
class ClassCard extends StatelessWidget {
  final ClassInfo info;
  const ClassCard({super.key, required this.info});

  void _toast(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias, 
      elevation: 2, 
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8), 
      ),
      margin: EdgeInsets.zero, 

      child: InkWell(
        onTap: () => _toast(context, 'Mở chi tiết lớp ${info.title}'),
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          height: 140, 
          child: Stack(
            children: [
              // 1. Ảnh nền
              Positioned.fill(
                child: Ink.image(
                  image: NetworkImage(info.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
              
              // 2. Lớp phủ gradient (ĐÃ SỬA LỖI CONST_EVAL_METHOD_INVOCATION)
              Positioned.fill(
                child: Container(
                  decoration: const BoxDecoration( // Đảm bảo const ở đây
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        // Alpha 38 (15% opacity): Color(0x26000000)
                        Color(0x26000000), 
                        // Alpha 115 (45% opacity): Color(0x73000000)
                        Color(0x73000000), 
                      ],
                    ),
                  ),
                ),
              ),
              
              // 3. Nội dung chính (Sát tiêu đề)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 8, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            info.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              // Sát tiêu đề
                              height: 1.0, 
                            ),
                          ),
                        ),
                        // Nút ba chấm
                        PopupMenuButton<String>(
                          icon: const Icon(Icons.more_vert, color: Colors.white),
                          onSelected: (value) {
                            switch (value) {
                              case 'info':
                                _toast(context, 'Xem thông tin lớp');
                                break;
                              case 'students':
                                _toast(context, 'Xem danh sách học viên');
                                break;
                              case 'leave':
                                _toast(context, 'Rời khỏi lớp');
                                break;
                            }
                          },
                          itemBuilder: (context) => const [
                            PopupMenuItem(value: 'info', child: Text('Xem thông tin lớp')),
                            PopupMenuItem(value: 'students', child: Text('Xem học viên')),
                            PopupMenuItem(value: 'leave', child: Text('Rời khỏi lớp')),
                          ],
                        ),
                      ],
                    ),
                    
                    // Mã lớp (Sát tiêu đề)
                    Text(
                      info.code,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white, 
                        // Sát tiêu đề
                        height: 1.0, 
                      ),
                    ),
                    
                    const Spacer(), 
                    
                    // Số học viên
                    Text(
                      '${info.students} học viên',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.white, 
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}