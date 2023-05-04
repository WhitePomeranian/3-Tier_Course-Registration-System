<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="java.sql.*" %>
<%		

		String user_id = "D1060064";
		
		//my database information
		String server = "localhost";
		String database = "course-registration-system";
		String user = "root";
		String password = "eric998877";
		int port = 3306;
		String url = "jdbc:mysql://" + server + ":" + port + "/" + database +
		    "?user=" + user + "&password=" + password + "&useSSL=true&characterEncoding=UTF-8&serverTimezone=UTC";
		
		String sql = "";         // my sql statement
		String target;      // used to receive parameters
		int section_code = Integer.parseInt(request.getParameter("section_code"));
		//int section_code = 1263;
		String section_name;
		int max_enrollment;
		int cur_enrollment;
		int week_time;
		int starting_time;
		int ending_time;
		
		
		// 接收前端傳遞的POST請求
		if(request.getMethod().equalsIgnoreCase("POST")){
			
			try {
				Class.forName("com.mysql.cj.jdbc.Driver").newInstance();  // 載入驅動程式
			    Connection conn = DriverManager.getConnection(url);       // 建立連線
			    Statement stmt = conn.createStatement();
			    sql = "SELECT Section.section_code, section_name, offer_class, max_enrollment, cur_enrollment, Instructor.instructor_name, department, week_time, starting_time, ending_time FROM Section RIGHT JOIN TimeSlot ON Section.section_code = TimeSlot.section_code LEFT JOIN Instructor ON Section.instructor_id = Instructor.instructor_id WHERE Section.section_code = " + section_code + ";";
			    ResultSet rs = stmt.executeQuery(sql);
			    
			    while(rs.next()) {
			    	
			    	Statement stmt_2 = conn.createStatement();
			    	String sql_2 = "SELECT selected_credit FROM Student WHERE student_id = \"" + user_id + "\";"; //selected_credit = 24
					ResultSet rs_2 = stmt_2.executeQuery(sql_2);
					
					Statement stmt_3 = conn.createStatement();
					String sql_3 = "SELECT credit FROM Section LEFT JOIN Course ON Section.course_id = Course.course_id WHERE section_code = " + section_code + ";"; //credit = 3
					ResultSet rs_3 = stmt_3.executeQuery(sql_3);
					
					int selected_credit = 0;
					int credit = 0;
					if(rs_2.next() && rs_3.next()){
						
						selected_credit = rs_2.getInt("selected_credit");
						credit = rs_3.getInt("credit");
						/*
						if(selected_credit - credit < 9) {      //改
							String message = "已選學分不得少於9!";
						    response.setContentType("text/plain");
						    response.getWriter().write(message);
						    return; // 在此處終止程式並返回訊息
						}
						*/
				 	}
			    	
			    	section_name = rs.getString("section_name");  
			    	max_enrollment = rs.getInt("max_enrollment");
			    	cur_enrollment = rs.getInt("cur_enrollment");
			    	week_time = rs.getInt("week_time");
			    	starting_time = rs.getInt("starting_time");
			    	ending_time = rs.getInt("ending_time");
			    	
			    	/*
			    	if(cur_enrollment == max_enrollment) {
			    		String message = "課程人數已滿";
					    response.setContentType("text/plain");
					    response.getWriter().write(message);
					    return; // 在此處終止程式並返回訊息
			    	}
			    	*/
			    	
			    	Statement stmt_4 = conn.createStatement();
					String sql_4 = "SELECT Student.student_id, student_name, SelectDetail.section_code, section_name, week_time, starting_time, ending_time FROM Student RIGHT JOIN SelectDetail ON Student.student_id = SelectDetail.student_id  RIGHT JOIN TimeSlot ON SelectDetail.section_code = TimeSlot.section_code LEFT JOIN Section ON SelectDetail.section_code = Section.section_code WHERE Student.student_id = \"" + user_id + "\";";
					ResultSet rs_4 = stmt_4.executeQuery(sql_4);
					
					
					/*
					while(rs_4.next()) {
						
						String section_name_2 = rs_4.getString("section_name");
						
						if(!section_name.equals(section_name_2)) {		//改
							String message = "不得加選重複課程!";
						    response.setContentType("text/plain");
						    response.getWriter().write(message);
						    return; // 在此處終止程式並返回訊息
						}
						
						int week_time_2 = rs_4.getInt("week_time");
						int starting_time_2 = rs_4.getInt("starting_time");
						int ending_time_2 = rs_4.getInt("ending_time");
						
						if(week_time == week_time_2) {
							
							for(int i = ending_time - starting_time; i >= 0; i--) {
								for(int j = ending_time_2 - starting_time_2; j >= 0; j--) {
									
									if(i + starting_time == j + starting_time_2) {
										String message = "該時段已有其他課程!";
									    response.setContentType("text/plain");
									    response.getWriter().write(message);
									    return; // 在此處終止程式並返回訊息
									}
								}
							}
						}
					}
					*/
					
					// 可以退選課程
					Statement stmt_5 = conn.createStatement();
					
					String sql_5 = "DELETE FROM SelectDetail WHERE student_id = \"" + user_id + "\" AND section_code = " + section_code; //改
					//DELETE FROM SelectDetail WHERE student_id = "D1060064" AND section_code = 1263;
					//String sql_5 = "INSERT INTO SelectDetail VALUES(\"" + user_id + "\"," + section_code + ")";
					
					stmt_5.executeUpdate(sql_5);
					sql_5 = "UPDATE Student SET selected_credit = " + (selected_credit - credit) + " WHERE student_id = \"" + user_id + "\";"; 
					stmt_5.executeUpdate(sql_5);
					sql_5 = "UPDATE Section SET cur_enrollment = " + (cur_enrollment - 1) + " WHERE section_code = " + section_code; //改
					stmt_5.executeUpdate(sql_5);
					
			    	rs_2.close();
			    	stmt_2.close();
				  	rs_3.close();
				  	stmt_3.close();
				  	rs_4.close();
				  	stmt_4.close();
				  	stmt_5.close();
			    }
				
			    
			  	//關閉連線  
			    rs.close(); 
			    stmt.close();  
			    conn.close();
			    
			    String message = "退選成功!";
			    response.setContentType("text/plain");
			    response.getWriter().write(message);
			    return; // 在此處終止程式並返回訊息
			} catch(Exception e) {
			    e.printStackTrace();
			}
		}
		
		
%>


