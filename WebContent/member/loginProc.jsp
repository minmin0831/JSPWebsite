<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>

<jsp:useBean id="mMgr" class="bean.MemberMgr"/>

<%
	request.setCharacterEncoding("utf-8");
	String id = request.getParameter("id");
	String pwd = request.getParameter("pwd");
	
	String msg = "로그인에 실패 하였습니다.";

	boolean result = mMgr.loginMember(id, pwd);
	if(result){
		session.setAttribute("idKey", id);
		msg = "로그인에 성공 하였습니다.";
	}
%>   

<script>
	alert("<%=msg %>");
	location.href = "../index.jsp";
</script>