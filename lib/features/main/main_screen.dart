import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterbloc/repository/authentication_repository.dart';
import 'package:flutterbloc/services/locator.dart';
import 'tabs/blog/bloc/blog_bloc.dart';
import 'tabs/blog/blog_screen.dart';
import 'tabs/explore/explore_screen.dart';
import 'tabs/profile/profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final authenticationRepository = locator<AuthenticationRepository>();

  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () async {
                await authenticationRepository.logout();
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: SafeArea(
        child: IndexedStack(
          index: index,
          children: [
            BlocProvider<BlogBloc>(
              create: (BuildContext context) => BlogBloc(),
              child: const BlogScreen(),
            ),
            const ExploreScreen(),
            const ProfileScreen(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) {
          setState(() {
            index = value;
          });
        },
        currentIndex: index,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home),
            label: 'Blog',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.sportscourt),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.bell),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
