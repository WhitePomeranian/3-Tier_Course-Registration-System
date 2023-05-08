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
		String section_name;
		String course_type;
		int cur_enrollment;
		
		// 接收前端傳遞的POST請求
		if(request.getMethod().equalsIgnoreCase("POST")){
			
			try {
				Class.forName("com.mysql.cj.jdbc.Driver").newInstance();  // 載入驅動程式
			    Connection conn = DriverManager.getConnection(url);       // 建立連線
			    
			    //系內可選的課
			    Statement stmt = conn.createStatement();
			    sql = "SELECT Section.section_code, section_name, offer_dept, grade, course_type, max_enrollment, cur_enrollment, week_time, starting_time, ending_time FROM Course LEFT JOIN Section ON Course.course_id = Section.course_id RIGHT JOIN TimeSlot ON Section.section_code = TimeSlot.section_code WHERE offer_dept IN (SELECT department FROM Student WHERE student_id = \"" + user_id + "\") AND course_type = \"選修\";";
			    //SELECT Section.section_code, section_name, offer_dept, grade, course_type, max_enrollment, cur_enrollment, week_time, starting_time, ending_time FROM Course LEFT JOIN Section ON Course.course_id = Section.course_id RIGHT JOIN TimeSlot ON Section.section_code = TimeSlot.section_code WHERE offer_dept IN (SELECT department FROM Student WHERE student_id = "D1060064") AND course_type = "選修";
			    ResultSet rs = stmt.executeQuery(sql);
			    
			    while(rs.next()) {
			    		int section_code =rs.getString("Section.section_code"); //課號
                        String section_name = rs.getString("section_name"); //課程名稱
                        String offer_dept=rs.getString("offer_dept"); //開課系所
                        int grade=rs.getInt("grade"); //年級
                        String course_type=rs.getString("course_type"); //必/選修別
                        int max_enrollment=rs.getInt("max_enrollment"); //修課人數上限
                        int cur_enrollment = rs.getInt("cur_enrollment"); //目前選修人數
                        int week_time = rs.getInt("week_time"); //開課時段
						int starting_time = rs.getInt("starting_time"); //開課時段
						int ending_time = rs.getInt("ending_time"); //開課時段
			    }
			    
			    //系外可選的課
			    Statement stmt_2 = conn.createStatement();
				String sql_2 = "SELECT Section.section_code, section_name, offer_dept, grade, course_type, max_enrollment, cur_enrollment, week_time, starting_time, ending_time FROM Course LEFT JOIN Section ON Course.course_id = Section.course_id RIGHT JOIN TimeSlot ON Section.section_code = TimeSlot.section_code WHERE offer_dept NOT IN (SELECT department FROM Student WHERE student_id = \"" + user_id + "\") AND course_type = \"選修\";";
				//SELECT Section.section_code, section_name, offer_dept, grade, course_type, max_enrollment, cur_enrollment, week_time, starting_time, ending_time FROM Course LEFT JOIN Section ON Course.course_id = Section.course_id RIGHT JOIN TimeSlot ON Section.section_code = TimeSlot.section_code WHERE offer_dept NOT IN (SELECT department FROM Student WHERE student_id = "D1060064") AND course_type = "選修";
				ResultSet rs_2 = stmt_2.executeQuery(sql_2);
				
				while(rs_2.next()) {
		    		int section_code2 = rs_2.getString("Section.section_code"); //課號
                    String section_name2 = rs_2.getString("section_name"); //課程名稱
                    String offer_dept2 = rs_2.getString("offer_dept"); //開課系所
                    int grade2 = rs_2.getInt("grade"); //年級
                    String course_type2 = rs_2.getString("course_type"); //必/選修別
                    int max_enrollment2 = rs_2.getInt("max_enrollment"); //修課人數上限
                    int cur_enrollment2 = rs_2.getInt("cur_enrollment"); //目前選修人數
                    int week_time2 = rs_2.getInt("week_time"); //開課時段
					int starting_time2 = rs_2.getInt("starting_time"); //開課時段
					int ending_time2 = rs_2.getInt("ending_time"); //開課時段
		    	}
				
				//關閉連線  
			    rs.close(); 
			    stmt.close();  
			    rs_2.close(); 
			    stmt_2.close();  
			    conn.close();
			    return;// 在此處終止程式並返回訊息

			} catch(Exception e) {
			    e.printStackTrace();
			}
		}
		
		
%>

