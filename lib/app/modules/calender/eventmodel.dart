// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'dart:collection';
import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart'as http;

import 'package:table_calendar/table_calendar.dart';

/// Example event class.
class Event extends Equatable {
  String id;
  String proId;
  String date;
  String time;
  String eventName;
  String eventReq;
  String event_add;
  String event_contact;
  String prod_name;

  Event(
      {this.id,
        this.proId,
        this.date,
        this.time,
        this.eventName,
        this.eventReq,this.event_add,this.event_contact,this.prod_name});

  Event.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    proId = json['pro_id'] ?? '';
    date = json['date'] ?? '';
    time = json['time'] ?? '';
    eventName = json['event_name'] ?? '';
    eventReq = json['event_req'] ?? '';
    event_add = json['event_add'] ?? '';
    event_contact =json['event_contact'] ?? '';
    prod_name =json['prod_name'] ?? '';

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['pro_id'] = this.proId;
    data['date'] = this.date;
    data['time'] = this.time;
    data['event_name'] = this.eventName;
    data['event_req'] = this.eventReq;
    return data;
  }

  @override
  // TODO: implement props
  List<Object> get props => [   id,
   proId,
   date,
   time,
   eventName,
   eventReq];

}
Future<List<Event>> _getEventsForDayOffline(DateTime day) async {
  // Implementation example
  http.Response response = await   http.get(Uri.parse('http://artiz.consciser.in/mrzulfapi/show_calender.php?pro_id=1'));
  print('responseEvent =${jsonDecode(response.body)} ');

  List responseList =  jsonDecode(response.body);
  List<Event> listOfEvents =responseList.map((e) => Event.fromJson(e)).toList();

  return listOfEvents;
  // return kEvents[day] ?? [];
}
/// Example events.
///
/// Using a [LinkedHashMap] is highly recommended if you decide to use a map.
// final kEvents = LinkedHashMap<DateTime, List<Event>>(
//   equals: isSameDay,
//   hashCode: getHashCode,
// )..addAll(_kEventSource);
//
// final _kEventSource = Map.fromIterable(List.generate(50, (index) => index),
//     key: (item) => DateTime.utc(kFirstDay.year, kFirstDay.month, item * 5),
//     value: (item) => List.generate(
//         item % 4 + 1, (index) => Event('Event $item | ${index + 1}')))
//   ..addAll({
//     kToday: [
//       Event('Today\'s Event 1'),
//       Event('Today\'s Event 2'),
//     ],
//   });


getEventsatDate(date){

}

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

/// Returns a list of [DateTime] objects from [first] to [last], inclusive.
List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
        (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}

final kToday = DateTime.now();
final kFirstDay = DateTime(1980, 01, 01);
final kLastDay = DateTime(2080, 01, 01);