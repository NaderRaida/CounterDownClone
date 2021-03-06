library flutter_timer_countdown;

import 'dart:async';
import 'package:flutter/widgets.dart';

enum CountDownTimerFormat {
  daysHoursMinutesSeconds,
  daysHoursMinutes,
  daysHours,
  daysOnly,
  hoursMinutesSeconds,
  hoursMinutes,
  hoursOnly,
  minutesSeconds,
  minutesOnly,
  secondsOnly,
}

class TimerCountdown extends StatefulWidget {
  /// Choose between different `CountDownTimerFormat`s
  final CountDownTimerFormat format;

  /// Defines the time when the timer is over.
  final DateTime endTime;

  /// Function to call when the timer is over.
  final VoidCallback? onEnd;

  /// Toggle time units descriptions.
  final bool enableDescriptions;

  /// `TextStyle` for the time numbers.
  final TextStyle? timeTextStyle;

  /// `TextStyle` for the colons betwenn the time numbers.
  final TextStyle? colonsTextStyle;

  /// `TextStyle`
  final TextStyle? descriptionTextStyle;

  /// Days unit description.
  final String daysDescription;

  /// Hours unit description.
  final String hoursDescription;

  /// Minutes unit description.
  final String minutesDescription;

  /// Seconds unit description.
  final String secondsDescription;

  /// Defines the width between the colons and the units.
  final double spacerWidth;

  final Function? callBack;

  final Function? reverseTheCounter;

  String upOrDown;

  DateTime? startTime;

  TimerCountdown({
    required this.upOrDown,
    required this.endTime,
    this.startTime,
    this.format = CountDownTimerFormat.daysHoursMinutesSeconds,
    this.enableDescriptions = true,
    this.onEnd,
    this.timeTextStyle,
    this.colonsTextStyle,
    this.descriptionTextStyle,
    this.daysDescription = "Days",
    this.hoursDescription = "Hours",
    this.minutesDescription = "Minutes",
    this.secondsDescription = "Seconds",
    this.spacerWidth = 10,
    required this.callBack,
    required this.reverseTheCounter,
  });

  @override
  _TimerCountdownState createState() => _TimerCountdownState();
}

class _TimerCountdownState extends State<TimerCountdown> {
  late Timer timer;
  late String countdownDays;
  late String countdownHours;
  late String countdownMinutes;
  late String countdownSeconds;
  late Duration difference;
  bool minus = true;
  late String upOrDown;

  @override
  void initState() {
    upOrDown = widget.upOrDown;
    _startTimer();
    super.initState();
  }

  @override
  void dispose() {
    if(timer != null){
      timer.cancel();
    }
    super.dispose();
  }

  /// Calculate the time difference between now end the given [endTime] and initialize all UI timer values.
  ///
  /// Then create a periodic `Timer` which updates all fields every second depending on the time difference which is getting smaller.
  /// When this difference reached `Duration.zero` the `Timer` is stopped and the [onEnd] callback is invoked.
  void _startTimer() {
    // print("here enter here enter here 0");
    if(/*widget.*/upOrDown == "down"){
      // print("here enter here enter here 1");
      if (widget.endTime.isBefore(DateTime.now())) {
        difference = Duration.zero;
      } else {
        difference = widget.endTime.difference(DateTime.now());
      }
      countdownDays = _durationToStringDays(difference);
      countdownHours = _durationToStringHours(difference);
      countdownMinutes = _durationToStringMinutes(difference);
      countdownSeconds = _durationToStringSeconds(difference);
      if (widget.callBack != null) {
        widget.callBack!(countdownDays,countdownHours,countdownMinutes,countdownSeconds,/*widget.*/upOrDown);
      }
      if (difference == Duration.zero) {
        // print("here enter here enter here 2");
        setState(() {
          widget.reverseTheCounter!("up");
          /*widget.*/upOrDown = "up";
          widget.startTime = DateTime(DateTime.now().year).add(Duration(
            days: int.parse(countdownDays),
            hours: int.parse(countdownHours),
            minutes: int.parse(countdownMinutes),
            seconds: int.parse(countdownSeconds),
          ));
        });
        /*if (widget.onEnd != null) {
          widget.onEnd!();
        }*/
      } else {
        // print("here enter here enter here 3");
        timer = Timer.periodic(Duration(seconds: 1), (timer) {
          difference = widget.endTime.difference(DateTime.now());
          setState(() {
            countdownDays = _durationToStringDays(difference);
            countdownHours = _durationToStringHours(difference);
            countdownMinutes = _durationToStringMinutes(difference);
            countdownSeconds = _durationToStringSeconds(difference);
            if (widget.callBack != null) {
              widget.callBack!(countdownDays, countdownHours, countdownMinutes,countdownSeconds,upOrDown);
            }
          });
          if (difference <= Duration.zero) {
            // print("here enter here enter here 4");
            this.timer.cancel();
            setState(() {
              // print("day=>>// $countdownDays}");
              // countdownDays = _twoDigits((int.parse(countdownDays) -1), "days");
              // print("day=>>1// $countdownDays}");
              widget.reverseTheCounter!("up");
              upOrDown = "up";
              countdownDays = "00";
              countdownHours = "00";
              countdownMinutes = "00";
              countdownSeconds = "00";
              minus = false;
              widget.startTime = DateTime(DateTime.now().year).add(Duration(
                days: 0,
                hours: 0,
                minutes: 0,
                seconds: 0,
              ));
            });
            setState(() {
              upUp();
            });
            /*if (widget.onEnd != null) {
              widget.onEnd!();
            }*/
          }
        });
      }
    }else{
      // print("here enter here enter here 5");
      /*countdownDays = widget.startTime!.day.toString();
      countdownHours = widget.startTime!.hour.toString();
      countdownMinutes = widget.startTime!.minute.toString();
      countdownSeconds = widget.startTime!.second.toString();*/

      countdownDays = _twoDigits(widget.startTime!.day,"days");
      countdownHours = _twoDigits(widget.startTime!.hour,"hours");
      countdownMinutes = _twoDigits(widget.startTime!.minute,"minutes");
      countdownSeconds = _twoDigits(widget.startTime!.second,"seconds");


      timer = Timer.periodic(Duration(seconds: 1), (timer) {
        int day = int.parse(countdownDays);
        int hour = int.parse(countdownHours);
        int minute = int.parse(countdownMinutes);
        int second = int.parse(countdownSeconds);
        setState(() {
          countdownSeconds = _twoDigits(second++ == 60 ? 0 : second++,"seconds");
          countdownMinutes = _twoDigits((/*int.parse(countdownSeconds)*/second++ == 60 )?
          (minute++ == 60 ? 0 : minute++) : minute,"minutes");
          countdownHours = _twoDigits((/*int.parse(countdownMinutes)*/minute++ == 60
              && /*int.parse(countdownSeconds)*/second++ == 60 )? (hour++ == 60 ? 0 : hour++) : hour,"hours");
          countdownDays = _twoDigits((/*int.parse(countdownHours)*/hour++ == 24
              && /*int.parse(countdownMinutes)*/minute++ == 60
              && /*int.parse(countdownSeconds)*/second++ == 60 )? day++ : day,"days");
          if (widget.callBack != null) {
            widget.callBack!(countdownDays, countdownHours, countdownMinutes,countdownSeconds,upOrDown);
          }
        });
      });
    }
  }

