package JiraSimProject;

import java.io.IOException;
import java.time.Duration;
import java.time.LocalDate;
import java.time.Month;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Scanner;
import java.util.stream.IntStream;
import java.time.YearMonth;

import org.apache.commons.math3.util.Precision;
import org.openqa.selenium.By;
import org.openqa.selenium.JavascriptExecutor;
import org.openqa.selenium.Keys;
import org.openqa.selenium.StaleElementReferenceException;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.interactions.Actions;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;
import org.testng.annotations.*;

public class SimTriagedReport {
	public static HashMap<String, Integer> sim_map=new HashMap<String, Integer>();
	public static int bug_triaged;
	public static int[] month_array;
	public static Scanner sc;
	public static String str;
	public static int end_month_num, end_date_num;
	public static String days15, days30,days16,above30days,new_to_date;
	public static int total_data_flag;
	public static String sim_not_triaged_url;
	public static Object data_array[][]=
		{
				{"Overall", new HashMap<String, Integer>()},
				{"JANUARY",new HashMap<String, Integer>()},
				{"FEBRUARY",new HashMap<String, Integer>()},
				{"MARCH",new HashMap<String, Integer>()},
				{"APRIL",new HashMap<String, Integer>()},
				{"MAY",new HashMap<String, Integer>()},
				{"JUNE",new HashMap<String, Integer>()},
				{"JULY",new HashMap<String, Integer>()},
				{"AUGUST",new HashMap<String, Integer>()},
				{"SEPTEMBER",new HashMap<String, Integer>()},
				{"OCTOBER",new HashMap<String, Integer>()},
				{"NOVEMBER",new HashMap<String, Integer>()},
				{"DECEMBER",new HashMap<String, Integer>()},
		};
	
	
	
	
	public static void scroll_down(ChromeDriver driver) {
		
		Actions act = new Actions(driver);
		for (int i=1; i <4; i++)
		{
			act.sendKeys(Keys.PAGE_DOWN).perform();
			act.sendKeys(Keys.PAGE_DOWN).perform();    //Page Down
		}
	}
	
	public static void scroll_up(ChromeDriver driver) {
		
		Actions act = new Actions(driver);
		for (int i=1; i<4; i++)
		{
			act.sendKeys(Keys.PAGE_UP).perform();
			act.sendKeys(Keys.PAGE_UP).perform();    //PageDown
		}
	}
	
	public static void add_new_filter(ChromeDriver driver, WebDriverWait wait) {
	
		wait.until(ExpectedConditions.elementToBeClickable(By.xpath("//span[normalize-space()='Add a new filter']"))).click();
		 

	}

	public static void tags_search(ChromeDriver driver,WebDriverWait wait, List<String> names, String operator ) throws InterruptedException
	{
		
		add_new_filter(driver,wait);
		//Entering Tag Details
		wait.until(ExpectedConditions.elementToBeClickable(By.xpath("//div[@class='select2-search']//input"))).sendKeys("Tags");
		wait.until(ExpectedConditions.elementToBeClickable(By.xpath("//ul[@class='select2-results']/li//span[text()='Tags']"))).click();
		
	    
		for (String name: names)
		{
			wait.until(ExpectedConditions.elementToBeClickable(By.xpath("//input[@placeholder='Enter full text']"))).sendKeys(name);
			wait.until(ExpectedConditions.elementToBeClickable(By.xpath("//button[@class='btn add-to-list']"))).click();
		}
		
		//default OR radio button enabled
		if ( operator == "AND")
		{
			wait.until(ExpectedConditions.elementToBeClickable(By.xpath("//input[@value='AND']"))).click();
		}
	Thread.sleep(1000);	
try {
		wait.until(ExpectedConditions.elementToBeClickable(By.xpath("//button[@data-name='add-search-filter-button']"))).click(); //Add button
}
catch (Exception e) {
	WebElement element = driver.findElement(By.xpath("//button[@data-name='add-search-filter-button']"));
	JavascriptExecutor executor = driver;
	executor.executeScript("arguments[0].click()", element );
}
		hit_search(driver,wait);
	}
	
