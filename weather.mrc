on $*:text:/^[!](weather|forecast|forecast5|alert|alerts|alertinfo|alertsinfo|time)/Si:#: {
  unset %wu_*
  if ($2 == $null) { .notice $nick Please specify a location $1 [zipcode|city,state|city,country|airport] | halt }
  set %wu_command $1
  set %wu_address $replace($2-,$chr(32),$chr(43)) 
  set %wu_nick $nick
  set %wu_network $network
  set %wu_chan $chan



  if (%wu_command == !weather) || (%wu_command == !w) || (%wu_command == !time) { 
    set %wu_link $+(/auto/wui/geo/WXCurrentObXML/index.xml?query=,%wu_address)
    set %wu_host api.wunderground.com
    sockopen wunderground %wu_host 80
  }
  if (%wu_command == !forecast) || (%wu_command == !forecast5) { 
    set %wu_link $+(/auto/wui/geo/ForecastXML/index.xml?query=,%wu_address)
    set %wu_host www.wunderground.com
    sockopen wunderground %wu_host 80


  }
  if (%wu_command == !alert) set %wu_command !alerts
  if (%wu_command == !alertsinfo) set %wu_command !alertinfo
  if (%wu_command == !alerts) || (%wu_command == !alertinfo) { 
    ;echo -s pass
    set %wu_link $+(/auto/wui/geo/AlertsXML/index.xml?query=,%wu_address)
    set %wu_host www.wunderground.com
    sockopen wunderground %wu_host 80
  }


  ;echo -s LINK: %wu_link
}




on *:sockopen:wunderground: {


  ;sockwrite -n $sockname GET %wu_link XML/1.0
  sockwrite -n $sockname GET %wu_link
  sockwrite -n $sockname Host: %wu_host
  sockwrite -n $sockname $crlf
}


