// import 'package:flutter/material.dart';
// import 'dart:math';
// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }


// class _HomePageState extends State<HomePage> {
//   int _currentPage = 0;
//   int _currentCategoryPage = 0;
//   late final List<String> _carouselTexts;
//   late final PageController _carouselController;
//   late final PageController _categoryPageController;

//   final List<Map<String, dynamic>> _categories = [
//     {'icon': Icons.pets, 'label': 'Dogs'},
//     {'icon': Icons.pets, 'label': 'Cats'},
//     {'icon': Icons.bug_report, 'label': 'Reptiles'},
//     {'icon': Icons.bubble_chart, 'label': 'Fish'},
//     {'icon': Icons.bug_report_outlined, 'label': 'Birds'},
//     {'icon': Icons.grass, 'label': 'Rodents'},
//     {'icon': Icons.emoji_nature, 'label': 'Farm'},
//     {'icon': Icons.emoji_emotions, 'label': 'Exotic'},
//     {'icon': Icons.bug_report_rounded, 'label': 'Insects'},
//     {'icon': Icons.emoji_food_beverage, 'label': 'Amphibians'},
//     {'icon': Icons.emoji_people, 'label': 'Horses'},
//     {'icon': Icons.emoji_transportation, 'label': 'Others'},
//   ];

//   double _responsiveFontSize(double base, double width) {
//     if (width < 350) return base * 0.75;
//     if (width < 500) return base * 0.88;
//     return base;
//   }

//   double _responsiveIconSize(double width) {
//     if (width < 350) return 18.0;
//     if (width < 500) return 24.0;
//     if (width < 700) return 28.0;
//     return 34.0;
//   }

//   double _responsiveAvatarSize(double width) {
//     if (width < 350) return 32.0;
//     if (width < 500) return 40.0;
//     if (width < 700) return 48.0;
//     return 56.0;
//   }

//   @override
//   void initState() {
//     super.initState();
//     _carouselTexts = [
//       "Adotar é salvar uma vida – talvez até a sua.!",
//       "Amor não se compra, se adota",
//       "O melhor amigo que você pode ter está te esperando num abrigo.",
//     ];
//     _carouselController = PageController();
//     _categoryPageController = PageController();
//     _startAutoSwitch();
//   }

//   void _startAutoSwitch() {
//     Future.doWhile(() async {
//       await Future.delayed(const Duration(seconds: 3));
//       if (!mounted) return false;
//       int nextPage = (_currentPage + 1) % _carouselTexts.length;
//       _carouselController.animateToPage(
//         nextPage,
//         duration: const Duration(milliseconds: 400),
//         curve: Curves.easeInOut,
//       );
//       return mounted;
//     });
//   }

//   Widget _buildCarouselPage(String text, double width, double height) {
//     return Container(
//       margin: EdgeInsets.symmetric(horizontal: width * 0.04, vertical: height * 0.015),
//       decoration: BoxDecoration(
//         color: Colors.teal.shade50,
//         borderRadius: BorderRadius.circular(18),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.teal.shade100.withOpacity(0.3),
//             blurRadius: 8,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Center(
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: width * 0.06, vertical: height * 0.03),
//           child: Text(
//             text,
//             style: TextStyle(
//               fontSize: _responsiveFontSize(20, width),
//               fontWeight: FontWeight.w600,
//               color: Colors.teal,
//             ),
//             textAlign: TextAlign.center,
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _carouselController.dispose();
//     _categoryPageController.dispose();
//     super.dispose();
//   }

//   List<List<Map<String, dynamic>>> _getCategoryPages(int itemsPerPage) {
//     List<List<Map<String, dynamic>>> pages = [];
//     for (int i = 0; i < _categories.length; i += itemsPerPage) {
//       pages.add(_categories.sublist(
//         i,
//         (i + itemsPerPage) > _categories.length ? _categories.length : (i + itemsPerPage),
//       ));
//     }
//     return pages;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     final width = size.width;
//     final height = size.height;

//     // Responsive sizes
//     final appBarHeight = height * 0.11;
//     final carouselHeight = height * 0.20;
//     final categoryHeight = height * 0.13;
//     final iconSize = _responsiveIconSize(width);
//     final avatarSize = _responsiveAvatarSize(width);
//     final cardPadding = width * 0.04;

//     // Category carousel logic
//     final int itemsPerPage = 3;
//     final categoryPages = _getCategoryPages(itemsPerPage);

//     return Scaffold(
//       appBar: PreferredSize(
//       preferredSize: Size.fromHeight(appBarHeight),
//       child: Container(
//         decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [Colors.teal.shade800, Colors.teal.shade400],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         boxShadow: [
//           BoxShadow(
//           color: Colors.black.withOpacity(0.15),
//           blurRadius: 12,
//           offset: const Offset(0, 4),
//           ),
//         ],
//         borderRadius: const BorderRadius.vertical(
//           bottom: Radius.circular(28),
//         ),
//         ),
//         child: SafeArea(
//         child: Padding(
//           padding: EdgeInsets.symmetric(
//           horizontal: width * 0.05,
//           vertical: height * 0.018,
//           ),
//           child: Row(
//           children: [
//             CircleAvatar(
//             backgroundColor: Colors.white,
//             radius: avatarSize / 2,
//             child: Icon(Icons.pets, color: Colors.teal.shade700, size: iconSize),
//             ),
//             SizedBox(width: width * 0.03),
//             Text(
//             'Coração Animal',
//             style: TextStyle(
//               color: Colors.white,
//               fontWeight: FontWeight.bold,
//               fontSize: _responsiveFontSize(width < 500 ? 22 : 28, width),
//               letterSpacing: 1.2,
//             ),
//             ),
//             const Spacer(),
//             IconButton(
//             icon: Icon(Icons.search, color: Colors.white, size: iconSize),
//             onPressed: () {},
//             tooltip: 'Search',
//             ),
//             SizedBox(width: width * 0.01),
//           ],
//           ),
//         ),
//         ),
//       ),
//       ),
//       backgroundColor: Colors.grey[100],
//       body: LayoutBuilder(
//       builder: (context, constraints) {
//         return SingleChildScrollView(
//         child: Column(
//           children: [
//           SizedBox(height: height * 0.025),
//           SizedBox(
//             height: carouselHeight,
//             child: Stack(
//             alignment: Alignment.bottomCenter,
//             children: [
//               PageView.builder(
//               controller: _carouselController,
//               itemCount: _carouselTexts.length,
//               onPageChanged: (index) {
//                 setState(() {
//                 _currentPage = index;
//                 });
//               },
//               itemBuilder: (context, index) =>
//                 _buildCarouselPage(_carouselTexts[index], width, height),
//               ),
//               Positioned(
//               bottom: 15,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: List.generate(
//                 _carouselTexts.length,
//                 (index) => AnimatedContainer(
//                   duration: const Duration(milliseconds: 300),
//                   margin: const EdgeInsets.symmetric(horizontal: 4),
//                   width: _currentPage == index ? 18 : 8,
//                   height: 8,
//                   decoration: BoxDecoration(
//                   color: _currentPage == index ? Colors.teal : Colors.teal.shade200,
//                   borderRadius: BorderRadius.circular(4),
//                   ),
//                 ),
//                 ),
//               ),
//               ),
//             ],
//             ),
//           ),
//           SizedBox(height: height * 0.025),
//           ],
//         ),
//         );
//       },
//       ),
//     );
//   }
// }