  void upUp(){
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      int day = int.parse(countdownDays);
      int hour = int.parse(countdownHours);
      int minute = int.parse(countdownMinutes);
      int second = int.parse(countdownSeconds);
      setState(() {
        countdownSeconds = _twoDigits(second++ == 60 ? 0 : second++,"seconds");
        countdownMinutes = _twoDigits((/*int.parse(countdownSeconds)*/second++ == 60 )?
        (minute++ == 60 ? 0 : minute++) : minute,"minutes");
        countdownHours = _twoDigits((/*int.parse(countdownMinutes)*/minute++ == 60
            && /*int.parse(countdownSeconds)*/second++ == 60 )? (hour++ == 60 ? 0 : hour++) : hour,"hours");
        countdownDays = _twoDigits((/*int.parse(countdownHours)*/hour++ == 24
            && /*int.parse(countdownMinutes)*/minute++ == 60
            && /*int.parse(countdownSeconds)*/second++ == 60 )? day++ : day,"days");
        if (widget.callBack != null) {
          widget.callBack!(countdownDays, countdownHours, countdownMinutes,countdownSeconds,upOrDown);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return _countDownTimerFormat();
  }

  /// Builds the UI colons between the time units.
  Widget _colon() {
    return Row(
      children: [
        SizedBox(
          width: widget.spacerWidth,
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              ":",
              style: widget.colonsTextStyle,
            ),
            if (widget.enableDescriptions)
              SizedBox(
                height: 5,
              ),
            if (widget.enableDescriptions)
              Text(
                "",
                style: widget.descriptionTextStyle,
              ),
          ],
        ),
        SizedBox(
          width: widget.spacerWidth,
        ),
      ],
    );
  }

  /// Builds the timer days with its description.
  Widget _days(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          (upOrDown == "down") ? countdownDays
              : minus ? (int.parse(countdownDays) - 1).toString()
              : (countdownDays.length == 1 ?
          _twoDigits(int.parse(countdownDays), "days") : countdownDays),
          style: widget.timeTextStyle,
        ),
        if (widget.enableDescriptions)
          SizedBox(
            height: 5,
          ),
        if (widget.enableDescriptions)
          Text(
            widget.daysDescription,
            style: widget.descriptionTextStyle,
          ),
      ],
    );
  }

  /// Builds the timer hours with its description.
  Widget _hours(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          countdownHours,
          style: widget.timeTextStyle,
        ),
        if (widget.enableDescriptions)
          SizedBox(
            height: 5,
          ),
        if (widget.enableDescriptions)
          Text(
            widget.hoursDescription,
            style: widget.descriptionTextStyle,
          ),
      ],
    );
  }

  /// Builds the timer minutes with its description.
  Widget _minutes(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          countdownMinutes,
          style: widget.timeTextStyle,
        ),
        if (widget.enableDescriptions)
          SizedBox(
            height: 5,
          ),
        if (widget.enableDescriptions)
          Text(
            widget.minutesDescription,
            style: widget.descriptionTextStyle,
          ),
      ],
    );
  }

  /// Builds the timer seconds with its description.
  Widget _seconds(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          countdownSeconds,
          style: widget.timeTextStyle,
        ),
        if (widget.enableDescriptions)
          SizedBox(
            height: 5,
          ),
        if (widget.enableDescriptions)
          Text(
            widget.secondsDescription,
            style: widget.descriptionTextStyle,
          ),
      ],
    );
  }

  /// When the selected [CountDownTimerFormat] is leaving out the last unit, this function puts the UI value of the unit before up by one.
  ///
  /// This is done to show the currently running time unit.
  String _twoDigits(int n, String unitType) {
    switch (unitType) {
      case "minutes":
        if(upOrDown == "down"){
          if (widget.format == CountDownTimerFormat.daysHoursMinutes ||
              widget.format == CountDownTimerFormat.hoursMinutes ||
              widget.format == CountDownTimerFormat.minutesOnly) {
            if (difference > Duration.zero) {
              n++;
            }
          }
        }

        if (n >= 10) return "$n";
        return "0$n";
      case "hours":
        if(upOrDown == "down"){
          if (widget.format == CountDownTimerFormat.daysHours ||
              widget.format == CountDownTimerFormat.hoursOnly) {
            if (difference > Duration.zero) {
              n++;
            }
          }
        }
        if (n >= 10) return "$n";
        return "0$n";
      case "days":
        if(upOrDown == "down"){
          if (widget.format == CountDownTimerFormat.daysOnly) {
            if (difference > Duration.zero) {
              n++;
            }
          }
        }
        // print("days==>> ${n.toString()}");
        if (n >= 10) return "$n";
        return "0$n";
      default:
        if (n >= 10) return "$n";
        return "0$n";
    }
  }

  /// Convert [Duration] in days to String for UI.
  String _durationToStringDays(Duration duration) {
    return _twoDigits(duration.inDays, "days").toString();
  }

  /// Convert [Duration] in hours to String for UI.
  String _durationToStringHours(Duration duration) {
    if (widget.format == CountDownTimerFormat.hoursMinutesSeconds ||
        widget.format == CountDownTimerFormat.hoursMinutes ||
        widget.format == CountDownTimerFormat.hoursOnly) {
      return _twoDigits(duration.inHours, "hours");
    } else
      return _twoDigits(duration.inHours.remainder(24), "hours").toString();
  }

  /// Convert [Duration] in minutes to String for UI.
  String _durationToStringMinutes(Duration duration) {
    if (widget.format == CountDownTimerFormat.minutesSeconds ||
        widget.format == CountDownTimerFormat.minutesOnly) {
      return _twoDigits(duration.inMinutes, "minutes");
    } else
      return _twoDigits(duration.inMinutes.remainder(60), "minutes");
  }

  /// Convert [Duration] in seconds to String for UI.
  String _durationToStringSeconds(Duration duration) {
    if (widget.format == CountDownTimerFormat.secondsOnly) {
      return _twoDigits(duration.inSeconds, "seconds");
    } else
      return _twoDigits(duration.inSeconds.remainder(60), "seconds");
  }

  /// Switches the UI to be displayed based on [CountDownTimerFormat].
  Widget _countDownTimerFormat() {
    switch (widget.format) {
      case CountDownTimerFormat.daysHoursMinutesSeconds:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _days(context),
            _colon(),
            _hours(context),
            _colon(),
            _minutes(context),
            _colon(),
            _seconds(context),
          ],
        );
      case CountDownTimerFormat.daysHoursMinutes:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if(upOrDown == "up")
              Row(
                children: [
                  Text(
                    "-",
                    style: widget.timeTextStyle,
                  ),
                  SizedBox(
                    width: 4,
                  ),
                ],
              ),
            _days(context),
            _colon(),
            _hours(context),
            _colon(),
            _minutes(context),
          ],
        );
      case CountDownTimerFormat.daysHours:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _days(context),
            _colon(),
            _hours(context),
          ],
        );
      case CountDownTimerFormat.daysOnly:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _days(context),
          ],
        );
      case CountDownTimerFormat.hoursMinutesSeconds:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _hours(context),
            _colon(),
            _minutes(context),
            _colon(),
            _seconds(context),
          ],
        );
      case CountDownTimerFormat.hoursMinutes:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _hours(context),
            _colon(),
            _minutes(context),
          ],
        );
      case CountDownTimerFormat.hoursOnly:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _hours(context),
          ],
        );
      case CountDownTimerFormat.minutesSeconds:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _minutes(context),
            _colon(),
            _seconds(context),
          ],
        );

      case CountDownTimerFormat.minutesOnly:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _minutes(context),
          ],
        );
      case CountDownTimerFormat.secondsOnly:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _seconds(context),
          ],
        );
      default:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _days(context),
            _colon(),
            _hours(context),
            _colon(),
            _minutes(context),
            _colon(),
            _seconds(context),
          ],
        );
    }
  }
}
