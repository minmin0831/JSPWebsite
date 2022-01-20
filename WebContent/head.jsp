<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>

<table style="width:100%">
	<tr>
		<td colspan="5">
			<a href="index.jsp"><img src="./images/logo.png"></a>
		</td>
	</tr>
	<tr>
		<td style="width:250px;"></td>
<%
	String id = (String)session.getAttribute("idKey");
	if(id != null){
%>		
		<th><a href="index.jsp?article=./member/updateMember.jsp">회원정보 수정</a></th>
<%
	} else {
%>		
		<th><a href="index.jsp?article=./member/member.html">회원가입</a></th>
<%
	}//if(id != null)
%>
		<th><a href="index.jsp?article=./board/list.jsp">게시판</a></th>
		<th><a href="index.jsp?article=./poll/pollList.jsp">투표 프로그램</a></th>
		<td></td>
	</tr>
</table>