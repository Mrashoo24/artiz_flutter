// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;
import '../../models/user_model.dart';
import '../../services/auth_service.dart';
import '../global_widgets/custom_bottom_nav_bar.dart';
import 'eventmodel.dart';

class TableEventsExample extends StatefulWidget {
  @override
  _TableEventsExampleState createState() => _TableEventsExampleState();
}

class _TableEventsExampleState extends State<TableEventsExample> {
  List<Event> _selectedEvents;
  TextEditingController _eventController = TextEditingController();
  TextEditingController _customerName = TextEditingController();
  TextEditingController _customerNumber = TextEditingController();
  TextEditingController _customerAddress = TextEditingController();
  TextEditingController prod = TextEditingController();

  Map<DateTime, List<Event>> _groupedEvents = {};
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay;
  DateTime _rangeStart;
  DateTime _rangeEnd;
  String initialValue = 'Select Date';
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _selectedDay = _focusedDay;
    _getEventsForDay(DateTime.now());
    // _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay));
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<List<Event>> _getEventsForDay(DateTime day) async {
    // Implementation example
    User user = Get.find<AuthService>().user.value;

    http.Response response = await http.get(Uri.parse(
        'http://artiz.consciser.in/mrzulfapi/show_calender.php?pro_id=${user.id}'));
    print('responseEvent =${jsonDecode(response.body)} ');

    List responseList = jsonDecode(response.body);
    List<Event> listOfEvents =
        await responseList.map((e) => Event.fromJson(e)).toList();

    _getConvertedEvent(listOfEvents);

    return listOfEvents.where((element) {
      print("datefromapi ${DateFormat('yyyy/MM/dd').parse(element.date)}");
      print('dateselected${DateFormat('yyyy/MM/dd').format(day)}');

      return DateFormat('yyyy/MM/dd').format(day) == element.date;
    }).toList();
    // return kEvents[day] ?? [];
  }

  _getConvertedEvent(List<Event> events) {
    events.forEach((element) {
      DateTime date1 = DateFormat('yyyy/MM/dd').parse(element.date);
      DateTime date = DateTime.utc(date1.year, date1.month, date1.day);

      print('eventConverted = ${date}');

      if (_groupedEvents[date] == null) _groupedEvents[date] = [];
      if (!_groupedEvents[date].contains(element)) {
        _groupedEvents[date].add(element);
      }

      print('eventConvertedElement = ${_groupedEvents}');
    });
  }

