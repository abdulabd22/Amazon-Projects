package JiraSimProject;

import java.sql.Date;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.util.Calendar;

public class Practice {
	public static String days15, days16, days30,above30days;
	public static	String NotTriaged_15_days,NotTriaged_30_days,NotTriaged_Above_30_days;
    public static void main(String[] args) throws ParseException {
    	
    	String year = "2023";
    	String end_date_num="12", end_month_num ="03";
    	String new_to_date, to_date;
    	to_date="3/12/2024";
    	int mon,da;
    	String tmp_month;
    	mon= Integer.parseInt(to_date.split("/")[0]);
    	da=  Integer.parseInt(to_date.split("/")[1]);
    	
    	
    	String days15, days16, days30,above30days;
        // Create a LocalDate instance for a specific date
        LocalDate date = LocalDate.of(Integer.parseInt(year),Integer.parseInt(end_month_num) , Integer.parseInt(end_date_num)); // January 1, 2023
        

		NotTriaged_15_days=String.format("(issuetype = Bug AND created >= '%s' AND created <  '%s'  AND status in (Open)  AND  labels='%s' AND IsTriaged = No )", days15, new_to_date, org_label);
		NotTriaged_30_days=String.format("(issuetype = Bug AND created >= '%s' AND created < '%s'  AND status in (Open)  AND  labels='%s' AND IsTriaged = No )", days30, days16, org_label);
		NotTriaged_Above_30_days= String.format("(issuetype = Bug AND created >= '%s' AND created <  '%s'  AND status in (Open)  AND  labels='%s' AND IsTriaged = No )", from_date, above30days, org_label);
	
        
        LocalDate tmp_date = date.minusDays(15);
        LocalDate tmp_date2 = date.minusDays(30);
        LocalDate tmp_date3 = date.minusDays(16);
        LocalDate tmp_date4 = date.minusDays(31);
        
        days15 = tmp_date.toString();
        days30= tmp_date2.toString();
        days16= tmp_date3.toString();
        above30days= tmp_date4.toString();
        	
        
        
        System.out.println(days15);
        System.out.println(days30);
        System.out.println(days16);
        System.out.println(above30days);
        // Perform addition (e.g., add 10 days)
        //LocalDate result = date.plusDays(1);
       // System.out.println(date.minusDays(15).toString());
      //  new_to_date=  result.toString();
        // Get the result
       // System.out.println("Result: " + new_to_date);
        
    }
}