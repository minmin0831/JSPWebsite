<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="java.util.Vector" %>   
<%@ page import="java.util.Random" %> 
<%@ page import="bean.PollListBean" %> 
<%@ page import="bean.PollItemBean" %>   
    
<jsp:useBean id="pMgr" class="bean.PollMgr" />    

<%
	request.setCharacterEncoding("utf-8");
	int num = Integer.parseInt(request.getParameter("num"));
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link href="../Style.css" rel="stylesheet" type="text/css">
    <link href="poll.css" rel="stylesheet" type="text/css">

    <title>JSP Poll</title>
</head>
<body>
    <div class="divCenter">
        <table class="pollTable" style="width: 500px;">
<%
	PollListBean plBean = pMgr.getList(num);
	int sum = pMgr.sumCount(num);
%>        
            <tr>
                <td colspan="4"><b>Q : <%=plBean.getQuestion() %></b></td>
            </tr>
            <tr>
                <td colspan="3"><b>총 투표자 : <%=sum %> 명</b></td>
                <td>count</td>
            </tr>
<%
	Vector<PollItemBean> vlist = pMgr.getView(num);
	for(int i=0; i<vlist.size(); i++){
		PollItemBean bean = vlist.get(i);
		String[] item = bean.getItem();
		
		int count = bean.getCount();
		int ratio = (int)((double)count / sum * 100);
		
		Random r = new Random();
		int rgb = r.nextInt(255 * 255 * 255);
		String rgbt = Integer.toHexString(rgb);
		String hRGB = "#" + rgbt;
%>            
            <tr>
                <td class="center" style="width: 30px;">
                	<%=bean.getItemnum() + 1 %>
                </td>
                <td style="width: 150px;"><%=item[0] %></td>
                <td>
                    <div style="height: 20px; width: <%=ratio * 2 %>px; 
                    	background-color: <%=hRGB %>; border:1px solid gray" />
                </td>
                <td class="center" style="width: 30px;"><%=count %></td>
            </tr>
<%
	}//for(int i=0; i<vlist.size(); i++)
%>            
        </table>
        <p class="buttons">
            <button type="button" onclick="window.close()">닫기</button>
        </p>
    </div> 
</body>
</html>    