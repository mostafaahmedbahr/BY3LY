import 'package:by3ly_app/core/utils/app_colors/app_colors.dart';
import 'package:flutter/material.dart';

class ProfileViewBody extends StatefulWidget {
  const ProfileViewBody({super.key});

  @override
  State<ProfileViewBody> createState() => _ProfileViewBodyState();
}

class _ProfileViewBodyState extends State<ProfileViewBody> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final List<String> _items = [];
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    _addItem();
  }
  void _addItem() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_counter < 10) { // Adjust this value to control the number of items
        _items.add('Item $_counter');
        _listKey.currentState?.insertItem(_counter, duration: const Duration(milliseconds: 500));
        _counter++;
        _addItem();
      }
    });
  }

  Widget _buildItem(BuildContext context, int index, Animation<double> animation) {
    return SlideTransition(
      position: animation.drive(
        Tween<Offset>(begin: const Offset(-1, 0), end: const Offset(0, 0)).chain(
          CurveTween(curve: Curves.easeInOut),
        ),
      ),
      child: Card(
        color: AppColors.whiteColor,
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: ListTile(
          title: Text(_items[index]),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: const Text('Animated List Example'),
    ),
      body: AnimatedList(
        key: _listKey,
        initialItemCount: _items.length,
        itemBuilder: (context, index, animation) {
          return _buildItem(context, index, animation);
        },
      ),
    );
  }
}
