from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
import time

# Set up Chrome options
chrome_options = Options()
# chrome_options.add_argument("--headless")  # Run in headless mode
chrome_options.add_argument("--no-sandbox")  # Bypass OS security model
chrome_options.add_argument("--disable-dev-shm-usage")  # Overcome limited resource problems
chrome_options.add_argument("--disable-gpu")  # Applicable to Windows environments
chrome_options.add_argument("--window-size=1280x1024")  # Set a specific window size

# Initialize the Chrome WebDriver with these options
driver = webdriver.Chrome("C:\\Users\\jebas\\Downloads\\chromedriver-win64\\chromedriver-win64\\chromedriver.exe")

# Function to open a page
def open_page(url):
    driver.get(url)
    print(f"Opened page: {url}")

# Function to perform a Google search
def search_in_google(query):
    search_box = driver.find_element(By.NAME, "q")
    search_box.send_keys(query + Keys.RETURN)
    print(f"Searching for: {query}")
    time.sleep(2)

# Function to extract search results
def extract_search_results():
    results = driver.find_elements(By.CSS_SELECTOR, 'h3')
    for result in results:
        title = result.text
        link = result.find_element(By.XPATH, '..').get_attribute('href')
        print(f"Title: {title}, Link: {link}")

# Function to take a screenshot
def take_screenshot(file_name):
    driver.save_screenshot(file_name)
    print(f"Screenshot saved as: {file_name}")

# Function to close the browser
def close_browser():
    driver.quit()
    print("Browser closed.")

# Example 
if __name__ == "__main__":
    open_page("https://www.google.com")
    search_in_google("Selenium WebDriver")
    extract_search_results()
    take_screenshot("screenshot.png")
    close_browser()

