set terminal pngcairo size 350,262 enhanced font 'Verdana,10'
set output outfile
set title  alphatitle
set xlabel "alpha"
set ylabel "evaluation"
#set xr [0:500]
set autoscale
set style line 1 linecolor rgb 'red' lt 1 lw 1 pt 1 ps 1
set style line 2 linecolor rgb 'blue' lt 2  lw 1 pt 1 ps 1
set style line 3 linecolor rgb 'violet' lt 4 lw 1 pt 1 ps 1
set style line 4 linecolor rgb 'black' lt 3 lw 1 pt 1 ps 1

plot datafile1 u 3:30 title 'MobiQoR' w linespoints smooth csplines ls 1,\
     datafile2 u 3:30 title 'Even' w linespoints smooth csplines ls 2,\
     datafile3 u 3:30 title 'inverse' w linespoints smooth csplines ls 3,\
     datafile4 u 3:30 title 'loadbalance' w linespoints  smooth csplines ls 4

