<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="bean.BoardBean" %>

<jsp:useBean id="bMgr" class="bean.BoardMgr" />    

<%
	String id = (String)session.getAttribute("idKey");
	
	request.setCharacterEncoding("utf-8");
	int num = Integer.parseInt(request.getParameter("num"));
	int nowPage = Integer.parseInt(request.getParameter("nowPage"));
	String keyField = request.getParameter("keyField");
	String keyWord = request.getParameter("keyWord");
	
	//조회수 1회 증가
	bMgr.upCount(num);
	
	//num 레코드 조회
	BoardBean bean = bMgr.getBoard(num);
	String filename = bean.getFilename();
	
	//num 레코드 조회 결과를 session으로 등록
	session.setAttribute("bean", bean);
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <link href="./board/boardStyle.css" rel="stylesheet" type="text/css">
    <style>
        table.readFrm th {
            background-color: #99aaee;
            width: 100px;
        }
    </style>

    <title>JSP Board</title>
</head>
<body>
    <div class="pageName">글읽기</div>
    <table class="readFrm">
        <tr>
            <th>성 명</th>
            <td><%=bean.getName() %></td>
            <th>등록일자</th>
            <td><%=bean.getRegdate() %></td>
        </tr>
        <tr>
            <th>제 목</th>
            <td colspan="3"><%=bean.getSubject() %></td>
        </tr>
        <tr>
            <th>첨부파일</th>
            <td colspan="3">
<%
	if(filename == null || filename.equals("")){
%>            
            	등록된 파일이 없습니다.
<%
	} else {
%>            	
            	<a href="javascript:down('<%=filename %>')"><%=filename %></a>
            	(<span style="color:blue;"><%=bean.getFilesize() %></span> Bytes)
<%
	}
%>            	
            </td>
        </tr>
        <tr>
            <td colspan="4" style="padding: 20px 5px;">
                <pre><%=bean.getContent() %></pre>
            </td>
        </tr>
        <tr>
            <td colspan="4" style="text-align: right;">
                <%=bean.getIp() %>로 부터 글을 남기셨습니다. / 조회수 <%=bean.getCount() %>
            </td>
        </tr>
        <tr>
            <td colspan="4"><hr></td>
        </tr>
        <tr>
            <td class="buttons" colspan="4">
                <button type="button" onclick="list()">리스트</button>&nbsp;&nbsp;
                <button type="button" onclick="checkId()">
                	답변
                </button>&nbsp;&nbsp;                
<%
	if(id != null && bean.getId() != null && id.equals(bean.getId())){
%>                
                <button type="button" 
                	onclick="location.href='index.jsp?num=<%=num %>&nowPage=<%=nowPage %>&article=./board/update.jsp'">
                	수정
                </button>&nbsp;&nbsp;
                <button type="button" 
                	onclick="location.href='index.jsp?num=<%=num %>&nowPage=<%=nowPage %>&article=./board/delete.jsp'">
                	삭제
                </button>
<%
	}//if(id.equals(bean.getId()))
%>                
            </td>
        </tr>
    </table>
    
    <form name="downFrm" method="post" action="./board/download.jsp">
    	<input name="filename" type="hidden">
    </form>
    
    <form name="listFrm" method="post" action="index.jsp">
    	<input name="nowPage" type="hidden" value="<%=nowPage %>">
    	<input name="article" type="hidden" value="./board/list.jsp">
<%
	if(!(keyWord == null || keyWord.equals(""))){
%>    	
    	<input name="keyField" type="hidden" value="<%=keyField %>">
    	<input name="keyWord" type="hidden" value="<%=keyWord %>">
<%
	}//if(!(keyWord == null || keyWord.equals("")))
%>    	
    </form>
    
<jsp:include page="../comment/comment.jsp" />
  
</body>

<script>
	function down(filename){
		document.downFrm.filename.value = filename;
		document.downFrm.submit();
	}
	
	function list(){
		document.listFrm.submit();
	}
	
	function checkId(){
		let id = "<%=id %>";
		if(id == "" || id == "null"){
			alert("로그인을 하셔야 글을 쓸 수 있습니다.");
			return false;
		}
		
		location.href='index.jsp?nowPage=<%=nowPage %>&article=./board/reply.jsp';
	}
</script>
</html>    