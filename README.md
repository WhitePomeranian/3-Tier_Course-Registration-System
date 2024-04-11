## 期中專題
### 系統功能
期中專題為以 3-tier 架構製作一選課系統，功能如下：

a. 同學可以根據學號查詢該學號的課表；

b. 同學可以根據學號查詢該學號的可選課列表，課程屬性包含課號、課程名稱、開課系所、年級、必/選修別、修課人數上限、目前選修人數、開課時段；

c. 同學可以加選課程，課程加選須滿足以下限制：  
   (i) 人數已滿的課程不可加選；  
   (ii) 不可加選衝堂的課程；  
   (iii) 不可加選與已選課程同名的課程；  
   (iv) 加選後學分不可超過最高學分限制 (30 學分)；

d. 同學可以退選課程，課程退選須滿足下列限制：  
    (i) 退選後學分不可低於最低學分限制 (9 學分)；  
    (ii) 必修課不可退選；

<br>
<b>註: 使用前請記得將"user_interface.jsp"、"add_section.jsp"和"delete_section.jsp"程式碼內的資料庫連線配置修改成你自己的設定<b>
<div align=left><img src="https://github.com/WhitePomeranian/3-tier_course-registration-system/assets/125969536/38dbcaca-f65e-4e58-8d78-b92d2eee482a">
<br>
<br>
   
### 如何使用
<b>1st: 請先安裝XAMPP(https://www.apachefriends.org/zh_tw/download.html):</b>
和MySQL(https://www.mysql.com/downloads):
<div align=left><img width="400" src="https://github.com/WhitePomeranian/3-tier_course-registration-system/assets/125969536/ea01c863-c9c6-493e-bb13-2928bdced744">
<img width="400" src="https://github.com/WhitePomeranian/3-tier_course-registration-system/assets/125969536/f81454e8-05e9-480e-a5d4-98382e8bb00c" style="float:left;">
<br><br>
<b>2nd: 下載project後，將其解壓縮並放入XAMPP的tomcat之webapp目錄下(path: C:\xampp\tomcat\webapps):</b>
<div align=left><img height="300" src="https://github.com/WhitePomeranian/3-tier_course-registration-system/assets/125969536/85f76cd0-4617-4555-bbe4-e7991dca2c88">
<br><br>
<b>3rd: 開啟XAMPP Control Panel，將Tomcat啟動:</b>
<div align=left><img height="300" src="https://github.com/WhitePomeranian/3-tier_course-registration-system/assets/125969536/536073ac-97d9-4a5d-a953-17b5ea18276b">
<br><br>
<b>4th: 開啟MySQL Workbench，登入連線到本機(localhost，預設port: 3306)上運行的MySQL資料庫instance:</b>
<div align=left><img height="300" src="https://github.com/WhitePomeranian/3-tier_course-registration-system/assets/125969536/8e0000bb-d448-4385-a0dd-3ab833ac40fe">
<br><br>
<b>5th: 創立新的Schema: `course-registration-system`:</b>
<div align=left><img height="300" src="https://github.com/WhitePomeranian/3-tier_course-registration-system/assets/125969536/13584fcd-c81b-4396-ba28-a5ff380abe34">
<img width="400" src="https://github.com/WhitePomeranian/3-tier_course-registration-system/assets/125969536/324121c3-bd5a-44fa-ad75-6669a9310f4f" style="float:left;">
<img width="400" src="https://github.com/WhitePomeranian/3-tier_course-registration-system/assets/125969536/707e928b-32b7-44e7-8b84-db8725fad93c">
<br><br>
<b>6th: 新增一個query file，然後輸入以下指令並執行:</b>
<div align=left><img src="https://github.com/WhitePomeranian/3-tier_course-registration-system/assets/125969536/580cbcec-eda3-4b29-856f-15afd3106afc">
<br><br>
<b>7th: 開啟專案內的create_table.sql和insert_table.sql並執行:</b>
<div align=left><img height="300" src="https://github.com/WhitePomeranian/3-tier_course-registration-system/assets/125969536/a8c58b69-62ea-4e95-8696-bb242e10613a">
<br><br>
<b>8th: 開啟Chrome瀏覽器並輸入url: "http://localhost:8080/3-tier_course-registration-system-master/3-tier_course-registration-system/src/main/webapp/user_interface.jsp"後，就能夠進入選課系統:</b>
<div align=left><img height="300" src="https://github.com/WhitePomeranian/3-tier_course-registration-system/assets/125969536/70136ea1-32cf-45db-96fe-ccaa6fae091e">
<br><br>
<b>在學號欄位輸入任一insert_table.sql插入資料之學號，例如: "D1059887"，就會看到該學生的必修課程(無法退選)</b>
<div align=left><img height="300" src="https://github.com/WhitePomeranian/3-tier_course-registration-system/assets/125969536/fa2763d2-77cf-4907-895f-732f6c89e7e5">
<br><br>
<b>捲動至下方會看到可加選列表</b>
<div align=left><img height="300" src="https://github.com/WhitePomeranian/3-tier_course-registration-system/assets/125969536/9e8c1d3e-1da2-439b-a1d6-068badb9cc29">
<br><br>
<b>輸入可加選列表的任一選課代碼並點擊加選，例如: "3543"，就會看到該課程被加選至課表上</b>
<div align=left><img src="https://github.com/WhitePomeranian/3-tier_course-registration-system/assets/125969536/f5cbad64-23cd-4961-8e46-66d8579718bd">
<img width="600" src="https://github.com/WhitePomeranian/3-tier_course-registration-system/assets/125969536/3c3eefe9-2beb-4807-9bbb-decefa4afa4b">
<br><br>
<b>捲動至最下方也會條列出已加選的課程</b>
<div align=left><img src="https://github.com/WhitePomeranian/3-tier_course-registration-system/assets/125969536/91995345-9b55-47ae-8900-e0194ed63968">
<br><br>
<b>那最後說明如何"退選"，只需點擊課表上的課程，再點擊退選即可退選課程</b>
<div align=left><img width="600" src="https://github.com/WhitePomeranian/3-tier_course-registration-system/assets/125969536/3c3eefe9-2beb-4807-9bbb-decefa4afa4b">
<div align=left><img src="https://github.com/WhitePomeranian/3-tier_course-registration-system/assets/125969536/d08d5d88-e928-4e3e-abb0-7b82ca40dd63">















