import time
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.common.by import By


def require_otp(driver,email):

    driver.execute_script("window.open('');")
    driver.switch_to.window(driver.window_handles[1])
    driver.get("https://ballard.amazon.com/owa/#path=/mail")
    time.sleep(5)

    # Reload the page if page is not loaded and click on search icon and handle pop-ups (if any)
    try:


        SearchIcon = driver.find_element(By.CSS_SELECTOR,"._n_m.owaimg.ms-Icon--search.ms-icon-font-size-20.ms-fcl-ts-b")
        SearchIcon.click()
        time.sleep(3)

    except:
        driver.get("https://ballard.amazon.com/owa/#path=/mail")
        time.sleep(5)

        # Handle pop-ups (if any) on ballard
        try:
            PopupButton = driver.find_element(By.CSS_SELECTOR, "button[autoid='_fce_e']")
            PopupButton.click()
        except:
            print("No pop-ups encountered")

        SearchIcon = driver.find_element(By.CSS_SELECTOR,"._n_m.owaimg.ms-Icon--search.ms-icon-font-size-20.ms-fcl-ts-b")
        SearchIcon.click()
        time.sleep(3)

    # Send email id to search box
    try:
        SearchMailBox = driver.find_element(By.CSS_SELECTOR, "input[role*='combobox']")
        SearchMailBox.click()
        time.sleep(2)
        SearchMailBox.send_keys(email)
        SearchMailBox.send_keys(Keys.ENTER)
        time.sleep(5)
    except:
        ActivateMailBox = driver.find_element(By.CSS_SELECTOR, "button[aria-label='Activate Search Textbox']")
        ActivateMailBox.click()
        time.sleep(2)
        SearchMailBox = driver.find_element(By.CSS_SELECTOR, "input[role*='combobox']")
        SearchMailBox.send_keys(email)
        SearchMailBox.send_keys(Keys.ENTER)
        time.sleep(5)

    Mails = driver.find_elements(By.CSS_SELECTOR,"div[class*='listItemDefaultBackground']")
    while len(Mails) == 0:
        # refresh the mails
        SearchAgain = driver.find_element(By.CSS_SELECTOR,"._fc_3.owaimg.ms-Icon--search.ms-icon-font-size-20.ms-fcl-ts-b")
        SearchAgain.click()
        time.sleep(3)

        Mails = driver.find_elements(By.CSS_SELECTOR,"div[class*='listItemDefaultBackground']")

    
    otp = ''
    if len(Mails) == 1 or not retry:
        # standard procedure
        Mails = driver.find_elements(By.CSS_SELECTOR, "div[class*='listItemDefaultBackground']")
        Mails[0].click()
        time.sleep(3)
        otp = driver.find_element(By.CLASS_NAME, 'x_otp').text
        time.sleep(2)

    time.sleep(10)

    # driver.close()
    driver.switch_to.window(driver.window_handles[0])
    return otp