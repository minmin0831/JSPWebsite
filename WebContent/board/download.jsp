<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
    
<jsp:useBean id="bMgr" class="bean.BoardMgr" />   

<%
	bMgr.downLoad(request, response, out, pageContext);
%>