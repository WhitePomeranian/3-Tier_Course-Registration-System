<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="java.sql.*" %>
<%		
		
		String user_id = request.getParameter("user_id");
		
		//my database information
		String server = "localhost";
		String database = "course-registration-system";
		String user = "root";
		String password = "BlackPomeranian";
		int port = 3306;
		String url = "jdbc:mysql://" + server + ":" + port + "/" + database +
		    "?user=" + user + "&password=" + password + "&useSSL=true&characterEncoding=UTF-8&serverTimezone=UTC";
		
		String sql = "";         // my sql statement
		String target;      // used to receive parameters
		int section_code = Integer.parseInt(request.getParameter("section_code"));
		String section_name;
		String course_type;
		int cur_enrollment;
		
		// 接收前端傳遞的POST請求
		if(request.getMethod().equalsIgnoreCase("POST")){
			
			try {
				Class.forName("com.mysql.cj.jdbc.Driver").newInstance();  // 載入驅動程式
			    Connection conn = DriverManager.getConnection(url);       // 建立連線
			    Statement stmt = conn.createStatement();
			    sql = "SELECT section_code, section_name, cur_enrollment FROM Section WHERE section_code = " + section_code + ";";
			    //SELECT section_code, section_name, cur_enrollment FROM Section WHERE section_code = 1263 ;
			    ResultSet rs = stmt.executeQuery(sql);
			    
			    while(rs.next()) {
			    	
			    	section_name = rs.getString("section_name");  
			    	cur_enrollment = rs.getInt("cur_enrollment");
			    	
			    	//必修不能退選
			    	Statement stmt_3 = conn.createStatement();
					String sql_3 = "SELECT course_type, section_name FROM Section LEFT JOIN Course ON Section.course_id = Course.course_id WHERE section_code = " + section_code + ";"; 
					//SELECT course_type, section_name FROM Section LEFT JOIN Course ON Section.course_id = Course.course_id WHERE section_code = 1263;
					ResultSet rs_3 = stmt_3.executeQuery(sql_3);
					
					String str1 = "必修";
					
					if(rs_3.next()){	
						
						course_type = rs_3.getString("course_type");
						
						if(course_type.equals(str1)) {      
							String message = "不能退選必修科目!";
						    response.setContentType("text/plain");
						    response.getWriter().write(message);
						    return; // 在此處終止程式並返回訊息
						}
				 	}
					
					//已選學分不得少於9
					Statement stmt_4 = conn.createStatement();
			    	String sql_4 = "SELECT selected_credit FROM Student WHERE student_id = \"" + user_id + "\";";
			    	//SELECT selected_credit FROM Student WHERE student_id = "D1060064";
					ResultSet rs_4 = stmt_4.executeQuery(sql_4);
					
					Statement stmt_5 = conn.createStatement();
					String sql_5 = "SELECT credit FROM Section LEFT JOIN Course ON Section.course_id = Course.course_id WHERE section_code = " + section_code + ";"; 
					//SELECT credit FROM Section LEFT JOIN Course ON Section.course_id = Course.course_id WHERE section_code = 1263;
					ResultSet rs_5 = stmt_5.executeQuery(sql_5);
					
					int selected_credit = 0;
					int credit = 0;
					if(rs_4.next() && rs_5.next()){
						
						selected_credit = rs_4.getInt("selected_credit");
						credit = rs_5.getInt("credit");
						if(selected_credit - credit < 9) {      
							String message = "已選學分不得少於9!";
						    response.setContentType("text/plain");
						    response.getWriter().write(message);
						    return; // 在此處終止程式並返回訊息
						}
				 	}
					
					// 可以退選課程
					Statement stmt_6 = conn.createStatement();
					
					String sql_6 = "DELETE FROM SelectDetail WHERE student_id = \"" + user_id + "\" AND section_code = " + section_code + ";";			
					stmt_6.executeUpdate(sql_6);
					sql_6 = "UPDATE Student SET selected_credit = " + (selected_credit - credit) + " WHERE student_id = \"" + user_id + "\";";
					stmt_6.executeUpdate(sql_6);
					sql_6 = "UPDATE Section SET cur_enrollment = " + (cur_enrollment - 1) + " WHERE section_code = " + section_code; 
					stmt_6.executeUpdate(sql_6);
							
				  	rs_3.close();
				  	stmt_3.close();
				  	rs_4.close();
				  	stmt_4.close();
				  	rs_5.close();
				  	stmt_5.close();
				  	stmt_6.close();
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
