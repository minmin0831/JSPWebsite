<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="java.util.Vector" %> 
<%@ page import="bean.CommentBean" %>   

<jsp:useBean id="mMgr" class="bean.MemberMgr" />
<jsp:useBean id="cMgr" class="bean.CommentMgr" />
    
<%
	String id = (String)session.getAttribute("idKey");
	int num = Integer.parseInt(request.getParameter("num"));
	int nowPage = Integer.parseInt(request.getParameter("nowPage"));
	String keyField = request.getParameter("keyField");
	String keyWord = request.getParameter("keyWord");
	
	String url = "num="+ num +"&nowPage="+ nowPage +"&keyField="+ keyField
			+"&keyWord="+ keyWord +"&article=./board/read.jsp";
	
	int comNum = -1;
	if(request.getParameter("comNum") != null){
		comNum = Integer.parseInt(request.getParameter("comNum"));
	}
	
	int repComNum = -1;
	if(request.getParameter("repComNum") != null){
		repComNum = Integer.parseInt(request.getParameter("repComNum"));
	}
%>    
    
<!DOCTYPE html>
<html lang="ko">
<head>
    <link href="../Style.css" rel="stylesheet" type="text/css">
    <link href="../board/boardStyle.css" rel="stylesheet" type="text/css">
    <style>
        table.comment{
            border-bottom: 1px solid gray ;
            margin-bottom: 20px;
        }

        table.comment th,
        table.comment td{
            padding: 0;
        }

        table.comment .left{
            text-align: left;
        }

        table.comment .right{
            text-align: right;
        }

        table.comment td pre{
            margin: 5px;
        }
    </style>

    <title>Document</title>
</head>
<body>
<%
	Vector<CommentBean> vlist = cMgr.getCommentList(num);
	for(int i=0; i<vlist.size(); i++){
		CommentBean bean = vlist.get(i);
		int bComNum = bean.getComNum();
		int bRef = bean.getRef();
		
		if(bComNum != comNum){
			if(bComNum == bRef){
%>
	<!-- 댓글 목록 출력 테이블 -->
    <table class="comment">
        <tr>
            <th class="left"><%=mMgr.getName(bean.getId()) %></th>
            <td></td>
            <td class="right">
<%
			if(id != null && id.equals(bean.getId())){
%>            
                <button type="button" 
                	onclick="editComment(<%=bComNum %>)">
                	수정
                </button>
                <button type="button" 
                	onclick="deleteComment(<%=bComNum %>)">
                	삭제
                </button>
<%
			}//if(id.equals(bean.getId()))
%>                
            </td>
        </tr>
        <tr>
            <td colspan="3">
<pre>
<%=bean.getComContent() %>
</pre>                
            </td>
        </tr>
        <tr>
            <td colspan="3" class="left">
            	<%=bean.getComDate() %>
<%
			if(id != null){
%>            	 
            	<button type="button" 
            		onclick="showReplyInsert(<%=bComNum %>)">
            		답글쓰기
            	</button>
<%
			}//if(id != null)
%>            	
            </td>
        </tr>
    </table>
<%
			} else {
				if(bComNum != comNum){
%>    
	<!-- 답글 출력 테이블 -->
    <table class="comment" name="reply">
        <tr>
            <td style="width: 50px;"></td>
            <th class="left"><%=mMgr.getName(bean.getId()) %></th>
            <td></td>
            <td class="right">
                <button type="button" 
                	onclick="editComment(<%=bComNum %>)">
                	수정
                </button>
                <button type="button" 
                	onclick="deleteComment(<%=bComNum %>)">
                	삭제
                </button>
            </td>
        </tr>
        <tr>
            <td></td>
            <td colspan="3">
<pre>
<%=bean.getComContent() %>
</pre>                
            </td>
        </tr>
        <tr>
            <td></td>
            <td colspan="3" class="left">
            	<%=bean.getComDate() %>
<%
			if(id != null){
%>            	 
            	<button type="button" 
            		onclick="showReplyInsert(<%=bComNum %>)">
            		답글쓰기
            	</button>
<%
			}//if(id != null)
%>
            </td>
        </tr>
    </table>    
<%
				} else {
%>
	<!-- 답글 수정 폼 -->
    <form name="replyUpdate">
        <table class="comment">
            <tr>
                <td style="width: 50px;"></td>
                <th class="left">홍길동</th>
            </tr>
            <tr>
                <td style="width: 50px;"></td>
                <td>
<textarea name="comment" style="width: 100%; height: 60px;">
코멘트 내용을 입력합니다.
엔터 이후 다음줄이 나오는것을 확인 합니다.
</textarea></td>
            </tr>
            <tr>
                <td style="width: 50px;"></td>
                <td class="right">
                	<button>수정</button>
                	<button>취소</button>
                </td>
            </tr>
        </table>
    </form>
<%					
				}
			}//if(bComNum == bRef)
			
			if(bComNum == repComNum){
%>  
    <!-- 답글 입력 폼 -->  
    <form name="replyInsert" method="post" action="CommentControl">
        <table class="comment">
            <tr>
                <td style="width: 50px;"></td>
                <th class="left"><%=mMgr.getName(id) %></th>
            </tr>
            <tr>
                <td style="width: 50px;"></td>
                <td>
                	<textarea name="comContent" style="width: 100%; height: 60px;"></textarea>
                </td>
            </tr>
            <tr>
                <td style="width: 50px;"></td>
                <td class="right"><button>등록</button></td>
            </tr>
        </table>
        <input name="id" type="hidden" value="<%=id %>">
        <input name="listNum" type="hidden" value="<%=num %>">
        <input name="ref" type="hidden" value="<%=bRef %>">
        <input name="mode" type="hidden" value="insert">
        <input name="url" type="hidden" value="<%=url %>" >
    </form>
<%
			}//if(bComNum == repComNum)
		} else {
			CommentBean editBean = cMgr.getComment(comNum);
%>
	<!-- 댓글 수정 폼 -->
    <form name="commentUpdate" method="post" action="CommentControl">
        <table class="comment">
            <tr>
                <th class="left"><%=mMgr.getName(editBean.getId()) %></th>
            </tr>
            <tr>
                <td>
<textarea name="comContent" style="width: 100%; height: 60px;">
<%=editBean.getComContent() %>                
</textarea></td>
            </tr>
            <tr>
                <td class="right">
                    <button>수정</button>
                    <button type="button" onclick="editCancelComment()">
                    	취소
                    </button>
                </td>
            </tr>
        </table>
        <input name="comNum" type="hidden" value="<%=editBean.getComNum() %>">
        <input name="mode" type="hidden" value="update">
        <input name="url" type="hidden" value="<%=url %>">
    </form>
<%			
		}//if(bean.getComNum() != comNum)
	}//for(int i=0; i<vlist.size(); i++)
	
	if(id != null){
%>
	<!-- 댓글 등록 폼 -->
    <form name="commentInsert" method="post" action="CommentControl">
        <table class="comment">
            <tr>
                <th class="left"><%=mMgr.getName(id) %></th>
            </tr>
            <tr>
                <td><textarea name="comContent" style="width: 100%; height: 60px;"></textarea></td>
            </tr>
            <tr>
                <td class="right">
                    <button>등록</button>
                    <button type="reset">취소</button>
                </td>
            </tr>
        </table>
        <input name="id" type="hidden" value="<%=id %>">
        <input name="listNum" type="hidden" value="<%=num %>">
        <input name="mode" type="hidden" value="insert">
        <input name="url" type="hidden" value="<%=url %>" >
    </form>
<%
	}//if(id != null)
