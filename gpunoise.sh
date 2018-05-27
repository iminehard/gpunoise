#!/bin/bash
#
# gpunoise - a basic script to do spectrum scans, intended to evaluate the effect of open
# air crypto currency mining "rigs" on LTE spectrum
#
# https://www.reddit.com/user/iminehard
# License - BSD 3 clause (sure)
#

# Pass an argument to add a suffix to each scan
if [ -n "$1" ]; then
  SUFFIX="-$1"
fi

# Uses this excellent software:
# https://eartoearoak.com/software/rtlsdr-scanner

# Ranges to scan
# Format is start freq:end freq:name for range
# Default to rough ranges to include uplink and downlink for all LTE providers in the US
# The E4000 has a top end of 2200 MHz but scanning up to that range is unreliable
RANGES="617:746:uslte1 1710:1790:uslte2 2110:2190:uslte3"

# Number of sweeps
SWEEPS="1"

# Delay between sweeps
DELAY="0"

# Gain (0 triggers default)
GAIN="0"

# Time to dwell in seconds
DWELL="0.008"

# FFT (see docs)
FFT="1024"

# RTL-SDR device to use
INDEX="0"

# Build scanner command
CMD="python2 -m rtlsdr_scanner -w $SWEEPS -p $DELAY -g $GAIN -d $DWELL -f $FFT -i $INDEX"

for i in $RANGES; do
  # Gangster, who cares
  START=$(echo $i | cut -d":" -f1)
  END=$(echo $i | cut -d":" -f2)
  NAME=$(echo $i | cut -d":" -f3)
  $CMD -s "$START" -e "$END" "$NAME""$SUFFIX".rfs
done
