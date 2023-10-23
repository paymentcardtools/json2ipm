def lpad($val; $len):
    ($val | tostring | length) as $l
    | "\("0" * ($len - $l))\($val)"
    ;

# calculate total of amounts for PDS 0301
([ .[] | if .de4 != null then .de4|tonumber else 0 end ]  | add) as $total 

# adjust sequentially all the DE 71 (Message Number)
| [ foreach .[] as $item (0; .+1; $item + {"de71":lpad(.; 8)}) ]

# update totals and count in the trailer
| last.pds0301 = lpad($total; 16) 
| last.pds0306 = last.de71
