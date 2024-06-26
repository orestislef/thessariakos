import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:thessariakos/widgets/info/information_list.dart';
import 'package:thessariakos/widgets/post/add_post.dart';
import 'package:thessariakos/widgets/post/post_list.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isAddPostVisible = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: _buildNavForTabs().length,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Tab> navTabsList = _buildNavForTabs();
    List<Widget> tabsList = _buildTabs();

    _tabController.addListener(() => _onTabChange(_tabController.index));

    return DefaultTabController(
      length: navTabsList.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text('app_name'.tr()),
          bottom: TabBar(
            controller: _tabController,
            tabs: navTabsList,
          ),
        ),
        body: TabBarView(
          children: tabsList,
        ),
        floatingActionButton: _isAddPostVisible
            ? FloatingActionButton(
                heroTag: 'add_post',
                onPressed: _addPost,
                child: const Icon(Icons.add),
              )
            : null,
      ),
    );
  }

  List<Tab> _buildNavForTabs() {
    return [
      Tab(text: 'posts'.tr()),
      Tab(text: 'info'.tr()),
    ];
  }

  List<Widget> _buildTabs() {
    return [
      const PostsList(),
      const InformationForm(),
    ];
  }

  void _addPost() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddPostForm(),
      ),
    );
  }

  void _onTabChange(int index) {
    setState(() {
      _isAddPostVisible = index == 0;
    });
  }
}