	public static void date_range(ChromeDriver driver,WebDriverWait wait, String from_date, String to_date) 
	{
		add_new_filter(driver,wait);
		
		//Entering Range of Dates
		wait.until(ExpectedConditions.elementToBeClickable(By.xpath("//div[@class='select2-search']//input"))).sendKeys("Create date");
		wait.until(ExpectedConditions.elementToBeClickable(By.xpath("//ul[@class='select2-results']/li//span[text()='Create date']"))).click();
		
		Actions actions = new Actions(driver);
		wait.until(ExpectedConditions.elementToBeClickable(By.xpath("//input[@data-link='absolute^start']"))).sendKeys(from_date); //From
		actions.sendKeys(Keys.ENTER).perform();
		wait.until(ExpectedConditions.elementToBeClickable(By.xpath("//input[@data-link='absolute^end']"))).sendKeys(to_date); //To
		actions.sendKeys(Keys.ENTER).perform();
		//wait.until(ExpectedConditions.elementToBeClickable(By.xpath("//button[@data-name='add-search-filter-button']"))).click(); //Add button
		
		WebElement element = driver.findElement(By.xpath("//button[@data-name='add-search-filter-button']"));
		JavascriptExecutor executor = driver;
		executor.executeScript("arguments[0].click()", element);
	}
	
	public static void bug_status_search(ChromeDriver driver,WebDriverWait wait, String status) throws InterruptedException
	{
		add_new_filter(driver,wait);
		
		//Bug status - Open/Resolved Search
		wait.until(ExpectedConditions.elementToBeClickable(By.xpath("//div[@class='select2-search']//input"))).sendKeys("Status");
		wait.until(ExpectedConditions.elementToBeClickable(By.xpath("//ul[@class='select2-results']/li//span[text()='Status']"))).click();
		
		wait.until(ExpectedConditions.elementToBeClickable(By.xpath("//input[@name='boolean' and @value ='"+status+"']"))).click();
		wait.until(ExpectedConditions.elementToBeClickable(By.xpath("//button[@data-name='add-search-filter-button']"))).click(); //Add button
		//Thread.sleep(1000);
	}
	
	public static void bug_label_search(ChromeDriver driver, WebDriverWait wait, String label) throws InterruptedException 
	{
		add_new_filter(driver,wait);
		
		//Label name - Triaged
		wait.until(ExpectedConditions.elementToBeClickable(By.xpath("//div[@class='select2-search']//input"))).sendKeys("Label");
		wait.until(ExpectedConditions.elementToBeClickable(By.xpath("//ul[@class='select2-results']/li//span[text()='Label']"))).click();
		wait.until(ExpectedConditions.elementToBeClickable(By.xpath("//input[@placeholder='Enter label']"))).sendKeys("Triaged");
		Thread.sleep(3000);
		try {
			 WebElement ele= wait.until(ExpectedConditions.elementToBeClickable(By.xpath("//div[@class='input search-filter-autocomplete']//span[@title='Triaged']")));
				ele.click();
				
	     } catch(StaleElementReferenceException e) {
	         WebElement ele= wait.until(ExpectedConditions.elementToBeClickable(By.xpath("//div[@class='input search-filter-autocomplete']//span[@title='Triaged']")));
	     	ele.click();
	    	
	     }
		
		wait.until(ExpectedConditions.elementToBeClickable(By.xpath("//span[@class='text editable-text']"))).click();
		wait.until(ExpectedConditions.elementToBeClickable(By.xpath("//li//a[normalize-space()='"+label+"']"))).click();
		wait.until(ExpectedConditions.elementToBeClickable(By.xpath("//button[@data-name='add-search-filter-button']"))).click(); //Add button
		//Thread.sleep(1000);
	}
	
	
	public static void hit_search(ChromeDriver driver, WebDriverWait wait) throws InterruptedException {
		//Hit Search button
		wait.until(ExpectedConditions.elementToBeClickable(By.xpath("//button[@id='initiate-search']"))).click();
		Thread.sleep(3000);
		
	}
	
