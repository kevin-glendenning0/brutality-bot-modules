
on $*:TEXT:*:*: {
  if ($regex($1-,/^[!@]y(t|ube|search|outube)/Si)) {
    var %r $r(1,9999)
    sockopen youtube. $+ %r www.youtube.com 80
    sockmark youtube. $+ %r $iif($left($strip($1),1) == !, .notice $nick, msg $iif($chan,$chan,$nick)) results?search_query= $+ $replace($2-,$chr(32),+)
  }
  elseif ($regex($1-,/(youtube.com|youtu.be)\/(.+)/i)) {
    var %r $r(1,9999)
    sockopen youtube. $+ %r www.youtube.com 80
    sockmark youtube. $+ %r $iif($chan, msg $chan, msg $nick) $strip($regml(2))
  }
}
on *:input:*: {
  if $left($1,1) != / {
    if ($regex($1-,/^[!@]y(t|ube|search|outube)/Si)) {
      var %r $r(1,9999)
      sockopen youtube. $+ %r www.youtube.com 80
      sockmark youtube. $+ %r $iif($left($strip($1),1) == !, .notice $me, msg $chan) results?search_query= $+ $replace($2-,$chr(32),+)
    }
    elseif ($regex($1-,/(youtube.com|youtu.be)\/(.+)/i)) {
      var %r $r(1,9999)
      sockopen youtube. $+ %r www.youtube.com 80
      sockmark youtube. $+ %r $iif($chan, msg $chan, msg $nick) $strip($regml(2))
    }
  }
}
on *:sockopen:youtube.*: {
  sockwrite -nt $sockname GET / $+ $gettok($sock($sockname).mark,3,32) HTTP/1.1
  sockwrite -nt $sockname HOST: www.youtube.com
  sockwrite -nt $sockname $crlf
}
on *:sockread:youtube.*: {
  var %reader
  sockread %reader
  if $regex(%reader,a href="/(.*?)".*class=.*title="(.*?)") {
    var %r $r(1,9999)
    .sockopen youtube. $+ %r www.youtube.com 80
    sockmark youtube. $+ %r $gettok($sock($sockname).mark,1-2,32) $regml(1) | set %yt.link 10Link:4 http://www.youtu.be/ $+ $regml(1)
    sockclose $sockname
  }  
  if $regex(%reader,/<meta itemprop="name" content="(.*?)"/Si) { set %yt.title $regml(1) } 
  elseif $regex(%reader,/<meta itemprop="description" content="(.*?)"/Si) {  set %yt.description $regml(1) }
  elseif $regex(%reader,/rel="author" href="/user/(.*?)"/Si) { set %yt.user $regml(1) }
  elseif $regex(%reader,<span class="likes">(.*?)</span>.*<span class="dislikes">(.*?)</span>) {
    tokenize 32 $sock($sockname).mark 
    $1 $2  1,0You0,4Tube  10Title:4 $replace(%yt.title,&#39;,',&quot;,") 10User:4 %yt.user 10Likes:4 $regml(1) 10Dislikes:4 $regml(2) 10Description:4 $replace(%yt.description,&#39;,',&quot;,") $iif(%yt.link,%yt.link,$chr(32))
    sockclose $sockname | unset %yt*
  }
}

