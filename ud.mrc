alias -l c1 return $+($chr(3),1,$1-,$chr(3))
alias -l c2 return $+($chr(3),13,$1-,$chr(3))
on $*:Text:/^[.!@]urban/Si:#:{
  if (!$2) {
    notice $nick *** [ $c2(URBAN) ]: You must specify a word to look up.
  }
  else {
    var %ticks $ticks, %sockname Urban. $+ %ticks
    hadd -m %sockname Msg $iif(@* iswm $1,msg $chan,notice $nick)
    hadd -m %sockname Word $iif($chr(35) !isin $2-,$2-,$gettok($2-,1,35))
    hadd -m %sockname ID $iif($chr(35) isin $3-,$gettok($3-,-1,35),$null)
    sockopen %sockname rscript.org 80
  }
}
on $*:sockopen:/^Urban\.(\d+)/Si:{
  sockwrite -nt $sockname GET  $+(/lookup.php?type=urban&search=,$replace($hget($sockname,Word),$chr(32),$eval(%20,0)),&id=,$hget($sockname,ID)) HTTP/1.0
  sockwrite -nt $sockname Host: rscript.org
  sockwrite -nt $sockname $crlf
}
on $*:sockread:/^Urban\.(\d+)/Si:{
  if ($sockerr) {
    sockclose $sockname
  }
  else {
    var %Urban | sockread %Urban
    if ($regex(%Urban,/^MATCHES: [0]$/)) {
      $hget($sockname,Msg) *** [ $c2(URBAN) ]: No results were found for " $+ $c2($hget($sockname,Word)) $+ " or the $c2(Urban Dictionnary) might be down.
      sockclose $sockname
    }
    else {
      if ($regex(%Urban,/^MATCHES: ((?:[1-9]+)[0-9]?)$/)) {
        sockread %Urban
        $hget($sockname,Msg) *** [ $c2(URBAN) ]: $c1($iif($regml(1) == 1,Definition:,Definitions:)) $c3($regml(1)) $chr(124) " $+ $c3($hget($sockname,Word)) $+ $replace(" $remove(%Urban,DEFINED:),$hget($sockname,Word),$c3($hget($sockname,Word)))
        sockread %Urban
        $hget($sockname,Msg) *** [ $c2(URBAN) ]: $c3(Example:) $replace($remove(%Urban,EXAMPLE:),$hget($sockname,Word),$c3($hget($sockname,Word)))
        hfree $sockname
        sockclose $sockname
      }
    }
  }
}
alias c3 return $+($chr(3),13,$1-,$chr(3))
