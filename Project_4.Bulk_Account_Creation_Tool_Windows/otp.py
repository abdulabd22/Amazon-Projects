import time
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC


def require_otp(driver, email):
    print(email)
    driver.execute_script("window.open('');")
    driver.switch_to.window(driver.window_handles[1])
    # driver.get("https://ballard.amazon.com/owa/#path=/mail")
    # Authenticated pop up
    driver.get("https://rahaabdu:Hypnos@321@ballard.amazon.com/owa/#path=/mail")
    time.sleep(8)

    # Reload the page if page is not loaded and click on search icon and handle pop-ups (if any)

    try:

        # Handle pop-ups (if any) on ballard
        try:
            PopupButton = driver.find_element(By.CSS_SELECTOR, "button[autoid='_fce_e']")
            PopupButton.click()
        except:
            print(email)
            print("first popup")
            print("No pop-ups encountered")
        driver.refresh()
        wait = WebDriverWait(driver, 3)  # Change the 10 to the desired wait time
        SearchIcon = wait.until(EC.element_to_be_clickable(
            (By.CSS_SELECTOR, "._n_m.owaimg.ms-Icon--search.ms-icon-font-size-20.ms-fcl-ts-b")))
        SearchIcon.click()
        time.sleep(2)

    except:
        driver.get("https://ballard.amazon.com/owa/#path=/mail")
        time.sleep(7)

        # Handle pop-ups (if any) on ballard
        try:
            print("second popup hit")
            wait = WebDriverWait(driver, 2)
            PopupButton = wait.until(EC.element_to_be_clickable((By.CSS_SELECTOR, "button[autoid='_fce_e']")))
            PopupButton.click()
        except:
            print(email)
            print("second popup")
            print("No pop-ups encountered")
        driver.refresh()
        time.sleep(7)
        # SearchIcon = driver.find_element(By.CSS_SELECTOR,"._n_m.owaimg.ms-Icon--search.ms-icon-font-size-20.ms-fcl-ts-b")
        SearchIcon = driver.find_element(By.CSS_SELECTOR,
                                         "._n_m.owaimg.ms-Icon--search.ms-icon-font-size-20.ms-fcl-ts-b")

        SearchIcon.click()
        time.sleep(2)

    # Send email id to search box
    try:
        print(email)
        print("Sending email id to search box")

        SearchMailBox = driver.find_element(By.CSS_SELECTOR,
                                            "input[aria-label='Search mail and people, type your search term then press enter to search.']")
        SearchMailBox.click()
        SearchMailBox.send_keys(email)
        print("Email is entered in search")
        SearchMailBox.send_keys(Keys.ENTER)
        time.sleep(5)
    except:

        print(email)
        print("Trying Active Mail Box")

        # ActivateMailBox = wait.until(EC.element_to_be_clickable((By.CSS_SELECTOR, "button[aria-label='Activate Search Textbox']")))

        try:
            ActivateMailBox = driver.find_element(By.CSS_SELECTOR,
                                                  "._n_j ms-bgc-tl-h _n_k ms-bgc-tlr o365button ms-border-color-themeLighter")
        except:
            driver.refresh()
            time.sleep(5)
            ActivateMailBox = driver.find_element(By.CSS_SELECTOR,
                                                  "._n_j ms-bgc-tl-h _n_k ms-bgc-tlr o365button ms-border-color-themeLighter")

        ActivateMailBox.click()
        wait = WebDriverWait(driver, 2)
        print("Trying Search Mail Box - Input")
        SearchMailBox = driver.find_element(By.CSS_SELECTOR,
                                            "input[aria-label='Search mail and people, type your search term then press enter to search.']")
        SearchMailBox.send_keys(email)
        SearchMailBox.send_keys(Keys.ENTER)
        time.sleep(5)

    # Select inbox option
    folders = driver.find_elements(By.CSS_SELECTOR,
                                   "div[aria-label*='In folders'] div[role='option'] div[autoid*='_is_h'] span[autoid*='_is_j']")
    for folder in folders:
        option = folder.text
        if option == "Inbox":
            folder.click()
            time.sleep(3)
            break

    Mails = driver.find_elements(By.CSS_SELECTOR, "div[class*='listItemDefaultBackground']")
    while len(Mails) == 0:
        # refresh the mails
        SearchAgain = driver.find_element("xpath",
                                          "/html[1]/body[1]/div[2]/div[1]/div[3]/div[5]/div[1]/div[1]/div[1]/div[1]/div[2]/div[1]/div[1]/div[2]/div[1]/div[1]/div[1]/button[1]/span[1]")
        SearchAgain.click()
        time.sleep(3)

        Mails = driver.find_elements(By.CSS_SELECTOR, "div[class*='listItemDefaultBackground']")

    # if mails == 1, then that is the newest mail else need to go through the timings of mail recieved
    retry = True
    if len(Mails) != 1:
        while retry:
            # refresh the mails
            SearchAgain = driver.find_element(By.CSS_SELECTOR,
                                              "._fc_3.owaimg.ms-Icon--search.ms-icon-font-size-20.ms-fcl-ts-b")
            SearchAgain.click()
            time.sleep(5)

            MailReceivedTimings = driver.find_elements(By.CSS_SELECTOR, "div[class*='_lvv_J'] span[class*='_lvv_M']")
            ReceivedLatestTime = MailReceivedTimings[0].text

            # means it is in 12:12,12:09 format, means mail received today only
            if len(ReceivedLatestTime) <= 5:
                retry = False

    otp = ''
    if len(Mails) == 1 or not retry:
        # standard procedure
        Mails = driver.find_elements(By.CSS_SELECTOR, "div[class*='listItemDefaultBackground']")
        Mails[0].click()
        time.sleep(2)
        otp = driver.find_element(By.CLASS_NAME, 'x_otp').text
        time.sleep(2)

    time.sleep(10)

    # driver.close()
    driver.switch_to.window(driver.window_handles[0])
    return otp