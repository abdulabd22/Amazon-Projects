package JiraSimProject;

import org.testng.annotations.Test;
import java.io.FileInputStream;
import java.io.IOException;
import java.time.Duration;
import java.time.LocalDate;
import java.time.Month;
import java.time.YearMonth;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Scanner;
import java.util.Set;
import java.util.stream.IntStream;
import org.testng.annotations.*;



import org.openqa.selenium.JavascriptExecutor;
import org.apache.commons.math3.util.Precision;
import org.openqa.selenium.By;
import org.openqa.selenium.Dimension;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.WindowType;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;

public class JiraTriagedReport {
	
	public static HashMap<String, Integer> map;
	public static String from, to, from_jira, to_jira, from_sim, to_sim, year, month,date;
	public static String parentwindowID, childwindowID;
	public static ChromeDriver driver, driver2;
	public static Set<String> windowids;
	public static  WebDriverWait wait,wait2;
	public static List<String> windowsList;
	public static int[] month_array;
	public static int end_month_num, end_date_num,bug_triaged, total_data_flag;
	public static Integer month_total=0, month_triaged=0, month_not_triaged=0, month_open=0, month_resolved=0, month_fixed=0;
	public static String Month_Triaged_percentage,  Month_Fixed_percentage;
	public static	String NotTriaged_15days,NotTriaged_30days,NotTriaged_Above_30days;
	public static String days15, days16, days30,above30days;
	public static String jira_not_triaged_url;
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
	
	
	@BeforeTest
	public static void prerun() throws InterruptedException
	{
		String str,count;
		Scanner sc= new Scanner(System.in);
		
		
		System.out.println("Enter the year: e.g. 2023 ");
		year=sc.next().trim();
		//year="2023";
		
		
		System.out.println("Enter To date as 'MM/DD' format : e.g. 11/29 ");
		str=sc.next().trim();
		//str="1/1:12/18";
		str="1/1:"+ str;
	
		/*
		System.out.println("1- Bug Untriaged data & 2 - For Defect Noise Analysis ");
		str=sc.next().trim();
		if ( str == "1")
		{
			bug_triaged=1;
		}
		else {
			bug_triaged=0;
		}
		*/
		bug_triaged=0;
		from= str.substring(0, str.indexOf(':'));
		to= str.substring(str.indexOf(':') + 1, str.length());
		
		from_jira = year + "-"+ from.replace('/', '-') ;
		to_jira =year + "-"+ to.replace('/', '-') ;
		from_sim =from + "/" +year;
		to_sim = to + "/" +year;
		
		/*
		System.out.println(from_jira);
		System.out.println(to_jira);
		System.out.println("Enter any input");
		*/
		
		
		//JIRA driver
		driver= new ChromeDriver();
		//driver.manage().window().maximize();
		driver.manage().window().setSize(new Dimension(1920, 1080));
		wait=new WebDriverWait(driver, Duration.ofSeconds(10));
		driver.get("https://midway-auth.amazon.com/login");
		midway2(wait);
		
		//SIM driver
		driver2= new ChromeDriver();
		//driver2.manage().window().maximize();
		driver2.manage().window().setSize(new Dimension(1920, 1080));
		wait2=new WebDriverWait(driver2, Duration.ofSeconds(10));
		driver2.get("https://midway-auth.amazon.com/login");
		midway2(wait2);
		
		//parentwindowID=driver.getWindowHandle();
		
		/*String url= driver.getCurrentUrl();
		if (url.contains("lasso.labcollab"))
		{
			midway(wait);
			
		}
		*/
		
		
		
		
		System.out.println("Enter any key after authenticating midway - JIRA and SIM:  ");
		str=sc.next();
		
		
		
		
		//driver.switchTo().newWindow(WindowType.WINDOW);
		//childwindowID= driver.getWindowHandle();
		
	    //driver.switchTo().window(parentwindowID);
		
	}
	
	
	@Test
	public static void run_jira() throws InterruptedException, IOException
	{
		
		driver.get("https://issues.labcollab.net/issues/?jql=");
		midway(wait);
		Thread.sleep(3000);
		report(driver, wait, from_jira,to_jira,year);
	}
	