	public static String get_count(ChromeDriver driver, WebDriverWait wait) {
		String total, count;
		total= wait.until(ExpectedConditions.elementToBeClickable(By.xpath("//div[@id='view-content-pane-left-bottom']"))).getText();
		count=total.split("of")[1].trim();
		return count;
	}
	 

	//span[@class='label-field-name' and text()='Tags']/following::button[1]
	public static void clear_filter(ChromeDriver driver, WebDriverWait wait, String search) {
		wait.until(ExpectedConditions.elementToBeClickable(By.xpath("//button[contains(@title,'"+search+"')]/following-sibling::button"))).click();
		scroll_down(driver);
		
	}
	
	public static void clear_search(ChromeDriver driver, WebDriverWait wait) throws InterruptedException {
		
		wait.until(ExpectedConditions.elementToBeClickable(By.xpath("//span[@class='remove-all']"))).click();
		
	}
	
	public static void triage_report(ChromeDriver driver, WebDriverWait wait, String from_date, String to_date, int month_flag) throws InterruptedException
	{
		
		JavascriptExecutor js= driver;
		Actions act2 = new Actions(driver);
		String total,count;
		
		String filter_array[]={"Overall", "Resolved","Open","Fixed","Triaged","NotTriaged",
					"Testcase","Adhoc","Valid","Invalid"};
							

		Integer total_defects, open_defects, resolved_defects, triaged_defects, not_triaged_defects, fixed_defects;
		Integer valid_defects, invalid_defects, testcase_defects, adhoc_defects;
		String str;
		double triaged_percentage, open_percentage, fixed_percentage;
		ArrayList<String> tag_names=new ArrayList<String>();
		
	//1)Counting Total no of defects
	scroll_up(driver);
	scroll_up(driver);
	clear_search(driver,wait);
	//Entering date
	date_range(driver,wait,from_date,to_date);
	
	scroll_down(driver);
	//Entering Tags
	tag_names.add("GDQ_QS_Detected_AlexaDiscovery");
	tags_search(driver,wait,tag_names, "OR");
	scroll_down(driver);
	tag_names.clear();
	//Counting defects
	total_defects=Integer.parseInt(get_count(driver,wait));
	((HashMap<String, Integer>) data_array[month_flag][1]).put("Overall",total_defects);
	//map.put("Overall",total_defects);
	System.out.println("Total No of SIM Defects raised no: " +total_defects );
	
	
	//2)Counting Open defects
	//Searching for Open Bugs
	scroll_down(driver);
	bug_status_search(driver,wait,"Open");
	hit_search(driver,wait);
	//Counting defects
	open_defects=Integer.parseInt(get_count(driver,wait));
	((HashMap<String, Integer>) data_array[month_flag][1]).put("Open",open_defects);
	//map.put("Open",open_defects);
	System.out.println("Total No of SIM Open Defects no: " + open_defects);
	//Clearing Status filter
	clear_filter(driver, wait,"Open");
	scroll_down(driver);
	
	//3)Counting Resolved defects
	//Searching for Resolved Bugs
	
	bug_status_search(driver,wait,"Resolved");
	hit_search(driver,wait);
	//Counting defects
	resolved_defects=Integer.parseInt(get_count(driver,wait));
	System.out.println("Total No of SIM Resolved Defects no: " + resolved_defects);
	((HashMap<String, Integer>) data_array[month_flag][1]).put("Resolved",resolved_defects);
	//map.put("Resolved",resolved_defects);
	
	//Clearing Status filter
	clear_filter(driver, wait,"Resolved");
	scroll_down(driver);
	
	//4)Counting Triaged defects
	//Searching for Triaged defects
	bug_status_search(driver,wait,"Open");
	scroll_down(driver);
	bug_label_search(driver,wait, "is labeled");
	scroll_down(driver);
	hit_search(driver,wait);
	//Counting defects
	triaged_defects=Integer.parseInt(get_count(driver,wait))+ resolved_defects;
	System.out.println("Total No of SIM Triaged Defects are: " + triaged_defects);
	((HashMap<String, Integer>) data_array[month_flag][1]).put("Triaged",triaged_defects);
	//map.put("Triaged",triaged_defects);
	//Clearing Status filter
	clear_filter(driver,wait,"Triaged");
	scroll_down(driver);

	//5)Counting Not Triaged bugs
	//Searching for Triaged defects
	bug_label_search(driver,wait, "is not labeled");
	hit_search(driver,wait);
	//Counting defects
	not_triaged_defects=Integer.parseInt(get_count(driver,wait));
	System.out.println("Total No of SIM Not Triaged Defects are: " + not_triaged_defects);
	((HashMap<String, Integer>) data_array[month_flag][1]).put("NotTriaged",not_triaged_defects);
	String url= driver.getCurrentUrl();
//	map.put("NotTriaged",not_triaged_defects);
	//Clearing Label filter
	clear_filter(driver,wait,"NOT (Triaged)");
	clear_filter(driver,wait,"Open");
	scroll_down(driver);
	
		
	
	
	//6)Counting Fixed bugs
	clear_filter(driver,wait, "GDQ_QS_Detected_AlexaDiscovery");
	scroll_down(driver);
	//Searching with specific tag names
	tag_names.add("GDQ_QS_Detected_AlexaDiscovery");
	tag_names.add("QS_Fixed");
	tags_search(driver,wait,tag_names, "AND");
	tag_names.clear();
	//Counting defects
	fixed_defects=Integer.parseInt(get_count(driver,wait));
	((HashMap<String, Integer>) data_array[month_flag][1]).put("Fixed",fixed_defects);
	//map.put("Fixed",fixed_defects);
	System.out.println("Total No of SIM Fixed Defects are: " + fixed_defects);
	//Clearing Label filter
	clear_filter(driver,wait,"QS_Fixed");
	scroll_down(driver);
	
	if ( bug_triaged == 1 && total_data_flag == 1)
	{
		sim_not_triaged_url=url;
		scroll_up(driver);
		scroll_up(driver);
		clear_search(driver,wait);
		scroll_down(driver);
		
		
		//Last 15 days
		//Entering date
		date_range(driver,wait,days15,to_date);
		scroll_down(driver);
		//Entering Tags
		tag_names.add("GDQ_QS_Detected_AlexaDiscovery");
		tags_search(driver,wait,tag_names, "OR");
		scroll_down(driver);
		tag_names.clear();
		bug_status_search(driver,wait,"Open");
		scroll_down(driver);
		bug_label_search(driver,wait, "is not labeled");
		hit_search(driver,wait);
		//Counting defects
		not_triaged_defects=Integer.parseInt(get_count(driver,wait));
		System.out.println("Total No of SIM Not Triaged Defects in Last 15 days are: " + not_triaged_defects);
		((HashMap<String, Integer>) data_array[month_flag][1]).put("NotTriaged15days",not_triaged_defects);
		Thread.sleep(2000);
	
		//Last 30 days
		scroll_up(driver);
		clear_search(driver,wait);
		scroll_down(driver);
		
		//Entering date
		date_range(driver,wait,days30,days16);
		scroll_down(driver);
		//Entering Tags
		//Entering Tags
		tag_names.add("GDQ_QS_Detected_AlexaDiscovery");
		tags_search(driver,wait,tag_names, "OR");
		scroll_down(driver);
		tag_names.clear();
		bug_status_search(driver,wait,"Open");
		scroll_down(driver);
		bug_label_search(driver,wait, "is not labeled");
		hit_search(driver,wait);
		//Counting defects
		not_triaged_defects=Integer.parseInt(get_count(driver,wait));
		System.out.println("Total No of SIM Not Triaged Defects in Last 16-30 days are: " + not_triaged_defects);
		((HashMap<String, Integer>) data_array[month_flag][1]).put("NotTriaged30days",not_triaged_defects);
		Thread.sleep(2000);
		
		//Above 30 days
		scroll_up(driver);
		clear_search(driver,wait);
		scroll_down(driver);
		
		//Entering date
		date_range(driver,wait,from_date,above30days);
		scroll_down(driver);
		//Entering Tags
		tag_names.add("GDQ_QS_Detected_AlexaDiscovery");
		tags_search(driver,wait,tag_names, "OR");
		tag_names.clear();
		bug_status_search(driver,wait,"Open");
		scroll_down(driver);
		bug_label_search(driver,wait, "is not labeled");
		hit_search(driver,wait);
		//Counting defects
		not_triaged_defects=Integer.parseInt(get_count(driver,wait));
		System.out.println("Total No of SIM Not Triaged Defects for above 30 days are: " + not_triaged_defects);
		((HashMap<String, Integer>) data_array[month_flag][1]).put("NotTriagedAbove30days",not_triaged_defects);
		scroll_up(driver);
				clear_search(driver,wait);
				scroll_down(driver);
		
	}
	
	
	//To check and proceed for Bug Triaged - 1 or defect noise - 0
	if ( bug_triaged == 0)
	{
		//7)Counting Valid defects
		//Searching with specific tag names
		tag_names.add("GDQ_QS_Detected_AlexaDiscovery");
		tag_names.add("QS_Detected_Valid");
		tags_search(driver,wait,tag_names, "AND");
		tag_names.clear();
		//Counting defects
		valid_defects=Integer.parseInt(get_count(driver,wait));
		((HashMap<String, Integer>) data_array[month_flag][1]).put("Valid",valid_defects);

		//map.put("Valid",valid_defects);
		System.out.println("Total No of SIM Valid Defects are: " + valid_defects);
		//Clearing Label filter
		clear_filter(driver,wait,"QS_Detected_Valid");
		scroll_down(driver);
		
		//8)Counting Invalid defects
		//Searching with specific tag names
		tag_names.add("GDQ_QS_Detected_AlexaDiscovery");
		tag_names.add("QS_Detected_Invalid");
		tags_search(driver,wait,tag_names, "AND");
		tag_names.clear();
		//Counting defects
		
		invalid_defects=Integer.parseInt(get_count(driver,wait));
		((HashMap<String, Integer>) data_array[month_flag][1]).put("Invalid",invalid_defects);

	//	map.put("Invalid",invalid_defects);
		System.out.println("Total No of SIM Invalid Defects are: " + invalid_defects);
		//Clearing Label filter
		clear_filter(driver,wait,"QS_Detected_Invalid");
		scroll_down(driver);
		
		//9)Counting Testcase defects
		//Searching with specific tag names
		tag_names.add("GDQ_QS_Detected_AlexaDiscovery");
		tag_names.add("QS_Testcase");
		tags_search(driver,wait,tag_names, "AND");
		tag_names.clear();
		//Counting defects
		testcase_defects=Integer.parseInt(get_count(driver,wait));
		((HashMap<String, Integer>) data_array[month_flag][1]).put("Testcase",testcase_defects);

		//map.put("Testcase",testcase_defects);
		System.out.println("Total No of SIM Testcase Defects are: " + testcase_defects);
		//Clearing Label filter
		clear_filter(driver,wait,"QS_Testcase");
		scroll_down(driver);
		
		//10)Counting Adhoc defects
		//Searching with specific tag names
		tag_names.add("GDQ_QS_Detected_AlexaDiscovery");
		tag_names.add("QS_Adhoc");
		tags_search(driver,wait,tag_names, "AND");
		tag_names.clear();
		//Counting defects
		adhoc_defects=Integer.parseInt(get_count(driver,wait));
		((HashMap<String, Integer>) data_array[month_flag][1]).put("Adhoc",adhoc_defects);

	//	map.put("Adhoc",adhoc_defects);
		System.out.println("Total No of SIM Adhoc Defects are: " + adhoc_defects);
		//Clearing Label filter
		clear_filter(driver,wait,"QS_Adhoc");
		scroll_down(driver);
	
	}
		
}


