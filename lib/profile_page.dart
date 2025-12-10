import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'FormLogin.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthService _authService = AuthService();
  Map<String, dynamic>? _userData;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final result = await _authService.getCurrentUser();

    setState(() {
      _isLoading = false;
      if (result['success']) {
        _userData = result['data'];
      } else {
        _errorMessage = result['message'];
      }
    });
  }

  Future<void> _handleLogout() async {
    await _authService.logout();
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MyLogin()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông tin cá nhân'),
        backgroundColor: const Color(0xFF2196F3),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _handleLogout,
            tooltip: 'Đăng xuất',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 60, color: Colors.red),
                      const SizedBox(height: 16),
                      Text(_errorMessage!),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadUserData,
                        child: const Text('Thử lại'),
                      ),
                    ],
                  ),
                )
              : _userData == null
                  ? const Center(child: Text('Không có dữ liệu'))
                  : RefreshIndicator(
                      onRefresh: _loadUserData,
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            // Avatar
                            CircleAvatar(
                              radius: 60,
                              backgroundImage: _userData!['image'] != null
                                  ? NetworkImage(_userData!['image'])
                                  : null,
                              child: _userData!['image'] == null
                                  ? const Icon(Icons.person, size: 60)
                                  : null,
                            ),
                            const SizedBox(height: 16),
                            
                            // Tên
                            Text(
                              '${_userData!['firstName']} ${_userData!['lastName']}',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            
                            // Username
                            Text(
                              '@${_userData!['username']}',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 24),
                            
                            // Thông tin chi tiết
                            _buildInfoCard(),
                          ],
                        ),
                      ),
                    ),
    );
  }

  Widget _buildInfoCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Thông tin chi tiết',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(height: 24),
            
            _buildInfoRow(Icons.badge, 'ID', '${_userData!['id']}'),
            _buildInfoRow(Icons.email, 'Email', _userData!['email'] ?? 'N/A'),
            _buildInfoRow(Icons.phone, 'Số điện thoại', _userData!['phone'] ?? 'N/A'),
            _buildInfoRow(Icons.cake, 'Ngày sinh', _userData!['birthDate'] ?? 'N/A'),
            if (_userData!['age'] != null)
              _buildInfoRow(Icons.calendar_today, 'Tuổi', '${_userData!['age']}'),
            _buildInfoRow(Icons.wc, 'Giới tính', _userData!['gender'] ?? 'N/A'),
            if (_userData!['maidenName'] != null)
              _buildInfoRow(Icons.person_outline, 'Tên thời con gái', _userData!['maidenName']),
            _buildInfoRow(Icons.bloodtype, 'Nhóm máu', _userData!['bloodGroup'] ?? 'N/A'),
            _buildInfoRow(Icons.height, 'Chiều cao', '${_userData!['height'] ?? 'N/A'} cm'),
            _buildInfoRow(Icons.monitor_weight, 'Cân nặng', '${_userData!['weight'] ?? 'N/A'} kg'),
            _buildInfoRow(Icons.visibility, 'Màu mắt', _userData!['eyeColor'] ?? 'N/A'),
            if (_userData!['hair'] != null) ...[
              _buildInfoRow(Icons.face, 'Màu tóc', _userData!['hair']['color'] ?? 'N/A'),
              _buildInfoRow(Icons.face_2, 'Kiểu tóc', _userData!['hair']['type'] ?? 'N/A'),
            ],
            
            if (_userData!['address'] != null) ...[
              const Divider(height: 24),
              const Text(
                'Địa chỉ',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${_userData!['address']['address']}, ${_userData!['address']['city']}, ${_userData!['address']['state']} ${_userData!['address']['postalCode']}',
                style: TextStyle(color: Colors.grey[700]),
              ),
            ],
            
            if (_userData!['company'] != null) ...[
              const Divider(height: 24),
              const Text(
                'Công ty',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              _buildInfoRow(Icons.business, 'Tên công ty', _userData!['company']['name'] ?? 'N/A'),
              _buildInfoRow(Icons.work, 'Chức vụ', _userData!['company']['title'] ?? 'N/A'),
              _buildInfoRow(Icons.business_center, 'Phòng ban', _userData!['company']['department'] ?? 'N/A'),
            ],
            
            if (_userData!['university'] != null) ...[
              const Divider(height: 24),
              _buildInfoRow(Icons.school, 'Trường đại học', _userData!['university']),
            ],
            
            if (_userData!['bank'] != null) ...[
              const Divider(height: 24),
              const Text(
                'Thông tin ngân hàng',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              _buildInfoRow(Icons.credit_card, 'Số thẻ', _userData!['bank']['cardNumber'] ?? 'N/A'),
              _buildInfoRow(Icons.credit_card, 'Loại thẻ', _userData!['bank']['cardType'] ?? 'N/A'),
              _buildInfoRow(Icons.date_range, 'Ngày hết hạn', _userData!['bank']['cardExpire'] ?? 'N/A'),
              _buildInfoRow(Icons.account_balance, 'IBAN', _userData!['bank']['iban'] ?? 'N/A'),
              _buildInfoRow(Icons.attach_money, 'Tiền tệ', _userData!['bank']['currency'] ?? 'N/A'),
            ],
            
            if (_userData!['crypto'] != null) ...[
              const Divider(height: 24),
              const Text(
                'Thông tin Crypto',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              _buildInfoRow(Icons.currency_bitcoin, 'Đồng coin', _userData!['crypto']['coin'] ?? 'N/A'),
              _buildInfoRow(Icons.wallet, 'Ví', _userData!['crypto']['wallet'] ?? 'N/A'),
              _buildInfoRow(Icons.public, 'Mạng', _userData!['crypto']['network'] ?? 'N/A'),
            ],
            
            const Divider(height: 24),
            if (_userData!['ssn'] != null)
              _buildInfoRow(Icons.fingerprint, 'SSN', _userData!['ssn']),
            if (_userData!['ein'] != null)
              _buildInfoRow(Icons.badge_outlined, 'EIN', _userData!['ein']),
            if (_userData!['role'] != null)
              _buildInfoRow(Icons.admin_panel_settings, 'Vai trò', _userData!['role']),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}