	@Test
	 public static void run_sim() throws InterruptedException, IOException
	{ 
		 driver2.get("https://issues.amazon.com");
		 Thread.sleep(3000);
		SimTriagedReport.report(driver2, wait2,  from_sim,to_sim,year);
		
	}
	
	/*
	public static void main(String[] args) throws InterruptedException, IOException {
		prerun();
		run_jira();
		run_sim();
		postrun();
	}
	*/
	
	
	@AfterTest
	public static void postrun() throws InterruptedException, IOException
	{
		HashMap<String, Integer> jira_map = null, sim_map=null;
       String str;
		Scanner sc= new Scanner(System.in);
		
	/*	for (int i=0; i <= end_month_num; i++)
		{
			//jira_map= ((HashMap<String, Integer>) data_array[0][1]);
			sim_map= ((HashMap<String, Integer>) SimTriagedReport.data_array[i][1]);
			System.out.println(((String) SimTriagedReport.data_array[i][0]));
			
			
			for (Integer key: sim_map.values())
			{
				System.out.println(key);
			}
		}
		System.out.println("Stopping the program");
		str=sc.next();
		*/
		jira_map= ((HashMap<String, Integer>) data_array[0][1]);
        sim_map= ((HashMap<String, Integer>) SimTriagedReport.data_array[0][1]);
        write_total_data(jira_map, sim_map, 1, 0, 0);
//public static void write_total_data(HashMap<String, Integer> jira_map, HashMap<String, Integer> sim_map, int total_data_flag, int month_num, int month_start_row) 
        
		
		int month_row=19;
		for (int month: month_array)
		{
			jira_map= ((HashMap<String, Integer>) data_array[month][1]);
	        sim_map= ((HashMap<String, Integer>) SimTriagedReport.data_array[month][1]);
			//Get month name
			String month_name= Month.of(month).name();
			System.out.println("Writing Triage Report data for the month of "+month_name );
				
			write_total_data(jira_map, sim_map, 0, month, month_row);
			month_row +=3;
			
			
		}
		
		//Calculating Monthly Total and writing data.
		Month_Triaged_percentage= Double.toString(Precision.round(((Double.valueOf(month_triaged) / Double.valueOf(month_total) )* 100 ), 2))+ "%";
		Month_Fixed_percentage= Double.toString(Precision.round((Double.valueOf(month_fixed) / Double.valueOf(month_resolved) )  * 100,2))+ "%";
		String[] data10= {"Total", month_total.toString(), month_triaged.toString(), month_not_triaged.toString(), Month_Triaged_percentage.toString(), month_open.toString(), month_resolved.toString(), month_fixed.toString(), Month_Fixed_percentage.toString()};
		String excel_file= System.getProperty("user.dir")+ "//testdata//Triaged_report.xlsx";
		String sheet = "Sheet1";
		UtilityPOI.setCellsData(excel_file, sheet, month_row, 0, data10);
		
		System.out.println("JIRA Untriaged URL: ");
		System.out.println(jira_not_triaged_url);
		System.out.println("SIM Untriaged URL: ");
		System.out.println(SimTriagedReport.sim_not_triaged_url);
		
		driver.quit();
		driver2.quit();
	
	}
	
	public  static String get_count(ChromeDriver driver, WebDriverWait wait) {
		String total="0",text;
		try {
			
			text=driver.findElement(By.xpath("//div[@class='empty-results']//h2")).getText();
		
		}
		catch (Exception e) {
			total= wait.until(ExpectedConditions.visibilityOfElementLocated(By.xpath("//span[@class='results-count-text']"))).getText();
			total=total.split("of")[1].trim();
			
		}
		return total;
	}
	public static void clear(WebDriverWait wait) {
		wait.until(ExpectedConditions.elementToBeClickable(By.xpath("//textarea[@id='advanced-search']"))).clear();
	}

