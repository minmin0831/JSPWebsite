<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="java.util.Vector" %> 
<%@ page import="bean.ZipcodeBean" %>    
    
<jsp:useBean id="mMgr" class="bean.MemberMgr" />  

<%
	request.setCharacterEncoding("utf-8");
	String check = request.getParameter("check");
	
	String area3 = null;
	if(check.equals("y")){
		area3 = request.getParameter("area3");
	}
%>  

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link href="../Style.css" rel="stylesheet" type="text/css">
    <style>
        body {
            background-color: #ffffcc;
        }

        table {
            margin: auto;
        }

        table tr td {
            text-align: center;
        }

        table tr td.top_padding{
            padding: 30px 0 0 0;
        }
    </style>

    <title>우편번호 검색</title>
</head>
<body>
    <form name="zipFrm" method="post">
        <table>
            <tr>
            	<td class="top_padding">
            		도로명 입력 : <input name="area3">
            		<button type="button" onclick="loadSearch()">검색</button>
            	</td>
            </tr>
<%
	if(check.equals("y")){
		Vector<ZipcodeBean> vlist = mMgr.zipcodeRead(area3);
		
		if(vlist.isEmpty()){
%>            
            <tr><td class="top_padding">검색된 결과가 없습니다.</td></tr>
<%
		} else {
%>            
            <tr><td class="top_padding">※ 검색 후, 아래 우편번호를 클릭하면 자동으로 입력 됩니다.</td></tr>
<%
			for(int i=0; i<vlist.size(); i++){
				ZipcodeBean bean = vlist.get(i);
				String rZipcode = bean.getZipcode();
				String rArea1 = bean.getArea1();
				String rArea2 = bean.getArea2();
				String rArea3 = bean.getArea3();
				String address = rArea1 +" "+ rArea2 +" "+ rArea3;
%>            
            <tr>
            	<td>
            		<a href="#" onclick="sendAdd('<%=rZipcode %>','<%=address %>')">
            			<%=rZipcode %> <%=address %>
            		</a>
            	</td>
            </tr>
<%
			}//for(int i=0; i<vlist.size(); i++)
		}//if(vlist.isEmpty())
	}//if(check.equals("y"))
%>            
            <tr><td class="top_padding"><a href="#" onclick="self.close()">닫기</a></td></tr>
        </table>
        <input name="check" type="hidden" value="y">
    </form>
</body>

<script>
	function loadSearch(){
		var frm = document.zipFrm;
		if(frm.area3.value == ""){
			alert("도로명을 입력하세요.");
			frm.area3.focus();
			return;
		}
		
		frm.action = "zipSearch.jsp";
		frm.submit();
	}
	
	function sendAdd(zipcode, address){
		opener.document.regFrm.zipcode.value = zipcode; //수정후 작업
		opener.document.regFrm.address.value = address;
		self.close();
	}
</script>
</html>