on *:sockread:wunderground: {
  sockread %wu_temp
  ;echo -s %wu_temp


  if (%wu_command == !weather) || (%wu_command == !w) || (%wu_command == !time) { 
    ; local info
    if (<full> isin %wu_temp) && (%wu_full == $null) %wu_full = $remove(%wu_temp,<full>,</full>,$chr(9)) 
    if (<city> isin %wu_temp) && (%wu_city == $null) %wu_city = $remove(%wu_temp,<city>,</city>,$chr(9)) 
    if (<state> isin %wu_temp) && (%wu_state == $null) %wu_state = $remove(%wu_temp,<state>,</state>,$chr(9)) 
    if (<state_name> isin %wu_temp) && (%wu_state_name == $null) %wu_state_name = $remove(%wu_temp,<state_name>,</state_name>,$chr(9)) 
    if (<country> isin %wu_temp) && (%wu_country == $null)  %wu_country = $remove(%wu_temp,<country>,</country>,$chr(9)) 
    if (<country_iso3166> isin %wu_temp) && (%wu_country_iso3166 == $null) %wu_country_iso3166 = $remove(%wu_temp,<country_iso3166>,</country_iso3166>,$chr(9)) 
    if (<zip> isin %wu_temp) && (%wu_zip == $null)  %wu_zip = $remove(%wu_temp,<zip>,</zip>,$chr(9)) 
    if (<latitude> isin %wu_temp) && (%wu_latitude == $null) %wu_latitude = $remove(%wu_temp,<latitude>,</latitude>,$chr(9)) 
    if (<longitude> isin %wu_temp) && (%wu_longitude == $null) %wu_longitude = $remove(%wu_temp,<longitude>,</longitude>,$chr(9)) 
    if (<elevation> isin %wu_temp) && (%wu_elevation == $null) %wu_elevation = $remove(%wu_temp,<elevation>,</elevation>,$chr(9)) 


    if (<local_time> isin %wu_temp) %wu_local_time = $remove(%wu_temp,<local_time>,</local_time>,$chr(9)) 
    if (<local_time_rfc822> isin %wu_temp) %wu_local_time_rfc822 = $remove(%wu_temp,<local_time_rfc822>,</local_time_rfc822>,$chr(9)) 


    ; current weather
    if (<weather> isin %wu_temp) %wu_weather = $remove(%wu_temp,<weather>,</weather>,$chr(9)) 
    if (<temperature_string> isin %wu_temp) %wu_temperature_string = $remove(%wu_temp,<temperature_string>,</temperature_string>,$chr(9)) 
    if (<temp_f> isin %wu_temp) %wu_temp_f = $remove(%wu_temp,<temp_f>,</temp_f>,$chr(9))
    if (<temp_c> isin %wu_temp) %wu_temp_c = $remove(%wu_temp,<temp_c>,</temp_c>,$chr(9)) 
    if (<relative_humidity> isin %wu_temp) %wu_relative_humidity = $remove(%wu_temp,<relative_humidity>,</relative_humidity>,$chr(9)) 


    ; wind
    if (<wind_string> isin %wu_temp) %wu_wind_string = $remove(%wu_temp,<wind_string>,</wind_string>,$chr(9)) 
    if (<wind_dir> isin %wu_temp) %wu_wind_dir = $remove(%wu_temp,<wind_dir>,</wind_dir>,$chr(9)) 
    if (<wind_degrees> isin %wu_temp) %wu_wind_degrees = $remove(%wu_temp,<wind_degrees>,</wind_degrees>,$chr(9)) 
    if (<wind_mph> isin %wu_temp) %wu_wind_mph = $remove(%wu_temp,<wind_mph>,</wind_mph>,$chr(9)) 
    if (<wind_gust_mph> isin %wu_temp) %wu_wind_gust_mph = $remove(%wu_temp,<wind_gust_mph>,</wind_gust_mph>,$chr(9)) 


    if (<pressure_string> isin %wu_temp) %wu_pressure_string = $remove(%wu_temp,<pressure_string>,</pressure_string>,$chr(9)) 
    if (<pressure_mb> isin %wu_temp) %wu_pressure_mb = $remove(%wu_temp,<pressure_mb>,</pressure_mb>,$chr(9))
    if (<pressure_in> isin %wu_temp) %wu_pressure_in = $remove(%wu_temp,<pressure_in>,</pressure_in>,$chr(9))
    if (<dewpoint_string> isin %wu_temp) %wu_dewpoint_string = $remove(%wu_temp,<dewpoint_string>,</dewpoint_string>,$chr(9))
    if (<dewpoint_f> isin %wu_temp) %wu_dewpoint_f = $remove(%wu_temp,<dewpoint_f>,</dewpoint_f>,$chr(9))
    if (<dewpoint_c> isin %wu_temp) %wu_dewpoint_c = $remove(%wu_temp,<dewpoint_c>,</dewpoint_c>,$chr(9))


    if (<heat_index_string> isin %wu_temp) %wu_heat_index_string = $remove(%wu_temp,<heat_index_string>,</heat_index_string>,$chr(9))
    if (<heat_index_f> isin %wu_temp) %wu_heat_index_f = $remove(%wu_temp,<heat_index_f>,</heat_index_f>,$chr(9))
    if (<heat_index_c> isin %wu_temp) %wu_heat_index_c = $remove(%wu_temp,<heat_index_c>,</heat_index_c>,$chr(9))
    if (<windchill_string> isin %wu_temp) %wu_windchill_string = $remove(%wu_temp,<windchill_string>,</windchill_string>,$chr(9))
    if (<windchill_f> isin %wu_temp) %wu_windchill_f = $remove(%wu_temp,<windchill_f>,</windchill_f>,$chr(9))
    if (<windchill_c> isin %wu_temp) %wu_windchill_c = $remove(%wu_temp,<windchill_c>,</windchill_c>,$chr(9))


    if (<visibility_mi> isin %wu_temp) %wu_visibility_mi = $remove(%wu_temp,<visibility_mi>,</visibility_mi>,$chr(9))
    if (<visibility_km> isin %wu_temp) %wu_visibility_km = $remove(%wu_temp,<visibility_km>,</visibility_km>,$chr(9))
  }


  if (%wu_command == !forecast) || (%wu_command == !forecast5) {
    if (<period> isin %wu_temp) set %wu_period $remove(%wu_temp,<period>,</period>,$chr(9),$chr(32))
    if (<high> isin %wu_temp) set %wu_xtemp 1
    if (<low> isin %wu_temp) set %wu_xtemp 2
    if (<simpleforecast> isin %wu_temp) set %wu_simpleforecast 1


    if (<title> isin %wu_temp) && (%wu_period == 1) %wu_f1_title = $remove(%wu_temp,<title>,</title>,$chr(9),$chr(32))
    if (<fcttext> isin %wu_temp) && (%wu_period == 1) %wu_f1_fcttext = $remove(%wu_temp,<fcttext>,</fcttext>,$chr(9))
    if (<title> isin %wu_temp) && (%wu_period == 2) %wu_f2_title = $remove(%wu_temp,<title>,</title>,$chr(9),$chr(32))
    if (<fcttext> isin %wu_temp) && (%wu_period == 2) %wu_f2_fcttext = $remove(%wu_temp,<fcttext>,</fcttext>,$chr(9))


    if (%wu_simpleforecast == 1) {
      if (<weekday> isin %wu_temp) set $+(%,wu_P,%wu_period,_weekday) $remove(%wu_temp,<weekday>,</weekday>,$chr(9),$chr(32))
      if (<conditions> isin %wu_temp) set $+(%,wu_P,%wu_period,_conditions) $remove(%wu_temp,<conditions>,</conditions>,$chr(9))
      if (%wu_xtemp == 1) {
        if (<fahrenheit> isin %wu_temp) set $+(%,wu_P,%wu_period,_highf) $remove(%wu_temp,<fahrenheit>,</fahrenheit>,$chr(9),$chr(32))
        if (<celsius> isin %wu_temp) set $+(%,wu_P,%wu_period,_highc) $remove(%wu_temp,<celsius>,</celsius>,$chr(9),$chr(32))
      }
      if (%wu_xtemp == 2) {
        if (<fahrenheit> isin %wu_temp) set $+(%,wu_P,%wu_period,_lowf) $remove(%wu_temp,<fahrenheit>,</fahrenheit>,$chr(9),$chr(32))
        if (<celsius> isin %wu_temp) set $+(%,wu_P,%wu_period,_lowc) $remove(%wu_temp,<celsius>,</celsius>,$chr(9),$chr(32))
      }
    }
  }
  if (%wu_command == !alerts) || (%wu_command == !alertinfo) { 
    ;echo -s %wu_temp
    set -n %wu_ac <alert count="
    if (%wu_ac isin %wu_temp) set -n %wu_a_count $remove(%wu_temp,<termsofservice link="http://www.wunderground.com/members/tos.asp#api" />,<alert count=",">,$chr(32),$chr(9))
    if (<AlertItem> isin %wu_temp) inc %wu_a_i
    if (<type> isin %wu_temp) set $+(%,wu_a,%wu_a_i,_type) $remove(%wu_temp,<type>,</type>,$chr(9)) 
    if (<description> isin %wu_temp) set $+(%,wu_a,%wu_a_i,_description) $remove(%wu_temp,<description>,</description>,$chr(9))
    if (<date epoch isin %wu_temp) set $+(%,wu_a,%wu_a_i,_date) $right($remove(%wu_temp,<date epoch=",">,</date>,$chr(9)),-12)
    if (<expires epoch isin %wu_temp) set $+(%,wu_a,%wu_a_i,_expires) $right($remove(%wu_temp,<expires epoch=",">,</expires>,$chr(9)),-10)
    if (</message> isin %wu_temp) { set %wu_msg OFF | set $+(%,wu_a,%wu_a_i,_count) $(%wu_msg_c,2) | set %wu_msg_c 0 }
    if (%wu_msg == ON) {
      inc %wu_msg_gc
      inc %wu_msg_c 
      set $+(%,wu_a,%wu_a_i,_message,%wu_msg_c) %wu_temp
    }
    if (<message> isin %wu_temp) { set %wu_msg ON }
  }
}






