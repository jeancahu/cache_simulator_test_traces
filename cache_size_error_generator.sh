#!/bin/bash

# $1 block size
# $2 cache size (KiB)
# $3 asociatividad

set -e

declare -i CACHE_SIZE
declare -i TAG
declare -i NUM

[ $# != 3 ] && exit 1

(( CACHE_SIZE = $2 * 1024 / $3 ))

# echo $(( $( bc <<< "ibase=10;obase=2;$1" | wc -c ) -2 ))
# echo $(( $( bc <<< "ibase=10;obase=2;$CACHE_SIZE" | wc -c ) -2 ))

NUM=$( shuf -i 0-$(( ( CACHE_SIZE / $1 ) -1 )) -n 1 )

for ITERA in {0..99}
do

TAGS=( $( shuf -i 0-$(( 4294967296 / CACHE_SIZE )) -n $(( $3 + 1 )) ) )

for TAG in ${TAGS[@]}
do
	RESULT="00000000$( bc <<< "ibase=10;obase=16;$(( ( TAG * CACHE_SIZE )+(NUM*$1) + ( RANDOM%$1 ) ))" )"
	echo "# $(( RANDOM%2 )) $( echo ${RESULT: -8} | tr 'A-F' 'a-f' ) $(( RANDOM%10 + 5 ))"
done

done

exit 0
