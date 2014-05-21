ON @*:ACTION:*:#:{
  if ($nick isreg $chan) {
    var %flood = $flood(1,5,5,$chan,$nick,actflood)
    if (%flood) {
      var %fl = $gettok(%flood,1,46)
      var %ft = $gettok(%flood,2,46)
      ban -u60 $chan $nick 2
      kick $chan $nick Please stop flooding ( $+ $+(%fl,lines/,%ft,secs) $+ )
      return
    }
    var %repeat = $repeat(1,4,60,$chan,$nick,repeat,$1-)
    if (%repeat) {
      var %rl = $gettok(%repeat,1,46)
      var %rt = $gettok(%repeat,2,46)
      ban -u60 $chan $nick
      kick $chan $nick Stop! repeating...( $+ $+(%rl,repeats/,%rt,secs) $+ )
      return
    }
  }
}

ON @*:TEXT:*:#:{
  if ($nick isreg $chan) {
    var %flood = $flood(1,5,5,$chan,$nick,txtflood)
    if (%flood) {
      var %fl = $gettok(%flood,1,46)
      var %ft = $gettok(%flood,2,46)
      ban -u60 $chan $nick 2
      kick $chan $nick Please stop flooding ( $+ $+(%fl,lines/,%ft,secs) $+ )
      return
    }
    var %repeat = $repeat(1,4,60,$chan,$nick,repeat,$1-)
    if (%repeat) {
      var %rl = $gettok(%repeat,1,46)
      var %rt = $gettok(%repeat,2,46)
      ban -u60 $chan $nick
      kick $chan $nick Stop! repeating...( $+ $+(%rl,repeats/,%rt,secs) $+ )
      return
    }
    if (($caps($1-) > 75) && ($len($strip($1-)) >= 6)) { kick $chan $nick Please do not use excessive amounts of caps.  }


  }
}

alias caps {
  set -l %caps $regex(caps,$strip($1-),/[A-Z]/g)
  set -l %norm $regex(caps,$strip($1-),/[^A-Z]/g)
  set -l %total $len($strip($1-))
  if ($prop == caps) { return %caps }
  elseif ($prop == ncaps) { return %norm }
  else { return $calc((%caps / %total) * 100) }

}

alias flood {
  if ($hget($+(prot.,$cid,.,$4)) != $+(prot.,$cid,.,$4)) hmake $+(prot.,$cid,.,$4) 1500
  var %h = $+(prot.,$cid,.,$4)
  var %h1 = $+($6,.,$5)
  var %h3 = $hget(%h,%h1)
  if (%h3) {
    var %counts = $gettok(%h3,1,46)
    var %c = $gettok(%h3,2,46)
    var %ct = $calc($ctime - $gettok(%h3,2,46))
    hadd -u [ $+ [ $calc($3 - %ct) ] ] %h %h1 $+($calc(%counts + $1),.,%c)
    if ($calc(%counts + 1) > $2) { return $+($gettok($hget(%h,%h1),1,46),.,$calc($ctime - $gettok($hget(%h,%h1),2,46))) }
  }
  else { hadd -u [ $+ [ $3 ] ] %h %h1 $+($1,.,$ctime) }
}

alias repeat {
  var %t = $hash($strip($7-),32)
  if ($hget($+(prot.,$cid,.,$4)) != $+(prot.,$cid,.,$4)) hmake $+(prot.,$cid,.,$4) 1500
  var %h = $+(prot.,$cid,.,$4)
  var %h1 = $+($6,.,$5)
  var %h3 = $hget(%h,%h1)
  if (%h3) {
    var %last.text = $gettok(%h3,3,46)
    if (%t == %last.text) {
      var %counts = $gettok(%h3,1,46)
      var %inccounts = $calc(%counts + 1)
    }
    elseif (%t != %last.text) {
      var %inccounts = 1
    }
    var %c = $gettok(%h3,2,46)
    var %ct = $calc($ctime - $gettok(%h3,2,46))
    hadd -u [ $+ [ $calc($3 - %ct) ] ] %h %h1 $+(%inccounts,.,%c,.,%t)
    if ($calc(%counts + $1) >= $2) { return $+($gettok($hget(%h,%h1),1,46),.,$calc($ctime - $gettok($hget(%h,%h1),2,46))) }
  }
  else { hadd -u [ $+ [ $3 ] ] %h %h1 $+($1,.,$ctime,.,%t) }
}
