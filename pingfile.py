#!/usr/bin/python
"""
This script ping hosts one/multiple times with varying packet sizes
"""
import re
import csv
import time
import requests

#CSV file
csv_connection = open("nicru20test.csv", 'wb')
writer = csv.writer(csv_connection)
writer.writerow([
        'time', 'host_name', 'packet_size', 'min',
        'avg', 'max', 'deviation', 'loss_percent'
    ])

# Requests metadata
proxyDict = {
    "http" : "http://172.16.114.233:3344",
    "https" : "https://172.16.114.233:3344"
}
headers = {
    'User-Agent': 'Mozilla/5.0'
}

host_name_list = [
    "google.com", "iitg.ac.in", "nic.ru", "imare.in", "bewakoof.com"
]
size_list = [64, 128, 256, 512, 1024, 2048]


TIME_RUN = 1

def ping_all_hosts():
    """ Ping multiple hosts with multiple packet size"""
    size_list2 = [64]
    for ping_size in size_list2:
        for ping_host_name in host_name_list:
            # url varies with host and ping size
            url = "http://www.spfld.com/cgi-bin/ping?remote_host=" + \
                    str(ping_host_name) + "&dns=on&count=20&size=" + \
                    str(ping_size)
            # get request
            req = requests.get(url, headers=headers, proxies=proxyDict)
            # request data analysis
            ping_data = req.text.splitlines()[4]
            loss_line = req.text.splitlines()[3]
            #loss
            loss = re.search(r'\d+%', loss_line).group(0)[:-1]
            # timinings
            ping_digits = r"\d+\.\d+/\d+\.\d+/\d+\.\d+/\d+\.\d+"
            ping_min, ping_avg, ping_max, ping_sd = \
                    re.search(ping_digits, ping_data).group(0).split('/')
            writer.writerow([
                    TIME_RUN, ping_host_name, ping_size, ping_min,
                    ping_avg, ping_max, ping_sd, loss
                ])
            print ping_host_name + " pinged " + str(ping_size) + "bytes"

#  pings only one host arg_n number of times for different packet sizes
def one_host_n_times(ping_host_name, arg_n):
    """ Ping one host multiple times with varying packet sizes"""
    # ping each size arg_n times
    for _ in range(arg_n):
        # for each ping size
        for ping_size in size_list:
            # delay for 1 second
            time.sleep(1)
            # URL to be pinged
            url = "http://www.spfld.com/cgi-bin/ping?remote_host=" + \
                    str(ping_host_name) + "&dns=on&count=20&size=" + \
                    str(ping_size)
            # get request
            req = requests.get(url, headers=headers, proxies=proxyDict)
            # ping_data
            ping_time = req.text.splitlines()[4]
            ping_loss = req.text.splitlines()[3]
            # loss
            loss = re.search(r'\d+%', ping_loss).group(0)[:-1]
            # timinings
            ping_digits = r"\d+\.\d+/\d+\.\d+/\d+\.\d+/\d+\.\d+"
            ping_min, ping_avg, ping_max, ping_sd = \
                    re.search(ping_digits, ping_time).group(0).split('/')
            writer.writerow([
                    TIME_RUN, ping_host_name, ping_size, ping_min,
                    ping_avg, ping_max, ping_sd, loss
                ])
            print ping_host_name + " pinged " + str(ping_size) + "bytes"


def main():
    """ main function for the script """
    one_host_n_times("nic.ru", 20)
    # for _ in range(20):
    #   ping_all_hosts()

main()

