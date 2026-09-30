import 'package:eventary_prototype/admin/event/view/event_screen.dart';
import 'package:eventary_prototype/admin/maintenance/view/maintenance_screen.dart';
import 'package:eventary_prototype/screens/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:maplibre_gl/maplibre_gl.dart' show LatLng;

import '../data/dummy_properties.dart';
import '../models/property.dart';
import '../theme/app_theme.dart';
import '../widgets/coordinate_picker_dialog.dart';
import '../widgets/property_card.dart';
import '../widgets/property_detail.dart';
import '../widgets/property_map.dart';
import '../widgets/sidebar.dart';
import 'admin_dashboard_screen.dart';

const double _narrowBreakpoint = 900;
const double _stackedDetailBreakpoint = 1150;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // ============================================================
  // PROPERTY DATA
  // ============================================================

  final List<Property> _properties =
      List<Property>.from(dummyProperties);

  Property? _popupProperty;
  Property? _detailProperty;

  String _query = '';
  String? _typeFilter;

  // ============================================================
  // SIDEBAR MENU
  //
  // 0 = Dashboard
  // 1 = Eventaris
  // 2 = Peta Properti
  // 3 = Maintenance
  // 4 = Events
  // 5 = Settings
  // ============================================================

  int _selectedMenu = 0;

  final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>();

  // ============================================================
  // PROPERTY FILTER
  // ============================================================

  List<Property> get _filteredProperties {
    return _properties.where((property) {
      final matchesQuery =
          _query.isEmpty ||
          property.name
              .toLowerCase()
              .contains(_query.toLowerCase()) ||
          property.location
              .toLowerCase()
              .contains(_query.toLowerCase());

      final matchesType =
          _typeFilter == null ||
          property.type == _typeFilter;

      return matchesQuery && matchesType;
    }).toList();
  }

  // ============================================================
  // PROPERTY MAP
  // ============================================================

  void _onMarkerTap(Property property) {
    setState(() {
      _popupProperty = property;
    });
  }

  void _onViewDetails(Property property) {
    setState(() {
      _detailProperty = property;
      _popupProperty = null;
    });
  }

  // ============================================================
  // PROPERTY CRUD
  // ============================================================

  void _addProperty(Property property) {
    setState(() {
      _properties.add(property);
    });
  }

  void _updateProperty(Property updated) {
    setState(() {
      final index = _properties.indexWhere(
        (property) => property.id == updated.id,
      );

      if (index != -1) {
        _properties[index] = updated;
      }

      if (_popupProperty?.id == updated.id) {
        _popupProperty = updated;
      }

      if (_detailProperty?.id == updated.id) {
        _detailProperty = updated;
      }
    });
  }

  void _deleteProperty(String id) {
    setState(() {
      _properties.removeWhere(
        (property) => property.id == id,
      );

      if (_popupProperty?.id == id) {
        _popupProperty = null;
      }

      if (_detailProperty?.id == id) {
        _detailProperty = null;
      }
    });
  }

  // ============================================================
  // EDIT PROPERTY LOCATION
  // ============================================================

  Future<void> _editPropertyLocation(
    Property property,
  ) async {
    final picked = await pickCoordinateOnMap(
      context,
      LatLng(
        property.latitude,
        property.longitude,
      ),
    );

    if (picked != null) {
      _updateProperty(
        property.copyWith(
          latitude: picked.latitude,
          longitude: picked.longitude,
        ),
      );
    }
  }

  // ============================================================
  // VIEW PROPERTY ON MAP
  // ============================================================

  void _viewPropertyOnMap(Property property) {
    setState(() {
      _selectedMenu = 2;
      _popupProperty = property;
      _detailProperty = null;
    });
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isNarrow =
            constraints.maxWidth < _narrowBreakpoint;

        final bool stackDetail =
            constraints.maxWidth <
                _stackedDetailBreakpoint;

        void selectMenu(int index) {
          setState(() {
            _selectedMenu = index;
          });
        }

        return Scaffold(
          key: _scaffoldKey,

          backgroundColor:
              AppColors.surface,

          // ======================================================
          // MOBILE / NARROW SIDEBAR
          // ======================================================

          drawer: isNarrow
              ? Drawer(
                  child: Sidebar(
                    selectedIndex: _selectedMenu,
                    onSelect: selectMenu,
                    onClose: () {
                      Navigator.of(context).pop();
                    },
                  ),
                )
              : null,

          // ======================================================
          // BODY
          // ======================================================

          body: SafeArea(
            child: Row(
              children: [
                // ==================================================
                // DESKTOP SIDEBAR
                // ==================================================

                if (!isNarrow)
                  Sidebar(
                    selectedIndex: _selectedMenu,
                    onSelect: selectMenu,
                  ),

                // ==================================================
                // MAIN CONTENT
                // ==================================================

                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.all(20),
                    child: _buildMainContent(
                      isNarrow,
                      stackDetail,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // MAIN CONTENT
  // ============================================================

  Widget _buildMainContent(
    bool isNarrow,
    bool stackDetail,
  ) {
    switch (_selectedMenu) {
      // ==========================================================
      // 0. DASHBOARD
      // ==========================================================

      case 0:
        return DashboardScreen(
          properties: _properties,
        );

      // ==========================================================
      // 1. EVENTARIS
      // ==========================================================

      case 1:
        return AdminDashboardScreen(
          properties: _properties,
          onAdd: _addProperty,
          onUpdate: _updateProperty,
          onDelete: _deleteProperty,
          onViewOnMap: _viewPropertyOnMap,
        );

      // ==========================================================
      // 2. PETA PROPERTI
      // ==========================================================

      case 2:
        return Column(
          crossAxisAlignment:
              CrossAxisAlignment.stretch,
          children: [
            _buildTopBar(isNarrow),

            const SizedBox(height: 16),

            Expanded(
              child: stackDetail
                  ? _buildStackedLayout()
                  : _buildSideBySideLayout(),
            ),
          ],
        );

      // ==========================================================
      // 3. MAINTENANCE
      // ==========================================================

      case 3:
        return MaintenanceScreen(
          properties: _properties,
        );

      // ==========================================================
      // 4. EVENTS
      //
      // INI YANG DITAMBAHKAN
      // ==========================================================

      case 4:
        return const EventScreen();

      // ==========================================================
      // 5. SETTINGS
      // ==========================================================

      case 5:
        return const Center(
          child: Text(
            'Settings belum tersedia di prototype.',
            style: TextStyle(
              color: AppColors.textSecondary,
            ),
          ),
        );

      // ==========================================================
      // DEFAULT
      // ==========================================================

      default:
        return const Center(
          child: Text(
            'Menu belum tersedia di prototype.',
            style: TextStyle(
              color: AppColors.textSecondary,
            ),
          ),
        );
    }
  }

  // ============================================================
  // MAP LAYOUT - DESKTOP
  // ============================================================

  Widget _buildSideBySideLayout() {
    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: _buildMapWithPopup(),
        ),

        if (_detailProperty != null)
          const SizedBox(width: 20),

        if (_detailProperty != null)
          SizedBox(
            width: 380,
            height: double.infinity,
            child: SingleChildScrollView(
              child: PropertyDetail(
                property: _detailProperty!,
                horizontal: false,
                onClose: () {
                  setState(() {
                    _detailProperty = null;
                  });
                },
              ),
            ),
          ),
      ],
    );
  }

  // ============================================================
  // MAP LAYOUT - MOBILE / TABLET
  // ============================================================

  Widget _buildStackedLayout() {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.stretch,
      children: [
        Expanded(
          flex: 3,
          child: _buildMapWithPopup(),
        ),

        if (_detailProperty != null)
          const SizedBox(height: 20),

        if (_detailProperty != null)
          SizedBox(
            height: 260,
            child: SingleChildScrollView(
              child: PropertyDetail(
                property: _detailProperty!,
                horizontal: true,
                onClose: () {
                  setState(() {
                    _detailProperty = null;
                  });
                },
              ),
            ),
          ),
      ],
    );
  }

  // ============================================================
  // MAP + PROPERTY POPUP
  // ============================================================

  Widget _buildMapWithPopup() {
    return Stack(
      children: [
        Positioned.fill(
          child: PropertyMap(
            properties: _filteredProperties,
            selectedProperty:
                _popupProperty ??
                    _detailProperty,
            onMarkerTap: _onMarkerTap,
          ),
        ),

        if (_popupProperty != null)
          Positioned(
            left: 24,
            top: 24,
            child: PropertyCard(
              property: _popupProperty!,
              onViewDetails: () {
                _onViewDetails(
                  _popupProperty!,
                );
              },
              onClose: () {
                setState(() {
                  _popupProperty = null;
                });
              },
              onEditLocation: () {
                _editPropertyLocation(
                  _popupProperty!,
                );
              },
            ),
          ),
      ],
    );
  }

  // ============================================================
  // PROPERTY MAP TOP BAR
  // ============================================================

  Widget _buildTopBar(bool isNarrow) {
    final types = _properties
        .map((property) => property.type)
        .toSet()
        .toList();

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // ====================================================
            // MOBILE MENU
            // ====================================================

            if (isNarrow)
              IconButton(
                onPressed: () {
                  _scaffoldKey.currentState
                      ?.openDrawer();
                },
                icon: const Icon(
                  Icons.menu,
                  color:
                      AppColors.textPrimary,
                ),
              ),

            // ====================================================
            // SEARCH
            // ====================================================

            Expanded(
              child: Container(
                height: 46,
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 14,
                ),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius:
                      BorderRadius.circular(
                    AppRadius.md,
                  ),
                  border: Border.all(
                    color: AppColors.border,
                  ),
                  boxShadow:
                      AppShadows.subtle,
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.search,
                      size: 19,
                      color:
                          AppColors.textSecondary,
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            _query = value;
                          });
                        },
                        decoration:
                            const InputDecoration(
                          border:
                              InputBorder.none,
                          hintText:
                              'Search properties or venues...',
                          hintStyle:
                              TextStyle(
                            color: AppColors
                                .textSecondary,
                            fontSize: 13.5,
                          ),
                          isDense: true,
                        ),
                        style:
                            const TextStyle(
                          fontSize: 13.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(width: 12),

            _buildIconAction(
              Icons.tune_rounded,
            ),

            const SizedBox(width: 8),

            _buildIconAction(
              Icons.notifications_none_rounded,
            ),
          ],
        ),

        const SizedBox(height: 12),

        // ========================================================
        // PROPERTY TYPE FILTER
        // ========================================================

        SizedBox(
          height: 34,
          child: ListView(
            scrollDirection:
                Axis.horizontal,
            children: [
              _FilterChip(
                label: 'All Types',
                selected:
                    _typeFilter == null,
                onTap: () {
                  setState(() {
                    _typeFilter = null;
                  });
                },
              ),

              for (final type in types)
                Padding(
                  padding:
                      const EdgeInsets.only(
                    left: 8,
                  ),
                  child: _FilterChip(
                    label: type,
                    selected:
                        _typeFilter == type,
                    onTap: () {
                      setState(() {
                        _typeFilter = type;
                      });
                    },
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  // ============================================================
  // TOP BAR ICON
  // ============================================================

  Widget _buildIconAction(
    IconData icon,
  ) {
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius:
            BorderRadius.circular(
          AppRadius.md,
        ),
        border: Border.all(
          color: AppColors.border,
        ),
        boxShadow:
            AppShadows.subtle,
      ),
      child: Icon(
        icon,
        size: 19,
        color:
            AppColors.textSecondary,
      ),
    );
  }
}

// ================================================================
// FILTER CHIP
// ================================================================

class _FilterChip
    extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius:
          BorderRadius.circular(20),
      child: AnimatedContainer(
        duration:
            const Duration(
          milliseconds: 150,
        ),
        padding:
            const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 7,
        ),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.accent
              : AppColors.card,
          borderRadius:
              BorderRadius.circular(20),
          border: Border.all(
            color: selected
                ? AppColors.accent
                : AppColors.border,
          ),
        ),
        alignment:
            Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12.5,
            fontWeight:
                FontWeight.w600,
            color: selected
                ? Colors.white
                : AppColors
                    .textSecondary,
          ),
        ),
      ),
    );
  }
}