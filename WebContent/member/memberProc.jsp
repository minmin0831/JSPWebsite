<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>

<%
	request.setCharacterEncoding("utf-8");
%>
<jsp:useBean id="bean" class="bean.MemberBean" />
<jsp:setProperty property="*" name="bean" />

<jsp:useBean id="mgr" class="bean.MemberMgr" />

<%
	String msg = "회원가입에 실패 하였습니다.";
	String location = "member.html";
	
	boolean result = mgr.insertMember(bean);
	if(result){
		msg = "회원가입에 성공 하였습니다.";
		location = "../index.jsp";
	}
%>

<script>
	alert("<%=msg %>");
	location.href = "<%=location %>"
</script>