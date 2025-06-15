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
kubectl patch pv free5gc-pv-mongo-1 -p '{"spec":{"claimRef": null}}'
kubectl patch pv free5gc-pv-cert -p '{"spec":{"claimRef": null}}'
sleep 40 # wait for all pods to shut down
kubectl patch pv free5gc-pv-cert -p '{"spec":{"claimRef": null}}'
helm upgrade free5gc-helm ~/free5gc-helm/charts/free5gc/ --set global.n1network.masterIf="enp7s0" --set global.n2network.masterIf="enp7s0" --set global.n3network.masterIf="enp7s0" --set global.n4network.masterIf="eth0" --set global.n9network.masterIf="eth0" --set global.n6network.masterIf="eth0" --install
kubectl apply -f ~/loxilb/loxilb.yaml
kubectl apply -f ~/loxilb/kube-loxilb.yaml
