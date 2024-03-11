import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.SensorHistory;
import Toybox.Time.Gregorian;
import Toybox.ActivityMonitor;

class SpaceView extends WatchUi.WatchFace {
    private var hourFont;
    private var dataFont;
    private var dateFont;
    private var minuteFont;
    private var bodyBatteryIcon;

    function initialize() {
      WatchFace.initialize();
      hourFont = Application.loadResource(Rez.Fonts.HourFont);
      dataFont = Application.loadResource(Rez.Fonts.DataFont);
      dateFont = Application.loadResource(Rez.Fonts.DateFont);
      minuteFont = Application.loadResource(Rez.Fonts.MinuteFont);
      bodyBatteryIcon = Application.loadResource(Rez.Drawables.BodyBatteryIcon);
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
      setLayout(Rez.Layouts.WatchFace(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
      // Call the parent onUpdate function to redraw the layout
      View.onUpdate(dc);

      drawHours(dc);
      drawBodyBattery(dc);
      drawMinutes(dc);
      drawDate(dc);
      drawHeartRate(dc);
      drawSteps(dc);
    }

    function drawHours(dc) as Void {
      var padding = 5;
      var clockTime = System.getClockTime();
      var hours = clockTime.hour.format("%02d");
      var hourFontHeight = dc.getFontHeight(hourFont);

      dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);

      dc.drawText(
        (dc.getWidth() / 2) - padding,
        (dc.getHeight() / 2) - (hourFontHeight / 2 + padding),
        hourFont,
        hours,
        Graphics.TEXT_JUSTIFY_RIGHT | Graphics.TEXT_JUSTIFY_VCENTER
      );
    }

    function drawBodyBattery(dc) as Void {
      var bodyBatteryCount = retrieveBodyBatteryText();
      var hourFontHeight = dc.getFontHeight(hourFont);

      var margin = 10;
      var padding = 6;
      var paddingLeft = 5;
      var iconSize = 22;

      dc.drawBitmap(
        dc.getWidth() / 2 + paddingLeft,
        (dc.getHeight() / 2 - hourFontHeight),
        bodyBatteryIcon
      );

      dc.setColor(0xE8B9B0, Graphics.COLOR_TRANSPARENT);

      dc.drawText(
        dc.getWidth() / 2 + iconSize + padding + paddingLeft,
        (dc.getHeight() / 2 - hourFontHeight + margin),
        dateFont,
        bodyBatteryCount,
        Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER
      );
    }

    private function retrieveBodyBatteryText() as String {
      var iterator = Toybox.SensorHistory.getBodyBatteryHistory({:period => 1, :order => SensorHistory.ORDER_NEWEST_FIRST});
      var value = iterator.next();
      if (value != null && value.data != null) {
        return Lang.format("$1$$2$", [(value.data as Number).toNumber(), "%"]);
      } else {
        return "--";
      }
    }

    function drawMinutes(dc) as Void {
      var padding = 5;
      var clockTime = System.getClockTime();
      var minutes = clockTime.min.format("%02d");
      var minuteFontHeight = dc.getFontHeight(minuteFont);

      dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);

      dc.drawText(
        (dc.getWidth() / 2) - padding,
        (dc.getHeight() / 2) + (minuteFontHeight / 2 + padding),
        minuteFont,
        minutes,
        Graphics.TEXT_JUSTIFY_RIGHT | Graphics.TEXT_JUSTIFY_VCENTER
      );
    }

