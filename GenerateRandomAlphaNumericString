#!/usr/bin/sh

# Generate a pseudo-random alphanumeric string of specified length
# Accepts one parameter: the length of the string to generate (range 1-32767) (default: 10)

# shellcheck disable=SC2155
GenerateRandomAlphaNumericString() {

    char_list="abcdefghijklmnopqrstuvwxyz0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    result_length=${1:-10}
    result_string=""

    # If the length requested is outside sane upper and lower bounds, reset it
    [ "$result_length" -lt 1 ] && result_length=1
    [ "$result_length" -gt 32767 ] && result_length=32767

    # Loop result_length times
    while [ "${#result_string}" -lt "$result_length" ]
    do

        # Randomly choose one offset of length one from char_list
        character=$(printf '%s' "$char_list" | cut -b$(( ($(shuf -i 1-32767 -n1) % 62) + 1 )) )

        # Concatenate character onto result_string
        result_string=${result_string}${character}

    done

    # "Return" the resulting string
    printf '%s' "$result_string"

    return 0

}

GenerateRandomAlphaNumericString "${1:-50}"
