<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="bean.BoardBean" %>

<jsp:useBean id="mMgr" class="bean.MemberMgr" />
    
<%
	String id = (String)session.getAttribute("idKey");
	String name = mMgr.getName(id);

	BoardBean bean = (BoardBean)session.getAttribute("bean");
	int nowPage = Integer.parseInt(request.getParameter("nowPage"));
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
    <div class="pageName">답변하기</div>
    <form method="post" action="boardReply">
        <table>
            <tr>
                <th>성 명</th>
                <td><%=name %></td>
            </tr>
            <tr>
                <th>제 목</th>
                <td>
                	<input name="subject" size="50" maxlength="30" 
                		value="답변 : <%=bean.getSubject() %>">
                </td>
            </tr>
            <tr>
                <th>내 용</th>
                <td>
                    <textarea name="content" rows="10" cols="50">
<%=bean.getContent() %>
===== 답변 글을 쓰세요 =====
                    </textarea>
                </td>
            </tr>
            <tr>
                <th>비밀번호</th>
                <td>
                    <input name="pass" type="password" size="15" maxlength="15">
                    수정시에는 비밀번호가 필요합니다.
                </td>
            </tr>
            <tr>
                <td colspan="2"><hr></td>
            </tr>
            <tr>
                <td class="buttons" colspan="2">
                    <button type="submit">답변등록</button>&nbsp;&nbsp;
                    <button type="reset">다시쓰기</button>&nbsp;&nbsp;
                    <button type="button" onclick="history.back()">뒤로</button>
                </td>
            </tr>
        </table>
        <input name="ip" type="hidden" value="<%=request.getRemoteAddr() %>">
        <input name="ref" type="hidden" value="<%=bean.getRef() %>">
        <input name="pos" type="hidden" value="<%=bean.getPos() %>">
        <input name="depth" type="hidden" value="<%=bean.getDepth() %>">
        <input name="nowPage" type="hidden" value="<%=nowPage %>">
        <input name="name" type="hidden" value="<%=name %>">
        <input name="id" type="hidden" value="<%=id %>">
    </form>
</body>
</html>