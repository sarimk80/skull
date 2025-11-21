import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:skool_app/bloc/bloc/events_bloc.dart';
import 'package:skool_app/bloc/event_cubit/event_cubit_cubit.dart';
import 'package:skool_app/helpers/routes.dart';
import 'package:skool_app/models/events/event_model.dart';

class EventHome extends StatefulWidget {
  const EventHome({super.key});

  @override
  State<EventHome> createState() => _EventHomeState();
}

class _EventHomeState extends State<EventHome> {
  late EventsBloc eventbloc;
  final _scrollController = ScrollController();
  int _currentPage = 1;
  final int _limit = 15;

  @override
  void initState() {
    eventbloc = RepositoryProvider.of<EventsBloc>(context);
    _loadInitialEvents();
    _scrollController.addListener(_onScroll);
    super.initState();
  }

  void _loadInitialEvents() {
    _currentPage = 1;
    eventbloc.add(FetchEvents(page: _currentPage, limit: _limit));
  }

  void _onScroll() {
    if (_isBottom) {
      _loadMoreEvents();
    }
  }

  void _loadMoreEvents() {
    if (!eventbloc.state.hasReachedMax) {
      _currentPage++;
      eventbloc.add(FetchEvents(page: _currentPage, limit: _limit));
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  void _refreshEvents() {
    //eventbloc.add(FetchEvents(page: 1, limit: 15));
  }

  void _logout() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Drag Handle
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 24),

                // Warning Icon
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.logout_rounded,
                    size: 32,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(height: 20),

                // Title
                Text(
                  'Log Out?',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 12),

                // Description
                Text(
                  'Are you sure you want to log out? You\'ll need to sign in again to access your account.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.7),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 32),

                // Action Buttons
                Row(
                  children: [
                    // Cancel Button
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Theme.of(
                            context,
                          ).colorScheme.onSurface,
                          backgroundColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          side: BorderSide(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Logout Button
                    Expanded(
                      child: FilledButton(
                        onPressed: () {
                          final userBox = Hive.box('skool');
                          userBox.delete('userId');
                          Navigator.pop(context); // Close bottom sheet
                          Navigator.pushReplacementNamed(context, '/root_view');
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.logout_rounded, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Log Out',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Events',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.onBackground,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, '/add_event');
            },
            tooltip: 'Add new event',
          ),
          IconButton(
            icon: const Icon(Icons.logout_outlined),
            onPressed: _logout,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: BlocBuilder<EventsBloc, EventsState>(
          builder: (context, state) {
            if (state.eventsStatus == EventsStatus.loading ||
                state.eventsStatus == EventsStatus.initial) {
              return _buildLoadingState();
            }
            if (state.eventsStatus == EventsStatus.success ||
                state.eventsStatus == EventsStatus.detailLoaded ||
                state.eventsStatus == EventsStatus.addLoaded ||
                state.eventsStatus == EventsStatus.deleteLoaded) {
              if (state.eventModelsList!.isEmpty) {
                return _buildEmptyState();
              }
              return _buildEventList(state);
            }

            if (state.eventsStatus == EventsStatus.failure) {
              return _buildErrorState(state.errorMessage ?? '');
            }

            return _buildInitialState();
          },
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CupertinoActivityIndicator(radius: 16),
          SizedBox(height: 16),
          Text(
            'Loading Events...',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildEventList(EventsState state) {
    final events = state.eventModelsList ?? [];
    final isLoadingMore =
        state.eventsStatus == EventsStatus.loading && events.isNotEmpty;
    final hasReachedMax = state.hasReachedMax;
    return RefreshIndicator(
      onRefresh: () async {
        _refreshEvents();
      },
      child: ListView.separated(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount:
            events.length + (isLoadingMore ? 1 : 0) + (hasReachedMax ? 1 : 0),
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          if (index >= events.length) {
            if (isLoadingMore) {
              return _buildLoadingMoreIndicator();
            } else if (hasReachedMax) {
              return _buildEndOfListIndicator();
            }
          }

          final event = events[index];
          return _buildEventCard(event);
        },
      ),
    );
  }

  Widget _buildLoadingMoreIndicator() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }

  Widget _buildEndOfListIndicator() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: Text(
          'No more events to load',
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildEventCard(EventsModel event) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event Header with Name and Date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    event.name ?? 'Untitled Event',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 12),
                _buildEventDate(event.createdAt),
              ],
            ),

            const SizedBox(height: 12),

            // Event Description
            if (event.description?.isNotEmpty == true) ...[
              Text(
                event.description!,
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.7),
                  height: 1.4,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
            ],

            // Event Avatar/Image
            if (event.avatar?.isNotEmpty == true) ...[
              Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: NetworkImage(event.avatar!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],

            // Event Actions
            _buildEventActions(event),
          ],
        ),
      ),
    );
  }

  Widget _buildEventDate(String? createdAt) {
    if (createdAt == null || createdAt.isEmpty) {
      return Container();
    }

    // Simple date formatting - you might want to use intl package for better formatting
    final date = formatDate(createdAt);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        date,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildEventActions(EventsModel model) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, '/detail', arguments: model.id);
            },
            icon: const Icon(Icons.info_outline_rounded, size: 16),
            label: const Text('Details'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        // const SizedBox(width: 8),
        // Expanded(
        //   child: FilledButton.icon(
        //     onPressed: () {
        //       // Handle event registration
        //     },
        //     icon: const Icon(Icons.event_available_rounded, size: 16),
        //     label: const Text('Register'),
        //     style: FilledButton.styleFrom(
        //       backgroundColor: Theme.of(context).colorScheme.primary,
        //       foregroundColor: Theme.of(context).colorScheme.onPrimary,
        //       shape: RoundedRectangleBorder(
        //         borderRadius: BorderRadius.circular(8),
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_available_rounded,
            size: 80,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'No Events Available',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Check back later for upcoming events',
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
            ),
          ),
          const SizedBox(height: 24),
          FilledButton(onPressed: _refreshEvents, child: const Text('Refresh')),
        ],
      ),
    );
  }

  Widget _buildErrorState(String errorMessage) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: 80,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            'Unable to Load Events',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.error,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _refreshEvents,
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildInitialState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_rounded,
            size: 80,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Text(
            'Welcome to Events',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Pull down to refresh or wait for events to load',
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }
}
