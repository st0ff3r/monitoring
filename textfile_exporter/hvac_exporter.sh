#!/bin/bash
set -e

HVAC_IP="${HVAC_IP:-10.0.1.19}"
OUTPUT_FILE="/data/hvac.prom"
mkdir -p /data

while true; do
  CO2=$(mbtget -r4 -a 100 -s $HVAC_IP | perl -ne 'chomp; s/;//; print $_')
  SUPPLY_AIR_VOLUME=$(mbtget -r4 -a 94 -s $HVAC_IP | perl -ne 'chomp; s/;//; print $_')
  EXHAUST_AIR_VOLUME=$(mbtget -r4 -a 95 -s $HVAC_IP | perl -ne 'chomp; s/;//; print $_')
  OUTSIDE_AIR_TEMP=$(mbtget -r4 -a 71 -s $HVAC_IP | perl -ne 'chomp; s/;//; print unpack(q[s>], pack(q[cc], 0xff & ($_ >> 8), 0xff & $_)) / 10')
  SUPPLY_AIR_TEMP=$(mbtget -r4 -a 72 -s $HVAC_IP | perl -ne 'chomp; s/;//; print unpack(q[s>], pack(q[cc], 0xff & ($_ >> 8), 0xff & $_)) / 10')
  ROOM_TEMP=$(mbtget -r4 -a 74 -s $HVAC_IP | perl -ne 'chomp; s/;//; print unpack(q[s>], pack(q[cc], 0xff & ($_ >> 8), 0xff & $_)) / 10')
  RETURN_AIR_TEMP=$(mbtget -r4 -a 75 -s $HVAC_IP | perl -ne 'chomp; s/;//; print unpack(q[s>], pack(q[cc], 0xff & ($_ >> 8), 0xff & $_)) / 10')
  EXHAUST_AIR_TEMP=$(mbtget -r4 -a 76 -s $HVAC_IP | perl -ne 'chomp; s/;//; print unpack(q[s>], pack(q[cc], 0xff & ($_ >> 8), 0xff & $_)) / 10')
  COOLING=$(mbtget -r4 -a 32 -s $HVAC_IP | perl -ne 'chomp; s/;//; print $_')
  HEAT_EXCHANGER=$(mbtget -r4 -a 35 -s $HVAC_IP | perl -ne 'chomp; s/;//; print $_')
  HEATING=$(mbtget -r4 -a 39 -s $HVAC_IP | perl -ne 'chomp; s/;//; print $_')

  cat > "$OUTPUT_FILE" <<EOF
# HELP hvac_co2 CO2 ppm
# TYPE hvac_co2 gauge
hvac_co2 $CO2

# HELP hvac_supply_air_volume Supply air volume m³/h
# TYPE hvac_supply_air_volume gauge
hvac_supply_air_volume $SUPPLY_AIR_VOLUME

# HELP hvac_exhaust_air_volume Exhaust air volume m³/h
# TYPE hvac_exhaust_air_volume gauge
hvac_exhaust_air_volume $EXHAUST_AIR_VOLUME

# HELP hvac_outside_air_temp Outside air temperature °C
# TYPE hvac_outside_air_temp gauge
hvac_outside_air_temp $OUTSIDE_AIR_TEMP

# HELP hvac_supply_air_temp Supply air temperature °C
# TYPE hvac_supply_air_temp gauge
hvac_supply_air_temp $SUPPLY_AIR_TEMP

# HELP hvac_room_temp Room temperature °C
# TYPE hvac_room_temp gauge
hvac_room_temp $ROOM_TEMP

# HELP hvac_return_air_temp Return air temperature °C
# TYPE hvac_return_air_temp gauge
hvac_return_air_temp $RETURN_AIR_TEMP

# HELP hvac_exhaust_air_temp Exhaust air temperature °C
# TYPE hvac_exhaust_air_temp gauge
hvac_exhaust_air_temp $EXHAUST_AIR_TEMP

# HELP hvac_cooling Cooling power
# TYPE hvac_cooling gauge
hvac_cooling $COOLING

# HELP hvac_heat_exchanger Heat exchanger state
# TYPE hvac_heat_exchanger gauge
hvac_heat_exchanger $HEAT_EXCHANGER

# HELP hvac_heating Heating power
# TYPE hvac_heating gauge
hvac_heating $HEATING
EOF

  sleep 10
done
