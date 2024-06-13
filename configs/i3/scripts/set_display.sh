#!/bin/bash

# Obtenha os nomes dos monitores
monitores=$(xrandr --query | grep " connected" | cut -d" " -f1)

# Para cada monitor conectado
for monitor in $monitores; do
	# Obtenha a resolução e a taxa de atualização máxima
	mode_line=$(xrandr --query | grep -A1 $monitor | tail -n 1)
	max_res=$(echo $mode_line | grep -oP '\d+x\d+(?=\s+\d+\.\d+\*)' | head -n 1)
	max_rate=$(echo $mode_line | grep -oP '\d+\.\d+' | sort -nr | head -n 1)

	# Exiba os valores das variáveis (para depuração)
	# echo "Monitor: $monitor"
	# echo "Resolução máxima: $max_res"
	# echo "Taxa de atualização máxima: $max_rate"

	# Defina a resolução e a taxa de atualização
	if [ -n "$max_res" ] && [ -n "$max_rate" ]; then
		xrandr --output $monitor --mode $max_res --rate $max_rate
	else
		echo "Não foi possível obter a resolução ou taxa de atualização para $monitor"
	fi
done
