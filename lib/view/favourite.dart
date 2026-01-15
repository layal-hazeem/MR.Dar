import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/apartment_controller.dart';
import '../model/apartment_model.dart';
import '../widgets/apartment_card.dart';
import 'apartment_details_page.dart';

class Favourite extends StatefulWidget {
  const Favourite({super.key});

  @override
  State<Favourite> createState() => _FavouriteState();
}

class _FavouriteState extends State<Favourite> {
  final ApartmentController controller = Get.find();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadFavorites();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {}
    });
  }

  Future<void> _loadFavorites() async {
    try {
      await controller.loadFavorites();
    } catch (e) {
      debugPrint("Error loading favorites: $e");
    }
  }

  void _onApartmentTapped(Apartment apartment) {
    Get.to(() => ApartmentDetailsPage(apartment: apartment));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Obx(() {
        if (controller.isLoading.value &&
            controller.favoriteApartments.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.favoriteApartments.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.favorite_border,
                  size: 80,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.3),
                ),
                const SizedBox(height: 16),
                Text(
                  "No favorites yet".tr,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Tap the heart icon on apartments to add them here".tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: _loadFavorites,
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            itemCount: controller.favoriteApartments.length,
            itemBuilder: (context, index) {
              final apartment = controller.favoriteApartments[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                child: ApartmentCard(
                  apartment: apartment,
                  onTap: () => _onApartmentTapped(apartment),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
