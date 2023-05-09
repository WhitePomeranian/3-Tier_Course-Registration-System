<%
  	// 檢查是否有名為 "cacheid" 的 cookie
  	String cacheid = "";
  	Cookie[] cookies = request.getCookies();
  	if (cookies != null) {
    	for (Cookie cookie : cookies) {
      	if (cookie.getName().equals("cacheid")) {
        	cacheid = cookie.getValue();
        	break;
      	}
    	}
  	}

  	// 檢查是否有表單提交
  	if (request.getMethod().equalsIgnoreCase("post")) {
    	// 從表單中獲取資料
    	String inputData = request.getParameter("studentId");

    	// 創建一個新的 cookie
    	Cookie myCookie = new Cookie("cacheid", inputData);

    	// 設置 cookie 的有效期，這裡設置為 1 天（以秒為單位）
   		myCookie.setMaxAge(24 * 60 * 60);

    	// 將 cookie 添加到 response 中
    	response.addCookie(myCookie);

    	// 更新 cacheid 的值
    	cacheid = inputData;
  	}
%>

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
    
    <script>
    	function setTarget(section_code) {
    		document.getElementById("T" + section_code).value = section_code; // 將 JavaScript 變量的值賦值給表單元素
    		document.getElementById("key").value = section_code; // 用來獲取id
    		document.getElementById("course_table").submit(); // 提交表單
    	}
    </script>
</head>

