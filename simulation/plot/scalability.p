set terminal pngcairo size 350,262 enhanced font 'Verdana,10'
set output outfile
set title  scalatitle
set xlabel "workload"
set ylabel "evaluation"
set autoscale
set style line 1 linecolor rgb '#000000' lt 1 lw 5 pt 1 ps 1
set style line 2 linecolor rgb '#888888' lt 2  lw 5 pt 1 ps 1
set style line 3 linecolor rgb '#666666' lt 5 lw 5 pt 1 ps 1
set style line 4 linecolor rgb '#aaaaaa' lt 3 lw 5 pt 1 ps 1


#plot "ga-raw-0.88-20" u 1:30 title 'MobiQoR' w linespoints,\
#     "even-raw-0.88-20" u 1:30 title 'Even' w linespoints,\
#     "inverse-raw-0.88-20" u 1:30 title 'inverse' w linespoints,\
#     "loadbalance-raw-0.88-20" u 1:30 title 'loadbalance' w linespoints

plot datafile1 u 1:30 title 'MobiQoR' w linespoints,\
     datafile2 u 1:30 title 'Even' w linespoints,\
     datafile3 u 1:30 title 'inverse' w linespoints,\
     datafile4 u 1:30 title 'loadbalance' w linespoints

