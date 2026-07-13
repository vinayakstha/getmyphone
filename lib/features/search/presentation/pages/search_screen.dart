import 'package:client/app/routes/app_routes.dart';
import 'package:client/core/api/api_endpoints.dart';
import 'package:client/features/phone/domain/entities/phone_entity.dart';
import 'package:client/features/phone/presentation/pages/phone_details_screen.dart';
import 'package:client/features/phone/presentation/state/phone_state.dart';
import 'package:client/features/phone/presentation/view_model/phone_view_model.dart';
import 'package:client/features/phone/presentation/widgets/phone_card.dart';
import 'package:client/features/saved/presentation/view_model/saved_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchScreen extends ConsumerStatefulWidget {
  final String initialQuery;

  const SearchScreen({super.key, this.initialQuery = ''});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    // Pre-fill the search field with the initial query from home screen
    _searchQuery = widget.initialQuery;
    _searchController.text = widget.initialQuery;
    Future.microtask(() {
      ref.read(phoneViewModelProvider.notifier).getAllPhones();
      ref.read(savedViewModelProvider.notifier).getSavedByUser();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<PhoneEntity> _filterPhones(List<PhoneEntity> phones) {
    if (_searchQuery.trim().isEmpty) return phones;
    final query = _searchQuery.trim().toLowerCase();
    return phones
        .where((phone) => phone.title.toLowerCase().contains(query))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final phoneState = ref.watch(phoneViewModelProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        title: SizedBox(
          height: 40,
          child: TextField(
            controller: _searchController,
            autofocus: _searchQuery.isEmpty,
            onChanged: (value) => setState(() => _searchQuery = value),
            decoration: InputDecoration(
              hintText: 'Search for models...',
              hintStyle: TextStyle(color: Colors.grey.shade400),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey.shade100,
              contentPadding: const EdgeInsets.symmetric(horizontal: 14),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: Icon(Icons.clear, size: 20, color: Colors.grey.shade600),
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _searchQuery = '');
                      },
                    )
                  : null,
            ),
          ),
        ),
      ),
      body: SafeArea(child: _buildBody(phoneState)),
    );
  }

  Widget _buildBody(PhoneState phoneState) {
    if (phoneState.status == PhoneStatus.loading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF0464D4)),
      );
    }

    if (phoneState.status == PhoneStatus.error) {
      return Center(
        child: Text(
          phoneState.errorMessage ?? 'Failed to load listings',
          style: const TextStyle(color: Colors.red),
        ),
      );
    }

    final filteredPhones = _filterPhones(phoneState.phones);

    // No phones loaded (empty dataset)
    if (phoneState.phones.isEmpty && phoneState.status == PhoneStatus.loaded) {
      return const Center(
        child: Text(
          'No phone listings found',
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      );
    }

    // User searched but no results matched
    if (_searchQuery.isNotEmpty && filteredPhones.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.search_off, size: 72, color: Colors.grey.shade300),
              const SizedBox(height: 16),
              Text(
                'No results for "$_searchQuery"',
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Try a different search term',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
              ),
            ],
          ),
        ),
      );
    }

    // Show results count + grid
    final savedState = ref.watch(savedViewModelProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_searchQuery.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Text(
              '${filteredPhones.length} result${filteredPhones.length == 1 ? '' : 's'} for "$_searchQuery"',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: GridView.builder(
              itemCount: filteredPhones.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.7,
              ),
              itemBuilder: (context, index) {
                final phone = filteredPhones[index];
                return PhoneCard(
                  image: phone.photo != null
                      ? ApiEndpoints.imageBaseUrl + phone.photo!
                      : '',
                  condition: phone.condition,
                  title: phone.title,
                  specs: '${phone.ram} RAM • ${phone.storage}',
                  price: 'NPR ${phone.price.toStringAsFixed(0)}',
                  isBookmarked: savedState.savedPhoneIds.contains(phone.phoneId),
                  onTap: () {
                    AppRoutes.push(
                      context,
                      PhoneDetailsScreen(phoneId: phone.phoneId ?? ''),
                    );
                  },
                  onBookmark: () async {
                    await ref
                        .read(savedViewModelProvider.notifier)
                        .toggleSave(phone.phoneId ?? '');
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
