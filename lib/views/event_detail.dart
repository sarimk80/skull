import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skool_app/bloc/bloc/events_bloc.dart';
import 'package:skool_app/bloc/event_cubit/event_cubit_cubit.dart';
import 'package:skool_app/models/events/event_model.dart';

class EventDetail extends StatefulWidget {
  final String id;
  const EventDetail({super.key, required this.id});

  @override
  State<EventDetail> createState() => _EventDetailState();
}

class _EventDetailState extends State<EventDetail> {
  late EventsBloc eventbloc;

  @override
  void initState() {
    eventbloc = RepositoryProvider.of<EventsBloc>(context);
    eventbloc.add(FetchEventsDetail(id: widget.id));
    super.initState();
  }

  void _refreshEvent() {
    eventbloc.add(FetchEventsDetail(id: widget.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<EventsBloc, EventsState>(
        builder: (context, state) {
          if (state.eventsStatus == EventsStatus.detailLoading) {
            return _buildLoadingState();
          }
          if (state.eventsStatus == EventsStatus.detailLoaded) {
            return _buildEventDetail(
              state.eventModel ??
                  EventsModel(
                    createdAt: '',
                    name: '',
                    avatar: '',
                    description: '',
                    id: '',
                  ),
            );
          }
          if (state.eventsStatus == EventsStatus.detailError) {
            return _buildErrorState(state.errorMessage ?? '');
          }

          return _buildInitialState();
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CupertinoActivityIndicator(radius: 16),
            SizedBox(height: 16),
            Text(
              'Loading Event Details...',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventDetail(EventsModel state) {
    final event = state;

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 300,
          stretch: true,
          flexibleSpace: _buildEventHeader(event),
          pinned: true,
          backgroundColor: Theme.of(context).colorScheme.surface,
          foregroundColor: Theme.of(context).colorScheme.onSurface,
          leading: IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_back_rounded, color: Colors.white),
            ),
            onPressed: () => Navigator.pop(context),
          ),
          // actions: [
          //   IconButton(
          //     icon: Container(
          //       padding: const EdgeInsets.all(8),
          //       decoration: BoxDecoration(
          //         color: Colors.black.withOpacity(0.5),
          //         shape: BoxShape.circle,
          //       ),
          //       child: const Icon(Icons.share_rounded, color: Colors.white),
          //     ),
          //     onPressed: () => _shareEvent(event),
          //   ),
          // ],
        ),

        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Event Title
                Text(
                  event.name ?? 'Untitled Event',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                  ),
                ),

                const SizedBox(height: 16),

                // Event Date and Time
                _buildEventDateTime(event),

                const SizedBox(height: 24),

                // Event Description
                if (event.description?.isNotEmpty == true) ...[
                  _buildDescriptionSection(event),
                  const SizedBox(height: 24),
                ],

                // Additional Event Details
               // _buildEventDetails(event),

                const SizedBox(height: 32),

                // Action Buttons
                //_buildActionButtons(event),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEventHeader(EventsModel event) {
    return FlexibleSpaceBar(
      background: event.avatar?.isNotEmpty == true
          ? Image.network(
              event.avatar!,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  color: Colors.grey[200],
                  child: const Center(child: CupertinoActivityIndicator()),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  child: const Icon(
                    Icons.event_rounded,
                    size: 80,
                    color: Colors.grey,
                  ),
                );
              },
            )
          : Container(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              child: const Icon(
                Icons.event_rounded,
                size: 80,
                color: Colors.grey,
              ),
            ),
      title: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          event.name ?? 'Event',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildEventDateTime(EventsModel event) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.calendar_today_rounded,
            color: Theme.of(context).colorScheme.primary,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _formatEventDate(event.createdAt),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _formatEventTime(event.createdAt),
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionSection(EventsModel event) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'About this Event',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Text(
          event.description!,
          style: TextStyle(
            fontSize: 16,
            height: 1.6,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildEventDetails(EventsModel event) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Event Details',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          _buildDetailRow(
            Icons.location_on_rounded,
            'Location',
            'Main Auditorium', // You might want to add location to your model
          ),
          const SizedBox(height: 8),
          _buildDetailRow(
            Icons.group_rounded,
            'Capacity',
            '200 Participants', // You might want to add capacity to your model
          ),
          const SizedBox(height: 8),
          _buildDetailRow(
            Icons.category_rounded,
            'Category',
            'Workshop', // You might want to add category to your model
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String title, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(EventsModel event) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              // Add to calendar functionality
              _addToCalendar(event);
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.primary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.calendar_month_outlined),
                SizedBox(width: 8),
                Text('Add to Calendar'),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: FilledButton(
            onPressed: () {
              // Register for event functionality
              _registerForEvent(event);
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.event_available_rounded),
                SizedBox(width: 8),
                Text('Register Now'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState(String errorMessage) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Event Details'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
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
                'Event Not Found',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                errorMessage,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _refreshEvent,
                child: const Text('Try Again'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInitialState() {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CupertinoActivityIndicator(),
            SizedBox(height: 16),
            Text('Loading event details...'),
          ],
        ),
      ),
    );
  }

  String _formatEventDate(String? dateString) {
    if (dateString == null) return 'Date not specified';

    try {
      final date = DateTime.parse(dateString);
      return '${_getWeekday(date)}, ${date.day} ${_getMonth(date)} ${date.year}';
    } catch (e) {
      return 'Invalid Date';
    }
  }

  String _formatEventTime(String? dateString) {
    if (dateString == null) return 'Time not specified';

    try {
      final date = DateTime.parse(dateString);
      return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return 'Invalid Time';
    }
  }

  String _getWeekday(DateTime date) {
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return weekdays[date.weekday - 1];
  }

  String _getMonth(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[date.month - 1];
  }

  void _shareEvent(EventsModel event) {
    // Implement share functionality
  }

  void _addToCalendar(EventsModel event) {
    // Implement add to calendar functionality
  }

  void _registerForEvent(EventsModel event) {
    // Implement event registration functionality
  }
}
