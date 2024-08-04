package JiraSimProject;

import java.time.Duration;
import java.util.Scanner;
import org.openqa.selenium.By;
import org.openqa.selenium.Cookie;
import org.openqa.selenium.JavascriptExecutor;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;

public class SimAuthentication {

	public static void midway(ChromeDriver driver, WebDriverWait wait) throws InterruptedException
	{
		WebElement submit;
		JavascriptExecutor executor = (JavascriptExecutor) driver;
		
		wait.until(ExpectedConditions.elementToBeClickable(By.xpath("//input[@id='user_name_field']"))).sendKeys("rahaabdu");
		Thread.sleep(2000);
		submit= driver.findElement(By.xpath("//input[@name='commit']"));
		executor.executeScript("arguments[0].click();", submit);
		Thread.sleep(4000);
		
		wait.until(ExpectedConditions.elementToBeClickable(By.xpath("//input[@name='one_time_ldap_field']"))).sendKeys("Donut@123");
		Thread.sleep(2000);
		executor.executeScript("arguments[0].click();", submit);
		
		
	}
	public static void main(String[] args) throws InterruptedException {
		String str;
		Scanner sc= new Scanner(System.in);
		ChromeDriver driver= new ChromeDriver();
		driver.manage().window().maximize();
		WebDriverWait wait=new WebDriverWait(driver, Duration.ofSeconds(10));
		
		driver.get("https://issues.amazon.com");
		 driver.manage().addCookie(new Cookie("key", "value"));
		Thread.sleep(5000);
		midway(driver,wait);
		
		System.out.println("Enter any key after authenticating midway: ");
		str=sc.next();

	}

}