	public static void midway(WebDriverWait wait) throws InterruptedException
	{
		wait.until(ExpectedConditions.elementToBeClickable(By.xpath("//span[contains(text(), 'Amazon Employees')]"))).click();
		
		
		
	}
	public static void midway2(WebDriverWait wait)
	{
		wait.until(ExpectedConditions.elementToBeClickable(By.xpath("//input[@id='user_name']"))).sendKeys("rahaabdu");
		wait.until(ExpectedConditions.elementToBeClickable(By.xpath("//input[@id='password']"))).sendKeys("Cupcake@123");
		wait.until(ExpectedConditions.elementToBeClickable(By.xpath("//input[contains(@value,'Sign in')]"))).click();
	}
	public static void search_first_time(WebDriverWait wait)
	{
		try {
			
			 driver.findElement(By.xpath("//textarea[@id='advanced-search']")).click();
			
			
			}
			catch(Exception e)
			{
				
				
				//wait.until(ExpectedConditions.elementToBeClickable(By.xpath("//a[@data-id='basic']"))).click();
				wait.until(ExpectedConditions.elementToBeClickable(By.xpath("//a[contains(@original-title,\"Switch to advanced\")]"))).click();
			
			}
	}
	
	public static void search(WebDriverWait wait, String filter) throws InterruptedException
	{
		
		wait.until(ExpectedConditions.elementToBeClickable(By.xpath("//textarea[@id='advanced-search']"))).sendKeys(filter);
		//wait.until(ExpectedConditions.elementToBeClickable(By.xpath("//button[text()='Search']"))).click();
		WebElement element = driver.findElement(By.xpath("//button[text()='Search']"));
		JavascriptExecutor executor = driver;
		executor.executeScript("arguments[0].click()", element);
		
		Thread.sleep(4000);
	}
	
