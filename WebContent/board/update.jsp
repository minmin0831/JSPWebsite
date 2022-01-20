<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="bean.BoardBean" %>    

<%
	request.setCharacterEncoding("utf-8");
	int num = Integer.parseInt(request.getParameter("num"));
	int nowPage = Integer.parseInt(request.getParameter("nowPage"));
	
	//session에 저장된 "bean" 값 가져오기
	BoardBean bean = (BoardBean)session.getAttribute("bean");
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
    <div class="pageName">수정하기</div>
    <form name="updateFrm" method="post" action="boardUpdate">
        <table>
            <tr>
                <th>성 명</th>
                <td><input name="name" size="10" maxlength="8" value="<%=bean.getName()%>"></td>
            </tr>
            <tr>
                <th>제 목</th>
                <td><input name="subject" size="50" maxlength="30" value="<%=bean.getSubject()%>"></td>
            </tr>
            <tr>
                <th>내 용</th>
                <td>
                    <textarea name="content" rows="10" cols="50"><%=bean.getContent()%></textarea>
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
                    <button type="button" onclick="check()">수정완료</button>&nbsp;&nbsp;
                    <button type="reset">다시수정</button>&nbsp;&nbsp;
                    <button type="button" onclick="history.go(-1)">뒤로</button>
                </td>
            </tr>
        </table>
        <input name="num" type="hidden" value="<%=num %>">
        <input name="ip" type="hidden" value="<%=request.getRemoteAddr() %>">
        <input name="nowPage" type="hidden" value="<%=nowPage %>">
    </form>
</body>

<script>
	function check(){
		if(document.updateFrm.pass.value == ""){
			alert("수정을 위해 패스워드를 입력하세요.");
			document.updateFrm.pass.focus();
			return false;
		}
		
		document.updateFrm.submit();
	}
</script>

</html>