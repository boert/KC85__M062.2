# M062.2, Speichermodul für KC85

- für die RAM-Version des M62.2
- CAOS 4.8


## prepare_M062FILL.py

konvertiert eine Binärdatei in vier einzelne Segmentdateien
M062SEG0.KCC
M062SEG1.KCC
M062SEG2.KCC
M062SEG3.KCC


## FILLM062.KCC
sucht nach dem ersten Modul M062 und lädt die Segmentdateien in das Speichermodul
