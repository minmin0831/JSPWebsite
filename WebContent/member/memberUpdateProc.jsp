<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>

<%
	request.setCharacterEncoding("utf-8");
%>

<jsp:useBean id="bean" class="bean.MemberBean" />
<jsp:setProperty property="*" name="bean"/>
<jsp:useBean id="mMgr" class="bean.MemberMgr" />

<%
	boolean result = mMgr.updateMember(bean);
	if(result){
%>
<script>
	alert("회원정보를 수정 하였습니다.");
	location.href = "../index.jsp";
</script>
<%
	} else {
%>
<script>
	alert("회원정보 수정에 실패 하였습니다.");
	history.back();
</script>
<%
	}
%>