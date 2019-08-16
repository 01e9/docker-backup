#!/usr/bin/env bash

if ! [ -f /etc/resilio.conf ]; then
    SECRET_RW="${RESILIO_SECRET_RW:-$(rslsync --generate-secret)}"
    SECRET_RO=$(rslsync --get-ro-secret "${SECRET_RW}")
    echo "Resilio ready-only secret: ${SECRET_RO}"

    cp /etc/resilio.conf.template /etc/resilio.conf
    sed -i "s/SECRET/${SECRET_RW}/" /etc/resilio.conf
fi

rslsync --config /etc/resilio.conf
