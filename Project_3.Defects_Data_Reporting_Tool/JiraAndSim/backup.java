package JiraSimProject;

import java.time.Duration;
import java.time.Month;
import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;
import java.time.YearMonth;


import org.openqa.selenium.By;
import org.openqa.selenium.JavascriptExecutor;
import org.openqa.selenium.Keys;
import org.openqa.selenium.StaleElementReferenceException;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.interactions.Actions;
import org.openqa.selenium.support.ui.WebDriverWait;

public class SimTriagedReport {
 
	public static void scroll_down(ChromeDriver driver) {
		
		Actions act = new Actions(driver);
		for (int i=1; i <4; i++)
		{
			act.sendKeys(Keys.PAGE_DOWN).perform();    //Page Down
		}
	}
	
	public static void scroll_up(ChromeDriver driver) {
		
		Actions act = new Actions(driver);
		for (int i=1; i<4; i++)
		{
			act.sendKeys(Keys.PAGE_UP).perform();    //PageDown
		}
	}
	
	public static void add_new_filter(ChromeDriver driver) throws InterruptedException {
		
		 driver.findElement(By.xpath("//span[normalize-space()='Add a new filter']")).click();
		 Thread.sleep(3000);
		
	}

	public static void tags_search(ChromeDriver driver, List<String> names, String operator ) throws InterruptedException
	{
		add_new_filter(driver);
		//Entering Tag Details
		driver.findElement(By.xpath("//div[@class='select2-search']//input")).sendKeys("Tags");
		driver.findElement(By.xpath("//ul[@class='select2-results']/li//span[text()='Tags']")).click();
	    
		for (String name: names)
		{
			driver.findElement(By.xpath("//input[@placeholder='Enter full text']")).sendKeys(name);
			driver.findElement(By.xpath("//button[@class='btn add-to-list']")).click();
		}
		
		//default OR radio button enabled
		if ( operator == "AND")
		{
			driver.findElement(By.xpath("//input[@value='AND']")).click();
		}
		
		
		driver.findElement(By.xpath("//button[@data-name='add-search-filter-button']")).click(); //Add button
		Thread.sleep(1000);
		hit_search(driver);
	}
	
	public static void date_range(ChromeDriver driver, String from_date, String to_date) throws InterruptedException
	{
		add_new_filter(driver);
		
		//Entering Range of Dates
		driver.findElement(By.xpath("//div[@class='select2-search']//input")).sendKeys("Create date");
		driver.findElement(By.xpath("//ul[@class='select2-results']/li//span[text()='Create date']")).click();
		driver. findElement(By.xpath("//input[@data-link='absolute^start']")).sendKeys(from_date); //From
		driver. findElement(By.xpath("//input[@data-link='absolute^end']")).sendKeys(to_date); //To
		driver.findElement(By.xpath("//button[@data-name='add-search-filter-button']")).click(); //Add button
		scroll_down(driver);
	}
	
	public static void bug_status_search(ChromeDriver driver, String status) throws InterruptedException
	{
		add_new_filter(driver);
		//Bug status - Open/Resolved Search
		driver.findElement(By.xpath("//div[@class='select2-search']//input")).sendKeys("Status");
		driver.findElement(By.xpath("//ul[@class='select2-results']/li//span[text()='Status']")).click();
		driver.findElement(By.xpath("//input[@name='boolean' and @value ='"+status+"']")).click();
		driver.findElement(By.xpath("//button[@data-name='add-search-filter-button']")).click(); //Add button
		Thread.sleep(1000);
	}
	
	public static void bug_label_search(ChromeDriver driver, String label) throws InterruptedException
	{
		add_new_filter(driver);
		//Label name - Triaged
		driver.findElement(By.xpath("//div[@class='select2-search']//input")).sendKeys("Label");
		driver.findElement(By.xpath("//ul[@class='select2-results']/li//span[text()='Label']")).click();
		driver.findElement(By.xpath("//input[@placeholder='Enter label']")).sendKeys("Triaged");
		 
		try {
			 WebElement ele= driver.findElement(By.xpath("//div[@class='input search-filter-autocomplete']//span[@title='Triaged']"));
				ele.click();
				
	     } catch(StaleElementReferenceException e) {
	         WebElement ele= driver.findElement(By.xpath("//div[@class='input search-filter-autocomplete']//span[@title='Triaged']"));
	     	ele.click();
	    	
	     }
		
		driver.findElement(By.xpath("//span[@class='text editable-text']")).click();
		driver.findElement(By.xpath("//li//a[normalize-space()='"+label+"']")).click();
		driver.findElement(By.xpath("//button[@data-name='add-search-filter-button']")).click(); //Add button
		Thread.sleep(1000);
	}
	
	
	public static void hit_search(ChromeDriver driver) throws InterruptedException {
		//Hit Search button
		driver.findElement(By.xpath("//button[@id='initiate-search']")).click();
		Thread.sleep(3000);
		
	}
	
