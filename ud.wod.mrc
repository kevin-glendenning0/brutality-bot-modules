alias -l addmark { return $+($sock($1).mark,$chr($3),$2) }
alias -l bet { var %x $calc($pos($1,$2,$3) + $len($2)), %y $calc($pos($1,$4,$5) - %x) | return $mid($1,%x,%y) }
alias -l htmlfree { var %x, %i = $regsub($1-,/(^[^<]*>|<[^>]*>|<[^>]*$)/g,$null,%x), %x = $remove(%x,&nbsp;) | return $replace(%x,&quot;,",&lt;,<,&gt;,>,$cr,$chr(32),$lf,$chr(32),&amp;,&) }
alias -l lt { var %l $1, %t $2- | tokenize 124 $sock(urban).mark | while ($len(%t) > %l) { smsg $1 $left(%t,%l) | var %t $remove(%t,$left(%t,%l)) } | if (%t) smsg $1 %t }
alias -l ltz { var %l $1, %t $2- | tokenize 124 $sock(wod).mark | while ($len(%t) > %l) { smsg $1 $left(%t,%l) | var %t $remove(%t,$left(%t,%l)) } | if (%t) smsg $1 %t }
alias -l smsg { msg $iif(c isincs $chan($1).mode,$1 $strip($2-),$1-) }

on $*:text:/^[.!@]wod*/Si:#: { $iif($istok(%wordofday,#,32),halt,set -u1 %wordofday $addtok(%wordofday,#,32)) | if (!$2) { sockopen wod www.urbandictionary.com 80 | sockmark wod $+(#,$chr(124),1) } | elseif ($2 isnum 1-7) { sockopen wod www.urbandictionary.com 80 | sockmark wod $+(#,$chr(124),$2) } | else { .notice $nick [Word of Day] Syntax: .wod [1~7]>. } }
on *:sockopen:wod: { sockwrite -n $sockname GET / HTTP/1.0 | sockwrite -n $sockname Host: www.urbandictionary.com $+ $crlf $+ $crlf }
on *:sockread:wod: {
  sockread %wod | tokenize 124 $sock(wod).mark
  if (<div class='word'> isin %wod) { inc %wodw | if (%wodw == $2) { sockread %wod | sockmark wod $addmark(wod,$htmlfree(%wod),124) } }
  elseif (<div class='definition'> isin %wod) { inc %wodd | if (%wodd == $2) { sockread %wod | set %wod.def $htmlfree(%wod) } }
  elseif (<div class='example'> isin %wod) { inc %wode | if (%wode == $2) { sockread %wod | set %wod.ex $htmlfree(%wod) } }
  elseif (<div class='smallcaps'> isin %wod) { inc %wods | if (%wods == $2) { sockread %wod | sockmark wod $addmark(wod,$left($gettok($htmlfree(%wod),1,32),3) $+($gettok($htmlfree(%wod),2,32),$chr(44)) $iif($date(m) == 1,$iif($date(d) <= 7,$+(0,$calc($date(yyyy) - 1))),$date(yyyy)),124) } }
  elseif ($regex(%wod,"author">(.*)</a>)) { inc %woda | if (%woda == $2) { sockmark wod $addmark(wod,$regml(1),124) } }
}
on *:sockclose:wod: { tokenize 124 $sock(wod).mark | ltz 425 [Word of Day ~ $+(,$2,,]) ~ $+(,$3,,:) %wod.def $+($chr(40),%wod.ex,$chr(41)) | ltz 425 [Word of Day] ~ Author: $5 ~ Date: $4 ~ Url: Check the homepage @ http://www.urbandictionary.com/ - (15 seconds until next word of the day) | unset %wod* }
