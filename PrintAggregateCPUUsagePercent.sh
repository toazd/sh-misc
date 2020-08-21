#!/bin/sh
# vim:set ft=shell nowrap et sta shiftwidth=4 ts=8 sts=0
#
#############
## Purpose ##
#############
#
# Parse /proc/stat for aggregate cpu usage and report it in %
#
###############
## Reference ##
###############
#
# https://stackoverflow.com/questions/23367857/accurate-calculation-of-cpu-usage-given-in-percentage-in-linux
#
# https://man7.org/linux/man-pages/man5/proc.5.html
#
# https://www.kernel.org/doc/Documentation/filesystems/proc.txt
#

set -hu

PrintAggregateCPUUsagePercent() {

    bash_only=1                       # 1=[use only bash arithmatic) 0=[use bc]
    printf_scale=1                    # If bc is used, how many decimal places to show
    printf_minwidth=3                 # Minimum width for printf field, padded with leading spaces (NOTE GNU printf does not support min width modifier for %s)
    bc_scale=$(( printf_scale + 1 ))  # bc_scale must be one higher than printf_scale for rounding
    num_samples=4                     # total_avg = tally / ( num_samples - 1 )
    sample_period_seconds="0.25"      # Time in seconds to sleep between iterations
    print_newline=1                   # 1=[Print a newline after n%] 0=[Do not print a newline after n%]
    tally=0                           # Cumulative average
    total_avg=0                       # Final cumulative average divided by number of samples
    idle=0
    prev_idle=0
    busy=0
    total=0
    prev_total=0
    delta_total=0
    delta_idle=0
    label=''
    usage_percent=0
    user=0
    nice=0
    system=0
    idle=0
    iowait=0
    irq=0
    softirq=0
    steal=0
    xtra=''
    i=0

    [ $num_samples -lt 1 ] && num_samples=1 # num_samples must be > 0

    while [ $i -le $(( num_samples + 1 )) ]; do
        while IFS=' ' read -r label user nice system idle iowait irq softirq steal xtra; do
            case $label in
                (cpu)
                    idle=$(( idle + iowait ))
                    busy=$(( user + nice + system + irq + softirq + steal ))
                    total=$(( idle + busy ))

                    delta_total=$(( total - prev_total ))
                    delta_idle=$(( idle - prev_idle ))

                    # Skip the first iteration
                    [ $i -gt 0 ] && {
                        if [ $bash_only -eq 1 ]; then
                            usage_percent=$(( (delta_total - delta_idle) * 100 / delta_total ))
                            [ $i -gt 1 ] && tally=$(( tally + usage_percent ))
                        elif [ $bash_only -eq 0 ]; then
                            usage_percent=$( echo "scale=$bc_scale; (($delta_total - $delta_idle) *100) / $delta_total" | bc -l )
                            [ $i -gt 1 ] && tally=$( echo "scale=$bc_scale; ($tally + $usage_percent)" | bc -l )
                        fi
                    }

                    [ $i -gt 1 ] && echo "($((i-1))) usage: $usage_percent tally: $tally" # For debug and double-checking results

                    prev_idle=$idle
                    prev_total=$total

                    sleep "$sample_period_seconds"s
                ;;
            esac
        done < /proc/stat
        i=$(( i + 1 ))
    done

    [ $i -eq $(( num_samples + 2 )) ] && {
        if [ $bash_only -eq 1 ]; then
            total_avg=$(( tally / num_samples ))
            if [ $total_avg -gt 0 ]; then
                if [ $print_newline -eq 1 ]; then
                    echo "${total_avg}%"
                elif [ $print_newline -eq 0 ]; then
                    printf '%s' "${total_avg}%"
                fi
            else
                if [ $print_newline -eq 1 ]; then
                    echo "<1%"
                elif [ $print_newline -eq 0 ]; then
                    printf '%s' "<1%"
                fi
            fi
        elif [ $bash_only -eq 0 ]; then
            total_avg=$( echo "scale=$bc_scale; ($tally / $num_samples)" | bc -l )
            total_avg=$( printf "%${printf_minwidth}.${printf_scale}f" "$total_avg" )
            if [ $print_newline -eq 1 ]; then
                echo "${total_avg%.0}%"
            elif [ $print_newline -eq 0 ]; then
                printf '%s' "${total_avg%.0}%"
            fi
        fi
    }
}

PrintAggregateCPUUsagePercent

