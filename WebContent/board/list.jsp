<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="java.util.Vector" %>
<%@ page import="bean.BoardBean" %>

<jsp:useBean id="bMgr" class="bean.BoardMgr" />

<%
	final int NUM_PER_PAGE = 10; //페이지당 레코드 수
	final int PAGE_PER_BLOCK = 15; //블럭당 페이지 수
	
	int totalRecord = 0; //전체 레코드 수
	int totalPage = 0; //전체 페이지 수
	int totalBlock = 0; //전체 블록 수
	
	int nowPage = 1; //현재 페이지
	int nowBlock = 1; //현재 블럭
	
	int start = 0; //tblBoard 테이블의 select 시작 번호
	int end = 10; //시작 번호로 부터 가져올 레코드 수
	
	int listSize = 0; //현재 읽어온 게시물 수
	
	request.setCharacterEncoding("utf-8");
	String keyField = "";
	String keyWord = "";
	if(request.getParameter("keyWord") != null){
		keyField = request.getParameter("keyField");
		keyWord = request.getParameter("keyWord");
		System.out.println(keyField+keyWord);
	}
/*
	if(request.getParameter("reload") != null){
		if(request.getParameter("reload").equals("true")){
			keyField = "";
			keyWord = "";
		}
	}
*/
	
	if(request.getParameter("nowPage") != null){
		nowPage = Integer.parseInt(request.getParameter("nowPage"));
	}
	start = (nowPage * NUM_PER_PAGE) - NUM_PER_PAGE;
	end = NUM_PER_PAGE;
	
	totalRecord = bMgr.getTotalCount();
	totalPage = totalRecord / NUM_PER_PAGE + 1;
	nowBlock = nowPage / PAGE_PER_BLOCK + 1;
	
	String id = (String)session.getAttribute("idKey");
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link href="./board/boardStyle.css" rel="stylesheet" type="text/css">
    <style>
        table.boardList th {
            background-color: #d0d0d0;
        }

        table.boardList td {
            text-align: center;
        }
    </style>

    <title>JSP Board</title>
</head>
<body>
    <h2 style="text-align: center;">JSP Board</h2>
    <div>
        <p>
        	Total : <%=totalRecord %> Article( 
        		<span style="color: red;"><%=nowPage %></span> / <%=totalPage %> Pages )
        </p>
    </div>
    <table class="boardList" style="margin:auto;">
        <tr>
            <th>번 호</th>
            <th>제 목</th>
            <th>이 름</th>
            <th>날 짜</th>
            <th>조회수</th>
        </tr>
<%
	Vector<BoardBean> vlist = bMgr.getBoardList(keyField, keyWord, start, end);
	if(vlist.isEmpty()){
%>
		<tr>
            <td colspan="5">검색된 결과가 업습니다.</td>
        </tr>
<%		
	} else {
		for(int i=0; i<vlist.size(); i++){
			BoardBean bean = vlist.get(i);
			int num = bean.getNum();
			int depth = bean.getDepth();
%>        
        <tr>
            <td><%=num %></td>
            <td style="text-align: left;">
<%
			if(depth > 0){
				for(int j=0; j<depth; j++){
					out.println("&nbsp;&nbsp;");
				}
			}
%>            
            	<a href="javascript:read('<%=num %>')"><%=bean.getSubject() %></a>
            </td>
            <td><%=bean.getName() %></td>
            <td><%=bean.getRegdate() %></td>
            <td><%=bean.getCount() %></td>
        </tr>
<%
		}//for(int i=0; i<vlist.size(); i++)
	}//if(vlist.isEmpty())
%>        
        <tr style="height: 50px;"></tr>
        <tr>
            <td colspan="3" style="text-align: center;">
<%
	int pageStart = (nowBlock - 1) * PAGE_PER_BLOCK + 1;
	int pageEnd = ((pageStart + PAGE_PER_BLOCK) < totalPage) 
			? (pageStart + PAGE_PER_BLOCK) : totalPage + 1;
	if(totalPage != 0){
		if(nowBlock > 1){
%>            
            	<a href="javascript:block('<%=nowBlock - 1 %>')">Prev...</a> 
<%
		}//if(nowBlock > 1)
			
		for(int i=pageStart; i<pageEnd; i++){
			if(i == nowPage){
%>            	
            	<span style="color:red">[<%=i %>]</span>
<%
			} else {
%>
				<a href="javascript:paging('<%=i %>')">[<%=i %>]</a>
<%				
			}//if(i == nowPage)
		}//for(int i=pageStart; i<pageEnd; i++)
			
		if(nowBlock < totalBlock){
%>            	
            	 <a href="javascript:block('<%=nowBlock + 1 %>')">...Next</a>
<%
		}//if(nowBlock < totalBlock)
	}//if(totalPage != 0)
%>            	
            </td>
            <td colspan="2" style="text-align: right;">
            	<button type="button" onclick="checkId()">글쓰기</button>
            	<button type="button" onclick="list()">처음으로</button>
            </td>
        </tr>
    </table>

    <hr style="width: 80%; margin: auto;">

    <form name="searchFrm" method="get" action="index.jsp">
        <table style="margin:auto;">
            <tr>
                <td style="text-align: center;">
                    <select name="keyField" size="1">
                        <option value="name">이 름</option>
                        <option value="subject">제 목</option>
                        <option value="content">내 용</option>
                    </select>
                    <input name="keyWord" size="16">
                    <button type="button" onclick="check()">찾기</button>
                </td>
            </tr>
        </table>
        <input name="article" type="hidden" value="./board/list.jsp">
    </form>
    
    <form name="readFrm" method="get">
    	<input name="num" type="hidden">
    	<input name="nowPage" type="hidden" value="<%=nowPage %>">
    	<input name="keyField" type="hidden" value="<%=keyField %>">
    	<input name="keyWord" type="hidden" value="<%=keyWord %>">
    	<input name="article" type="hidden" value="./board/read.jsp">
    </form>
    
    <form name="listFrm" method="post">
    	<input name="nowPage" type="hidden" value="1">
    	<input name="reload" type="hidden" value="true">
    	<input name="article" type="hidden" value="./board/list.jsp">
    </form>
</body>

<script>
	function read(num){
		document.readFrm.num.value = num;
		document.readFrm.action = "index.jsp";
		document.readFrm.submit();
	}

	function block(value){
		document.readFrm.nowPage.value = <%=PAGE_PER_BLOCK %> * (value - 1) + 1;
		document.readFrm.article.value = "./board/list.jsp";
		document.readFrm.submit();
	}
	
	function paging(page){
		document.readFrm.nowPage.value = page;
		document.readFrm.article.value = "./board/list.jsp";
		document.readFrm.submit();
	}
	
	function list(){
		document.listFrm.action = "index.jsp";
		document.listFrm.submit();
	}
	
	function check(){
		if(document.searchFrm.keyWord.value == ""){
			alert("검색어를 입력해 주세요");
			document.searchFrm.keyWord.focus();
			return;
		}
		
		document.searchFrm.submit();
	}
	
	function checkId(){
		let id = "<%=id %>";
		if(id == "" || id == "null"){
			alert("로그인을 하셔야 글을 쓸 수 있습니다.");
			return false;
		}
		
		window.location.href='index.jsp?article=./board/post.jsp';
	}
</script>
</html>