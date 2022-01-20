<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
    
<jsp:useBean id="mMgr" class="bean.MemberMgr" />    

<%
	request.setCharacterEncoding("utf-8");
	String id = request.getParameter("id");
%>
    
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ID 중복체크</title>
</head>
<body style="background-color: #ffffcc;">
    <div style="text-align: center;">
        <br>
<%
	boolean result = mMgr.checkId(id);
	if(result){
%>        
        <p><b><%=id %></b>는 이미 존재하는 ID 입니다.</p>
<%
	} else {
%>        
        <p><b><%=id %></b>는 사용 가능 합니다.</p>
<%
	}
%>        
        <a href="#" onclick="self.close()">닫기</a>
    </div>
</body>
</html>