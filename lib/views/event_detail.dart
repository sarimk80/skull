import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skool_app/bloc/bloc/events_bloc.dart';
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

  void _deleteEvent(EventsModel event) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Event'),
        content: const Text('Are you sure you want to delete this event? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              eventbloc.add(DeleteEvent(id: event.id ?? ''));
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _shareEvent(EventsModel event) {
    // Implement share functionality
    final shareText = 'Check out this event: ${event.name}\n\n${event.description}';
    // You can use share_plus package for actual sharing
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EventsBloc, EventsState>(
      listener: (context, state) {
        if (state.eventsStatus == EventsStatus.deleteLoaded) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Event deleted successfully'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );
          Navigator.pop(context);
        }
        
        if (state.eventsStatus == EventsStatus.deleteError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'Failed to delete event'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );
        }
      },
      child: Scaffold(
        body: BlocBuilder<EventsBloc, EventsState>(
          builder: (context, state) {
            if (state.eventsStatus == EventsStatus.detailLoading) {
              return _buildLoadingState();
            }
            
            if (state.eventsStatus == EventsStatus.detailLoaded) {
              return _buildEventDetail(state.eventModel!);
            }
            
            if (state.eventsStatus == EventsStatus.detailError) {
              return _buildErrorState(state.errorMessage ?? '');
            }

            return _buildInitialState();
          },
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: const Center(
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

  Widget _buildEventDetail(EventsModel event) {
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
          actions: [
            // IconButton(
            //   icon: Container(
            //     padding: const EdgeInsets.all(8),
            //     decoration: BoxDecoration(
            //       color: Colors.black.withOpacity(0.5),
            //       shape: BoxShape.circle,
            //     ),
            //     child: const Icon(Icons.share_rounded, color: Colors.white),
            //   ),
            //   onPressed: () => _shareEvent(event),
            // ),
          ],
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
                //_buildEventDetails(event),
                const SizedBox(height: 32),

                // Action Buttons
                _buildActionButtons(event),

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
                  child: const Center(
                    child: CupertinoActivityIndicator(),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  child: Icon(
                    Icons.event_rounded,
                    size: 80,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                );
              },
            )
          : Container(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              child: Icon(
                Icons.event_rounded,
                size: 80,
                color: Theme.of(context).colorScheme.primary,
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
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
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
          const SizedBox(width: 16),
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
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionSection(EventsModel event) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'About this Event',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            event.description!,
            style: TextStyle(
              fontSize: 16,
              height: 1.6,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
            ),
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
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          _buildDetailRow(
            Icons.location_on_rounded,
            'Location',
            'Main Auditorium',
          ),
          const SizedBox(height: 12),
          _buildDetailRow(
            Icons.group_rounded,
            'Capacity',
            '200 Participants',
          ),
          const SizedBox(height: 12),
          _buildDetailRow(
            Icons.category_rounded,
            'Category',
            'Workshop',
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String title, String value) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              const SizedBox(height: 2),
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
    return BlocBuilder<EventsBloc, EventsState>(
      builder: (context, state) {
        final isDeleting = state.eventsStatus == EventsStatus.deleteLoading;
        
        return Row(
          children: [
            // Edit Button
            // Expanded(
            //   child: OutlinedButton(
            //     onPressed: () {
            //       // Navigate to edit screen
            //     },
            //     style: OutlinedButton.styleFrom(
            //       foregroundColor: Theme.of(context).colorScheme.primary,
            //       padding: const EdgeInsets.symmetric(vertical: 16),
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(12),
            //       ),
            //       side: BorderSide(
            //         color: Theme.of(context).colorScheme.primary,
            //       ),
            //     ),
            //     child: const Row(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: [
            //         Icon(Icons.edit_rounded, size: 20),
            //         SizedBox(width: 8),
            //         Text('Edit Event'),
            //       ],
            //     ),
            //   ),
            // ),
            const SizedBox(width: 12),
            
            // Delete Button
            Expanded(
              child: FilledButton(
                onPressed: isDeleting ? null : () => _deleteEvent(event),
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: isDeleting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.delete_forever, size: 20),
                          SizedBox(width: 8),
                          Text('Delete'),
                        ],
                      ),
              ),
            ),
          ],
        );
      },
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  errorMessage,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  ),
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
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: const Center(
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

  String _formatEventDate(int? timeStamp) {
    if (timeStamp == null) return 'Date not specified';

    try {
      final date = DateTime.fromMicrosecondsSinceEpoch(timeStamp);
      return '${_getWeekday(date)}, ${date.day} ${_getMonth(date)} ${date.year}';
    } catch (e) {
      return 'Invalid Date';
    }
  }

  String _formatEventTime(int? timeStamp) {
    if (timeStamp == null) return 'Time not specified';

    try {
      final date = DateTime.fromMicrosecondsSinceEpoch(timeStamp);
      return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return 'Invalid Time';
    }
  }

  String _getWeekday(DateTime date) {
    const weekdays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return weekdays[date.weekday - 1];
  }

  String _getMonth(DateTime date) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[date.month - 1];
  }
}