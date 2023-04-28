<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="user_interface.css">
    <title>
        選課系統
    </title>
</head>

<body>
	<%
		// my database information
		String server = "localhost";
		String database = "course-registration-system_schema";
		String user = "root";
		String password = "BlackPomeranian";
		int port = 3306;
		String url = "jdbc:mysql://" + server + ":" + port + "/" + database +
		    "?user=" + user + "&password=" + password + "&useSSL=true&characterEncoding=UTF-8&serverTimezone=UTC";
		
		String sql = "\0";  // my sql statement
		String target;      // used to receive parameters
		String element1;
		String element2;
		String element3;
		String element4;
		String element5;
		String element6;
		
		boolean flag = true;
		
		try {
			Class.forName("com.mysql.cj.jdbc.Driver").newInstance();  // 載入驅動程式
		    Connection conn = DriverManager.getConnection(url);       // 建立連線
		    Statement stmt = conn.createStatement();
			sql = "SELECT student_id, TimeSlot.section_code, section_name, week_time, starting_time, ending_time FROM SelectDetail INNER JOIN Section ON SelectDetail.section_code = Section.section_code RIGHT JOIN TimeSlot ON SelectDetail.section_code = TimeSlot.section_code;";
		    ResultSet rs = stmt.executeQuery(sql);  
		    
		    element1 = rs.getString("TimeSlot.section_code");  
			element2 = rs.getString("section_name");
			element3 = rs.getString("week_time");
			element4 = rs.getString("starting_time");
			element5 = rs.getString("ending_time");
			
			while(rs.next()) {
				element1 = rs.getString("TimeSlot.section_code");  
				element2 = rs.getString("section_name");
				element3 = rs.getString("week_time");
				element4 = rs.getString("starting_time");
				element5 = rs.getString("ending_time");
				
			}
		      
		    //關閉連線  
		    rs.close();  
		    stmt.close();  
		    conn.close(); 
		} catch (Exception e) {
		    e.printStackTrace();
		    //out.println("<p style=\"text-align:center; color:green;\">" + "與資料庫連線失敗" + "</p>");
		}
			
		
		
	%>
    <div class="header">
        <h1>選課系統</h1>
        <hr>
    </div>

    <div class="content">
        <div class="left_content">
            <!-- <p>left</p> -->
            <fieldset>
                <legend>學生資料</legend>
                <p id="display_student_id">學號:</p>
                <p id="display_student_name">姓名:</p>
                <p id="display_student_class">班級:</p>
                <P>學分上限:30</P>
                <p>學分下限:9</p>
            </fieldset>
            <fieldset>
            	<legend>系統操作原則</legend>
            </fieldset>
            <fieldset>
            	<legend>注意事項</legend>
            </fieldset>
        </div>
        <div class="right_content">
            <!-- <p>right</p> -->
            <fieldset>
            	<legend>查詢課程</legend>
            	<form action="user_interface.jsp" method="post">
	                <label for="section_code">查詢選課代碼</label>
	                <input type="text" inputmode="numeric" maxlength=4 name="section_code" id="section_code">
	                <button type="submit">查詢</button>
	            </form>
            </fieldset>
            
 
			<fieldset>
				<legend>課程加選</legend>
				<form action="user_interface.jsp" method="post">

				<%
					
					target = request.getParameter("section_code");
					
					flag = true;
					
					if(target != null) {
						try {
							Class.forName("com.mysql.cj.jdbc.Driver").newInstance();  // 載入驅動程式
						    Connection conn = DriverManager.getConnection(url);       // 建立連線
						    Statement stmt = conn.createStatement();
						    sql = "SELECT * FROM Section WHERE section_code LIKE " + target + ";";
						    //sql = "SELECT * FROM Section;";
						    ResultSet rs = stmt.executeQuery(sql);  
						    
						    
						    //依據資料庫中的欄位名列印資料 
						    out.println("<table border=\"1px solid\"  style=\"font-size: 20px; border-collapse: collapse;\">");
						   
						    while(rs.next()){
						    	
						    	// the header is printed only once
						    	if(flag) {
						    		out.println("<tr>");
						    	    out.println("</td>");
						    	    out.println("<td>");
						    	    out.println("<td>");
						    	    out.println("選課代碼");
						    	    out.println("</td>");
						    	    out.println("<td>");
						    	    out.println("課程名稱");
						    	    out.println("</td>");
						    	    out.println("</tr>");
						    	    flag = false;
						    	} 
						    	
						    	element1 = rs.getString("section_code");  
								element2 = rs.getString("section_name");
								out.println("<tr>");
								out.println("<td>");
								out.println("<button type=\"submit\">" + "加選" + "</button>");
								out.println("<td>");
								out.println(element1);
								out.println("</td>");
								out.println("<td>");
								out.println(element2);
								out.println("</td>");
								out.println("</tr>");
								
						    }
						    out.println("</table>");	
						    
						  	 
						    
						        
						 	// 找不到任何資料
							sql = "SELECT COUNT(*) AS row_count FROM Section WHERE section_code LIKE " + target + ";";
							rs = stmt.executeQuery(sql);
							if(rs.next() && rs.getString("row_count").equals("0")){
								out.println("<p style=\"text-align:center; color:red;\">" + "找不到課程資料" + "</p>");
						 	}
							
							//關閉連線  
						    rs.close();  
						    stmt.close();  
						    conn.close();
						} catch (Exception e) {
						    e.printStackTrace();
						    out.println("<p style=\"text-align:center; color:green;\">" + "請輸入選課代碼" + "</p>");
						}
						
					} else {
						out.println("<p style=\"text-align:center; color:green;\">" + "請輸入選課代碼" + "</p>");
					}
					
				                
				%>

				</form>
			</fieldset>
			
			<fieldset>
				<legend>已選課表</legend>
            	<table class="course_table">
                    <tr style="width: 10%; height: 50px; border: 1px solid black; border-collapse: collapse;">
                        <th class="course_table"></th>
                        <th class="course_table">星期一</th>
                        <th class="course_table">星期二</th>
                        <th class="course_table">星期三</th>
                        <th class="course_table">星期四</th>
                        <th class="course_table">星期五</th>
                        <th class="course_table">星期六</th>
                        <th class="course_table">星期日</th>
                    </tr>
                    <tr class="course_table">
                        <th class="course_table">1<br>08:10~09:00</th>
                        <td class="course_table"></td>
                        <td class="course_table"></td>
                        <td class="course_table"></td>
                        <td class="course_table"></td>
                        <td class="course_table"></td>
                        <td class="course_table"></td>
                        <td class="course_table"></td>
                    </tr>
                    <tr class="course_table">
                        <th class="course_table">2<br>09:10~10:00</th>
						<td class="course_table"></td>
                        <td class="course_table"></td>
                        <td class="course_table"></td>
                        <td class="course_table"></td>
                        <td class="course_table"></td>
                        <td class="course_table"></td>
                        <td class="course_table"></td>
                    </tr>
                    <tr class="course_table">
                        <th class="course_table">3<br>10:10~11:00</th>
                        <td class="course_table"></td>
                        <td class="course_table"></td>
                        <td class="course_table"></td>
                        <td class="course_table"></td>
                        <td class="course_table"></td>
                        <td class="course_table"></td>
                        <td class="course_table"></td>
                    </tr>
                    <tr class="course_table">
                        <th class="course_table">4<br>11:10~12:00</th>
                        <td class="course_table"></td>
                        <td class="course_table"></td>
                        <td class="course_table"></td>
                        <td class="course_table"></td>
                        <td class="course_table"></td>
                        <td class="course_table"></td>
                        <td class="course_table"></td>
                    </tr>
                    <tr class="course_table">
                        <th>5<br>12:10~13:00</th>
                        <td class="course_table"></td>
                        <td class="course_table"></td>
                        <td class="course_table"></td>
                        <td class="course_table"></td>
                        <td class="course_table"></td>
                        <td class="course_table"></td>
                        <td class="course_table"></td>
                    </tr>
                    <tr class="course_table">
                        <th>6<br>13:10~14:00</th>
                        <td class="course_table"></td>
                        <td class="course_table"></td>
                        <td class="course_table"></td>
                        <td class="course_table"></td>
                        <td class="course_table"></td>
                        <td class="course_table"></td>
                        <td class="course_table"></td>
                    </tr>
                    <tr class="course_table">
                        <th class="course_table">7<br>14:10~15:00</th>
                        <td class="course_table"></td>
                        <td class="course_table"></td>
                        <td class="course_table"></td>
                        <td class="course_table"></td>
                        <td class="course_table"></td>
                        <td class="course_table"></td>
                        <td class="course_table"></td>
                    </tr>
                    <tr class="course_table">
                        <th class="course_table">8<br>15:10~16:00</th>
                        <td class="course_table"></td>
                        <td class="course_table"></td>
                        <td class="course_table"></td>
                        <td class="course_table"></td>
                        <td class="course_table"></td>
                        <td class="course_table"></td>
                        <td class="course_table"></td>
                    </tr>
                    <tr class="course_table">
                        <th class="course_table">9<br>16:10~17:00</th>
                        <td class="course_table"></td>
                        <td class="course_table"></td>
                        <td class="course_table"></td>
                        <td class="course_table"></td>
                        <td class="course_table"></td>
                        <td class="course_table"></td>
                        <td class="course_table"></td>
                    </tr>
                    <tr class="course_table">
                        <th class="course_table">10<br>17:10~18:00</th>
                        <td class="course_table"></td>
                        <td class="course_table"></td>
                        <td class="course_table"></td>
                        <td class="course_table"></td>
                        <td class="course_table"></td>
                        <td class="course_table"></td>
                        <td class="course_table"></td>
                    </tr>
                    <tr class="course_table">
                        <th class="course_table">11<br>18:30~19:20</th>
                        <td class="course_table"></td>
                        <td class="course_table"></td>
                        <td class="course_table"></td>
                        <td class="course_table"></td>
                        <td class="course_table"></td>
                        <td class="course_table"></td>
                        <td class="course_table"></td>
                    </tr>
                    <tr class="course_table">
                        <th class="course_table">12<br>19:25~20:15</th>
                        <td class="course_table"></td>
                        <td class="course_table"></td>
                        <td class="course_table"></td>
                        <td class="course_table"></td>
                        <td class="course_table"></td>
                        <td class="course_table"></td>
                        <td class="course_table"></td>
                    </tr>
                    <tr class="course_table">
                        <th class="course_table">13<br>20:25~21:15</th>
                        <td class="course_table"></td>
                        <td class="course_table"></td>
                        <td class="course_table"></td>
                        <td class="course_table"></td>
                        <td class="course_table"></td>
                        <td class="course_table"></td>
                        <td class="course_table"></td>
                    </tr>
                    <tr class="course_table">
                        <th class="course_table">14<br>21:20~22:10</th>
                        <td class="course_table"></td>
                        <td class="course_table"></td>
                        <td class="course_table"></td>
                        <td class="course_table"></td>
                        <td class="course_table"></td>
                        <td class="course_table"></td>
                        <td class="course_table"></td>
                    </tr>
            	</table>
            </fieldset>
		</div>
	</div>
</body>
</html>