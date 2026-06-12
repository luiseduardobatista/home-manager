#!/usr/bin/env bash
# monitor.sh — CPU% e MEM% lendo direto /proc
# Uso: monitor.sh {cpu|mem}

set -euo pipefail

CACHE_FILE="/tmp/tmux-monitor-$UID"

case "${1:-}" in
    cpu)
        # Lê /proc/stat atual
        read -r idle2 total2 < <(
            awk '/^cpu / {
                idle = $5; total = 0
                for (i = 2; i <= NF; i++) total += $i
                print idle, total
            }' /proc/stat
        )

        # Se existe cache, calcula delta (sem check de tempo)
        if [[ -f "$CACHE_FILE" ]]; then
            read -r idle1 total1 < "$CACHE_FILE"
            # Evita divisão por zero se os valores forem idênticos
            if [[ "$total1" != "$total2" ]]; then
                awk -v i1="$idle1" -v t1="$total1" -v i2="$idle2" -v t2="$total2" \
                    'BEGIN { printf "%.1f", 100 * (1 - (i2 - i1) / (t2 - t1)) }'
                echo "$idle2 $total2" > "$CACHE_FILE"
                exit 0
            fi
        fi

        # Sem cache ou valores idênticos, mostra 0 e salva
        printf "0"
        echo "$idle2 $total2" > "$CACHE_FILE"
        ;;
    mem)
        awk '/^MemTotal:/  { total = $2 }
             /^MemAvailable:/ { avail = $2 }
             END { printf "%.1f", 100 * (1 - avail / total) }' /proc/meminfo
        ;;
    *)
        echo "Usage: monitor.sh {cpu|mem}" >&2
        exit 1
        ;;
esac