	public static String get_count(ChromeDriver driver) {
		String total, count;
		total= driver.findElement(By.xpath("//div[@id='view-content-pane-left-bottom']")).getText();
		count=total.split("of")[1].trim();
		return count;
	}
	 

	//span[@class='label-field-name' and text()='Tags']/following::button[1]
	public static void clear_filter(ChromeDriver driver, String search) {
		driver.findElement(By.xpath("//button[contains(@title,'"+search+"')]/following-sibling::button")).click();
		scroll_down(driver);
		
	}
	
	public static void clear_search(ChromeDriver driver) throws InterruptedException {
		
		driver.findElement(By.xpath("//span[@class='remove-all']")).click();
		Thread.sleep(3000);
	}
	
	public static void triage_report(ChromeDriver driver, String from_date, String to_date) throws InterruptedException
	{
		
		JavascriptExecutor js= driver;
		Actions act2 = new Actions(driver);
		String total,count;
		Integer total_defects, open_defects, resolved_defects, triaged_defects, not_triaged_defects, fixed_defects;
		Integer valid_defects, invalid_defects, testcase_defects, adhoc_defects;
		String str;
		double triaged_percentage, open_percentage, fixed_percentage;
		ArrayList<String> tag_names=new ArrayList<String>();
		
	//1)Counting Total no of defects
	
	clear_search(driver);
	//Entering date
	date_range(driver,from_date,to_date);
	//Entering Tags
	tag_names.add("GDQ_QS_Detected_AlexaDiscovery");
	tags_search(driver,tag_names, "OR");
	tag_names.clear();
	//Counting defects
	total_defects=Integer.parseInt(get_count(driver));
	System.out.println("Total Defects raised no: " +total_defects );
	
	
	//2)Counting Open defects
	//Searching for Open Bugs
	bug_status_search(driver,"Open");
	hit_search(driver);
	//Counting defects
	open_defects=Integer.parseInt(get_count(driver));
	System.out.println("Total Open Defects no: " + open_defects);
	//Clearing Status filter
	clear_filter(driver,"Open");

	
	//3)Counting Resolved defects
	//Searching for Resolved Bugs
	bug_status_search(driver,"Resolved");
	hit_search(driver);
	//Counting defects
	resolved_defects=Integer.parseInt(get_count(driver));
	System.out.println("Total Resolved Defects no: " + resolved_defects);
	//Clearing Status filter
	clear_filter(driver,"Resolved");
	
	
	//4)Counting Triaged defects
	//Searching for Triaged defects
	bug_status_search(driver,"Open");
	bug_label_search(driver, "is labeled");
	hit_search(driver);
	//Counting defects
	triaged_defects=Integer.parseInt(get_count(driver));
	System.out.println("Total No of Triaged Defects are: " + triaged_defects);
	//Clearing Status filter
	clear_filter(driver,"Triaged");
	

	//5)Counting Not Triaged bugs
	//Searching for Triaged defects
	bug_label_search(driver, "is not labeled");
	hit_search(driver);
	//Counting defects
	not_triaged_defects=Integer.parseInt(get_count(driver));
	System.out.println("Total No of Not Triaged Defects are: " + not_triaged_defects);
	//Clearing Label filter
	clear_filter(driver,"NOT (Triaged)");
	clear_filter(driver,"Open");
	
	//6)Counting Fixed bugs
	clear_filter(driver, "GDQ_QS_Detected_AlexaDiscovery");
	//Searching with specific tag names
	tag_names.add("GDQ_QS_Detected_AlexaDiscovery");
	tag_names.add("QS_Fixed");
	tags_search(driver,tag_names, "AND");
	tag_names.clear();
	//Counting defects
	fixed_defects=Integer.parseInt(get_count(driver));
	System.out.println("Total No of Fixed Defects are: " + fixed_defects);
	//Clearing Label filter
	clear_filter(driver,"QS_Fixed");
	
	//7)Counting Valid defects
	//Searching with specific tag names
	tag_names.add("GDQ_QS_Detected_AlexaDiscovery");
	tag_names.add("QS_Detected_Valid");
	tags_search(driver,tag_names, "AND");
	tag_names.clear();
	//Counting defects
	valid_defects=Integer.parseInt(get_count(driver));
	System.out.println("Total No of Valid Defects are: " + valid_defects);
	//Clearing Label filter
	clear_filter(driver,"QS_Detected_Valid");
	
	
	//8)Counting Invalid defects
	//Searching with specific tag names
	tag_names.add("GDQ_QS_Detected_AlexaDiscovery");
	tag_names.add("QS_Detected_Invalid");
	tags_search(driver,tag_names, "AND");
	tag_names.clear();
	//Counting defects
	invalid_defects=Integer.parseInt(get_count(driver));
	System.out.println("Total No of Invalid Defects are: " + invalid_defects);
	//Clearing Label filter
	clear_filter(driver,"QS_Detected_Invalid");
		
		
	//9)Counting Testcase defects
	//Searching with specific tag names
	tag_names.add("GDQ_QS_Detected_AlexaDiscovery");
	tag_names.add("QS_Testcase");
	tags_search(driver,tag_names, "AND");
	tag_names.clear();
	//Counting defects
	testcase_defects=Integer.parseInt(get_count(driver));
	System.out.println("Total No of Testcase Defects are: " + testcase_defects);
	//Clearing Label filter
	clear_filter(driver,"QS_Testcase");
	
	
	//10)Counting Adhoc defects
	//Searching with specific tag names
	tag_names.add("GDQ_QS_Detected_AlexaDiscovery");
	tag_names.add("QS_Adhoc");
	tags_search(driver,tag_names, "AND");
	tag_names.clear();
	//Counting defects
	adhoc_defects=Integer.parseInt(get_count(driver));
	System.out.println("Total No of Adhoc Defects are: " + adhoc_defects);
	//Clearing Label filter
	clear_filter(driver,"QS_Adhoc");
	
/*	open_percentage= Double.pa (( open_defects / total_defects ) * 100);
	triaged_percentage= (triaged_defects / total_defects) * 100;
	
	System.out.println("Open percentage: " + open_percentage);
	System.out.println("Triaged percentage: " + triaged_defects);
	*/
	
	}

	
	
