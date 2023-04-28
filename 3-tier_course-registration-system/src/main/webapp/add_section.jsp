<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="user_interface.css">
    <title>
        課程加選功能
    </title>
</head>
<body>

<%
		//my database information
		String server = "localhost";
		String database = "course-registration-system_schema";
		String user = "root";
		String password = "BlackPomeranian";
		int port = 3306;
		String url = "jdbc:mysql://" + server + ":" + port + "/" + database +
		    "?user=" + user + "&password=" + password + "&useSSL=true&characterEncoding=UTF-8&serverTimezone=UTC";
		
		String sql = "\0";  // my sql statement
		String target;      // used to receive parameters
		String section_code = request.getParameter("section_code");
		
		String section_name;
		String max_enrollment;
		String cur_enrollment;
		String week_time;
		String starting_time;
		String ending_time;
		
		boolean flag = true;
		
		// 接收前端傳遞的POST請求
		if(request.getMethod().equalsIgnoreCase("POST")){
			
			try {
				Class.forName("com.mysql.cj.jdbc.Driver").newInstance();  // 載入驅動程式
			    Connection conn = DriverManager.getConnection(url);       // 建立連線
			    Statement stmt = conn.createStatement();
			    sql = "SELECT Section.section_code, section_name, credit, offer_class, max_enrollment, cur_enrollment, Instructor.instructor_name, department, week_time, starting_time, ending_time FROM Section RIGHT JOIN TimeSlot ON Section.section_code = TimeSlot.section_code LEFT JOIN Instructor ON Section.instructor_id = Instructor.instructor_id WHERE Section.section_code = " + section_code + ";";
			    ResultSet rs = stmt.executeQuery(sql);
			    
			    while(rs.next()) {
			    	
			    	String sql_2 = "SELECT selected_credit FROM Student WHERE student_id = \"D1059887\";";
					ResultSet rs_2 = stmt.executeQuery(sql);
					String temp = rs.getInt("selected_credit");
					
					if(rs.next() && ){
						String message = "已選學分不得超過30!";
					    response.setContentType("text/plain");
					    response.getWriter().write(message);
				 	}
			    	
			    	section_name = rs.getString("section_name");  
			    	max_enrollment = rs.getString("max_enrollment");
			    	cur_enrollment = rs.getString("cur_enrollment");
			    	week_time = rs.getString("week_time");
			    	starting_time = rs.getString("starting_time");
			    	ending_time = rs.getString("ending_time");
			    	
			    	
			    }
				
			} catch(Exception e) {
			    e.printStackTrace();
			}
		}
		
		
%>

</body>
</html>