%>    

	<form name="frmEditComment" method="get" action="index.jsp">
		<input name="num" type="hidden" value="<%=num %>">
		<input name="nowPage" type="hidden" value="<%=nowPage %>">
		<input name="keyField" type="hidden" value="<%=keyField %>">
		<input name="keyWord" type="hidden" value="<%=keyWord %>">
		<input name="article" type="hidden" value="./board/read.jsp">
		<input name="comNum" type="hidden">
	</form>
	
	<form name="frmDeleteComment" method="post" action="CommentControl">
		<input name="comNum" type="hidden">
		<input name="mode" type="hidden" value="delete">
		<input name="url" type="hidden" value="<%=url %>">
	</form>
	
	<form name="frmReplyInsert" method="get" action="index.jsp">
		<input name="num" type="hidden" value="<%=num %>">
		<input name="nowPage" type="hidden" value="<%=nowPage %>">
		<input name="keyField" type="hidden" value="<%=keyField %>">
		<input name="keyWord" type="hidden" value="<%=keyWord %>">
		<input name="article" type="hidden" value="./board/read.jsp">
		<input name="repComNum" type="hidden">
	</form>
</body>
<script>
	function editComment(comNum){
		document.frmEditComment.comNum.value = comNum;
		document.frmEditComment.submit();
	}
	
	function editCancelComment(){
		document.frmEditComment.comNum.value = -1;
		document.frmEditComment.submit();
	}
	
	function deleteComment(comNum){
		if(confirm("댓글을 삭제 합니까?")){
			document.frmDeleteComment.comNum.value = comNum;
			document.frmDeleteComment.submit();
		}
	}
	
	function showReplyInsert(comNum){
		document.frmReplyInsert.repComNum.value = comNum;
		document.frmReplyInsert.submit();
	}
</script>
</html>