  List<Event> _getEventsForRange(DateTime start, DateTime end) {
    // Implementation example
    final days = daysInRange(start, end);

    return [
      // for (final d in days) ..._getEventsForDay(d),
    ];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      // _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  void _onRangeSelected(DateTime start, DateTime end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    // `start` or `end` could be null
    if (start != null && end != null) {
      _selectedEvents = _getEventsForRange(start, end);
    } else if (start != null) {
      // _selectedEvents.value = _getEventsForDay(start);
    } else if (end != null) {
      // _selectedEvents.value = _getEventsForDay(end);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showDialog(
          context: context,
          builder: (context) => StatefulBuilder(builder: (context, setDialog) {
            return AlertDialog(
              title: Text("Add Event"),
              content: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      buildTextFormField(_eventController, 'Event Name'),
                      InkWell(
                        onTap: () async {
                          var time = await showTimePicker(
                            context: context,
                            initialTime: const TimeOfDay(hour: 10, minute: 47),
                            builder: (BuildContext context, Widget child) {
                              return MediaQuery(
                                data: MediaQuery.of(context)
                                    .copyWith(alwaysUse24HourFormat: true),
                                child: child,
                              );
                            },
                          );
                          setDialog(() {
                            initialValue = time.format(context);
                          });
                          setState(() {
                            initialValue = time.format(context);
                          });


                        },
                        child: TextFormField(
                          // initialValue: initialValue,
                          enabled: false,
                          decoration: InputDecoration(hintText: initialValue,hintStyle: TextStyle(color: Colors.white),label:Text(initialValue)),


                        ),
                      ),
                      buildTextFormField(_customerName, 'Event Customer Name'),
                      buildTextFormField(_customerNumber, 'Customer Number'),
                      buildTextFormField(_customerAddress, 'Customer Address'),
                      buildTextFormField(prod, 'Product Name'),

                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  child: Text("Cancel"),
                  onPressed: () => Navigator.pop(context),
                ),
                TextButton(
                  child: Text("Ok"),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      User user = Get.find<AuthService>().user.value;
                      await http.get(Uri.parse(
                          'http://artiz.consciser.in/mrzulfapi/add_calender.php?pro_id=${user.id}&event_req=${_customerName.text}&event_name=${_eventController.text}&time=${initialValue}&date=${DateFormat('yyyy/MM/dd').format(_selectedDay)}&event_add=${_customerAddress.text}&event_contact=${_customerNumber.text}&prod_name=${prod.text}'));

                      Navigator.pop(context);
                      _eventController.clear();
                      setState(() {});
                    } else {
                    }


                  },
                ),
              ],
            );
          }),
        ),
        label: Text("Add Event"),
        icon: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text('TableCalendar - Events'),
      ),
      body: FutureBuilder<List<Event>>(
        future: _getEventsForDay(_selectedDay),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }

          _selectedEvents = snapshot.requireData ?? [];
          print('selectedDay = ${_selectedDay} ${snapshot.requireData}');

          return Column(children: [
            TableCalendar<Event>(
              firstDay: kFirstDay,
              lastDay: kLastDay,
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              rangeStartDay: _rangeStart,
              rangeEndDay: _rangeEnd,
              calendarFormat: _calendarFormat,
              rangeSelectionMode: _rangeSelectionMode,
              eventLoader: (date) {
                return _groupedEvents[date];
              },
              startingDayOfWeek: StartingDayOfWeek.monday,
              calendarStyle: CalendarStyle(
                // Use `CalendarStyle` to customize the UI
                outsideDaysVisible: false,
              ),
              onDaySelected: _onDaySelected,
              onRangeSelected: _onRangeSelected,
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                }
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
            ),
            const SizedBox(height: 8.0),
            Expanded(
                child: ListView.builder(
              itemCount: _selectedEvents.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: Key(_selectedEvents[index].id),
                  confirmDismiss: (direction) async {

               return   await  Get.defaultDialog(
                      title: 'ARE YOU SURE YOU WANT TO DELETE THIS EVENT ?',
                      middleText: '',
                      onConfirm: () async {
                        http.Response response = await http.get(Uri.parse(
                            'http://artiz.consciser.in/mrzulfapi/delete_calender.php?id=${_selectedEvents[index].id}'));
                        setState(() {
                          _selectedEvents.removeAt(index);
                        });
                        // Get.snackbar('Event Deleted', 'Succesfully');
                        Get.back();
                        return true;
                      },
                      onCancel: (){
                        Get.back();
                        return false;
                      },
                      textConfirm: 'Delete'
                    );



                  },

                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 4.0,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: ListTile(
                      onTap: () => print('${_selectedEvents[index]}'),
                      title: Text('${_selectedEvents[index].eventName}'),
                      subtitle:Text('Customer Name: ${_selectedEvents[index].eventReq}'),
                      trailing: InkWell(
                          onTap: () async {

                            setState(() {
                              _eventController = TextEditingController(text:_selectedEvents[index].eventName);
                                  _customerName=TextEditingController(text:_selectedEvents[index].eventReq);
                                  _customerNumber=TextEditingController(text:_selectedEvents[index].event_contact);
                                  _customerAddress=TextEditingController(text:_selectedEvents[index].event_add);
                                  prod =TextEditingController(text:_selectedEvents[index].prod_name);
                                  initialValue =_selectedEvents[index].time;
                            });

                            showDialog(
                              context: context,
                              builder: (context) => StatefulBuilder(builder: (context, setDialog) {
                                return AlertDialog(
                                  title: Text("Edit Event"),
                                  content: Form(
                                    key: _formKey,
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          buildTextFormField(_eventController, 'Event Name'),
                                          InkWell(
                                            onTap: () async {
                                              var time = await showTimePicker(
                                                context: context,
                                                initialTime: const TimeOfDay(hour: 10, minute: 47),
                                                builder: (BuildContext context, Widget child) {
                                                  return MediaQuery(
                                                    data: MediaQuery.of(context)
                                                        .copyWith(alwaysUse24HourFormat: true),
                                                    child: child,
                                                  );
                                                },
                                              );
                                              setDialog(() {
                                                initialValue = time.format(context);
                                              });
                                              setState(() {
                                                initialValue = time.format(context);
                                              });


                                            },
                                            child: TextFormField(
                                              // initialValue: initialValue,
                                              enabled: false,
                                              decoration: InputDecoration(hintText: initialValue,hintStyle: TextStyle(color: Colors.white),label:Text(initialValue)),


                                            ),
                                          ),
                                          buildTextFormField(_customerName, 'Event Customer Name'),
                                          buildTextFormField(_customerNumber, 'Customer Number'),
                                          buildTextFormField(_customerAddress, 'Customer Address'),
                                          buildTextFormField(prod, 'Product Name'),

                                        ],
                                      ),
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      child: Text("Cancel"),
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                    TextButton(
                                      child: Text("Ok"),
                                      onPressed: () async {
                                        if (_formKey.currentState.validate()) {
                                          User user = Get.find<AuthService>().user.value;
                                         var response =  await http.get(Uri.parse(
                                              'http://artiz.consciser.in/mrzulfapi/edit_calender.php?id=${_selectedEvents[index].id}&pro_id=${user.id}&event_req=${_customerName.text}&event_name=${_eventController.text}&time=${initialValue}&date=${DateFormat('yyyy/MM/dd').format(_selectedDay)}&event_add=${_customerAddress.text}&event_contact=${_customerNumber.text}&prod_name=${prod.text}'));

                                         print('resppnseEdit = ${response.body}');

                                          Navigator.pop(context);

                                          _eventController.clear();
                                          setState(() {});
                                        } else {
                                        }


                                      },
                                    ),
                                  ],
                                );
                              }),
                            );
                          },
                          child: Icon(Icons.edit)),
                    ),
                  ),
                );
              },
            )),
          ]);
        },
      ),
    );
  }

  TextFormField buildTextFormField(
      TextEditingController controller, String hint) {
    return TextFormField(
      controller: controller,
      validator: (value) => value.isEmpty ? 'Field is mandatory' : null ,
      decoration: InputDecoration(hintText: hint,label: Text(hint)),
    );
  }

  Future<TimeOfDay> showTimePicker({
    BuildContext context,
    TimeOfDay initialTime,
    TransitionBuilder builder,
    bool useRootNavigator = true,
    TimePickerEntryMode initialEntryMode = TimePickerEntryMode.dial,
    String cancelText,
    String confirmText,
    String helpText,
    String errorInvalidText,
    String hourLabelText,
    String minuteLabelText,
    RouteSettings routeSettings,
    EntryModeChangeCallback onEntryModeChanged,
    Offset anchorPoint,
  }) async {
    assert(context != null);
    assert(initialTime != null);
    assert(useRootNavigator != null);
    assert(initialEntryMode != null);
    assert(debugCheckHasMaterialLocalizations(context));

    final Widget dialog = TimePickerDialog(
      initialTime: initialTime,
      initialEntryMode: initialEntryMode,
      cancelText: cancelText,
      confirmText: confirmText,
      helpText: helpText,
      errorInvalidText: errorInvalidText,
      hourLabelText: hourLabelText,
      minuteLabelText: minuteLabelText,
      onEntryModeChanged: onEntryModeChanged,
    );
    return showDialog<TimeOfDay>(
      context: context,
      useRootNavigator: useRootNavigator,
      builder: (BuildContext context) {
        return builder == null ? dialog : builder(context, dialog);
      },
      routeSettings: routeSettings,
      anchorPoint: anchorPoint,
    );
  }
}
