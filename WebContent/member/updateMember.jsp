<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="bean.MemberBean" %>    

<jsp:useBean id="mMgr" class="bean.MemberMgr" />

<%
	String id = (String)session.getAttribute("idKey");
	MemberBean bean = mMgr.getMember(id);
%>

<head>
    <link href="Style.css" rel="stylesheet" type="text/css">
    <style>
        body {
            background-color: #ffffcc;
        }

        table.regFrm {
            margin: auto;
            border: 1px solid black;
            width: 900px;
        }

        table.regFrm th,
        table.regFrm td {
            border: 1px solid black;
            padding: 5px;
        }
    </style>

    <title>회원 정보 수정</title>
</head>
<body>
    <form name="regFrm" method="post" action="./member/memberUpdateProc.jsp">
        <table class="regFrm">
            <tr><th colspan="3" style="background-color: #996600; color: white;">회원 가입</th></tr>
            <tr>
                <th>아이디</th>
                <td><%=id %></td>
            </tr>
            <tr>
                <th>패스워드</th>
                <td>
                	<input name="pwd" type="password" size="15" value="<%=bean.getPwd() %>">
                </td>
            </tr>
            <tr>
                <th>패스워드 확인</th>
                <td><input name="repwd" type="password" size="15"></td>
            </tr>
            <tr>
                <th>이름</th>
                <td><input name="name" size="15" value="<%=bean.getName() %>"></td>
            </tr>
            <tr>
                <th>성별</th>
                <td>
                    <input name="gender" type="radio" value="1" 
                    	<%=bean.getGender().equals("1") ? "checked" : "" %>>남
                    <input name="gender" type="radio" value="2"
                    	<%=bean.getGender().equals("2") ? "checked" : "" %>>여
                </td>
            </tr>
            <tr>
                <th>생년월일</th>
                <td>
                	<input name="birthday" type="date" 
                		value="<%=bean.getBirthday() %>">
                </td>
            </tr>
            <tr>
                <th>E-mail</th>
                <td>
                	<input name="email" size="30" value="<%=bean.getEmail() %>">
                </td>
            </tr>
            <tr>
                <th>우편번호</th>
                <td>
                    <input name="zipcode" size="5" readonly 
                    	value="<%=bean.getZipcode() %>">
                    <button type="button" onclick="zipCheck()">우편번호 검색</button>
                </td>
            </tr>
            <tr>
                <th>주소</th>
                <td>
                	<input name="address" type="email" size="45" 
                		value="<%=bean.getAddress() %>">
                </td>
            </tr>
            <tr>
                <th>취미</th>
                <td>
<%
	String[] list = {"인터넷", "여행", "게임", "영화", "운동"};
	String[] hobbys = bean.getHobby();
	for(int i=0; i<list.length; i++){
%>                
                    <input name="hobby" type="checkbox" value="<%=list[i] %>" 
                    	<%=hobbys[i].equals("1") ? "checked" : "" %>>
                    	<%=list[i] %>
<%
	}//for(int i=0; i<list.length; i++)
%>                    
                </td>
            </tr>
            <tr>
                <th>직업</th>
                <td>
                    <select name="job">
                        <option value="0" selected>선택하세요</option>
                        <option value="회사원">회사원</option>
                        <option value="연구전문직">연구전문직</option>
                        <option value="교수학생">교수/학생</option>
                        <option value="일반자영업">일반자영업</option>
                        <option value="공무원">공무원</option>
                        <option value="의료인">의료인</option>
                        <option value="법조인">법조인</option>
                        <option value="종교,언론,예술인">종교/언론/예술인</option>
                        <option value="농,축,수산,광업인">농/축/수산/광업인</option>
                        <option value="주부">주부</option>
                        <option value="무직">무직</option>
                        <option value="기타">기타</option>
                    </select>
                </td>
            </tr>
            <tr>
                <td colspan="2" style="text-align: center;">
                    <button type="button" onclick="pwdCheck()">수정 완료</button>&nbsp;&nbsp;&nbsp;
                    <button type="reset">다시쓰기</button>&nbsp;&nbsp;&nbsp;
                </td>
            </tr>
        </table>
        <input name="id" type="hidden" value="<%=id %>">
    </form>
</body>

<script>
	document.regFrm.job.value = "<%=bean.getJob() %>";
	
    function zipCheck(){
        var url = "./member/zipSearch.jsp?check=n";
        window.open(url, "ZipcodeSearch", "width=500,height=300,scrollbars=yes");
    }
    
    function pwdCheck(){
    	let pwd = document.regFrm.pwd;
        let repwd = document.regFrm.repwd;
        if(pwd.value == ""){
            alert("비밀번호를 입력해 주세요.");
            pwd.focus();
            return;
        }

        if(repwd.value == ""){
            alert("비밀번호 확인을 입력해 주세요.");
            repwd.focus();
            return;
        }

        if(pwd.value != repwd.value){
            alert("비밀번호가 일치하지 않습니다.");
            pwd.value = "";
            repwd.value = "";
            pwd.focus();
            return;
        }
        
        document.regFrm.submit();
    }
</script>
