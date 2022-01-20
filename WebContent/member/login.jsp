<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="java.lang.System" %>
<%@ page import="java.io.PrintStream" %>
    
<%
	String id = (String)session.getAttribute("idKey"); // idKey는 현재 null 값이다. String id에는 null 값이 저장된다. 
	System.out.println("현재 idKey 저장값: " + id);
%>    

<head>
    <link href="Style.css" rel="stylesheet" type="text/css">
    <style>
        td {
            padding: 5px;
        }
    </style>

    <title>로그인</title>
</head>
<body style="background-color: #ffffcc;">
<%
	if(id != null){
%>
<jsp:useBean id="mMgr" class="bean.MemberMgr" />
<%
		String name = mMgr.getName(id);
%>	
    <div style="margin-top: 30px; text-align: center;">
        <p><b><%=name %></b>님 환영합니다.</p>
        <p>제한된 기능을 사용 할 수 가 있습니다.</p>
        <p><a href="./member/logout.jsp">로그아웃</a></p>
    </div>
<%
	} else {
%>    
    <form name="loginFrm" method="post" action="./member/loginProc.jsp">
        <table style="margin:auto">
            <tr>
                <th colspan="2" style="font-size: 20px; padding: 20px;">로그인</th>
            </tr>
            <tr>
                <td>아이디</td>
                <td><input name="id" required></td>
            </tr>
            <tr>
                <td>비밀번호</td>
                <td><input name="pwd" type="password" required></td>
            </tr>
            <tr>
                <td colspan="2" style="text-align: right;">
                    <button>로그인</button>&nbsp;&nbsp;
                    <button type="button" 
                    	onclick="location.href='index.jsp?article=./member/member.html'">
                    	회원가입
                    </button>
                </td>
            </tr>
        </table>
    </form>
<%
	}//if(id != null)
%>    
</body>
