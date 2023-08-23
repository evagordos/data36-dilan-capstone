#!/bin/bash

wget $IP_ADDRESS/testtask/dilans_data.csv

# creating four separate datasets according to the funnel

grep 'read' dilans_data.csv | grep 'AdWords\|Reddit\|SEO' > first_read.csv
grep 'read' dilans_data.csv | grep -v 'AdWords\|Reddit\|SEO' > returning_read.csv
grep 'subscribe' dilans_data.csv > subscribe.csv
grep 'buy' dilans_data.csv > buy.csv

