#! /usr/bin/env python
import json
from datetime import datetime, timedelta
import os
import argparse
import sys

def get_log_files(path):
    files = []
    for myfile in os.listdir(path):
        if myfile.endswith(".log"):
            match = os.path.join(path, myfile)
            files.append(match)

    return files


if __name__=='__main__':
    parser = argparse.ArgumentParser(description='Fixes dates on json format bro logs relative to some time period')

    parser.add_argument('-i', '--logs_input', help='Path where logs will be modified.', required=True)
    parser.add_argument('-o', '--logs_output', help='Path where logs will be dropped.', required=True)
    parser.add_argument('-hr', '--hours', help='Number hours from curent time to adjust logs to.', required=True)

    args = parser.parse_args()

    if not os.path.exists(args.logs_input):
        print "\nSupplied log_directory path did not exist.  Exiting.\n"
        parser.print_help()
        sys.exit(1)

    if not os.path.exists(args.logs_output):
        os.makedirs(args.logs_output)

    try:
        hours = int(args.hours)
    except:
        print "\nMust supply a valid number of hours relative to current time to start logs from."
        parser.print_help()
        sys.exit(1)

    input_path = args.logs_input
    output_path = args.logs_output
    files = get_log_files(input_path)
    d = datetime.today() - timedelta(hours=hours)
    new_start_time = int(d.strftime('%s'))

    for log_file in files:
        print log_file
        with open(log_file) as mylog:
            logs = mylog.readlines()
    
        orig_start_time = json.loads(logs[0]).get('ts', 0)
        os.remove(log_file)
        
        with open(os.path.join(output_path, os.path.basename(log_file)), 'wb') as write_log:
            for log in logs:
                log_dictionary = json.loads(log)
                event_time = log_dictionary.get('ts', -1)
                if event_time > -1:
                    log_dictionary['ts'] = float(event_time) - orig_start_time + new_start_time
                write_log.write(json.dumps(log_dictionary) + '\n')