    function drawDate(dc) as Void {
      var weekdayArray = ["День", "Воскресенье", "Понедельник" , "Вторник" , "Среда" , "Четверг" , "Пятница" , "Суббота"] as Array<String>;
      var monthArray = ["Месяц", "Января" , "Февраля" , "Марта" , "Апреля" , "Мая" , "Июня" , "Июля" , "Августа" , "Сентября" , "Октября" , "Ноября" , "Декабря"] as Array<String>;

      var margin = 21;
      var paddingLeft = 5;
      var padding = 5;
      var date = Gregorian.info(Time.now(), Time.FORMAT_SHORT);

      var dayString = date.day.toString();
      var monthString = monthArray[date.month].toUpper();
      var weekdayString = weekdayArray[date.day_of_week].toUpper();

      var dateFontHeight = dc.getFontHeight(dateFont);
      var dayStringWidth = dc.getTextWidthInPixels(dayString, dateFont);

      dc.setColor(0xE8B9B0, Graphics.COLOR_TRANSPARENT);

      dc.drawText(
        dc.getWidth() / 2 + paddingLeft,
        (dc.getHeight() / 2 - margin),
        dateFont,
        dayString,
        Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER
      );

      dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);

      dc.drawText(
        dc.getWidth() / 2 + dayStringWidth + 4 + paddingLeft,
        (dc.getHeight() / 2 - margin),
        dateFont,
        monthString,
        Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER
      );

      dc.drawText(
        dc.getWidth() / 2 + paddingLeft,
        (dc.getHeight() / 2 - margin - dateFontHeight + padding),
        dateFont,
        weekdayString,
        Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER
      );
    }

    function drawHeartRate(dc) as Void {
      var title = "Pulse";
      var heartRate = retrieveHeartRateText();

      var margin = 13; // Margin on middle
      var paddingLeft = 5;
      var padding = 10; // Padding between title и value

      var dataFontHeight = dc.getFontHeight(dataFont);

      dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);

      dc.drawText(
        dc.getWidth() / 2 + paddingLeft,
        ((dc.getHeight() / 2) + margin),
        dataFont,
        title.toUpper(),
        Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER
      );

      dc.setColor(0xE8B9B0, Graphics.COLOR_TRANSPARENT);

      dc.drawText(
        dc.getWidth() / 2 + paddingLeft,
        ((dc.getHeight() / 2) + dataFontHeight + margin + padding),
        dateFont,
        heartRate[0],
        Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER
      );

      dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);

      if(heartRate[1] != null) {
        var maring = 5;
        var heartRateStringWidth = dc.getTextWidthInPixels(heartRate[0], dateFont);

        dc.drawText(
          dc.getWidth() / 2 + paddingLeft + heartRateStringWidth + maring,
          ((dc.getHeight() / 2) + dataFontHeight + margin + padding),
          dateFont,
          heartRate[1].toUpper(),
          Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER
        );
      }
    }

    private function retrieveHeartRateText() as [String, String | Null] {
      var unit = "bpm";
      var info = Activity.getActivityInfo();

      if (info != null) {
        var hr = info.currentHeartRate;
        if (hr == null) {
          return ["--", null];
        }
        return [Lang.format("$1$", [hr]), unit];
      }


      var hrIterator = ActivityMonitor.getHeartRateHistory(null, false);

      var sample = hrIterator.next();

      if (sample == null) {
        return ["--", null];
      }

      if (sample.heartRate == ActivityMonitor.INVALID_HR_SAMPLE) {
        return ["--", null];
      }
      
      return [Lang.format("$1$", [sample.heartRate]), unit];
    }

    function drawSteps(dc) as Void {
      var title = "Steps";
      var info = ActivityMonitor.getInfo();
      var stepCount = info.steps.toString();

      var paddingLeft = 5;
      var margin = 18; // Uppder block margin + padding
      var padding = 10; // Padding between title и value

      var dataFontHeight = dc.getFontHeight(dataFont);
      var dateFontHeight = dc.getFontHeight(dateFont);

      dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);

      dc.drawText(
        dc.getWidth() / 2 + paddingLeft,
        (dc.getHeight() / 2) + dataFontHeight + dateFontHeight + margin,
        dataFont,
        title.toUpper(),
        Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER
      );

      dc.setColor(0xE8B9B0, Graphics.COLOR_TRANSPARENT);

      dc.drawText(
        dc.getWidth() / 2 + paddingLeft,
        ((dc.getHeight() / 2) + (dataFontHeight * 2 + dateFontHeight) + margin + padding),
        dateFont,
        stepCount,
        Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER
      );
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() as Void {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() as Void {
    }
}
