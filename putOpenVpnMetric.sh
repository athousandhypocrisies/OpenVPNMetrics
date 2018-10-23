#!/bin/bash

SACLI_LOC=/usr/local/openvpn_as/scripts
CONCURRENT_USERS=$(echo "{licUsage:" $(${SACLI_LOC}/sacli LicUsage | jsawk ) "}"| jsawk 'return this.licUsage[0]')
LICENSED_USERS=$(echo "{licUsage:" $(${SACLI_LOC}/sacli LicUsage | jsawk ) "}"| jsawk 'return this.licUsage[1]')
INSTANCE_ID=$(wget -O - -q http://169.254.169.254/latest/meta-data/instance-id)

aws \
        cloudwatch \
        put-metric-data \
                --namespace OpenVPN \
                --metric-name ConcurrentUsers \
                --value ${CONCURRENT_USERS} \
                --dimensions InstanceID=${INSTANCE_ID} \
		--region us-east-1


aws \
        cloudwatch \
        put-metric-data \
                --namespace OpenVPN \
                --metric-name LicensedUsers \
                --value ${LICENSED_USERS} \
                --dimensions InstanceID=${INSTANCE_ID} \
		--region us-east-1



