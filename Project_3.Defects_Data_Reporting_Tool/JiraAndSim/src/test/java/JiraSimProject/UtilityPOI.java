package JiraSimProject;

import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;


import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.CellType;
import org.apache.poi.ss.usermodel.DataFormatter;
import org.apache.poi.ss.usermodel.FillPatternType;
import org.apache.poi.ss.usermodel.IgnoredErrorType;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;


public class UtilityPOI {

		
		public static FileInputStream fi;
		public static FileOutputStream fo;
		public static XSSFWorkbook wb;
		public static XSSFSheet ws;
		public static  XSSFRow row;
		public static  XSSFCell cell;
		public static CellStyle style;
		
		public static int getRowCount(String xlfile, String xlsheet) throws IOException 
		{
			fi=new FileInputStream(xlfile);
			wb = new XSSFWorkbook(fi);
			ws = wb.getSheet(xlsheet);
			int rowCount = ws.getLastRowNum();
			fi.close();
			wb.close();
			return rowCount;		
		}
		
		public static int getCellCount(String xlfile,String xlsheet,int rownum) throws IOException
		{
			fi=new FileInputStream(xlfile);
			wb = new XSSFWorkbook(fi);
			ws = wb.getSheet(xlsheet);
			int cellcount = ws.getRow(rownum).getLastCellNum();
			fi.close();
			wb.close();
			return cellcount;		
		
		}
		
		public static String getCellData(String xlfile,String xlsheet,int rownum,int colnum) throws IOException
		{
			fi=new FileInputStream(xlfile);
			wb=new XSSFWorkbook(fi);
			ws=wb.getSheet(xlsheet);
			row=ws.getRow(rownum);
			cell=row.getCell(colnum);
		
			String data;
			try 
			{
				//data=cell.toString();
				
			DataFormatter formatter = new DataFormatter();
	        data = formatter.formatCellValue(cell);
	            return data;
			}
			catch (Exception e) 
			{
				data="";
			}
			
			wb.close();
			fi.close();
			return data;
		}
		
		public static void setCellData(String xlfile,String xlsheet,int rownum,int colnum,String data) throws IOException
		{
			
			fi=new FileInputStream(xlfile);
			wb=new XSSFWorkbook(fi);
			ws=wb.getSheet(xlsheet);
			row=ws.getRow(rownum);
			cell=row.createCell(colnum);
			cell.setCellValue(data);
			fo=new FileOutputStream(xlfile);
			
			wb.write(fo);		
			wb.close();
			fi.close();
			fo.close();
					
		}
		
		public static void setCellsData(String xlfile,String xlsheet,int rownum,int start_colnum,String[] data) throws IOException
		{
			
			fi=new FileInputStream(xlfile);
			wb=new XSSFWorkbook(fi);
			ws=wb.getSheet(xlsheet);
			row=ws.createRow(rownum);
			//row=ws.getRow(rownum);
			int col=start_colnum;
			for ( String value : data )
			{
				cell=row.createCell(col);
				cell.setCellValue(value);
				col++;
				
				
			}
			ws.addIgnoredErrors(new CellRangeAddress(0, ws.getLastRowNum(), 0, 20),
		            IgnoredErrorType.NUMBER_STORED_AS_TEXT);
			
			fo=new FileOutputStream(xlfile);
			wb.write(fo);		
			wb.close();
			fi.close();
			fo.close();
					
		}
		
		public static void fillGreenColor(String xlfile,String xlsheet,int rownum,int colnum) throws IOException
		{
			fi=new FileInputStream(xlfile);
			wb=new XSSFWorkbook(fi);
			ws=wb.getSheet(xlsheet);
			row=ws.getRow(rownum);
			cell=row.getCell(colnum);
			
			style=wb.createCellStyle();
			
			style.setFillForegroundColor(IndexedColors.GREEN.getIndex());
			style.setFillPattern(FillPatternType.SOLID_FOREGROUND); 
					
			cell.setCellStyle(style);
			fo=new FileOutputStream(xlfile);
			wb.write(fo);
			wb.close();
			fi.close();
			fo.close();
		}
		
		
		public static void fillRedColor(String xlfile,String xlsheet,int rownum,int colnum) throws IOException
		{
			fi=new FileInputStream(xlfile);
			wb=new XSSFWorkbook(fi);
			ws=wb.getSheet(xlsheet);
			row=ws.getRow(rownum);
			cell=row.getCell(colnum);
			
			style=wb.createCellStyle();
			
			style.setFillForegroundColor(IndexedColors.RED.getIndex());
			style.setFillPattern(FillPatternType.SOLID_FOREGROUND);  
			
			cell.setCellStyle(style);		
			fo=new FileOutputStream(xlfile);
			wb.write(fo);
			wb.close();
			fi.close();
			fo.close();
		}
		
		public static void mergeCells(String xlfile,String xlsheet,int row_from,int column_from, int row_to, int column_to) throws IOException
		{
			fi=new FileInputStream(xlfile);
			wb=new XSSFWorkbook(fi);
			ws=wb.getSheet(xlsheet);		
			fo=new FileOutputStream(xlfile);
	
			//Merging cells by providing cell index  
            ws.addMergedRegion(new CellRangeAddress(row_from,column_from,row_to,column_to));  
            wb.write(fo); 
			wb.close();
			fi.close();
			fo.close();
		}
			

	}

