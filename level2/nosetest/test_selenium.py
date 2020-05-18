from selenium import webdriver
from selenium.webdriver.common.desired_capabilities import DesiredCapabilities
import os

class TestSelenium:
    def setUp(self):
        self.driver = webdriver.Remote(command_executor=os.environ['SELENIUM_ENDPOINT'], desired_capabilities=DesiredCapabilities.CHROME)

    def test_new(self):
        self.driver.get("https://python.org")

        assert "Python" in self.driver.title

    def test_new_2(self):
        self.driver.get("https://python.org")

        assert "Python" in self.driver.title

    def test_new_3(self):
        self.driver.get("https://python.org")

        assert "Python" in self.driver.title

    def test_new_4(self):
        self.driver.get("https://python.org")

        assert "Python" in self.driver.title

    def test_new_5(self):
        self.driver.get("https://python.org")

        assert "Python" in self.driver.title

    def tearDown(self):
        self.driver.quit()
