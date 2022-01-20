<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="bean.BoardBean" %>  

<jsp:useBean id="bMgr" class="bean.BoardMgr" />  

<%
	request.setCharacterEncoding("utf-8");
	int num = Integer.parseInt(request.getParameter("num"));
	String nowPage = request.getParameter("nowPage"); 
	
	if(request.getParameter("pass") != null){
		String inPass = request.getParameter("pass");
		BoardBean bean = (BoardBean)session.getAttribute("bean");
		String dbPass = bean.getPass();
		if(inPass.equals(dbPass)){
			bMgr.deleteBoard(num);
			String url = "index.jsp?article=./board/list.jsp&nowPage="+ nowPage;
%>
<script>
	location.href="<%=url %>";
</script>
<%			
		} else {
%>
<script>
	alert("입력하신 비밀번호가 아닙니다.");
	history.back();
</script>
<%			
		}//if(inPass.equals(dbPass))
	}//if(request.getParameter("pass") != null)
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
    <div class="pageName">사용자의 비밀번호를 입력해 주세요</div>
    <form name="delFrm" method="post" action="index.jsp">
        <table>
            <tr>
                <td style="text-align: center;">
                    <input name="pass" type="password" size="17" maxlength="15">
                </td>
            </tr>
            <tr>
                <td><hr></td>
            </tr>
            <tr>
                <td class="buttons">
                    <button type="button" onclick="check()">삭제완료</button>&nbsp;&nbsp;
                    <button type="reset">다시쓰기</button>&nbsp;&nbsp;
                    <button type="button" onclick="history.go(-1)">뒤로</button>
                </td>
            </tr>
        </table>
        <input name="num" type="hidden" value="<%=num %>" >
        <input name="nowPage" type="hidden" value="<%=nowPage %>">
        <input name="article" type="hidden" value="./board/delete.jsp">
    </form>
</body>
<script>
	function check(){
		if(document.delFrm.pass.value == ""){
			alert("패스워드를 입력해 주세요");
			document.delFrm.pass.focus();
			return false;
		}
		
		document.delFrm.submit();
	}
</script>
</html>