on 5:TEXT:*:#: {
  if ($1 = $+(%prefix,k)) { kick # $2- }
  if ($1 = $+(%prefix,kb)) { ban -k # $2 4 }
  if ($1-2 = $+(%prefix,op) me) { mode # +o $nick }
}