	public static void main(String[] args) throws InterruptedException  {
		
		
		ChromeDriver driver = new ChromeDriver();
		WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(10));
		driver.manage().window().maximize();
		driver.get("https://issues.amazon.com");
		Scanner sc= new Scanner(System.in);
		System.out.println("Enter any key after authenticating midway: ");
		String str=sc.next();
	
		String from_date,to_date;
		String year="2023";
		/*String str;
		System.out.println("Enter From and To Date as 'MM/DD:MM/DD' format : e.g. 01/01:02/15 ");
		str=sc.next().trim();
		
		String from_date= str.substring(0, str.indexOf(':')) + "/" +year;
		String to_date= str.substring(str.indexOf(':') + 1, str.length())+ "/" +year;
		*/
		
		//from_date="01/01/2024";
		//to_date="02/13/2024";
		//triage_report(from_date, to_date);
		int[] month_array = {1,2,3,4,5,6,7,8,9,10,11,12};
		
		for (int month: month_array)
		{
			
			//Get month name
			String month_name= Month.of(month).name();
			System.out.println("Getting Triage Report for the month of "+month_name );
			
			// Get the number of days in that month
			YearMonth yearMonthObject = YearMonth.of((Integer.parseInt(year)), month);
			int daysInMonth = yearMonthObject.lengthOfMonth();
			from_date= month+ "/"+ "01" + "/"+ year;
			to_date=month+ "/"+  daysInMonth + "/"+ year;
			System.out.println(from_date + " - " + to_date );
			triage_report(driver,from_date, to_date);
			System.out.println();
			System.out.println();
			
		}
		
		
		
				
}
}
