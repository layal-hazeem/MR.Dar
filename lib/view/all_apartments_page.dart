import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/apartment_controller.dart';
import '../widgets/apartment_card.dart';
import 'apartment_details_page.dart';
import 'filter_page.dart';

class AllApartmentsPage extends StatelessWidget {
  AllApartmentsPage({super.key});

  final ApartmentController controller = Get.find();
  final args = Get.arguments;
  late final bool fromHome = args?['fromHome'] ?? false;


  void _openFilterPage() async {
    final result = await Get.to(() => FilterPage());
    if (result != null) {
      controller.applyFilter(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        title: Text(
          "All Apartments".tr,
          style: TextStyle(color: Theme.of(context).colorScheme.primary),
        ),
      ),
      body: Column(
        children: [
          // ---------------- Search & Filter ----------------
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: TextField(
                      autofocus: fromHome,
                      decoration: InputDecoration(
                        hintText: "Search".tr,
                        prefixIcon: Icon(
                          Icons.search_rounded,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                        filled: true,
                        fillColor: Colors.transparent,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 14,
                        ),
                      ),
                         onChanged: (value) {
                          controller.searchApartments(value);
                          },
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: _openFilterPage,
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).colorScheme.primary,
                          Theme.of(
                            context,
                          ).colorScheme.primary.withValues(alpha: 0.85),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withValues(alpha: 0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.tune_rounded,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ---------------- Apartments List ----------------
          Expanded(
            child: Obx(() {
              final apartments = controller.displayApartments;

              if (controller.isLoading.value && apartments.isEmpty) {
                return Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                );
              }

              if (apartments.isEmpty) {
                return Center(
                  child: Text(
                    "No apartments found".tr,
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                );
              }

              return NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  if (!controller.isLoadingMore.value &&
                      controller.hasMore.value &&
                      scrollInfo.metrics.pixels ==
                          scrollInfo.metrics.maxScrollExtent) {
                    controller.loadMore();
                  }
                  return false;
                },
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  itemCount: apartments.length + 1,
                  itemBuilder: (context, index) {
                    if (index < apartments.length) {
                      final apt = apartments[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: ApartmentCard(
                          apartment: apt,
                          onTap: () {
                            Get.to(() => ApartmentDetailsPage(apartment: apt));
                          },
                        ),
                      );
                    } else {
                      return Obx(
                        () => controller.isLoadingMore.value
                            ? Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                                ),
                              )
                            : const SizedBox(),
                      );
                    }
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
