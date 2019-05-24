#!/bin/sh
cmd="${1:-start}" 
set -ex
systemctl $cmd osmo-hlr osmo-msc osmo-mgw osmo-ggsn osmo-sgsn osmo-stp osmo-bsc osmo-hnbgw osmo-bts-trx osmo-pcu