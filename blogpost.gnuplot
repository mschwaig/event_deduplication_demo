set term png
set output 'example1.png'

plot [0:8] 'example1_pdf.dat' with lines title 'PDF',\
           'example1_inputs.dat' pt 2 ps 3 title 'reported events',\
           'example1_outputs.dat' pt 1 ps 3 title 'consolidated events'
