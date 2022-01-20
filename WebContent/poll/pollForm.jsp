<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="java.text.SimpleDateFormat" %> 
<%@ page import="java.util.Date" %>   
<%@ page import="java.util.Vector" %>
<%@ page import="bean.PollListBean" %> 
<%@ page import="bean.PollItemBean" %>    

<jsp:useBean id="pMgr" class="bean.PollMgr" />

<%
	request.setCharacterEncoding("utf-8");
	String pNum = request.getParameter("num");
	int num = 0;
	if(pNum != null && !pNum.equals("")){
		num = Integer.parseInt(pNum);
	}
	
	if(num != 0){
		PollListBean plBean = pMgr.getList(num);
		Vector<String> vlist = pMgr.getItem(num);
%>
<form method="post" action="./poll/pollFormProc.jsp">
    <table class="pollTable" style="width: 300px;">
        <tr>
            <td>Q : <%=plBean.getQuestion() %></td>
        </tr>
        <tr>
            <td>
<%
		String type = "checkbox";
		if(plBean.getType() == 0){
			type = "radio";
		}

		for(int i=0; i<vlist.size(); i++){
			String item = vlist.get(i);
%>            
                <input name="itemnum" type="<%=type %>" value="<%=i %>">
                	<%=item %><br>
<%
		}//for(int i=0; i<vlist.size(); i++)
%>                
            </td>
        </tr>
    </table>
    <p class="buttons">
<%
	SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-mm-dd");
	Date today = new Date();
	Date sdate = dateFormat.parse(plBean.getSdate());
	Date edate = dateFormat.parse(plBean.getEdate());
	
	if(today.before(sdate)){
%>
		투표일은 <%=plBean.getSdate() %> ~ <%=plBean.getEdate() %> 입니다.
<%		
	} else if(today.after(edate)){
%>
		<button type="button" 
        	onclick="window.open('./poll/pollView.jsp?num=<%=num%>',
        		'PollView','width=600, height=350')">
        	결과
        </button>
<%
	} else {
%>    
        <button>투표</button>&nbsp;&nbsp;&nbsp;&nbsp;
        <button type="button" 
        	onclick="window.open('./poll/pollView.jsp?num=<%=num%>',
        		'PollView','width=600, height=350')">
        	결과
        </button>
<%
	}
%>        
    </p>
    <input name="listnum" type="hidden" value="<%=num %>">
</form>
<%
	} else {
%>
<p>아래 설문 리스트를 클릭하면 설문폼이 나타납니다.</p>
<%
	}
%>