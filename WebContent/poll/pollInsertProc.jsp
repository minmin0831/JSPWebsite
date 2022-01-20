<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>

<%
	request.setCharacterEncoding("utf-8");
%>

<jsp:useBean id="pMgr" class="bean.PollMgr" />
<jsp:useBean id="plBean" class="bean.PollListBean" />
<jsp:setProperty property="*" name="plBean"/>
<jsp:useBean id="piBean" class="bean.PollItemBean" />
<jsp:setProperty property="*" name="piBean"/>

<%
	boolean flag = pMgr.insertPoll(plBean, piBean);

	String msg = "설문 추가에 실패 하였습니다.";
	String url = "../index.jsp?article=./poll/pollInsert.html";
	if(flag){
		msg = "설문이 추가 되었습니다.";
		url = "../index.jsp?article=./poll/pollList.jsp";
	}
%>

<script>
	alert("<%=msg %>");
	location.href = "<%=url %>";
</script>