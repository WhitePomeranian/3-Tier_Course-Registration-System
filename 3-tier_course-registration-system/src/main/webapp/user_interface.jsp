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
	String server = "localhost";
	String database = "course-registration-system_schema";
	String user = "root";
	String password = "BlackPomeranian";
	int port = 3306;
	String url = "jdbc:mysql://" + server + ":" + port + "/" + database +
	    "?user=" + user + "&password=" + password + "&useSSL=true&characterEncoding=UTF-8&serverTimezone=UTC";
	
	String target = request.getParameter("section_code");
	String element1;
	String element2;
	boolean flag = true;
	
	if(target != null) {
		try {
			Class.forName("com.mysql.cj.jdbc.Driver").newInstance();  // 載入驅動程式
		    Connection conn = DriverManager.getConnection(url);       // 建立連線
		    Statement stmt = conn.createStatement();
		    //String sql="select * from Section WHERE section_code LIKE " + target;
		    String sql="select * from Section;";
		    ResultSet rs = stmt.executeQuery(sql);  
		      
			// 找不到任何資料
			//if (rs.getRow() == 0) {
			//	out.println("<p style=\"text-align:center; color:red;\">" + "找不到課程" + "</p>");
			//} 
		    
		    
		    //依據資料庫中的欄位名列印資料 
		    out.println("<table border=\"1px solid\"  style=\"font-size: 20px; border-collapse: collapse;\">");
		   
		    while(rs.next()){
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
            </fieldset>
		</div>
	</div>
</body>
</html>