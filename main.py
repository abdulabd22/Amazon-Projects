import os
import time
import csv

from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.common.by import By
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.common.action_chains import ActionChains
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

        service = Service(executable_path='./chromedriver.exe')
        driver = webdriver.Chrome(service=service, options=options )
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

        # fill the form
        email = Base_Account + str(value) + '_' + locale + Account_suffix
        passkey = Password
        customer_name.send_keys('Test')
        try:
            pronunciation.send_keys('test')
        except:
            print('no pronunciation tab')
        username.send_keys(email)
        password.send_keys(passkey)
        password_confirm.send_keys(passkey)
        time.sleep(2)

        # Press enter key to submit the form instead of clicking on UI button
        password_confirm.send_keys(Keys.ENTER)

        # Get otp from outlook
        print("Get otp from outlook")
        otp = require_otp(driver,email)
        print(otp)

        driver.find_element("xpath", "//*[@id='cvf-input-code']").send_keys(otp)
        print("otp entered")

        try:
            driver.find_element("xpath", '//*[@id="cvf-submit-otp-button"]/span/input').send_keys(Keys.ENTER)
        except:
            pass

        print('otp submitted')
        time.sleep(11)

        # press Accept cookies button
        try:
            driver.find_element('xpath', "//input[@id='sp-cc-accept']").click()
        except:
            pass



        # set address
        # Add a different logic to set address for in accounts
        if locale == 'in':
            # login to in webisite using the created account
            driver.get(
                'https://www.amazon.in/ap/signin?_encoding=UTF8&openid.assoc_handle=inflex&openid.claimed_id=http%3A%2F%2Fspecs.openid.net%2Fauth%2F2.0%2Fidentifier_select&openid.identity=http%3A%2F%2Fspecs.openid.net%2Fauth%2F2.0%2Fidentifier_select&openid.mode=checkid_setup&openid.ns=http%3A%2F%2Fspecs.openid.net%2Fauth%2F2.0&openid.ns.pape=http%3A%2F%2Fspecs.openid.net%2Fextensions%2Fpape%2F1.0&openid.pape.max_auth_age=0&openid.return_to=https%3A%2F%2Fwww.amazon.in%2Fgp%2Fyourstore%2Fhome%3Fie%3DUTF8%26action%3Dsign-out%26path%3D%252Fgp%252Fyourstore%252Fhome%26ref_%3Dnav_AccountFlyout_signout%26signIn%3D1%26useRedirectOnSuccess%3D1')
            time.sleep(5)
            driver.find_element("id", "ap_email").send_keys(email)
            driver.find_element("id", "ap_email").send_keys(Keys.ENTER)
            driver.find_element("id", "ap_password").send_keys(passkey)
            driver.find_element("id", "ap_password").send_keys(Keys.ENTER)
            time.sleep(5)
            try:


                driver.find_element("xpath",
                                    "/html/body/div[1]/div[1]/div[2]/div/div[2]/div/div/div/form/div/div[3]/div/a").click()
            except:
                print('no phone number authentication')
        # check the xpaths of other locales
        else:
            print('standard procedure')
        time.sleep(3)

        address = get_url(locale)
        address_page = str(address[9])
        driver.get(address_page)
        time.sleep(8)

        # Address page is different for JP locale
        # check if locale is jp and execute the below loop
        if locale == 'jp':
            # country or region
            # driver.sendKeys(Keys.DOWN)
            driver.execute_script("window.scrollTo(0, 350)")

            driver.find_element('xpath', "/html/body/div[1]/div[1]/div[1]/div/div/div/div/div/div[4]/div/div/div[5]/div/div/div/div/div/div/div/div/div[2]/div").click()
            time.sleep(2)
            driver.find_element('xpath', "/html/body/div[1]/div[1]/div[1]/div/div/div/div/div/div[4]/div/div/div[5]/div/div/div/div/div/div/div/div/div[1]/div/div[2]/a/span/button/span").click()

            time.sleep(3)

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

        else:

            driver.find_element('xpath', '//*[@id="country"]/div[2]/div').click()
            time.sleep(2)
            driver.find_element('xpath', "//*[@id='country_change_myx ']/span/button/span").click()

            time.sleep(3)


            driver.find_element('xpath', "//input[@id='adr_AddressLine1']").send_keys(str(address[3]))

            # line1 = locale + '_adr_line2'

            driver.find_element('xpath', "//input[@id='adr_AddressLine2']").send_keys(str(address[4]))
            driver.find_element('xpath', "//input[@id='adr_City']").send_keys(str(address[5]))
            driver.find_element('xpath', "//input[@id='adr_StateOrRegion']").send_keys(str(address[6]))
            driver.find_element('xpath', "//input[@id='adr_PostalCode']").send_keys(str(address[7]))
            driver.find_element('xpath', "//*[@id='adr_PhoneNumber']").send_keys(str(address[8]))

            time.sleep(2)
            driver.find_element('xpath', "//a[@id='dialogButton_ok_myx ']/span/button").click()
            # loop ends for address set for other locales

        time.sleep(2)
        cid_url2 = get_url(locale)
        cid_url = str(cid_url2[2])
        driver.get(cid_url)
        time.sleep(10)
        driver.sendKeys(Keys.CONTROL + "U")
        customerid = driver.find_element('xpath', "// td[contains(text(), 'customerID')]").text
        cid = customerid
        try:
            #cid = driver.find_element('xpath',
             #                     '/html/body/table[2]/tbody/tr[1]/td/table/tbody/tr/td/table/tbody/tr[2]/td/table/tbody/tr[2]/td[3]/b').text


            print("Account created with cid = {}".format(cid))
            print(customerid)

        except:
            pass


        # Close driver
        # driver.close()
        print(email)

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

    csv_name = input('Enter name for csv file where details need to be stored: ')

    for locale in mydict:   #sequential loop
        print()  #blank line
        print('Starting account creation for locale = {} '.format(locale))
        print('No of Accounts to be created = {} '.format(mydict[locale]))

        account_list.clear()
        password_list.clear()
        cid_list.clear()

        url1 = get_url(locale)
        url = str(url1[0])

        values = []
        for i in range(int(mydict[locale])):
            values.append(i)

        pool = Pool(processes=10)
        func = partial(run,locale,url,Base_Account,Password,Account_suffix)

        for result in pool.map(func, values):
            if result is not None:
                account_list.append(result[0])
                password_list.append(result[1])
                cid_list.append(result[2])

        pool.close()
        pool.join()

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
                writer.writerow([account_list[i], password_list[i], cid_list[i]])

            writer.writerow([])  # blank line after each locale csv fill
        time.sleep(10)
        print(f"Accounts are saved in {csv_name} file")


if __name__ == '__main__':
    myfunc()


