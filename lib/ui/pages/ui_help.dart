import 'package:flutter/material.dart';

class LoadingButton extends StatefulWidget {
  final Future<void> Function()? onPressed;
  final Widget child;
  const LoadingButton({Key? key, this.onPressed, required this.child})
      : super(key: key);

  @override
  _LoadingButtonState createState() => _LoadingButtonState();
}

class _LoadingButtonState extends State<LoadingButton> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return isLoading
        ? CircularProgressIndicator()
        : ElevatedButton(
            onPressed: widget.onPressed == null
                ? null
                : () async {
                    setState(() {
                      isLoading = true;
                    });
                    await widget.onPressed!();
                    setState(() {
                      isLoading = false;
                    });
                  },
            child: widget.child);
  }
}
