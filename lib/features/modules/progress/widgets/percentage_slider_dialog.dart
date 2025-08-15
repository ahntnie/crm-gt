import 'package:flutter/material.dart';

class PercentageSliderDialog extends StatefulWidget {
  final double currentPercentage;
  final String title;
  final Function(double) onConfirm;

  const PercentageSliderDialog({
    super.key,
    required this.currentPercentage,
    required this.title,
    required this.onConfirm,
  });

  @override
  State<PercentageSliderDialog> createState() => _PercentageSliderDialogState();
}

class _PercentageSliderDialogState extends State<PercentageSliderDialog> {
  late double _percentage;

  @override
  void initState() {
    super.initState();
    _percentage = widget.currentPercentage;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(20),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 450),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(),
            _buildContent(),
            _buildActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _getPercentageColor(),
            _getPercentageColor().withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.tune,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Cập nhật tiến độ',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(
              Icons.close,
              color: Colors.white,
              size: 24,
            ),
            style: IconButton.styleFrom(
              backgroundColor: Colors.white.withOpacity(0.2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Percentage Display Circle
          Center(
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    _getPercentageColor().withOpacity(0.1),
                    _getPercentageColor().withOpacity(0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(
                  color: _getPercentageColor().withOpacity(0.3),
                  width: 3,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${_percentage.toStringAsFixed(0)}%',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: _getPercentageColor(),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _getStatusText(),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: _getPercentageColor(),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 32),

          // Slider Section
          Text(
            'Điều chỉnh tiến độ',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 16),

          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: _getPercentageColor(),
              inactiveTrackColor: Colors.grey[300],
              thumbColor: _getPercentageColor(),
              overlayColor: _getPercentageColor().withOpacity(0.2),
              trackHeight: 6,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
              valueIndicatorColor: _getPercentageColor(),
              valueIndicatorTextStyle: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            child: Slider(
              value: _percentage,
              min: 0,
              max: 100,
              divisions: 20,
              label: '${_percentage.toStringAsFixed(0)}%',
              onChanged: (value) {
                setState(() {
                  _percentage = value;
                });
              },
            ),
          ),

          const SizedBox(height: 8),

          // Slider Labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('0%', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
              Text('25%', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
              Text('50%', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
              Text('75%', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
              Text('100%', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
            ],
          ),

          const SizedBox(height: 24),

          // Quick Buttons
          Text(
            'Chọn nhanh',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildQuickButton('0%', 0),
              _buildQuickButton('25%', 25),
              _buildQuickButton('50%', 50),
              _buildQuickButton('75%', 75),
              _buildQuickButton('100%', 100),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActions() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Hủy',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: () {
                widget.onConfirm(_percentage);
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _getPercentageColor(),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.check,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Cập nhật',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickButton(String label, double value) {
    final isSelected = _percentage == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _percentage = value;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [
                    _getPercentageColor(),
                    _getPercentageColor().withOpacity(0.8),
                  ],
                )
              : null,
          color: isSelected ? null : Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? _getPercentageColor() : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: _getPercentageColor().withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[700],
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Color _getPercentageColor() {
    if (_percentage >= 100) {
      return Colors.green[600]!;
    } else if (_percentage >= 75) {
      return Colors.blue[600]!;
    } else if (_percentage >= 50) {
      return Colors.orange[600]!;
    } else if (_percentage >= 25) {
      return Colors.amber[600]!;
    } else {
      return Colors.red[600]!;
    }
  }

  String _getStatusText() {
    if (_percentage >= 100) {
      return 'Hoàn thành';
    } else if (_percentage >= 75) {
      return 'Gần hoàn thành';
    } else if (_percentage >= 50) {
      return 'Đang tiến triển';
    } else if (_percentage >= 25) {
      return 'Bắt đầu';
    } else {
      return 'Chưa bắt đầu';
    }
  }
}
