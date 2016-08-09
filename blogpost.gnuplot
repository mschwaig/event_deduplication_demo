set term png
set output 'example1.png'

plot [0:8] 'example1_pdf.txt' with lines title 'PDF',\
           'example1_inputs.txt' pt 2 ps 3 title 'reported events',\
           'example1_outputs.txt' pt 1 ps 3 title 'consolidated events'
