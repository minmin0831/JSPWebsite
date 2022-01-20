<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
    
<jsp:useBean id="pMgr" class="bean.PollMgr" />    

<%
	request.setCharacterEncoding("utf-8");
	int listnum = Integer.parseInt(request.getParameter("listnum"));
	String[] itemnum = request.getParameterValues("itemnum");
	
	boolean flag = pMgr.updatePoll(listnum, itemnum);
	
	String msg = "투표가 등록되지 않앗습니다.";
	if(flag){
		msg = "투표가 정상적으로 등록되었습니다.";
	}
%>

<script>
	alert("<%=msg %>");
	location.href="../index.jsp?article=./poll/pollList.jsp&num=<%=listnum %>";
</script>