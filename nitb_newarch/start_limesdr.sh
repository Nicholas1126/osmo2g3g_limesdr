#!/bin/bash

osmo-hlr -l hlr.db -c osmo-hlr.cfg
osmo-msc -c osmo-msc.cfg
osmo-mgw -c osmo-mgw-for-msc.cfg
osmo-mgw -c osmo-mgw-for-bsc.cfg
osmo-ggsn -c osmo-ggsn.cfg
osmo-sgsn -c osmo-sgsn.cfg
osmo-stp -c osmo-stp.cfg
osmo-bsc -c osmo-bsc.cfg
osmo-hnbgw -c osmo-hnbgw.cfg

# on a 2G limesdr:
osmo-sip-connector -c osmo-sip-connector.cfg
osmo-bts-trx -c osmo-bts.cfg -s
osmo-trx-lms -C limesdr.cfg
osmo-pcu -c osmo-pcu.cfg

