#!/bin/bash
shopt -s expand_aliases
source ~/.bash_aliases
helm uninstall free5gc-helm
kubectl delete -f loxilb.yaml
kubectl delete -f kube-loxilb.yaml
rm -rf /srv/nfs/mongodb/*
kubectl delete pvc datadir-mongodb-0
kubectl delete pvc datadir-mongodb-1
kubectl patch pv free5gc-pv-mongo -p '{"spec":{"claimRef": null}}'
kubectl patch pv free5gc-pv-cert -p '{"spec":{"claimRef": null}}'
sleep 35
kubectl patch pv free5gc-pv-cert -p '{"spec":{"claimRef": null}}'
