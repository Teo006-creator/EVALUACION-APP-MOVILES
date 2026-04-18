import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class ProgressWidget extends StatelessWidget {
  final double percentage;
  final double size;
  final bool showPercentage;

  const ProgressWidget({
    super.key,
    required this.percentage,
    this.size = 80,
    this.showPercentage = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: percentage / 100,
              strokeWidth: 8,
              backgroundColor: Colors.grey.shade300,
              valueColor: AlwaysStoppedAnimation<Color>(_getColor()),
            ),
          ),
          if (showPercentage)
            Text(
              '${percentage.toInt()}%',
              style: TextStyle(
                fontSize: size / 4,
                fontWeight: FontWeight.bold,
                color: _getColor(),
              ),
            ),
        ],
      ),
    );
  }

  Color _getColor() {
    if (percentage >= 100) return AppTheme.primaryColor;
    if (percentage >= 50) return AppTheme.accentColor;
    return AppTheme.secondaryColor;
  }
}

class AnimatedProgressBar extends StatefulWidget {
  final double percentage;
  final double height;
  final Duration duration;

  const AnimatedProgressBar({
    super.key,
    required this.percentage,
    this.height = 8,
    this.duration = const Duration(milliseconds: 500),
  });

  @override
  State<AnimatedProgressBar> createState() => _AnimatedProgressBarState();
}

class _AnimatedProgressBarState extends State<AnimatedProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _animation = Tween<double>(
      begin: 0,
      end: widget.percentage,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _controller.forward();
  }

  @override
  void didUpdateWidget(AnimatedProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.percentage != widget.percentage) {
      _animation = Tween<double>(
        begin: oldWidget.percentage,
        end: widget.percentage,
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(widget.height / 2),
              child: LinearProgressIndicator(
                value: _animation.value / 100,
                backgroundColor: Colors.grey.shade300,
                valueColor: AlwaysStoppedAnimation<Color>(
                  _getColor(_animation.value),
                ),
                minHeight: widget.height,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${_animation.value.toInt()}%',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: _getColor(_animation.value),
              ),
            ),
          ],
        );
      },
    );
  }

  Color _getColor(double progress) {
    if (progress >= 100) return AppTheme.primaryColor;
    if (progress >= 50) return AppTheme.accentColor;
    return AppTheme.secondaryColor;
  }
}
