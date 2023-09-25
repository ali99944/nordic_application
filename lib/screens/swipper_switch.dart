import 'package:flutter/material.dart';

class SwipeToUnlockSwitch extends StatefulWidget {
  final VoidCallback onSwipeEnd;

  const SwipeToUnlockSwitch({Key? key, required this.onSwipeEnd}) : super(key: key);

  @override
  _SwipeToUnlockSwitchState createState() => _SwipeToUnlockSwitchState();
}

class _SwipeToUnlockSwitchState extends State<SwipeToUnlockSwitch> {
  double _xOffset = 10;
  double _maxXOffset = 300;
  bool _unlocked = false;
  bool _swipeCompleted = false; // Flag to track if the swipe action is completed

  @override
  Widget build(BuildContext context) {
    double borderRadius = 25; // Calculate dynamic border radius

    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        if (!_swipeCompleted) { // Only update if swipe is not completed
          setState(() {
            _xOffset += details.delta.dx;
            if (_xOffset < 0) {
              _xOffset = 10;
            } else if (_xOffset > _maxXOffset && !_swipeCompleted) {
              _xOffset = _maxXOffset;
              _unlocked = true;
              _swipeCompleted = true; // Mark the swipe action as completed

              widget.onSwipeEnd();
            }
          });
        }
      },
      onHorizontalDragEnd: (details) {
        setState(() {
          if (!_unlocked) {
            _xOffset = 0;
          }
          if (_xOffset <= 0) {
            _unlocked = false;
          }
          _swipeCompleted = false; // Reset the swipe completion flag
        });
      },
      child: Container(
        color: Colors.transparent,
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            Container(
              height: 80,
              width: double.infinity,
              decoration: BoxDecoration(
                color: _unlocked ? Colors.green : Colors.blue, // Adjust colors as needed
                borderRadius: BorderRadius.circular(borderRadius * 4), // Use the dynamic border radius
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.upload,
                      color: Colors.white,
                    ),
                    SizedBox(width: 5),
                    Text(
                      _unlocked ? 'Lastet opp' : 'Sveip for å laste opp',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                      ),
                    ),
                  ],
                ),
              ),
            ),
            AnimatedPositioned(
              duration: Duration(milliseconds: 100),
              left: _xOffset,
              child: Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.chevron_right,
                  size: 50,
                  color: Colors.green,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