on *:sockclose:wunderground: {
  var %wu_space = $+($chr(45),$chr(124),$chr(45))
  var %wu_spaceend = $+($chr(45),$chr(124))


  if (%wu_command == !weather) || (%wu_command == !w) { 
    set %wu_present $remove(%wu_full,$chr(9),$chr(32),$chr(44))
    if (%wu_present == $null) msg %wu_chan Location not found
    if (%wu_present != $null) msg %wu_chan %wu_full $+ : %wu_weather and $+(%wu_temp_f,F,$chr(40),%wu_temp_c,C,$chr(41))
  }
  if (%wu_command == !time) {
    msg %wu_chan %wu_full $+ : %wu_local_time
  }
  if (%wu_command == !forecast) || (%wu_command == !forecast5) {
    if (%wu_f1_title != $null) { 
      var %wu_forecast1 $(%wu_f1_title $+ : %wu_f1_fcttext)
      var %wu_forecast2 $(%wu_f2_title $+ : %wu_f2_fcttext)
      if (%wu_f2_title != %wu_P2_weekday ) var %wu_forecast3 $(%wu_P2_weekday $+ : %wu_P2_conditions $+ . High: $+(%wu_P2_highf,F) $chr(47) $+(%wu_P2_highc,C) Low: $+(%wu_P2_lowf,F) $chr(47) $+(%wu_P2_lowc,C)) 
      if (%wu_f2_title == %wu_P2_weekday ) var %wu_forecast3 $(%wu_P3_weekday $+ : %wu_P3_conditions $+ . High: $+(%wu_P3_highf,F) $chr(47) $+(%wu_P3_highc,C) Low: $+(%wu_P3_lowf,F) $chr(47) $+(%wu_P3_lowc,C))
      .timer 1 0 msg %wu_chan %wu_address $+ : %wu_forecast1
      .timer 1 1 msg %wu_chan %wu_forecast2 %wu_space %wu_forecast3 %wu_spaceend 
    }
    if (%wu_f1_title == $null) {
      var %wu_forecast1 $(%wu_P1_weekday $+ : %wu_P1_conditions $+ . High: $+(%wu_P1_highf,F,$chr(40),%wu_P1_highc,C,$chr(41)) Low: $+(%wu_P1_lowf,F,$chr(40),%wu_P1_lowc,C,$chr(41)))
      var %wu_forecast2 $(%wu_P2_weekday $+ : %wu_P2_conditions $+ . High: $+(%wu_P2_highf,F,$chr(40),%wu_P2_highc,C,$chr(41)) Low: $+(%wu_P2_lowf,F,$chr(40),%wu_P2_lowc,C,$chr(41)))
      var %wu_forecast3 $(%wu_P3_weekday $+ : %wu_P3_conditions $+ . High: $+(%wu_P3_highf,F,$chr(40),%wu_P3_highc,C,$chr(41)) Low: $+(%wu_P3_lowf,F,$chr(40),%wu_P3_lowc,C,$chr(41)))
      .timer 1 0 msg %wu_chan %wu_address $+ : %wu_forecast1  
      .timer 1 1 msg %wu_chan %wu_forecast2 %wu_space %wu_forecast3
    }
  }


  if (%wu_command == !forecast5) {
    ;.timer 1 0 .msg %wu_chan %wu_P1_weekday $+ : %wu_P1_conditions $+ . High: $+(%wu_P1_highf,$F,$chr(40),%wu_P1_highc,C,$chr(41)) - Low: $+(%wu_P1_lowf,F,$chr(40),%wu_P1_lowc,C,$chr(41))
    .timer 1 1 .msg %wu_nick Your forcast for %wu_address
    .timer 1 2 .msg %wu_nick %wu_P1_weekday $+ : %wu_P1_conditions $+ . High: $+(%wu_P1_highf,F,$chr(40),%wu_P1_highc,C,$chr(41)) - Low: $+(%wu_P1_lowf,F,$chr(40),%wu_P1_lowc,C,$chr(41))
    .timer 1 3 .msg %wu_nick %wu_P2_weekday $+ : %wu_P2_conditions $+ . High: $+(%wu_P2_highf,F,$chr(40),%wu_P2_highc,C,$chr(41)) - Low: $+(%wu_P2_lowf,F,$chr(40),%wu_P2_lowc,C,$chr(41))
    .timer 1 4 .msg %wu_nick %wu_P3_weekday $+ : %wu_P3_conditions $+ . High: $+(%wu_P3_highf,F,$chr(40),%wu_P3_highc,C,$chr(41)) - Low: $+(%wu_P3_lowf,F,$chr(40),%wu_P3_lowc,C,$chr(41))
    .timer 1 5 .msg %wu_nick %wu_P4_weekday $+ : %wu_P4_conditions $+ . High: $+(%wu_P4_highf,F,$chr(40),%wu_P4_highc,C,$chr(41)) - Low: $+(%wu_P4_lowf,F,$chr(40),%wu_P4_lowc,C,$chr(41))
    .timer 1 6 .msg %wu_nick %wu_P5_weekday $+ : %wu_P5_conditions $+ . High: $+(%wu_P5_highf,F,$chr(40),%wu_P5_highc,C,$chr(41)) - Low: $+(%wu_P5_lowf,F,$chr(40),%wu_P5_lowc,C,$chr(41))
    .timer 1 7 .msg %wu_nick %wu_P6_weekday $+ : %wu_P6_conditions $+ . High: $+(%wu_P6_highf,F,$chr(40),%wu_P6_highc,C,$chr(41)) - Low: $+(%wu_P6_lowf,F,$chr(40),%wu_P6_lowc,C,$chr(41))
  }


  if (%wu_command == !alerts) {
    if (%wu_a_count == 0) msg %wu_chan %wu_address $+ : No Alerts
    if (%wu_a_count > 0) {
      msg %wu_chan %wu_address $+ : %wu_a_count Alerts
      var %i 1
      while (%i <= %wu_a_count) {
        .timer 1 %i msg %wu_chan %wu_a_start $($+(%,wu_a,%i,_description),2) till $($+(%,wu_a,%i,_expires),2) %wu_a_end
        inc %i
      }
      .timer 1 %i .notice %wu_nick use $chr(2) !alertinfo $chr(2) [zipcode|city,state|city,country|airport] for alert details
    }
  }
  if (%wu_command == !alertinfo) {
    if (%wu_a_count == 0) msg %wu_chan %wu_address $+ : No Alerts
    if (%wu_a_count > 0) {
      msg %wu_chan %wu_address $+ : %wu_a_count Alerts - See PM for details
      .msg %wu_nick %wu_address $+ : %wu_a_count Alerts
      var %i 1 , %i_gc 1
      while (%i <= %wu_a_count) {
        .timer 1 %i_gc .msg %wu_nick $chr(2) $($+(%,wu_a,%i,_description),2) $chr(2) from $($+(%,wu_a,%i,_date),2) till $($+(%,wu_a,%i,_expires),2)
        var %i_msg 1
        while (%i_msg <= $($+(%,wu_a,%i,_count),2)) {
          .timer 1 %i_gc .msg %wu_nick $($+(%,wu_a,%i,_message,%i_msg),2)
          inc %i_gc
          inc %i_msg
        }
        inc %i
      }
      .timer 1 %i_gc .msg %wu_nick --------- End of Alerts -------
    }
  }




  unset %wu_*
  ;echo -s End-------- of WU $time --------
}
