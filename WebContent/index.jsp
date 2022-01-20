<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>

<%
	request.setCharacterEncoding("utf-8");

	String strTitle = "JSP Home";
	
	String article = "main.jsp";
	if(request.getParameter("article") != null){
		article = request.getParameter("article");
	}
	System.out.println(article);
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">

<style>
	*{
		margin: 0;
		padding: 0;
	}
	
	body {
		max-width: 1280px;
		margin: auto;
	}
	
	header {
		height: 150px;
	}
	
	main{
		display : flex;
	}
	
	section {
		flex: 30%;
	}
	
	article {
		flex: 70%;
	}
</style>

<title><%=strTitle %></title>
</head>
<body>
	<header>
		<jsp:include page="head.jsp" />
	</header>
	<main>
		<section>
			<jsp:include page="./member/login.jsp" />
		</section>
		<article>
			<jsp:include page="<%=article %>" />
		</article>
	</main>
	<footer>
		<jsp:include page="copy.jsp" />
	</footer>
</body>
</html>