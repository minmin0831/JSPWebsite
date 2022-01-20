<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="java.util.Vector" %>
<%@ page import="bean.PollListBean" %>    

<jsp:useBean id="pMgr" class="bean.PollMgr" />

<%
	String id = (String)session.getAttribute("idKey");
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    
    <link href="./poll/poll.css" rel="stylesheet" type="text/css">
    
    <title>JSP Poll</title>
</head>
<body>
    <div class="divCenter">
        <h2>투표 프로그램</h2>
        <hr width="60%">
        <b>설 문 폼</b>
        
<jsp:include page="pollForm.jsp" />
        
        <hr width="60%">
        <b>설문 리스트</b>
        <table class="pollTable" style="width: 600px;">
            <tr>
                <th>번호</th>
                <th>제목</th>
                <th>시작일 ~ 종료일</th>
            </tr>
<%
	Vector<PollListBean> vlist = pMgr.getAllList();

	for(int i=0; i<vlist.size(); i++){
		PollListBean bean = vlist.get(i);
		int num = bean.getNum();
%>            
            <tr>
                <td class="center"><%=num %></td>
                <td>
                	<a href="index.jsp?article=./poll/pollList.jsp&num=<%=num %>">
                		<%=bean.getQuestion() %>
                	</a>
                </td>
                <td class="center">
                	<%=bean.getSdate() %> ~ <%=bean.getEdate() %>
                </td>
            </tr>
<%
	}//for(int i=0; i<vlist.size(); i++)
%>            
        </table>
        <p class="buttons">
<%
	if(id != null){
%>        
            <button type="button" 
            	onclick="location.href='index.jsp?article=./poll/pollInsert.html'">
            	설문 작성하기
            </button>
<%
	}//if(id != null)
%>            
        </p>
    </div>
</body>
</html>