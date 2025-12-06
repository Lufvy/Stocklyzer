import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stocklyzer/component/loading.dart';
import 'package:stocklyzer/config/appTheme.dart';
import 'package:stocklyzer/config/extension.dart';
import 'package:stocklyzer/controller/searchController.dart';
import 'package:stocklyzer/controller/themeController.dart';
import 'package:stocklyzer/view/stockDetail.dart';

class Search extends StatelessWidget {
  Search({super.key});
  final themeController = Get.find<Themecontroller>();
  final searchController = Get.put(Searchcontroller());

  final TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: themeController.isDarkMode.value
                    ? Apptheme.darkGradient
                    : Apptheme.lightGradient,
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 15,
                    children: [
                      Text(
                        'Search',
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextField(
                        controller: textController,
                        onChanged: (value) {
                          searchController.searchQuery.value = value;
                        },
                        decoration: InputDecoration(
                          hintText: 'Search for stocks, indices, etc.',
                          hintStyle: GoogleFonts.poppins(
                            color: Colors.white.withValues(alpha: 0.6),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: themeController.isDarkMode.value
                                ? BorderSide.none
                                : BorderSide(color: Colors.black),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: themeController.isDarkMode.value
                                ? BorderSide.none
                                : BorderSide(color: Colors.black),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: themeController.isDarkMode.value
                                ? BorderSide.none
                                : BorderSide(color: Colors.black),
                          ),
                          filled: true,
                          fillColor: Theme.of(
                            context,
                          ).colorScheme.secondaryContainer,
                          prefixIcon: Icon(Icons.search),
                          suffixIcon: IconButton(
                            onPressed: () {
                              textController.clear();
                              searchController.searchQuery.value = '';
                              searchController.searchQuery.value = '';
                            },
                            icon: Icon(Icons.close),
                          ),
                        ),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Obx(() {
                          return Row(
                            children: List.generate(
                              searchController.uniqueSectors.length,
                              (index) {
                                final isSelected =
                                    searchController.selectedIndex.value ==
                                    index;
                                return Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: GestureDetector(
                                    onTap: () {
                                      searchController.selectedIndex.value =
                                          index;
                                    },
                                    child: AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 200,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? Color(0XFF01ABC4)
                                            : Color(
                                                0XFF01ABC4,
                                              ).withValues(alpha: 0.45),
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: isSelected
                                            ? [
                                                BoxShadow(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary
                                                      .withValues(alpha: 0.4),
                                                  blurRadius: 6,
                                                  offset: const Offset(0, 3),
                                                ),
                                              ]
                                            : [],
                                      ),
                                      child: Text(
                                        searchController.uniqueSectors[index],
                                        style: GoogleFonts.poppins(
                                          fontWeight: CustomFontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        }),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: searchController.filteredStocks.length,
                          itemBuilder: (context, index) {
                            final stock =
                                searchController.filteredStocks[index];

                            return Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Get.to(
                                      () => StockDetail(
                                        selectedTicker: stock.ticker,
                                      ),
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.secondaryContainer,
                                      borderRadius: BorderRadius.circular(8),
                                      border: themeController.isDarkMode.value
                                          ? null
                                          : Border.all(
                                              width: 2,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSecondaryContainer,
                                            ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Row(
                                        spacing: 10,
                                        children: [
                                          Image.asset(
                                            'assets/tickers/${stock.ticker}.png',
                                            width: 32,
                                            height: 32,
                                          ),
                                          Text(
                                            stock.ticker,
                                            style: GoogleFonts.poppins(
                                              fontSize: 13,
                                              fontWeight: CustomFontWeight.bold,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            stock.name,
                                            style: GoogleFonts.poppins(
                                              fontSize: 10,
                                              fontWeight:
                                                  CustomFontWeight.regular,
                                              color:
                                                  themeController
                                                      .isDarkMode
                                                      .value
                                                  ? Color(
                                                      0XFFFFFFFF,
                                                    ).withValues(alpha: 0.8)
                                                  : Color(
                                                      0XFF000000,
                                                    ).withValues(alpha: 0.8),
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 14),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            if (searchController.isLoading.value) OverlayLoading(),
          ],
        ),
      ),
    );
  }
}