	public static void jira_triaged_report (ChromeDriver driver, WebDriverWait wait, String from_date, String to_date, int month_flag)throws InterruptedException, IOException
	{
		Scanner sc=new Scanner(System.in);
		String str, count;
			
		//from_date="2023-1-1";
		//to_date="2023-12-31";
		String org_label="GDQ_QS_Detected_AlexaDiscovery";
		String fixed_label="Fixed";
		
		//Adding one date to to_date so that last day is included in the search
		//e.g. 31st January, 2023 - adding one makes it February 1 ,2023 and using it '<' in below created filter 
		//so that bugs created on 31st January is included.
		String new_to_date;
    	int mon,da;
    	mon= Integer.parseInt(to_date.split("-")[1]);
    	da=  Integer.parseInt(to_date.split("-")[2]);
    	
        // Create a LocalDate instance for a specific date
        LocalDate date = LocalDate.of(Integer.parseInt(year),mon , da); // January 1, 2023
        
        // Perform addition (e.g., add 10 days)
        LocalDate result = date.plusDays(1);
        new_to_date=  result.toString();
       
        /*
        String Testcase_Defects="",Adhoc_Defects="",Regression_Defects="",NewFeature_Defects="",NR_Defects="",WontFix_Defects="",External_Defects="",ByDesign_Defects="",Duplicate_Defects="",CR_Defects="",Valid_Defects="",Invalid_Defects="",NewFeatureByDesign_Defects="";
        String Blocker_Defects="",Critical_Defects="",Major_Defects="",Minor_Defects="";
      
        if (bug_triaged == 0)
		{
        String testcase_label="QS_Testcase";
		String adhoc_label="QS_Adhoc";
		String regression_label="QS_FDX_REGRESSION";
		String new_feature_label="QS_FDX_NEWFEATURE";
		
	    String nr_label="QS_FDX_NR";
	    String wont_fix_label="QS_FDX_WF";
	    String external_label="QS_FDX_EXTERNAL";
	    String by_design_label ="QS_FDX_BD";
	    String duplicate_label="QS_FDX_DUPE";
	    String cr_label="QS_FDX_CR";
	    String valid_label="QS_Detected_Valid";
		String invalid_label="QS_Detected_Invalid";
		 
	    
		 Testcase_Defects=String.format("(issuetype = Bug AND created >= %s AND created <  %s  AND labels='%s' AND labels='%s')", from_date, new_to_date, org_label,testcase_label);
		Adhoc_Defects=String.format("(issuetype = Bug AND created >= %s AND created <  %s  AND labels='%s' AND labels='%s')", from_date, new_to_date, org_label,adhoc_label);
		Regression_Defects=String.format("(issuetype = Bug AND created >= %s AND created < %s   AND  labels='%s' AND labels='%s' )", from_date,new_to_date,org_label,regression_label);
		NewFeature_Defects=String.format("(issuetype = Bug AND created >= %s AND created < %s   AND  labels='%s' AND labels='%s' )", from_date,new_to_date,org_label,new_feature_label);
		NR_Defects=String.format("(issuetype = Bug AND created >= %s AND created < %s  AND status in (Resolved,Closed)  AND  labels='%s' AND labels='%s' )", from_date,new_to_date,org_label,nr_label);
		WontFix_Defects=String.format("(issuetype = Bug AND created >= %s AND created < %s  AND status in (Resolved,Closed)  AND  labels='%s' AND labels='%s' )", from_date,new_to_date,org_label,wont_fix_label);
		 External_Defects=String.format("(issuetype = Bug AND created >= %s AND created < %s  AND status in (Resolved,Closed)  AND  labels='%s' AND labels='%s' )", from_date,new_to_date,org_label,external_label);
		 NewFeatureByDesign_Defects=String.format("(issuetype = Bug AND created >= %s AND created < %s    AND  labels='%s' AND  labels='%s' AND labels='%s' )", from_date,new_to_date,org_label,new_feature_label, by_design_label);
		 Duplicate_Defects=String.format("(issuetype = Bug AND created >= %s AND created < %s  AND status in (Resolved,Closed)  AND  labels='%s' AND labels='%s' )", from_date,new_to_date,org_label,duplicate_label);
		CR_Defects=String.format("(issuetype = Bug AND created >= %s AND created < %s  AND status in (Resolved,Closed)  AND  labels='%s' AND labels='%s' )", from_date,new_to_date,org_label,cr_label);
		 ByDesign_Defects=String.format("(issuetype = Bug AND created >= %s AND created < %s  AND   labels='%s' AND labels='%s' )", from_date,new_to_date,org_label,by_design_label); 
		Valid_Defects=String.format("(issuetype = Bug AND created >= %s AND created < %s  AND status in (Resolved,Closed)  AND  labels='%s' AND labels='%s' )", from_date,new_to_date,org_label,valid_label);
		 Invalid_Defects=String.format("(issuetype = Bug AND created >= %s AND created < %s  AND status in (Resolved,Closed)  AND  labels='%s' AND labels='%s' )", from_date,new_to_date,org_label,invalid_label);
		
		 Blocker_Defects=String.format("(issuetype = Bug AND created >= %s AND created < %s   AND  labels='%s' AND labels='%s' AND priority in (Blocker))", from_date,new_to_date,org_label);
		Critical_Defects=String.format("(issuetype = Bug AND created >= %s AND created < %s  AND  labels='%s' AND labels='%s' AND priority in (Critical) )", from_date,new_to_date,org_label);
		Major_Defects=String.format("(issuetype = Bug AND created >= %s AND created < %s   AND  labels='%s' AND labels='%s' AND priority in (Major))", from_date,new_to_date,org_label);
		Minor_Defects=String.format("(issuetype = Bug AND created >= %s AND created < %s   AND  labels='%s'  AND priority in (Minor) )", from_date,new_to_date,org_label);

		}
        */
		String Overall_Defects=String.format("(issuetype = Bug AND created >= %s AND created <  %s  AND labels in (%s))", from_date, new_to_date, org_label); 
		String Open_Defects=String.format("(issuetype = Bug AND created >= %s AND created <  %s  AND  status not in (Closed, Resolved)   AND labels in (%s))", from_date, new_to_date, org_label);
		String Resolved_Defects= String.format("(issuetype = Bug AND created >= %s AND created <  %s  AND status in (Closed, Resolved)  AND labels in (%s))", from_date, new_to_date, org_label);
		String Triaged_Defects=String.format("(issuetype = Bug AND created >= %s AND created <  %s  AND status not in (Resolved, Closed)  AND  labels='%s' AND IsTriaged = Yes )", from_date, new_to_date, org_label);
		String NotTriaged_Defects=String.format("(issuetype = Bug AND created >= %s AND created <  %s  AND status not in (Resolved, Closed)  AND  labels='%s' AND IsTriaged = No )", from_date, new_to_date, org_label);
		String Fixed_Defects=String.format("(issuetype = Bug AND created >= %s AND created <  %s  AND status in (Closed, Resolved)  AND  labels='%s' AND labels='%s')", from_date, new_to_date, org_label,fixed_label);
		
	

			NotTriaged_15days=String.format("(issuetype = Bug AND created >= '%s' AND created <  '%s'  AND status not in (Resolved, Closed)  AND  labels='%s' AND IsTriaged = No )", days15, new_to_date, org_label);
			NotTriaged_30days=String.format("(issuetype = Bug AND created >= '%s' AND created < '%s'  AND status not in (Resolved, Closed)  AND  labels='%s' AND IsTriaged = No )", days30, days15, org_label);
			NotTriaged_Above_30days= String.format("(issuetype = Bug AND created >= '%s' AND created <  '%s' AND status not in (Resolved, Closed) AND  labels='%s' AND IsTriaged = No )", from_date, days30, org_label);
		
		
		
	
		String filter_array[][]=
			{
					{"Overall_Defects", Overall_Defects},
					{"Resolved_Defects",Resolved_Defects},
					{"Open_Defects",Open_Defects},
					{"Fixed_Defects",Fixed_Defects},
					{"Triaged_Defects",Triaged_Defects},
					{"NotTriaged_Defects",NotTriaged_Defects},
					{"NotTriaged15days_Defects", NotTriaged_15days},
					{"NotTriaged30days_Defects", NotTriaged_30days},
					{"NotTriagedAbove30days_Defects", NotTriaged_Above_30days},
					/*
					{"Testcase_Defects",Testcase_Defects},
					{"Adhoc_Defects",Adhoc_Defects},
					{"Regression_Defects",Regression_Defects },
					{"NewFeature_Defects",NewFeature_Defects},
					{"NotReproducible_Defects", NR_Defects},
					{"WontFix_Defects",WontFix_Defects},
					{"External_Defects",External_Defects},
					{"NewFeatureByDesign_Defects",NewFeatureByDesign_Defects},					
					{"Duplicate_Defects",Duplicate_Defects},
					{"CannotRepoducible_Defects",CR_Defects},
					{"ByDesign_Defects",ByDesign_Defects},
					{"Valid_Defects",Valid_Defects},
					{"Invalid_Defects",Invalid_Defects},
					{"Blocker_Defects", Blocker_Defects},
					{"Critical_Defects", Critical_Defects},
					{"Major_Defects", Major_Defects},
					{"Minor_Defects", Minor_Defects},
					*/
							
			};
		
		
		
		

		
		String title1;
		int total_count;
		
		//For Bug triaged report - from 0 to 8 in filter array - 0 to 5 and then 6 to 8.
		String url=null;
		int num;
		
		//For Defect Noise Analysis - 0 to 5 and 9 to 13
		/*if (bug_triaged == 0)
		{
			num = 17;
		}
			else {
				num=5;
			}
			*/
		num=5;
		for (int i =0; i <=num; i++)
		{
			//Skipping 15 days, 16-30 days and >30 days in the filter array
		/*	if ( num == 6 || num == 7 || num ==8 )
				
			{
				continue;
			}*/
			title1=filter_array[i][0].split("_")[0].trim();
			String filter=filter_array[i][1];
			search(wait, filter);
			count=get_count(driver, wait);
			
			
			if (title1.equals("Triaged"))
			{
				int resolved=((HashMap<String, Integer>) data_array[month_flag][1]).get("Resolved").intValue();
				total_count = Integer.valueOf(count).intValue() +  resolved;
				((HashMap<String, Integer>) data_array[month_flag][1]).put(title1,(Integer.valueOf(total_count)));
				
				//map.put(title1,(Integer.valueOf(total_count)));
				System.out.println(String.format("Total number of JIRA %s defects are : %s", title1,total_count));
			}
			else {
				
				((HashMap<String, Integer>) data_array[month_flag][1]).put(title1,(Integer.valueOf(count)));
				//map.put(title1,(Integer.valueOf(count)));
				System.out.println(String.format("Total number of JIRA %s defects are : %s", title1,count));
			
				
			}
			if (title1.equals("NotTriaged"))
			{
				url= driver.getCurrentUrl();
			}
			System.out.println(filter);
			clear(wait);
			Thread.sleep(1000);
			
		}
		
		if ( bug_triaged == 1 && total_data_flag == 1)
		{
			System.out.println("Entering 15,30, above 30 days");
			System.out.println("Days 15days: " + days15);
			System.out.println("Days 30days: " + days30);
			System.out.println("Days above 30 days: " + above30days);
			jira_not_triaged_url=url;
		for (int i=6; i <=8; i++)
		{
					
			title1=filter_array[i][0].split("_")[0].trim();
			String filter=filter_array[i][1];
			System.out.println(filter);
			search(wait, filter);
			count=get_count(driver, wait);
			((HashMap<String, Integer>) data_array[month_flag][1]).put(title1,(Integer.valueOf(count)));
			//map.put(title1,(Integer.valueOf(count)));
			System.out.println(String.format("Total number of JIRA %s defects are : %s", title1,count));
			clear(wait);
			
		}
		
		}
		
		
		
				
		
	}
	
