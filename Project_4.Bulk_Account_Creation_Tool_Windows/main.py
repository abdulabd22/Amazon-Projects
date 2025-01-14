import os
import time
import csv

from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.chrome.service import Service
from multiprocessing import Pool
from functools import partial

from Localeinfo import get_url
from otp import require_otp

account_list = []
password_list = []
cid_list = []
locale_list = []


def run(locale,url,Base_Account,Password,Account_suffix,value):
    try:
        wd = os.getcwd()
        options = webdriver.ChromeOptions()
        options.add_argument("start-maximized")

        driver = webdriver.Chrome(options=options, executable_path=wd + '/chromedriver')
        driver.get(url)
        time.sleep(3)

        # get the form field elements
        customer_name = driver.find_element("id", "ap_customer_name")
        pronunciation = None
        try:
            pronunciation = driver.find_element("id", "ap_customer_name_pronunciation")
        except:
            print('no pronunciation tab')
        username = driver.find_element("id", "ap_email")
        password = driver.find_element("id", "ap_password")
        password_confirm = driver.find_element("id", "ap_password_check")

        
        if locale == 'jp':
            # country or region
            # driver.sendKeys(Keys.DOWN)
            driver.execute_script("window.scrollTo(0, 350)")
            driver.find_element("xpath",
                                "/html/body/div[1]/div[2]/div/div/div/div/div/div[5]/div/div/div[5]/div/div/div/div/div/div/div/div/div[2]/div").click()
            time.sleep(2)
            driver.find_element("xpath", "//*[@id='country_change_myx ']/span/button/span").click()

            time.sleep(3)
            #
            zip1 = str(address[7])
            zip2 = zip1[-4:]
            driver.find_element('xpath',
                                '/html/body/div[3]/div/div[2]/div/div/div/div/div[2]/div/div/div/span/span[2]/span/div/div/input').send_keys(
                zip1)
            driver.find_element('xpath',
                                '/html/body/div[3]/div/div[2]/div/div/div/div/div[2]/div/div/div/span/span[3]/span/div/div[1]/input').send_keys(
                zip2)
            driver.find_element('xpath', '//*[@id="adr_AddressLine1"]').send_keys(str(address[3]))
            driver.find_element('xpath', '//*[@id="adr_AddressLine2"]').send_keys(str(address[4]))
            driver.find_element('xpath', '//*[@id="adr_PhoneNumber"]').send_keys(str(address[8]))
            time.sleep(2)
            driver.find_element('xpath', '//*[@id="dialogButton_ok_myx "]/span/button/span').click()

     
       
        print("Account created with cid = {}".format(cid))

        # Close driver
        # driver.close()

        return email,passkey,cid

    except Exception as e:
        print(e)
        email = Base_Account + str(value) + '_' + locale + Account_suffix
        print(f"Some error occurred during the process for account creation of {email} in {locale}. "
              f"Can you please try again by executing the script again?. Sorry for the inconvenience caused.")
        return None


def myfunc():
    mydict = {}
    userChoice = 'y'

    while userChoice=='y':
        locale = input('Enter the locale(us,de,uk,br,au,ca,it,jp,mx,es,fr,in,nl): ')
        Accounts = input('Enter the Number of Accounts Required: ')

        mydict[str(locale)] = Accounts

        print()  # blank line
        choice = input('Want to create accounts for more locales ?(y/n): ')
        print()  # blank line

        if choice=='y' or choice=='Y':
            userChoice = 'y'
        elif choice=='n' or choice=='N':
            userChoice = 'n'
        else:
            print('Wrong input!! Considering answer as no')
            userChoice = 'n'

    Base_Account = input('Enter the base account(user+test): ')
    Account_suffix = '@amazon.com'
    Password = input('Enter the password for the account(min 6 characters): ')

    while len(Password) < 6:
        print("Password must be six characters atleast.")
        Password = input('Enter the password again for the account(min 6 characters): ')


    for locale in mydict:   #sequential loop
        print()  #blank line
        print('Starting account creation for locale = {} '.format(locale))
        print('No of Accounts to be created = {} '.format(mydict[locale]))

        account_list.clear()
        password_list.clear()
        cid_list.clear()

        values = []
        for i in range(int(mydict[locale])):
            values.append(i)

   
        # write to csv
        wd = os.getcwd()
        with open(wd + '/Csv_Files/' + csv_name, 'a', newline='') as file:
            print("Writing to CSV File")
            writer = csv.writer(file)
            writer.writerow(["S.No", "Account", "Password", "CID"])
            looplen = len(account_list)
            for i in range(0, looplen):
                row = i + 1
                print("writing record = {}".format(i + 1))
                writer.writerow([row, account_list[i], password_list[i], cid_list[i]])

            writer.writerow([])  # blank line after each locale csv fill


if __name__ == '__main__':
    myfunc()