#!/bin/bash

while true;
do
        AP_SSID=`iwconfig 2>&1 | grep SSID | awk '{print $4 $5;}' | cut -d: -f2`
        AP_MAC=`iwconfig 2>&1 | grep "Access Point" | awk '{print $6}'`
        GATEWAY_IP=`route -n | head -n3 | tail -n1 | awk '{print $2}'`
        GATEWAY_MAC=`arp -n | grep -w "$GATEWAY_IP" | awk '{print toupper($3)}'`

        while [[ $AP_MAC == $GATEWAY_MAC ]];
        do
                sleep 1
                GATEWAY_IP=`route -n | head -n3 | tail -n1 | awk '{print $2}'`
                GATEWAY_MAC=`arp -n | grep -w "$GATEWAY_IP" | awk '{print toupper($3)}'`
        done
        notify-send --hint int:transient:1 --urgency=critical \
                "MITM Detected ($AP_SSID)" "Original: ${AP_MAC} \n Now: ${GATEWAY_MAC}"
        sleep 5
done
