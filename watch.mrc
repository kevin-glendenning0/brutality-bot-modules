on $*:TEXT:/^!watch$/Si:#: {
  sockopen wtfw whatthefuckshouldiwatchtonight.com 80
  sockmark wtfw msg #
}

on *:SOCKOPEN:wtfw: {
  sockwrite -n $sockname GET /get_movie.php HTTP/1.1
  sockwrite -n $sockname Host: whatthefuckshouldiwatchtonight.com
  sockwrite -n $sockname Connection: close
  sockwrite -n $sockname $crlf
}

on *:SOCKREAD:wtfw: {
  if ($sockerr) { $sock(wtfw).mark Socket Error: $sock(wtfw).wsmsg }
  var %wtfwtemp
  sockread %wtfwtemp

  if (<p id="intro" isin %wtfwtemp) { set %wtfwline $remove($gettok(%wtfwtemp,3-,32),class="cufon">,</p>,<br />) }
  if (<h1 class=" isin %wtfwtemp) {
    set %wtfwlink $replace($remove(%wtfwtemp,$left(%wtfwtemp,27),$right(%wtfwtemp,9)),">,$chr(32))
    tokenize 32 %wtfwlink
  }
}

on *:SOCKCLOSE:wtfw: {
  $sock(wtfw).mark %wtfwline $+ : $gettok(%wtfwlink,2-,32) :: $gettok(%wtfwlink,1,32)
}
