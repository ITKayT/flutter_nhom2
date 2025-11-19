import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;

class MyReport extends StatefulWidget {
  const MyReport({super.key});

  @override
  State<MyReport> createState() => _MyReportState();
}

class _MyReportState extends State<MyReport> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _feedbackController = TextEditingController();
  int _rating = 4;
  File? _selectedImage;
  XFile? _selectedImageWeb;
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _nameController.dispose();
    _feedbackController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1800,
        maxHeight: 1800,
        imageQuality: 85,
      );
      
      if (image != null) {
        setState(() {
          if (kIsWeb) {
            _selectedImageWeb = image;
          } else {
            _selectedImage = File(image.path);
          }
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi khi chọn ảnh: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showImageSourceDialog() {
    // Trên web, chỉ hỗ trợ chọn từ thư viện
    if (kIsWeb) {
      _pickImage(ImageSource.gallery);
      return;
    }
    
    // Trên mobile, hiển thị dialog để chọn nguồn
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Chọn nguồn ảnh'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Thư viện ảnh'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Chụp ảnh'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _submitFeedback() {
    if (_formKey.currentState!.validate()) {
      final hasImage = kIsWeb ? _selectedImageWeb != null : _selectedImage != null;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(hasImage 
            ? 'Cảm ơn bạn đã gửi phản hồi kèm ảnh!'
            : 'Cảm ơn bạn đã gửi phản hồi!'),
          backgroundColor: Colors.green,
        ),
      );
      // Reset form
      _nameController.clear();
      _feedbackController.clear();
      setState(() {
        _rating = 4;
        _selectedImage = null;
        _selectedImageWeb = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFB2DFDB),
      body: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: const BoxDecoration(
              color: Color(0xFFC62828),
            ),
            child: const SafeArea(
              bottom: false,
              child: Text(
                'Gửi phản hồi',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          
          // Form content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Họ tên
                    TextFormField(
                      controller: _nameController,
                      style: const TextStyle(fontSize: 16),
                      decoration: InputDecoration(
                        labelText: 'Họ tên',
                        labelStyle: const TextStyle(color: Color(0xFF37474F)),
                        prefixIcon: const Icon(
                          Icons.person_outline,
                          size: 22,
                          color: Color(0xFF37474F),
                        ),
                        filled: true,
                        fillColor: const Color(0xFFE0F2F1),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Color(0xFF37474F)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Color(0xFF37474F)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Color(0xFF37474F), width: 2),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập họ tên';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    // Đánh giá (dropdown)
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0F2F1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFF37474F)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 16, top: 8),
                            child: Text(
                              'Đánh giá (1 - 5 sao)',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF37474F),
                              ),
                            ),
                          ),
                          DropdownButtonFormField<int>(
                            value: _rating,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(
                                Icons.star,
                                size: 22,
                                color: Color(0xFF37474F),
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                            ),
                            dropdownColor: const Color(0xFFE0F2F1),
                            items: [1, 2, 3, 4, 5].map((int value) {
                              return DropdownMenuItem<int>(
                                value: value,
                                child: Text(
                                  '$value sao',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFF37474F),
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (int? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  _rating = newValue;
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Nội dung góp ý
                    TextFormField(
                      controller: _feedbackController,
                      maxLines: 6,
                      style: const TextStyle(fontSize: 16),
                      decoration: InputDecoration(
                        labelText: 'Nội dung góp ý',
                        labelStyle: const TextStyle(color: Color(0xFF37474F)),
                        alignLabelWithHint: true,
                        prefixIcon: const Padding(
                          padding: EdgeInsets.only(bottom: 90),
                          child: Icon(
                            Icons.comment_outlined,
                            size: 22,
                            color: Color(0xFF37474F),
                          ),
                        ),
                        filled: true,
                        fillColor: const Color(0xFFE0F2F1),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Color(0xFF37474F)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Color(0xFF37474F)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Color(0xFF37474F), width: 2),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập nội dung góp ý';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    // Upload ảnh
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0F2F1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFF37474F)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.image_outlined,
                                size: 22,
                                color: Color(0xFF37474F),
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                'Đính kèm ảnh (tùy chọn)',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF37474F),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          
                          // Hiển thị ảnh đã chọn hoặc nút chọn ảnh
                          if ((kIsWeb && _selectedImageWeb != null) || (!kIsWeb && _selectedImage != null)) ...[
                            Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: kIsWeb
                                    ? Image.network(
                                        _selectedImageWeb!.path,
                                        height: 200,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.file(
                                        _selectedImage!,
                                        height: 200,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                ),
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: CircleAvatar(
                                    backgroundColor: Colors.red,
                                    radius: 18,
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.close,
                                        size: 18,
                                        color: Colors.white,
                                      ),
                                      padding: EdgeInsets.zero,
                                      onPressed: () {
                                        setState(() {
                                          _selectedImage = null;
                                          _selectedImageWeb = null;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            OutlinedButton.icon(
                              onPressed: _showImageSourceDialog,
                              icon: const Icon(Icons.edit),
                              label: const Text('Thay đổi ảnh'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFF37474F),
                                side: const BorderSide(color: Color(0xFF37474F)),
                              ),
                            ),
                          ] else ...[
                            OutlinedButton.icon(
                              onPressed: _showImageSourceDialog,
                              icon: const Icon(Icons.add_photo_alternate),
                              label: const Text('Chọn ảnh'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFF37474F),
                                side: const BorderSide(color: Color(0xFF37474F)),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Nút Gửi phản hồi
                    ElevatedButton.icon(
                      onPressed: _submitFeedback,
                      icon: const Icon(Icons.send, size: 18),
                      label: const Text(
                        'Gửi phản hồi',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFC62828),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}