	public static void report(ChromeDriver driver, WebDriverWait wait, String from_date, String to_date, String year) throws InterruptedException, IOException  {
		
		sc= new Scanner(System.in);
	
		
		//Setting to bug_triaged to 1
				//To check and proceed for Bug Triaged - 0 or defect noise -1
				bug_triaged = 1;
				total_data_flag=1;
				
				
				
		String from,to; //for temp saving monthly data
		end_month_num= Integer.parseInt(to_date.split("/")[0]);
		end_date_num=Integer.parseInt(to_date.split("/")[1]);
		//In Java 8 or later, this can be answered trivially using Streams without any loops or additional libraries.
		//int[] range = IntStream.iterate(1, n -> n + 1).limit(10).toArray();
		// int[] range = IntStream.rangeClosed(1, 10).toArray();

		month_array = IntStream.rangeClosed(1, end_month_num).toArray();

		//Calculating last 15,30 and above 30 days 
		 // Create a LocalDate instance for a specific date
        LocalDate date = LocalDate.of(Integer.parseInt(year),end_month_num , end_date_num); // January 1, 2023
        
        LocalDate tmp_date = date.minusDays(14);
        LocalDate tmp_date2 = date.minusDays(29);
        LocalDate tmp_date3 = date.minusDays(15);
        LocalDate tmp_date4 = date.minusDays(30);
        
       String tmp_date5 = date.plusDays(1).toString();
        
        String tmp = tmp_date.toString();
        String tmp2= tmp_date2.toString();
        String tmp3= tmp_date3.toString();
        String tmp4= tmp_date4.toString();
        		
       days15 = tmp.split("-")[1] + "/" + tmp.split("-")[2] + "/" + tmp.split("-")[0];
       days30 = tmp2.split("-")[1] + "/" + tmp2.split("-")[2] + "/" + tmp2.split("-")[0];
       days16 = tmp3.split("-")[1] + "/" + tmp3.split("-")[2] + "/" + tmp3.split("-")[0];
       above30days = tmp4.split("-")[1] + "/" + tmp4.split("-")[2] + "/" + tmp4.split("-")[0];
       new_to_date=tmp_date5.split("-")[1] + "/" + tmp_date5.split("-")[2] + "/" + tmp_date5.split("-")[0];
    
       /*
       System.out.println(days15);
       System.out.println(days30);
       System.out.println(days16);
       System.out.println( above30days);
       */
       
       
		//from_date="01/01/2024";
		//to_date="02/13/2024";
		System.out.println("Getting SIM Triaged Report for the year "+ year);
		
		//Choosing new next date (new_to_date) - as it includes all bugs created till to_date end. 
		triage_report(driver, wait,from_date, new_to_date,0);
		total_data_flag=0;
		System.out.println();
		//write_sim_data(sim_map,1,0,0);
		
		
		for (int month: month_array)
		{
			if (month <= end_month_num)
			{
				//Get month name
				String month_name= Month.of(month).name();
				System.out.println("Getting SIM Triaged Report for the month of "+month_name );
				
				// Get the number of days in that month
				YearMonth yearMonthObject = YearMonth.of((Integer.parseInt(year)), month);
				int daysInMonth = yearMonthObject.lengthOfMonth();
				from= month+ "/"+ "01" + "/"+ year;
				if (end_month_num == month)
				{
					to=new_to_date;
				}
				else {
					to=month+ "/"+  daysInMonth + "/"+ year;
				}
				
				System.out.println(from + " - " + to );
				triage_report(driver,wait,from, to,month);
			
				System.out.println();
				
				
			}
		}
		
			
}
}
