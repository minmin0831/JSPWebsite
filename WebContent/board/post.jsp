<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
    
<jsp:useBean id="mMgr" class="bean.MemberMgr" />
    
<%
	String id = (String)session.getAttribute("idKey");
	String name = mMgr.getName(id);
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link href="./board/boardStyle.css" rel="stylesheet" type="text/css">

    <title>JSP Board</title>
</head>
<body>
    <div class="pageName">글쓰기</div>
    <form name="postFrm" method="post" action="boardPost" enctype="multipart/form-data">
        <table>
            <tr>
                <th>성 명</th>
                <td><%=name %></td>
            </tr>
            <tr>
                <th>제 목</th>
                <td><input name="subject" size="50" maxlength="30"></td>
            </tr>
            <tr>
                <th>내 용</th>
                <td><textarea name="content" rows="10" cols="50"></textarea></td>
            </tr>
            <tr>
                <th>비밀번호</th>
                <td><input name="pass" type="password" size="15" maxlength="15"></td>
            </tr>
            <tr>
                <th>파일찾기</th>
                <td><input name="filename" type="file" size="50" maxlength="50"></td>
            </tr>
            <tr>
                <th>내용타입</th>
                <td>
                    <input name="contentType" type="radio" value="HTTP">HTTP&nbsp;
                    <input name="contentType" type="radio" value="TEXT" checked>TEXT
                </td>
            </tr>
            <tr>
                <td colspan="2"><hr></td>
            </tr>
            <tr>
                <td class="buttons" colspan="2">
                    <button>등록</button>&nbsp;&nbsp;
                    <button type="reset">다시쓰기</button>&nbsp;&nbsp;
                    <button type="button" 
                    	onclick="location.href='index.jsp?article=./board/list.jsp'">
                    	리스트</button>
                </td>
            </tr>
        </table>
        <input name="name" type="hidden" value="<%=name %>">
        <input name="ip" type="hidden" value="<%=request.getRemoteAddr() %>">
        <input name="id" type="hidden" value="<%=id %>">
    </form>
</body>
</html>