<body>
	<%
		String user_id = "";
		String user_name = "";
		String user_grade = "";
    	String user_class1 = "";
    	String user_department = "";
    	String user_selected_credit = "";
		
		// my database information
		String server = "localhost";
		String database = "test";
		String user = "root";
		String password = "sam0520";
		int port = 3307;
		String url = "jdbc:mysql://" + server + ":" + port + "/" + database +
		    "?user=" + user + "&password=" + password + "&useSSL=true&characterEncoding=UTF-8&serverTimezone=UTC";
		
		// my sql statement
		String sql = "";  	
		// used to receive parameters
		String target = "";
		String element1 = "";
		String element2 = "";
		String element3 = "";
		String element4 = "";
		String element5 = "";
		String element6 = "";
		String element7 = "";
		String element8 = "";
		
		boolean flag = true;
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
                <div style="display:flex; align-items:center; margin-top:1%">
	                <form action="" method="post">
	                	<label for="studentId">學號</label>	                	
				        <input type="text" id="studentId" name="studentId" required maxlength="20" value="<%= cacheid%>" style="width:50%;  margin-left:1%;">			        
				        <button type="submit" style="display: inline;">送出</button>
				    </form>	
				</div>
				
				<%
				    user_id = request.getParameter("studentId");
					//request.setAttribute("user_id", user_id);					
					
				    if (user_id != null) {				    	
				        try {
				        	Class.forName("com.mysql.cj.jdbc.Driver").newInstance();  // 載入驅動程式
				        	Connection conn = DriverManager.getConnection(url);       // 建立連線
				        	Statement stmt = conn.createStatement();
				            
				            // 使用 PreparedStatement 準備 SQL 語句，避免 SQL 注入攻擊
				            sql = "SELECT * FROM Student WHERE student_id = '" + user_id + "'";            
				            
				            // 執行 SQL 語句，獲取查詢結果
				            ResultSet rs = stmt.executeQuery(sql);
			                
				            // 解析查詢結果，顯示學生資訊
				            if (rs.next()) {				                
				                user_name = rs.getString("student_name");
				                user_grade = rs.getString("grade");
				                user_class1 = rs.getString("class");
				                user_department = rs.getString("department");
				                user_selected_credit = rs.getString("selected_credit");
				%>                              
				<%
				            } else {
				%>
				                <p>沒有找到相關學生資訊。</p>
				<%
				            }
				        } catch (Exception e) {
				            e.printStackTrace();
				        } 
				    }
				%>
				
				<br>
				<label id="name" for="student_name">姓名: <% out.println(user_name); %></label>
				<br>
				<br>
				<label id="department" for="student_department">系所: <% out.println(user_department); %></label>
				<br>
				<br>
				<label id="grade" for="student_grade">年級: <% out.println(user_grade); %></label>
				<br>
				<br>
				<label id="class" for="student_class">班級: <% out.println(user_class1); %></label>
				<br>
				<br>
				<label id="class" for="student_class">已選學分: <% out.println(user_selected_credit); %></label>

                <P>學分上限: 30</P>
                <p>學分下限: 9</p>
            </fieldset>
            <fieldset>
            	<legend>系統操作原則</legend>
            	<div style="color:yellow;">
            	1. 輸入學號後，可以檢視已選的課程，並進行加退選。<br><br>
            	2. 查詢選課代碼後，只要符合限制，即可加選課程。<br><br>
            	3. 點擊已選課表之課程，可進行退選。<br><br>
            	4. 選課相關限制，請見注意事項。
            	</div>
            </fieldset>
            <fieldset>
            	<legend>注意事項</legend>
            	<div style="color:yellow;">
            	1. 同學可以加選課程，課程加選須滿足以下限制：<br>
				(i) 人數已滿的課程不可加選<br>
				(ii) 不可加選衝堂的課程<br>
				(iii) 不可加選與已選課程同名的課程<br>
				(iv) 加選後學分不可超過最高學分限制 (30 學分)<br>
				(v) 不得加選他系之必修課程<br><br>
				
				2. 同學可以退選課程，課程退選須滿足下列限制<br>
				(i) 退選後學分不可低於最低學分限制 (9 學分)<br>
				(ii) 必修課不可退選<br>
            	</div>
            </fieldset>
        </div>
        <div class="right_content">
            <!-- <p>right</p> -->
            <fieldset>
            	<legend>查詢課程</legend>
            	<form id="section_form" action="user_interface.jsp" method="post">
	                <label for="section_code">查詢選課代碼</label>
	                <input type="text" inputmode="numeric" maxlength=4 name="section_code" id="section_code">
	                <input type="hidden" id="studentId" name="studentId" required maxlength="20" value="<%= cacheid%>" style="width:50%;  margin-left:1%; display: none;">	                
	                <button type="submit">查詢</button>
	            </form>
            </fieldset>
            
 
			<fieldset>
				<legend>課程加選</legend>
				<form action="user_interface.jsp" method="post">

				<%
					target = request.getParameter("section_code");
					//user_id =  request.getParameter("myId");
					String key = request.getParameter("key");
					String del_target = request.getParameter("T" + key);
					
					flag = true;
					
					if(user_id != null) {
						try {
							Class.forName("com.mysql.cj.jdbc.Driver").newInstance();  // 載入驅動程式
						    Connection conn = DriverManager.getConnection(url);       // 建立連線
						    Statement stmt = conn.createStatement();
						    sql = "SELECT * FROM student WHERE student_id = \"" + user_id + "\"";
						    
						    ResultSet rs = stmt.executeQuery(sql); 
						    
						 	// 找不到任何資料
						 	Statement stmt_2 = conn.createStatement();
							
						 	sql = "SELECT COUNT(*) FROM Student WHERE student_id = \"" + user_id + "\"";
							ResultSet rs_2 = stmt_2.executeQuery(sql);
							
							if(rs_2.next() && rs_2.getString("COUNT(*)").equals("0")){
								out.println("<script>");
								out.println("document.getElementById(\"id\").innerHTML = '<label id=\"id\" for=\"student_id\">學號: <p style=\"color:red;display: inline;\">找不到學生資料</p></label>';");
								out.println("</script>");
						 	} else {						 		
						 		if(rs.next()) {
						 			element1 = rs.getString("student_id");  
									element2 = rs.getString("student_name");
									element3 = rs.getString("department");
									element4 = rs.getString("grade");
									element5 = rs.getString("class");
								}	
				%>
						 		<script type="text/javascript">
							        user_info("<%= element1 %>", "<%= element2 %>", "<%= element3 %>", "<%= element4 %>", "<%= element5 %>");
						 		</script>						 	
				<%
						 	}
							
							rs_2.close();
							stmt_2.close();
							
							//關閉連線  
						    rs.close();  
						    stmt.close();  
						    conn.close();
						} catch(Exception e) {
							e.printStackTrace();
						}
					}
					
					if(target != null || del_target != null) {
						try {
							Class.forName("com.mysql.cj.jdbc.Driver").newInstance();  // 載入驅動程式
						    Connection conn = DriverManager.getConnection(url);       // 建立連線
						    Statement stmt = conn.createStatement();
						    if(target != null) {
						    	sql = "SELECT section_code, section_name, credit, course_type, offer_class, instructor_name, max_enrollment, cur_enrollment FROM Section INNER JOIN Instructor ON Section.instructor_id = Instructor.instructor_id INNER JOIN Course ON Section.course_id = Course.course_id WHERE section_code LIKE " + target + ";";
						    } else {
						    	sql = "SELECT section_code, section_name, credit, course_type, offer_class, instructor_name, max_enrollment, cur_enrollment FROM Section INNER JOIN Instructor ON Section.instructor_id = Instructor.instructor_id INNER JOIN Course ON Section.course_id = Course.course_id WHERE section_code LIKE " + del_target + ";";
						    }
						    					
						    ResultSet rs = stmt.executeQuery(sql);  						    
						    
						    //依據資料庫中的欄位名列印資料 
						    out.println("<table border=\"1px solid\"  style=\"font-size: 20px; border-collapse: collapse; width: 1000px; text-align: center;\">");
						   
						    while(rs.next()){
						    	
						    	// the header is printed only once
						    	if(flag) {
						    		out.println("<tr>");
						    	    out.println("<th>");
						    	    out.println("</th>");
						    	    out.println("<th>");
						    	    out.println("選課代碼");
						    	    out.println("</th>");
						    	    out.println("<th>");
						    	    out.println("課程名稱");
						    	    out.println("<th>");
						    	    out.println("學分");
						    	    out.println("</th>");
						    	    out.println("<th>");
						    	    out.println("必選修");
						    	    out.println("</th>");
						    	    out.println("</th>");
						    	    out.println("<th>");
						    	    out.println("開課班級");
						    	    out.println("</th>");
						    	    out.println("<th>");
						    	    out.println("授課教師");
						    	    out.println("</th>");
						    	    out.println("<th>");
						    	    out.println("已選人數");
						    	    out.println("</th>");
						    	    out.println("<th>");
						    	    out.println("開放名額");
						    	    out.println("</th>");
						    	    out.println("</tr>");
						    	    flag = false;
						    	} 
						    	
						    	element1 = rs.getString("section_code");  
								element2 = rs.getString("section_name");
								element3 = rs.getString("credit");
								element4 = rs.getString("course_type");
								element5 = rs.getString("offer_class");
								element6 = rs.getString("instructor_name");
								element7 = rs.getString("max_enrollment");
								element8 = rs.getString("cur_enrollment");
								out.println("<tr>");
								out.println("<td>");
								
								
								if(target != null) {									
				%>						            
									<input type="hidden" id="studentId" name="studentId" value="<%= cacheid %>">
									<button id="add" type="submit" onclick="add_section(<%= element1 %>, '<%= user_id %>')">加選</button>
				<%
								} else {
				%>				
									<input type="hidden" id="studentId" name="studentId" required maxlength="20" value="<%= cacheid%>" style=" display: none;">
				<%
									out.println("<button id=\"add\" type=\"submit\" ");
									out.println("onclick=\"delete_section(" + element1 + ", \'" + user_id + "\')\">");
									out.println("退選");
									out.println("</button>");
								}
	
				%>				
								<script>
									function add_section(section_code, user_id) {
										// 創建一個XMLHttpRequest物件
									    var xhttp = new XMLHttpRequest();
										
									 	// 當請求完成時觸發的函數
									    xhttp.onreadystatechange = function() {
									 		
									    	if (this.readyState == 4 && this.status == 200) {
									    		
									    		// 接收到後端返回的資料
									    	    var message = xhttp.responseText;
									    	    // 在前端印出訊息
									    	    alert(message);
									    	    
									    	    location.reload();
									    	    document.cookie = "cacheid=" + encodeURIComponent(cacheid) + "; path=/";
											} else {
												//alert("this.readyState =" + this.readyState);
									    		//alert("this.status =" + this.status);
											}
										};
										xhttp.open("POST", "add_section.jsp", false);  // 假設後端程式與前端頁面在同一目錄中
										xhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
										console.log("section_code=" + section_code + "&user_id=" + user_id);
										xhttp.send("section_code=" + section_code + "&user_id=" + user_id); // 傳遞需要的argument
									}
									
									function delete_section(section_code, user_id) {
										// 創建一個XMLHttpRequest物件
									    var xhttp = new XMLHttpRequest();
										
									 	// 當請求完成時觸發的函數
									    xhttp.onreadystatechange = function() {
									 		
									    	if (this.readyState == 4 && this.status == 200) {

									    		// 接收到後端返回的資料
									    	    var message = xhttp.responseText;
									    	    // 在前端印出訊息
									    	    alert(message);
									    	    location.reload();
									    	  	
											} else {
												//alert("this.readyState =" + this.readyState);
									    		//alert("this.status =" + this.status);									    		
											}		
										};
										xhttp.open("POST", "delete_section.jsp", false);  // 假設後端程式與前端頁面在同一目錄中
										xhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
										xhttp.send("section_code=" + section_code + "&user_id=" + user_id); // 傳遞需要的argument
									}
								</script>
								
				<%				
								out.println("<td>");
								out.println(element1);
								out.println("</td>");
								out.println("<td>");
								out.println(element2);
								out.println("</td>");
								out.println("<td>");
								out.println(element3);
								out.println("</td>");
								out.println("<td>");
								out.println(element4);
								out.println("</td>");
								out.println("<td>");
								out.println(element5);
								out.println("</td>");
								out.println("<td>");
								out.println(element6);
								out.println("</td>");
								out.println("<td>");
								out.println(element8);
								out.println("</td>");
								out.println("<td>");
								out.println(element7);
								out.println("</td>");
								out.println("</tr>");
						    }
						    out.println("</table>");	
						        
						 	// 找不到任何資料
						 	Statement stmt_2 = conn.createStatement();
							sql = "SELECT COUNT(*) AS row_count FROM Section WHERE section_code LIKE " + target + ";";
							ResultSet rs_2 = stmt_2.executeQuery(sql);
							if(rs_2.next() && rs_2.getString("row_count").equals("0") && target != null){
								out.println("<p style=\"text-align:center; color:red;\">" + "找不到課程資料" + "</p>");
						 	}
							
							rs_2.close();
							stmt_2.close();
							
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
			
			<form id="course_table" action="user_interface.jsp" method="post">
				<input type="hidden" name="key" id="key" value="">
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
	                        <td id="1_1" class="course_table"></td>
	                        <td id="2_1" class="course_table"></td>
	                        <td id="3_1" class="course_table"></td>
	                        <td id="4_1" class="course_table"></td>
	                        <td id="5_1" class="course_table"></td>
	                        <td id="6_1" class="course_table"></td>
	                        <td id="7_1" class="course_table"></td>
	                    </tr>
	                    <tr class="course_table">
	                        <th class="course_table">2<br>09:10~10:00</th>
							<td id="1_2" class="course_table"></td>
	                        <td id="2_2" class="course_table"></td>
	                        <td id="3_2" class="course_table"></td>
	                        <td id="4_2" class="course_table"></td>
	                        <td id="5_2" class="course_table"></td>
	                        <td id="6_2" class="course_table"></td>
	                        <td id="7_2" class="course_table"></td>
	                    </tr>
	                    <tr class="course_table">
	                        <th class="course_table">3<br>10:10~11:00</th>
	                        <td id="1_3" class="course_table"></td>
	                        <td id="2_3" class="course_table"></td>
	                        <td id="3_3" class="course_table"></td>
	                        <td id="4_3" class="course_table"></td>
	                        <td id="5_3" class="course_table"></td>
	                        <td id="6_3" class="course_table"></td>
	                        <td id="7_3" class="course_table"></td>
	                    </tr>
	                    <tr class="course_table">
	                        <th class="course_table">4<br>11:10~12:00</th>
	                        <td id="1_4" class="course_table"></td>
	                        <td id="2_4" class="course_table"></td>
	                        <td id="3_4" class="course_table"></td>
	                        <td id="4_4" class="course_table"></td>
	                        <td id="5_4" class="course_table"></td>
	                        <td id="6_4" class="course_table"></td>
	                        <td id="7_4" class="course_table"></td>
	                    </tr>
	                    <tr class="course_table">
	                        <th class="course_table">5<br>12:10~13:00</th>
	                        <td id="1_5" class="course_table"></td>
	                        <td id="2_5" class="course_table"></td>
	                        <td id="3_5" class="course_table"></td>
	                        <td id="4_5" class="course_table"></td>
	                        <td id="5_5" class="course_table"></td>
	                        <td id="6_5" class="course_table"></td>
	                        <td id="7_5" class="course_table"></td>
	                    </tr>
	                    <tr class="course_table">
	                        <th class="course_table">6<br>13:10~14:00</th>
	                        <td id="1_6" class="course_table"></td>
	                        <td id="2_6" class="course_table"></td>
	                        <td id="3_6" class="course_table"></td>
	                        <td id="4_6" class="course_table"></td>
	                        <td id="5_6" class="course_table"></td>
	                        <td id="6_6" class="course_table"></td>
	                        <td id="7_6" class="course_table"></td>
	                    </tr>
	                    <tr class="course_table">
	                        <th class="course_table">7<br>14:10~15:00</th>
	                        <td id="1_7" class="course_table"></td>
	                        <td id="2_7" class="course_table"></td>
	                        <td id="3_7" class="course_table"></td>
	                        <td id="4_7" class="course_table"></td>
	                        <td id="5_7" class="course_table"></td>
	                        <td id="6_7" class="course_table"></td>
	                        <td id="7_7" class="course_table"></td>
	                    </tr>
	                    <tr class="course_table">
	                        <th class="course_table">8<br>15:10~16:00</th>
	                        <td id="1_8" class="course_table"></td>
	                        <td id="2_8" class="course_table"></td>
	                        <td id="3_8" class="course_table"></td>
	                        <td id="4_8" class="course_table"></td>
	                        <td id="5_8" class="course_table"></td>
	                        <td id="6_8" class="course_table"></td>
	                        <td id="7_8" class="course_table"></td>
	                    </tr>
	                    <tr class="course_table">
	                        <th class="course_table">9<br>16:10~17:00</th>
	                        <td id="1_9" class="course_table"></td>
	                        <td id="2_9" class="course_table"></td>
	                        <td id="3_9" class="course_table"></td>
	                        <td id="4_9" class="course_table"></td>
	                        <td id="5_9" class="course_table"></td>
	                        <td id="6_9" class="course_table"></td>
	                        <td id="7_9" class="course_table"></td>
	                    </tr>
	                    <tr class="course_table">
	                        <th class="course_table">10<br>17:10~18:00</th>
	                        <td id="1_10" class="course_table"></td>
	                        <td id="2_10" class="course_table"></td>
	                        <td id="3_10" class="course_table"></td>
	                        <td id="4_10" class="course_table"></td>
	                        <td id="5_10" class="course_table"></td>
	                        <td id="6_10" class="course_table"></td>
	                        <td id="7_10" class="course_table"></td>
	                    </tr>
	                    <tr class="course_table">
	                        <th class="course_table">11<br>18:30~19:20</th>
	                        <td id="1_11" class="course_table"></td>
	                        <td id="2_11" class="course_table"></td>
	                        <td id="3_11" class="course_table"></td>
	                        <td id="4_11" class="course_table"></td>
	                        <td id="5_11" class="course_table"></td>
	                        <td id="6_11" class="course_table"></td>
	                        <td id="7_11" class="course_table"></td>
	                    </tr>
	                    <tr class="course_table">
	                        <th class="course_table">12<br>19:25~20:15</th>
	                        <td id="1_12" class="course_table"></td>
	                        <td id="2_12" class="course_table"></td>
	                        <td id="3_12" class="course_table"></td>
	                        <td id="4_12" class="course_table"></td>
	                        <td id="5_12" class="course_table"></td>
	                        <td id="6_12" class="course_table"></td>
	                        <td id="7_12" class="course_table"></td>
	                    </tr>
	                    <tr class="course_table">
	                        <th class="course_table">13<br>20:25~21:15</th>
	                        <td id="1_13" class="course_table"></td>
	                        <td id="2_13" class="course_table"></td>
	                        <td id="3_13" class="course_table"></td>
	                        <td id="4_13" class="course_table"></td>
	                        <td id="5_13" class="course_table"></td>
	                        <td id="6_13" class="course_table"></td>
	                        <td id="7_13" class="course_table"></td>
	                    </tr>
	                    <tr class="course_table">
	                        <th class="course_table">14<br>21:20~22:10</th>
	                        <td id="1_14" class="course_table"></td>
	                        <td id="2_14" class="course_table"></td>
	                        <td id="3_14" class="course_table"></td>
	                        <td id="4_14" class="course_table"></td>
	                        <td id="5_14" class="course_table"></td>
	                        <td id="6_14" class="course_table"></td>
	                        <td id="7_14" class="course_table"></td>
	                    </tr>
	            	</table>
	            </fieldset>			
			</form>
			
	
	<%  // 此段顯示已選課程的程式一定要放在table後面，否則無法識別id!!!
		try {
			Class.forName("com.mysql.cj.jdbc.Driver").newInstance();  // 載入驅動程式
		    Connection conn = DriverManager.getConnection(url);       // 建立連線
		    Statement stmt = conn.createStatement();				  
			sql = "SELECT student_id, TimeSlot.section_code, section_name, week_time, starting_time, ending_time FROM SelectDetail INNER JOIN Section ON SelectDetail.section_code = Section.section_code RIGHT JOIN TimeSlot ON SelectDetail.section_code = TimeSlot.section_code WHERE student_id = \""  + user_id + "\";";
		    ResultSet rs = stmt.executeQuery(sql);  
		
			while(rs.next()) {
				element1 = rs.getString("TimeSlot.section_code");  
				element2 = rs.getString("section_name");
				element3 = rs.getString("week_time");
				element4 = rs.getString("starting_time");
				element5 = rs.getString("ending_time");
	%>			
				<script>
			        function required(week_time, starting_time ,ending_time, section_name, section_code) {
			        	var target_id = week_time + "_" + starting_time;
						var target_element = document.getElementById(target_id);
						
						// 添加圓弧padding和background-color
				        target_element.classList.add("section");
						
						// 添加section_name
				        document.getElementById(target_id).innerHTML = '<input type="hidden" id="studentId" name="studentId" required maxlength="20" value="<%= cacheid%>" style="display: none;">' + '<input type="hidden" name="T' + section_code + '" id="T' + section_code + '" value="">' + '<button type="button" style="border: none; background-color: transparent; padding: 0; cursor: pointer; font-size: 15px;" onclick="setTarget(' + section_code + ')">' + section_code + "<br>" + section_name + '</button>' + '</form>';				
				        
				        // 如果是連續的課程，重複呼叫required()
						var i = parseInt(ending_time) - parseInt(starting_time);
						var j = parseInt(starting_time) + 1;
						if(i > 0) {
							required(week_time, String(j), ending_time, section_name, section_code);
						}
			        }
			      
			        required("<%= element3 %>", "<%= element4 %>", "<%= element5 %>", "<%= element2 %>", "<%= element1 %>");
			       
			    </script>
		<%		
			}
		%>
			<%
				Class.forName("com.mysql.cj.jdbc.Driver").newInstance();  			// 載入驅動程式
				conn = DriverManager.getConnection(url);       			  			// 建立連線
				stmt = conn.createStatement();
			    	
			    // 執行SQL查詢(可選選修)
			    sql = "SELECT Section.section_code, section_name, offer_dept, grade, course_type, max_enrollment, cur_enrollment, week_time, starting_time, ending_time FROM Course LEFT JOIN Section ON Course.course_id = Section.course_id RIGHT JOIN TimeSlot ON Section.section_code = TimeSlot.section_code WHERE course_type = '選修' AND NOT EXISTS (SELECT 1 FROM SelectDetail WHERE SelectDetail.section_code = Section.section_code AND SelectDetail.student_id = '" + user_id + "');";		    
			    rs = stmt.executeQuery(sql);
			%>		    
			    <% // 顯示結果 // %>
			    <br><br>
			    <fieldset>
                	<legend>可加選列表</legend>
                	<div class="section_table">
                    	<table>
                        	<tr>
	                            <th rowspan="2">課號</th>
	                            <th rowspan="2">課程名稱</th>
	                            <th rowspan="2">開課系所</th>
	                            <th rowspan="2">年級</th>
	                            <th rowspan="2">必/選修別</th>
	                            <th rowspan="2">修課人數上限</th>
	                            <th rowspan="2">目前選修人數</th>
	                            <th colspan="3">開課時段</th>
	                        </tr>
	                        <tr>
	                            <th>星期</th>
	                            <th>開始節次</th>
	                            <th>結束節次</th>
	                        </tr>
	                        
							<%
								int pre_section_code = 0;
								String pre_section_name = "";
								String pre_offer_dept = "";
								int pre_grade = 0;
								String pre_course_type = "";
								int pre_max_enrollment = 0;
								int pre_cur_enrollment = 0;
								int pre_week_time = 0;
								int pre_starting_time = 0;
								int pre_ending_time = 0;
								int count = 0;
							
							    while (rs.next()) {
							    	int section_code = rs.getInt("Section.section_code"); 	//課號
						            String section_name = rs.getString("section_name"); 	//課程名稱
						            String offer_dept = rs.getString("offer_dept"); 		//開課系所
						            int grade = rs.getInt("grade"); 						//年級
						            String course_type = rs.getString("course_type"); 		//必/選修別
						            int max_enrollment = rs.getInt("max_enrollment"); 		//修課人數上限
						            int cur_enrollment = rs.getInt("cur_enrollment"); 		//目前選修人數
						            int week_time = rs.getInt("week_time"); 				//開課時段
									int starting_time = rs.getInt("starting_time"); 		//開課時段
									int ending_time = rs.getInt("ending_time"); 			//開課時段
							        
									count++;
									if(count == 1){
										pre_section_code = section_code;
										pre_section_name = section_name;
										pre_offer_dept = offer_dept;
										pre_grade = grade;
										pre_course_type = course_type;
										pre_max_enrollment = max_enrollment;
										pre_cur_enrollment = cur_enrollment;
										pre_week_time = week_time;
										pre_starting_time = starting_time;
										pre_ending_time = ending_time;
									}else{
										if(section_code == pre_section_code){
											out.println("<tr>");
											out.println("<td rowspan='2'>" + section_code + "</td><td rowspan='2'>" + section_name + "</td><td rowspan='2'>" + offer_dept + "</td><td rowspan='2'>" + grade + "</td><td rowspan='2'>" + course_type + "</td><td rowspan='2'>" + max_enrollment + "</td><td rowspan='2'>" + cur_enrollment + "</td>");
											out.println("<td>" + pre_week_time + "</td><td>" + pre_starting_time + "</td><td>" + pre_ending_time + "</td>");
											out.println("</tr>");
											out.println("<tr>");
											out.println("<td>" + week_time + "</td><td>" + starting_time + "</td><td>" + ending_time + "</td>");
											out.println("</tr>");
											count = 0;
										}else{
											out.println("<tr><td>" + pre_section_code + "</td><td>" + pre_section_name + "</td><td>" + pre_offer_dept + "</td><td>" + pre_grade + "</td><td>" + pre_course_type + "</td><td>" + pre_max_enrollment + "</td><td>" + pre_cur_enrollment + "</td><td>" + pre_week_time + "</td><td>" + pre_starting_time + "</td><td>" + pre_ending_time + "</td></tr>");
											
											pre_section_code = section_code;
											pre_section_name = section_name;
											pre_offer_dept = offer_dept;
											pre_grade = grade;
											pre_course_type = course_type;
											pre_max_enrollment = max_enrollment;
											pre_cur_enrollment = cur_enrollment;
											pre_week_time = week_time;
											pre_starting_time = starting_time;
											pre_ending_time = ending_time;
										}										
									}
							    }
							    out.println("<tr><td>" + pre_section_code + "</td><td>" + pre_section_name + "</td><td>" + pre_offer_dept + "</td><td>" + pre_grade + "</td><td>" + pre_course_type + "</td><td>" + pre_max_enrollment + "</td><td>" + pre_cur_enrollment + "</td><td>" + pre_week_time + "</td><td>" + pre_starting_time + "</td><td>" + pre_ending_time + "</td></tr>");
							%>
			    		</table>
                	</div>
            	</fieldset>            	
            	
            	<% // 執行SQL查詢(已選選修) // %>			 	
			 	<% 
				    sql = "SELECT Section.section_code, section_name, offer_dept, grade, course_type, max_enrollment, cur_enrollment, week_time, starting_time, ending_time FROM Course LEFT JOIN Section ON Course.course_id = Section.course_id RIGHT JOIN TimeSlot ON Section.section_code = TimeSlot.section_code WHERE course_type = '選修' AND EXISTS (SELECT 1 FROM SelectDetail WHERE SelectDetail.section_code = Section.section_code AND SelectDetail.student_id = '" + user_id + "');";		    
				    rs = stmt.executeQuery(sql);
			    %>
			 	<% // 顯示結果 // %>
			 	<br><br>
			    <fieldset>
                	<legend>已加選列表</legend>
                	<div class="section_table">
                    	<table>
                        	<tr>
	                            <th rowspan="2">課號</th>
	                            <th rowspan="2">課程名稱</th>
	                            <th rowspan="2">開課系所</th>
	                            <th rowspan="2">年級</th>
	                            <th rowspan="2">必/選修別</th>
	                            <th rowspan="2">修課人數上限</th>
	                            <th rowspan="2">目前選修人數</th>
	                            <th colspan="3">開課時段</th>
	                        </tr>
	                        <tr>
	                            <th>星期</th>
	                            <th>開始節次</th>
	                            <th>結束節次</th>
	                        </tr>				        
						    
						    <%
							    while (rs.next()) {
							    	int section_code1 =rs.getInt("Section.section_code"); 	//課號
						            String section_name1 = rs.getString("section_name");	//課程名稱
						            String offer_dept1 = rs.getString("offer_dept"); 		//開課系所
						            int grade1 = rs.getInt("grade"); 						//年級
						            String course_type1 = rs.getString("course_type"); 		//必/選修別
						            int max_enrollment1 = rs.getInt("max_enrollment"); 		//修課人數上限
						            int cur_enrollment1 = rs.getInt("cur_enrollment"); 		//目前選修人數
						            int week_time1 = rs.getInt("week_time"); 				//開課時段
									int starting_time1 = rs.getInt("starting_time"); 		//開課時段
									int ending_time1 = rs.getInt("ending_time"); 			//開課時段
							        out.println("<tr><td>" + section_code1 + "</td><td>" + section_name1 + "</td><td>" + offer_dept1 + "</td><td>" + grade1 + "</td><td>" + course_type1 + "</td><td>" + max_enrollment1 + "</td><td>" + cur_enrollment1 + "</td><td>" + week_time1 + "</td><td>" + starting_time1 + "</td><td>" + ending_time1 + "</td></tr>");
							    }
						    %>
						</table>
                	</div>
            	</fieldset>
            	<br><br>
	<%		
		    //關閉連線  
		    rs.close();  
		    stmt.close();  
		    conn.close(); 
		} catch(Exception e) {
		    e.printStackTrace();
		}
	%>	
</body>
</html>
