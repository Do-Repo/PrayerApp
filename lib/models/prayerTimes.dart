class PrayerTimesModel {
  // Geographic
  String? city;
  String? province;
  String? country;
  String? timezone;
  // Prayertimes
  String? fajr;
  String? dhuhr;
  String? aasr;
  String? maghrib;
  String? isha;
  //Extras
  String? imsak;
  String? sunset;
  String? sunrise;
  //Dates
  String? hijriDayNumber;
  String? hijriDayNameEN;
  String? hijriDayNameAR;
  String? hijriMonthEN;
  String? hijriMonthAR;
  String? hijriYear;
  String? hijriYearDesignation;
  String? gregorianDayNumber;
  String? gregorianDayName;
  String? gregorianMonth;
  String? gregorianYear;
  String? fullhijridate;
  String? fullgregoriandate;
  String? readabledate;
  List<dynamic>? holidays;
  PrayerTimesModel(
      {this.city,
      this.province,
      this.country,
      this.timezone,
      this.fajr,
      this.dhuhr,
      this.aasr,
      this.maghrib,
      this.isha,
      this.imsak,
      this.sunset,
      this.sunrise,
      this.hijriDayNumber,
      this.hijriDayNameEN,
      this.hijriDayNameAR,
      this.hijriMonthEN,
      this.hijriMonthAR,
      this.hijriYear,
      this.hijriYearDesignation,
      this.gregorianDayNumber,
      this.gregorianDayName,
      this.gregorianMonth,
      this.gregorianYear,
      this.fullgregoriandate,
      this.readabledate,
      this.fullhijridate,
      this.holidays});

  factory PrayerTimesModel.fromJson(Map<String, dynamic> json, String? city,
      String? province, String? country) {
    return PrayerTimesModel(
        city: city,
        province: province,
        country: country,
        timezone: json['meta']['timezone'],
        fajr: json['timings']['Fajr'],
        dhuhr: json['timings']['Dhuhr'],
        aasr: json['timings']['Asr'],
        maghrib: json['timings']['Maghrib'],
        isha: json['timings']['Isha'],
        imsak: json['timings']['Imsak'],
        sunset: json['timings']['Sunset'],
        sunrise: json['timings']['Sunrise'],
        hijriDayNumber: json['date']['hijri']['day'],
        hijriDayNameEN: json['date']['hijri']['weekday']['en'],
        hijriDayNameAR: json['date']['hijri']['weekday']['ar'],
        hijriMonthEN: json['date']['hijri']['month']['en'],
        hijriMonthAR: json['date']['hijri']['month']['ar'],
        hijriYear: json['date']['hijri']['year'],
        hijriYearDesignation: json['date']['hijri']['designation']
            ['abbreviated'],
        gregorianDayNumber: json['date']['gregorian']['day'],
        gregorianDayName: json['date']['gregorian']['weekday']['en'],
        gregorianMonth: json['date']['gregorian']['month']['en'],
        gregorianYear: json['date']['gregorian']['year'],
        fullgregoriandate: json['date']['gregorian']['date'],
        fullhijridate: json['date']['hijri']['date'],
        readabledate: json['date']['readable'],
        holidays: json['date']['hijri']['holidays']);
  }
}
