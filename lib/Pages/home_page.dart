import 'package:come_along_with_me/Pages/configurationPage.dart';
import 'package:come_along_with_me/Pages/group_page.dart';
import 'package:come_along_with_me/Pages/profile_page.dart';
import 'package:come_along_with_me/Pages/users_page.dart';
import 'package:come_along_with_me/cubit/auth/cubit/auth_cubit.dart';
import 'package:come_along_with_me/cubit/user/cubit/user_cubit.dart';
import 'package:come_along_with_me/data/user_model.dart';
import 'package:come_along_with_me/domain/entities/user_entity.dart';
import 'package:come_along_with_me/widgets/TextFieldContainer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  final String uid;
  const HomePage({Key? key, required this.uid}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _searchController = TextEditingController();
  PageController _pageViewController = PageController(initialPage: 0);
  bool _isSearch = false;
  int _toolBarPageIndex = 0;

  List<String> _popuMenuList = [
    "Log out",
    'Q/A'
  ];

  List<Widget> get pages => [
        GroupPage(
          uid: '',
        ),
        UsersPage(
          users: [],
        ),
        ProfilePage(
          currentUser: UserModel(),
        ),
        ConfigurationPage(),
      ];

  @override
  void dispose() {
    _searchController.dispose();
    _pageViewController.dispose();
    super.dispose();
  }

  Widget _buildSearchWidget() {
    return Container(
      margin: EdgeInsets.only(top: 50),
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.3),
            blurRadius: 2,
            spreadRadius: 1,
            offset: Offset(0, 0.50),
          ),
        ],
      ),
      child: TextFieldContainerWidget(
        hintText: "Search",
        prefixIcon: Icons.arrow_back,
        keyboardType: TextInputType.text,
        controller: _searchController,
        borderRadius: 0.0,
        color: Colors.white,
        iconClickEvent: () {
          setState(() {
            _isSearch = !_isSearch;
          });
        },
      ),
    );
  }

  Widget _emptyContainer() {
    return Container(
      height: 0,
      width: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: _isSearch == true
            ? Colors.transparent
            : Color.fromRGBO(82, 131, 202, 1),
        title: _isSearch == true ? _emptyContainer() : Text("CAWM"),
        flexibleSpace:
            _isSearch == true ? _buildSearchWidget() : _emptyContainer(),
        actions: _isSearch == true
            ? []
            : [
                InkWell(
                  onTap: () {
                    setState(
                      () {
                        _isSearch = !_isSearch;
                      },
                    );
                  },
                  child: const Icon(Icons.search),
                ),
                PopupMenuButton(
                  onSelected: (value) {
                    if (value == "Log out") {
                      BlocProvider.of<AuthCubit>(context).loggedOut();
                    }
                    else if (value == 'Q/A'){
                    launch("https://littleblckii234.wixsite.com/come-along-with-me");
                    }
                  },
                  itemBuilder: (_) => _popuMenuList.map(
                    (menuItem) {
                      return PopupMenuItem(
                        child: Text("$menuItem"),
                        value: menuItem,
                      );
                    },
                  ).toList(),
                ),
              ],
      ),
      body: BlocBuilder<UserCubit, UserState>(
        builder: (context, userState) {
          if (userState is UserLoaded) {
            final currentUser = userState.users.firstWhere(
              (element) => element.uid == widget.uid,
              orElse: () => UserModel(),
            );
            final users = userState.users
                .where((element) => element.uid != widget.uid)
                .toList();

            return Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _pageViewController,
                    onPageChanged: (index) {
                      setState(() {
                        _toolBarPageIndex = index;
                      });
                    },
                    itemCount: pages.length,
                    itemBuilder: (context, index) {
                      return _switchPage(
                          users: users, currentUser: currentUser);
                    },
                  ),
                ),
              ],
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _toolBarPageIndex,
        onTap: (index) {
          setState(() {
            _toolBarPageIndex = index;
            _pageViewController.jumpToPage(index);
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Column(
              children: [
                Icon(Icons.group, color: Colors.blue),
                Text('Group', style: TextStyle(color: Colors.blue)),
              ],
            ),
            label: 'Groups',
          ),
          BottomNavigationBarItem(
            icon: Column(
              children: [
                Icon(Icons.account_circle, color: Colors.blue),
                Text('Profile', style: TextStyle(color: Colors.blue)),
              ],
            ),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Column(
              children: [
                Icon(Icons.person, color: Colors.blue),
                Text('User', style: TextStyle(color: Colors.blue)),
              ],
            ),
            label: 'User',
          ),
          BottomNavigationBarItem(
            icon: Column(
              children: [
                Icon(Icons.settings, color: Colors.blue),
                Text('Configuration', style: TextStyle(color: Colors.blue)),
              ],
            ),
            label: 'Configuration',
          ),
        ],
      ),
    );
  }

  Widget _switchPage({
    required List<UserEntity> users,
    required UserEntity currentUser,
  }) {
    switch (_toolBarPageIndex) {
      case 0:
        return GroupPage(
          uid: '',
        );
      case 1:
        return ProfilePage(
          currentUser: currentUser as UserModel,
        );
      case 2:
        return UsersPage(users: users);
      case 3:
        return ConfigurationPage();
      default:
        return Container();
    }
  }
}
