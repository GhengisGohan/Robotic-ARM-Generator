import csv
import time
from selenium import webdriver

## Check if a string is a number greater than 0
def isNumGreatThanZero(value):
  try:
    num = float(value)
    if (num > 0):
        return True
    else:
        return False
  except:
    return False

def log(logfile, str):
    print str
    logfile.write(str + '\n')
    return


## Use PhantomJS through selenium webdriver
driver = webdriver.PhantomJS()                  # Get new connection/ this can go outside the loop.
driver.set_window_size(1120, 550)               # Set windows size, just for screenshoots debug

## Open CSV Output file
newfile = open("HobbyKingServos.csv", 'w')
## Open Log Output file
logfile = open("HobbyKingServos.log", 'w')


## Blacklisted Servos SKU (Product Number) like Slim Wing Servos
blacklist = ['014000008', '014000009', '014000012', '014000013', '122000019-0', 
            'TGY-A55H', 'BMS-555MG', '9355000005', '9355000006', '9355000007',
            '9355000027', '9355000060-0', '9225000001', '573000014-0', '458000006-0',
            '458000007-0', '458000008-0', '458000009-0', '9215000052-0', '9215000063-0']


ITNUM = 5
iteration = 0
flag_writedata = True
fieldnames = ['Servo', 'Weight(g)','Torque(kg)(min. 0.01kg)','Speed (Sec/60deg)',
              'A(mm)', 'B(mm)', 'C(mm)', 'D(mm)', 'E(mm)', 'F(mm)']

## Read CSV file with the Links and get servo data from Hobbyking webpage. 
with open('HobbyKingServosLinks.csv', 'rb') as f:
    reader = csv.reader(f)
    writer = csv.DictWriter(newfile, fieldnames=fieldnames)
    writer.writeheader()

    for row in reader:

        ## Reset values
        data = {}
        flag_writedata = True

        ## Parse and get Servo Webpage Links 
    	data['Servo'] = row[0]

        ## Get web link
        #driver.get('file:///home/jorge/Documents/RoboticARM/hobbyking.html')
        driver.get(data['Servo'])
        ## For DEBUG Only (Prints WebPage Screenshot)
        # driver.save_screenshot('screenie.png')

        ## Get length of elements of the Table
        span_len = len(driver.find_elements_by_xpath("//ul[@class='list-attribute-product']/li/span"))
        div_len = len(driver.find_elements_by_xpath("//ul[@class='list-attribute-product']/li/div"))
        table_length = 0
        if ( span_len != div_len ):
            log(logfile, "Fatal: Table contents doesn't match in {}".format(data['Servo']))
            break
        else:
            table_length = span_len

        if (table_length < 16):
            log(logfile, "Warning! Servo Discarded: Less data than expected in {}".format(data['Servo']))
            flag_writedata = False
            continue

        ## Get the elements
        try:
            for i in range(1, table_length+1):
                span = driver.find_element_by_xpath("//ul[@class='list-attribute-product']/li["+str(i)+"]/span")
                span = span.get_attribute('innerHTML')
                span = span.encode('ascii', 'ignore').replace(":", "")
                div = driver.find_element_by_xpath("//ul[@class='list-attribute-product']/li["+str(i)+"]/div")
                div = div.get_attribute('innerHTML')
                div = div.encode('ascii', 'ignore')

                ## Ignore Blacklisted parts.
                if (span == 'SKU'):
                    if (div in blacklist):
                        ## Blacklisted part, don't write this data
                        log(logfile, "Warning! Servo Discarded:  blacklisted servo {}".format(data['Servo']))
                        flag_writedata = False
                        break
                    else:
                        ## Write this data
                        flag_writedata = True

                ## Only use this servo data
                if ( (span == 'Weight(g)') or 
                     (span == 'Torque(kg)(min. 0.01kg)') or 
                     (span == 'Speed (Sec/60deg)') or
                     (span == 'A(mm)') or
                     (span == 'B(mm)') or
                     (span == 'C(mm)') or
                     (span == 'D(mm)') or 
                     (span == 'E(mm)') or 
                     (span == 'F(mm)') ) :
                    ## Check if data is a number and is > 0.00
                    if (isNumGreatThanZero(div)):
                        data[span] = div
                    else:
                        ## No data, don't write this data.
                        log(logfile, "Warning! Servo Discarded:  No data for {} in {}".format(span, data['Servo']))
                        flag_writedata = False
                        break

        except:
            log(logfile, "Fatal: Error or Exception parsing webpage data in {}".format(data['Servo']))
            break

        ## Save Data in CSV
        if (flag_writedata == True):
            #print data
            writer.writerow(data)
        #print "{} {}".format(span, div)

        ## Save Data in JSON
        #newfile.write(str(data) + '\n')


        # DEBUG only 
        # iteration = iteration + 1
        # if (iteration >= ITNUM):
        #     break
    
# driver.quit()
logfile.close()
newfile.close()