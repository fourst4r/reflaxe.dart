import dart.Lib.assert;

function main() {

    // we only specify basic things here, most invalid input is platform-dependent
    var date = new Date(1982,10,10,14,2,20);
    assert(date.getHours() == 14);
    assert(date.getMinutes() == 2);
    assert(date.getSeconds() == 20);
    assert(date.getFullYear() == 1982);
    assert(date.getMonth() == 10);
    assert(date.getDate() == 10);
    assert(date.getDay() == 3);
    assert(date.toString() == "1982-11-10 14:02:20");

    var date = Date.fromTime(date.getTime());
    assert(date.getHours() == 14);
    assert(date.getMinutes() == 2);
    assert(date.getSeconds() == 20);
    assert(date.getFullYear() == 1982);
    assert(date.getMonth() == 10);
    assert(date.getDate() == 10);
    assert(date.getDay() == 3);
    assert(date.toString() == "1982-11-10 14:02:20");

    var date = Date.fromTime(405781340000);
    assert(date.getTime() == 405781340000);
    assert(date.getUTCHours() == 13);
    assert(date.getUTCMinutes() == 2);
    assert(date.getUTCSeconds() == 20);
    assert(date.getUTCFullYear() == 1982);
    assert(date.getUTCMonth() == 10);
    assert(date.getUTCDate() == 10);
    assert(date.getUTCDay() == 3);

    // timezone issues
    var date1 = Date.fromTime(1455555555 * 1000.); // 15 Feb 2016 16:59:15 GMT
    var date2 = new Date(2016, 1, 15, 16, 59, 15);
    #if github
    assert(date1.getTime() == date2.getTime()); // depends on GitHub timezone setting!
    #end

    var referenceDate = new Date(1970, 0, 12, 2, 0, 0);
    assert(referenceDate.toString() == "1970-01-12 02:00:00");
    #if github
    assert(referenceDate.getTime() == 957600000.); // depends on GitHub timezone setting!
    #end

    var date = new Date(1970, 0, 12, 1, 59, 59);
    date.getTime() < referenceDate.getTime();

    // < 1970 (negative timestamp)
    // neko, cpp, and python only fail on Windows
    // disabled - see #8600
    #if false // !(hl || eval || neko || cpp || python)
    var date = new Date(1904, 11, 12, 1, 4, 1);
    assert(date.getHours() == 1);
    assert(date.getMinutes() == 4);
    assert(date.getSeconds() == 1);
    assert(date.getFullYear() == 1904);
    assert(date.getMonth() == 11);
    assert(date.getDate() == 12);
    assert(date.getDay() == 1);
    date.getTime() < referenceDate.getTime();
    #end

    // < 1902 (negative timestamp, outside of signed 32-bit integer range)
    // lua only fails on Mac
    // python only fails on Windows
    // disabled - see #8600
    #if false // !(hl || neko || eval || cpp || lua || python)
    var date = new Date(1888, 0, 1, 15, 4, 2);
    assert(date.getHours() == 15);
    assert(date.getMinutes() == 4);
    assert(date.getSeconds() == 2);
    assert(date.getFullYear() == 1888);
    assert(date.getMonth() == 0);
    assert(date.getDate() == 1);
    assert(date.getDay() == 0);
    date.getTime() < referenceDate.getTime();
    #end


    // Y2038 (outside of signed 32-bit integer range)
    // disabled - see #8600
    #if false // !neko
    var date = new Date(2039, 0, 1, 1, 59, 59);
    assert(date.getHours() == 1);
    assert(date.getMinutes() == 59);
    assert(date.getSeconds() == 59);
    assert(date.getFullYear() == 2039);
    assert(date.getMonth() == 0);
    assert(date.getDate() == 1);
    assert(date.getDay() == 6);
    date.getTime() > referenceDate.getTime();
    #end

    // Y2112 (outside of unsigned 32-bit integer range)
    // disabled - see #8600
    #if false // !(hl || neko)
    var date = new Date(2112, 0, 1, 1, 59, 59);
    assert(date.getHours() == 1);
    assert(date.getMinutes() == 59);
    assert(date.getSeconds() == 59);
    assert(date.getFullYear() == 2112);
    assert(date.getMonth() == 0);
    assert(date.getDate() == 1);
    assert(date.getDay() == 5);
    date.getTime() > referenceDate.getTime();
    #end

    /*
    // fromTime outside the 1970...2038 range (not supported)
    var date = Date.fromTime(-2052910800.0);
    date.getFullYear() == 1904;
    date.getMonth() == 11;
    date.getDate() == 12; // could fail on very large UTC offsets
    var date = Date.fromTime(-2587294800.0);
    date.getFullYear() == 1888;
    date.getMonth() == 0;
    date.getDate() == 5; // could fail on very large UTC offsets
    var date = Date.fromTime(2177838000.0);
    date.getFullYear() == 2039;
    date.getMonth() == 0;
    date.getDate() == 5; // could fail on very large UTC offsets
    var date = Date.fromTime(4481434800.0);
    date.getFullYear() == 2039;
    date.getMonth() == 0;
    date.getDate() == 5; // could fail on very large UTC offsets
    */

    // weekdays
    assert((new Date(2019, 6, 1, 12, 0, 0)).getDay() == 1);
    assert((new Date(2019, 6, 2, 12, 0, 0)).getDay() == 2);
    assert((new Date(2019, 6, 3, 12, 0, 0)).getDay() == 3);
    assert((new Date(2019, 6, 4, 12, 0, 0)).getDay() == 4);
    assert((new Date(2019, 6, 5, 12, 0, 0)).getDay() == 5);
    assert((new Date(2019, 6, 6, 12, 0, 0)).getDay() == 6);
    assert((new Date(2019, 6, 7, 12, 0, 0)).getDay() == 0);

    // fromString
    var date = Date.fromString("2019-07-08 12:22:00");
    assert(date.getHours() == 12);
    assert(date.getMinutes() == 22);
    assert(date.getSeconds() == 0);
    assert(date.getFullYear() == 2019);
    assert(date.getMonth() == 6);
    assert(date.getDate() == 8);
    assert(date.getDay() == 1);

    var date = Date.fromString("2019-03-02");
    assert(date.getHours() == 0);
    assert(date.getMinutes() == 0);
    assert(date.getSeconds() == 0);
    assert(date.getFullYear() == 2019);
    assert(date.getMonth() == 2);
    assert(date.getDate() == 2);
    assert(date.getDay() == 6);

    // fromString HH:MM:SS should interpret the time as UTC
    #if python
    // disabled on Windows due to https://bugs.python.org/issue37527
    if (Sys.systemName() != "Windows") {
    #end
    var date = Date.fromString("04:05:06");
    assert((date.getUTCHours() == 4));
    assert((date.getUTCMinutes() == 5));
    assert((date.getUTCSeconds() == 6));
    assert((date.getUTCFullYear() == 1970));
    assert((date.getUTCMonth() == 0));
    assert((date.getUTCDate() == 1));
    assert((date.getUTCDay() == 4));
    assert((date.getTime() == 14706000.));
    #if python
    }
    #end

    // timezone offset
    // see https://en.wikipedia.org/wiki/UTC_offset
    assert(Date.fromString("2015-01-08 12:22:00").getTimezoneOffset() % 15 == 0);
    assert(Date.fromString("2015-02-08 12:22:00").getTimezoneOffset() % 15 == 0);
    assert(Date.fromString("2015-03-08 12:22:00").getTimezoneOffset() % 15 == 0);
    assert(Date.fromString("2015-04-08 12:22:00").getTimezoneOffset() % 15 == 0);
    assert(Date.fromString("2015-05-08 12:22:00").getTimezoneOffset() % 15 == 0);
    assert(Date.fromString("2015-06-08 12:22:00").getTimezoneOffset() % 15 == 0);
    assert(Date.fromString("2015-07-08 12:22:00").getTimezoneOffset() % 15 == 0);
    assert(Date.fromString("2015-08-08 12:22:00").getTimezoneOffset() % 15 == 0);
    assert(Date.fromString("2015-09-08 12:22:00").getTimezoneOffset() % 15 == 0);
    assert(Date.fromString("2015-10-08 12:22:00").getTimezoneOffset() % 15 == 0);
    assert(Date.fromString("2015-11-08 12:22:00").getTimezoneOffset() % 15 == 0);
    assert(Date.fromString("2015-12-08 12:22:00").getTimezoneOffset() % 15 == 0);
    assert(Date.fromString("2015-06-15 10:00:00").getTimezoneOffset() == Date.fromString("2016-06-15 10:00:00").getTimezoneOffset());

}