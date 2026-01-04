import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';

class UsersTableWidget extends StatefulWidget {
  final String searchQuery;
  final String selectedFilter;

  const UsersTableWidget({
    super.key,
    required this.searchQuery,
    required this.selectedFilter,
  });

  @override
  State<UsersTableWidget> createState() => _UsersTableWidgetState();
}

class _UsersTableWidgetState extends State<UsersTableWidget> {
  int _currentPage = 1;
  final int _itemsPerPage = 10;

  // Sample data - replace with actual data from your backend
  final List<Map<String, dynamic>> _users = [
    {
      'id': 'USR-001',
      'name': 'John Doe',
      'email': 'john.doe@example.com',
      'role': 'Admin',
      'status': 'Active',
      'joinDate': '2024-01-15',
      'avatar': 'JD',
    },
    {
      'id': 'USR-002',
      'name': 'Jane Smith',
      'email': 'jane.smith@example.com',
      'role': 'User',
      'status': 'Active',
      'joinDate': '2024-02-20',
      'avatar': 'JS',
    },
    {
      'id': 'USR-003',
      'name': 'Mike Johnson',
      'email': 'mike.j@example.com',
      'role': 'Manager',
      'status': 'Inactive',
      'joinDate': '2024-03-10',
      'avatar': 'MJ',
    },
    {
      'id': 'USR-004',
      'name': 'Sarah Williams',
      'email': 'sarah.w@example.com',
      'role': 'User',
      'status': 'Active',
      'joinDate': '2024-04-05',
      'avatar': 'SW',
    },
    {
      'id': 'USR-005',
      'name': 'David Brown',
      'email': 'david.b@example.com',
      'role': 'User',
      'status': 'Pending',
      'joinDate': '2024-05-12',
      'avatar': 'DB',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Expanded(child: SingleChildScrollView(child: _buildTable())),
          _buildPagination(),
        ],
      ),
    );
  }

  Widget _buildTable() {
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(0.8),
        1: FlexColumnWidth(1.5),
        2: FlexColumnWidth(2),
        3: FlexColumnWidth(1),
        4: FlexColumnWidth(1),
        5: FlexColumnWidth(1),
        6: FlexColumnWidth(0.8),
      },
      children: [
        _buildTableHeader(),
        ..._users.map((user) => _buildTableRow(user)),
      ],
    );
  }

  TableRow _buildTableHeader() {
    return TableRow(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFE5E7EB)),
        ),
      ),
      children: [
        _buildHeaderCell('ID'),
        _buildHeaderCell('User'),
        _buildHeaderCell('Email'),
        _buildHeaderCell('Role'),
        _buildHeaderCell('Status'),
        _buildHeaderCell('Join Date'),
        _buildHeaderCell('Actions'),
      ],
    );
  }

  Widget _buildHeaderCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Text(
        text,
        style: TextStyle(
          color: AppTheme.black.withOpacity(0.5),
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  TableRow _buildTableRow(Map<String, dynamic> user) {
    return TableRow(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFE5E7EB)),
        ),
      ),
      children: [
        _buildCell(
          Text(
            user['id'],
            style: const TextStyle(
              color: AppTheme.black,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        _buildCell(
          Row(
            children: [
              _buildAvatar(user['avatar']),
              const SizedBox(width: 12),
              Text(
                user['name'],
                style: const TextStyle(
                  color: AppTheme.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        _buildCell(
          Text(
            user['email'],
            style: TextStyle(
              color: AppTheme.black.withOpacity(0.7),
              fontSize: 13,
            ),
          ),
        ),
        _buildCell(_buildRoleBadge(user['role'])),
        _buildCell(_buildStatusBadge(user['status'])),
        _buildCell(
          Text(
            user['joinDate'],
            style: TextStyle(
              color: AppTheme.black.withOpacity(0.7),
              fontSize: 13,
            ),
          ),
        ),
        _buildCell(_buildActionButtons()),
      ],
    );
  }

  Widget _buildCell(Widget child) {
    return Padding(padding: const EdgeInsets.all(20), child: child);
  }

  Widget _buildAvatar(String initials) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryColor,
            AppTheme.primaryColor.withOpacity(0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          initials,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildRoleBadge(String role) {
    Color color;
    switch (role) {
      case 'Admin':
        color = AppTheme.black;
        break;
      case 'Manager':
        color = AppTheme.black;
        break;
      default:
        color = AppTheme.black;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        role,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    IconData icon;

    switch (status) {
      case 'Active':
        color = AppTheme.black;
        icon = Icons.check_circle;
        break;
      case 'Inactive':
        color = AppTheme.black;
        icon = Icons.cancel;
        break;
      case 'Pending':
        color = AppTheme.black;
        icon = Icons.schedule;
        break;
      default:
        color = Colors.grey;
        icon = Icons.help;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 6),
          Text(
            status,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildActionButton(
          icon: Icons.edit,
          color: AppTheme.primaryColor,
          onTap: () {
            // Edit action
          },
        ),
        const SizedBox(width: 8),
        _buildActionButton(
          icon: Icons.delete,
          color: AppTheme.black,
          onTap: () {
            // Delete action
          },
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Icon(icon, color: color, size: 16),
          ),
        ),
      ),
    );
  }

  Widget _buildPagination() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Showing ${(_currentPage - 1) * _itemsPerPage + 1} to ${_currentPage * _itemsPerPage} of ${_users.length} entries',
            style: TextStyle(
              color: AppTheme.black.withOpacity(0.5),
              fontSize: 13,
            ),
          ),
          Row(
            children: [
              _buildPaginationButton(
                icon: Icons.chevron_left,
                onTap: _currentPage > 1
                    ? () {
                        setState(() {
                          _currentPage--;
                        });
                      }
                    : null,
              ),
              const SizedBox(width: 12),
              ..._buildPageNumbers(),
              const SizedBox(width: 12),
              _buildPaginationButton(
                icon: Icons.chevron_right,
                onTap: () {
                  setState(() {
                    _currentPage++;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _buildPageNumbers() {
    return List.generate(3, (index) {
      final pageNumber = index + 1;
      final isActive = pageNumber == _currentPage;

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: isActive ? AppTheme.primaryColor : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isActive ? AppTheme.primaryColor : const Color(0xFFE5E7EB),
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                setState(() {
                  _currentPage = pageNumber;
                });
              },
              borderRadius: BorderRadius.circular(8),
              child: Center(
                child: Text(
                  '$pageNumber',
                  style: TextStyle(
                    color: isActive
                        ? Colors.white
                        : AppTheme.black.withOpacity(0.7),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildPaginationButton({
    required IconData icon,
    required VoidCallback? onTap,
  }) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color:
              onTap != null ? const Color(0xFFE5E7EB) : const Color(0xFFF3F4F6),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Icon(
            icon,
            color: onTap != null
                ? AppTheme.black.withOpacity(0.7)
                : AppTheme.black.withOpacity(0.2),
            size: 18,
          ),
        ),
      ),
    );
  }
}
