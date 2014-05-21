on $*:TEXT:/^!v?dinner$/Si:#:{
  if ($sock(wtfd)) return
  sockopen wtfd $wtfd 80
  sockmark wtfd $iif(!v* iswm $1,/veg.php,/index.php) msg #
}
on *:SOCKOPEN:wtfd:{
  tokenize 32 $sock($sockname).mark
  if ($sockerr) $2- Dinner: Unable to connect.
  else {
    var %s = sockwrite -n $sockname
    %s GET $1 HTTP/1.1
    %s Host: $wtfd
    %s Connection: close
    %s
  }
}
on *:SOCKWRITE:wtfd:{
  if ($sockerr) {
    $gettok($sock($sockname).mark,2-,32) Dinner: Unable to request page
    unset %wtfd:*
  }
}

on *:SOCKREAD:wtfd:{
  tokenize 32 $sock($sockname).mark
  if ($sockerr) {
    $2- Dinner: Unable to read data.
    unset %wtfd:*
  }
  else {
    var %tmp
    sockread %tmp
    while ($sockbr) {
      if (fucking isin %tmp) inc %wtfd:x
      if ($1 == /veg.php && %wtfd:x == 1) || ($1 == /index.php && %wtfd:x == 2) {
        set %wtfd:line $remove(%tmp,</dl>)
        inc %wtfd:x
      }
      if (<dt><a href=" isin %tmp) {
        set %wtfd:desc $replace($nohtml(%tmp),&rsquo;,',&rdquo;,")
        set %wtfd:link $remove($gettok(%tmp,2,32),href=",")
      }
      sockread %tmp
    }
  }
}
on *:SOCKCLOSE:wtfd: {
  tokenize 32 $sock($sockname).mark
  if ($sockerr) $2- Dinner: Connection closed Unexpectedly
  else {
    $2- %wtfd:line $+ : %wtfd:desc
    $2- %wtfd:link
  }
  unset %wtfd:*
}

alias -l nohtml return $regsubex($1-,/<[^>]+>?|^[^<]*>/g,)
alias -l wtfd return whatthefuckshouldimakefordinner.com
