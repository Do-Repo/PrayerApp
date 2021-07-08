class CardModel {
  // Geographic
  String city;
  String province;
  String country;
  String timezone;
  // Prayertimes
  String fajr;
  String dhuhr;
  String aasr;
  String maghrib;
  String isha;
  //Extras
  String imsak;
  String sunset;
  String sunrise;
  //Dates
  String hijriDayNumber;
  String hijriDayNameEN;
  String hijriDayNameAR;
  String hijriMonthEN;
  String hijriMonthAR;
  String hijriYear;
  String hijriYearDesignation;
  String gregorianDayNumber;
  String gregorianDayName;
  String gregorianMonth;
  String gregorianYear;
  CardModel({
    this.city,
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
  });

  factory CardModel.fromJson(
      Map<String, dynamic> json, String city, String province, String country) {
    return CardModel(
      city: city,
      province: province,
      country: country,
      timezone: json['data']['meta']['timezone'],
      fajr: json['data']['timings']['Fajr'],
      dhuhr: json['data']['timings']['Dhuhr'],
      aasr: json['data']['timings']['Asr'],
      maghrib: json['data']['timings']['Maghrib'],
      isha: json['data']['timings']['Isha'],
      imsak: json['data']['timings']['Imsak'],
      sunset: json['data']['timings']['Sunset'],
      sunrise: json['data']['timings']['Sunrise'],
      hijriDayNumber: json['data']['date']['hijri']['day'],
      hijriDayNameEN: json['data']['date']['hijri']['weekday']['en'],
      hijriDayNameAR: json['data']['date']['hijri']['weekday']['ar'],
      hijriMonthEN: json['data']['date']['hijri']['month']['en'],
      hijriMonthAR: json['data']['date']['hijri']['month']['ar'],
      hijriYear: json['data']['date']['hijri']['year'],
      hijriYearDesignation: json['data']['date']['hijri']['designation']
          ['abbreviated'],
      gregorianDayNumber: json['data']['date']['gregorian']['day'],
      gregorianDayName: json['data']['date']['gregorian']['weekday']['en'],
      gregorianMonth: json['data']['date']['gregorian']['month']['en'],
      gregorianYear: json['data']['date']['gregorian']['year'],
    );
  }
}
