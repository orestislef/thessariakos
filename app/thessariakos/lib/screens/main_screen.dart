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

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    List<Tab> navTabsList = _buildNavForTabs();
    List<Widget> tabsList = _buildTabs();

    return DefaultTabController(
      length: navTabsList.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text('app_name'.tr()),
          bottom: TabBar(
            tabs: navTabsList,
          ),
        ),
        body: TabBarView(
          children: tabsList,
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () => _addPost(
            context: context,
          ),
        ),
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

  void _addPost({required BuildContext context}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddPostForm(),
      ),
    );
  }
}
