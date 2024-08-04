package JiraSimProject;

import java.time.Duration;
import java.util.Scanner;

import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.support.ui.WebDriverWait;

public class WhaJIRA {

	public static void main(String[] args) {
		ChromeDriver driver= new ChromeDriver();
		driver.manage().window().maximize();
		WebDriverWait wait=new WebDriverWait(driver, Duration.ofSeconds(10));
		String str,from_date,to_date,year,count;
		Scanner sc= new Scanner(System.in);
		
		
		
		driver.get("https://issues.labcollab.net/issues/?jql=");
		String url= driver.getCurrentUrl();
		if (url.contains("lasso.labcollab"))
		{
			midway(wait);
			
		}
		
		System.out.println("Enter any key after authenticating midway: ");
		str=sc.next();
		
	}

}