	public static void write_total_data(HashMap<String, Integer> jira_map, HashMap<String, Integer> sim_map, int total_data_flag, int month_num, int month_start_row) throws IOException {
		
		String excel_file= System.getProperty("user.dir")+ "//testdata//Triaged_report.xlsx";
		String sheet = "Sheet1";
		String Open_percentage,Triaged_percentage,Fixed_percentage;
		Integer jira_total,jira_resolved, jira_open, jira_fixed, jira_triaged, jira_not_triaged;
		Integer jira_15days,sim_15days, jira_30days, sim_30days,jira_Above30days, sim_Above30days;
		String total_15days, total_30days, total_Above30days;
		Integer sim_total,sim_resolved, sim_open, sim_fixed, sim_triaged, sim_not_triaged;
		Integer total, resolved, open, fixed, triaged, not_triaged;
		
		jira_total= jira_map.get("Overall");
		jira_resolved= jira_map.get("Resolved");
		jira_open= jira_map.get("Open");
		jira_fixed= jira_map.get("Fixed");
		jira_triaged= jira_map.get("Triaged");
		jira_not_triaged= jira_map.get("NotTriaged");
		
				
		
		sim_total= sim_map.get("Overall");
		sim_resolved= sim_map.get("Resolved");
		sim_open= sim_map.get("Open");
		sim_fixed= sim_map.get("Fixed");
		sim_triaged= sim_map.get("Triaged");
		sim_not_triaged= sim_map.get("NotTriaged");
		
		
		total= jira_total +sim_total;
		resolved= jira_resolved +sim_resolved;
		open= jira_open +sim_open;
		fixed=jira_fixed +sim_fixed;
		triaged= jira_triaged +sim_triaged;
		not_triaged= jira_not_triaged +sim_not_triaged;
		
		
		
		String Sim_Open_percentage, Sim_Triaged_percentage, Sim_Fixed_percentage;
		String Jira_Open_percentage, Jira_Triaged_percentage, Jira_Fixed_percentage;
	
		Jira_Open_percentage= Double.toString(Precision.round((jira_open.doubleValue() / jira_total.doubleValue() ) * 100	,2))+ "%";
		Jira_Triaged_percentage= Double.toString(Precision.round(((jira_triaged.doubleValue()) / jira_total.doubleValue() ) * 100 , 2))+ "%";
		Jira_Fixed_percentage= Double.toString(Precision.round((jira_fixed.doubleValue() / jira_resolved.doubleValue() ) * 100,2))+ "%";
		
		Sim_Open_percentage= Double.toString(Precision.round((sim_open.doubleValue() / sim_total.doubleValue() ) * 100	,2))+ "%";
		Sim_Triaged_percentage= Double.toString(Precision.round(((sim_triaged.doubleValue()) / sim_total.doubleValue() ) * 100 , 2))+ "%";
		Sim_Fixed_percentage= Double.toString(Precision.round((sim_fixed.doubleValue() / sim_resolved.doubleValue() ) * 100,2))+ "%";
		
		
		Open_percentage= Double.toString(Precision.round((( Double.valueOf(open) / Double.valueOf(total) ) * 100),2))+ "%";
		Triaged_percentage= Double.toString(Precision.round(((Double.valueOf(triaged) / Double.valueOf(total) )* 100 ), 2))+ "%";
		Fixed_percentage= Double.toString(Precision.round((Double.valueOf(fixed) / Double.valueOf(resolved) )  * 100,2))+ "%";
		
		System.out.println("Open percentage: " + Open_percentage);
		System.out.println("Triaged percentage: " + Triaged_percentage);
		System.out.println("Fixed percentage: " + Fixed_percentage);
		
		
		if ( total_data_flag == 1)
		{
		//For total data
			jira_15days=jira_map.get("NotTriaged15days");
			jira_30days=jira_map.get("NotTriaged30days");
			jira_Above30days=jira_map.get("NotTriagedAbove30days");
			
			sim_15days=sim_map.get("NotTriaged15days");
			sim_30days=sim_map.get("NotTriaged30days");
			sim_Above30days=sim_map.get("NotTriagedAbove30days");
			
			total_15days= Integer.toString( jira_15days+ sim_15days);
			total_30days=Integer.toString(jira_30days + sim_30days);
			total_Above30days=Integer.toString(jira_Above30days + sim_Above30days);
			
		
		String[] data1={"JIRA",jira_total.toString(), jira_resolved.toString(), jira_open.toString(), jira_fixed.toString(), jira_triaged.toString(), jira_not_triaged.toString(),Jira_Triaged_percentage, jira_15days.toString(), jira_30days.toString(), jira_Above30days.toString() };
		String[] data2= {"JIRA", jira_total.toString(), jira_open.toString(), Jira_Open_percentage, jira_resolved.toString(), jira_fixed.toString(), Jira_Fixed_percentage};
		String[] data3={"SIM",sim_total.toString(), sim_resolved.toString(), sim_open.toString(), sim_fixed.toString(), sim_triaged.toString(), sim_not_triaged.toString(),Sim_Triaged_percentage, sim_15days.toString(), sim_30days.toString(), sim_Above30days.toString() };
		String[] data4= {"SIM", sim_total.toString(), sim_open.toString(), Sim_Open_percentage, sim_resolved.toString(), sim_fixed.toString(), Sim_Fixed_percentage};
		
		//For total data
		String[] data5={"Total", Integer.toString(total), Integer.toString(resolved), Integer.toString(open), Integer.toString(fixed), Integer.toString(triaged), Integer.toString(not_triaged),Triaged_percentage, total_15days,total_30days, total_Above30days };
		String[] data6= { "Total", Integer.toString(total), Integer.toString(open), Open_percentage, Integer.toString(resolved), Integer.toString(fixed), Fixed_percentage};
		
		//JIRA
		UtilityPOI.setCellsData(excel_file, sheet, 4, 0, data1);
		UtilityPOI.setCellsData(excel_file, sheet, 11, 0, data2);
		//SIM
		UtilityPOI.setCellsData(excel_file, sheet, 5, 0, data3);
		UtilityPOI.setCellsData(excel_file, sheet, 12, 0, data4);
		//Total
		UtilityPOI.setCellsData(excel_file, sheet, 6, 0, data5);
		UtilityPOI.setCellsData(excel_file, sheet, 13, 0, data6);
		
	}
	else
		
	{
		//For monthly data
		//Get month name
		String month_name= Month.of(month_num).name();
		String[] data7= {month_name + " " + "JIRA", jira_total.toString(), jira_triaged.toString(), jira_not_triaged.toString(), Jira_Triaged_percentage,jira_open.toString(), jira_resolved.toString(),jira_fixed.toString(), Jira_Fixed_percentage};
		String[] data8= {month_name + " " + "SIM", sim_total.toString(), sim_triaged.toString(), sim_not_triaged.toString(), Sim_Triaged_percentage,sim_open.toString(), sim_resolved.toString(),sim_fixed.toString(), Sim_Fixed_percentage};
		String[] data9= {month_name, total.toString(), triaged.toString(), not_triaged.toString(), Triaged_percentage,open.toString(), resolved.toString(),fixed.toString(), Fixed_percentage};
		
		
		UtilityPOI.setCellsData(excel_file, sheet, month_start_row, 0, data7);
		UtilityPOI.setCellsData(excel_file, sheet, month_start_row+1, 0, data8);
		UtilityPOI.setCellsData(excel_file, sheet, month_start_row+2, 0, data9);
		
		month_total+= total;
		month_triaged +=triaged;
		month_not_triaged += not_triaged;
		month_open += open;
		month_resolved += resolved;
		month_fixed += fixed;
		
		
	}
		
		
	}
	
	
	public static void report(ChromeDriver driver, WebDriverWait wait, String from_date, String to_date, String year) throws InterruptedException, IOException {

		bug_triaged = 1;
		total_data_flag=1;
		
		end_month_num= Integer.parseInt(to_date.split("-")[1]);
		end_date_num=Integer.parseInt(to_date.split("-")[2]);
		
		//In Java 8 or later, this can be answered trivially using Streams without any loops or additional libraries.
				//int[] range = IntStream.iterate(1, n -> n + 1).limit(10).toArray();
				// int[] range = IntStream.rangeClosed(1, 10).toArray();

		month_array = IntStream.rangeClosed(1, end_month_num).toArray();
		
		
		String from,to; //for temp saving monthly data
	
		//Calculating last 15,30 and above 30 days 
		 // Create a LocalDate instance for a specific date
       LocalDate date = LocalDate.of(Integer.parseInt(year),end_month_num , end_date_num); // January 1, 2023
       
       days15 = date.minusDays(15).toString();
       days30  = date.minusDays(30).toString();
       days16  = date.minusDays(16).toString();
       above30days = date.minusDays(31).toString();
       
      
		System.out.println("Getting JIRA Triaged report for the year: " + year );
		search_first_time(wait);
		jira_triaged_report(driver, wait, from_date, to_date,0);
		System.out.println();
		total_data_flag=0;
		//map=((HashMap<String, Integer>) data_array[0][1]);
		//write_total_data(map,1,0,0);
		
	
		
		
		
		//For writing in excel sheet - monthly data
		int month_row=19;
		for (int month: month_array)
		{
			
			//Get month name
			String month_name= Month.of(month).name();
			System.out.println("Getting JIRA Triaged Report for the month of "+month_name );
				
			// Get the number of days in that month
				YearMonth yearMonthObject = YearMonth.of((Integer.parseInt(year)), month);
				int daysInMonth = yearMonthObject.lengthOfMonth();
				from= year+ "-"+ month + "-"+ "01";
				if (end_month_num == month)
				{
					to=to_date;
				}
				else {
					to=year+ "-"+  month + "-"+ daysInMonth;
				}
				
				
				jira_triaged_report(driver,wait,from, to, month);
				
				System.out.println();
				
			
			
		}
		
		
	}
		
	
		
		
		

}
