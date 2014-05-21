on *:text:/^[.!@]fml*/Si:#: {
  sockopen fml www.fmylife.com 80
  set %fmltarg $chan
}
on *:sockopen:fml: {
  sockwrite -n $sockname GET /random HTTP/2.0
  sockwrite -n $sockname Host: www.fmylife.com
  sockwrite -n $sockname Connection: close
  sockwrite -n $sockname $crlf
}
on *:sockread:fml: {
  sockread %fmltemp
  if (class="fmllink"> isin %fmltemp) {
    inc %t 1
    set %fml $+ %t $nohtml(%fmltemp)
  }
}

on *:sockclose:fml: {
  var %fmlstrip $left(%fml1, $calc($pos(%fml1, FML#) + 2))
  msg %fmltarg 4[10FMYLIFE4]10 Today, $noshit(%fmlstrip)
  unset %fml* %t
}

alias nohtml return $regsubex($$1-,/^[^<]*>|<[^>]*>|<[^>]*$/g,)
alias noshit return $remove($$1-,Net Avenir,$chr(58),gestion,publicitaireClose,the advertisement,today,$chr(44),&quot;,&#187;,Navigation,FMyLife,&rarr;,Random FMLs)
