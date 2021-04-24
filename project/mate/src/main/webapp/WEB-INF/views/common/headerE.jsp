
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<head>
<meta charset="UTF-8">
<title>${ param.headTitle }</title>
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<link rel="stylesheet"
	href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.0/css/bootstrap.min.css"
	integrity="sha384-9gVQ4dYFwwWSjIDZnLEWnxCjeSWFphJiwGPXr1jddIhOegiu1FwO5qRGvFXOdJZ4"
	crossorigin="anonymous">
<link
	href="//netdna.bootstrapcdn.com/bootstrap/3.0.0/css/bootstrap.min.css"
	rel="stylesheet" id="bootstrap-css">
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js"
	integrity="sha384-ZMP7rVo3mIykV+2+9J3UJ46jBk0WLaUAdn689aCwoqbBJiSnjAK/l8WvCWPIPm49"
	crossorigin="anonymous"></script>
<script
	src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/js/bootstrap.min.js"
	integrity="sha384-ChfqqxuZUCnJSK3+MXmPNIyE6ZbWh2IMqE241rYiqJxyMiZ6OW/JmZQ5stwEULTy"
	crossorigin="anonymous"></script>
<link rel="icon" type="image/png"  href="${ pageContext.request.contextPath }/resources/images/favicon1.ico"/>
</head>
<style>
#headerE-nav{
	display: grid;
	grid-template-columns: 0fr 0.3fr 1fr 3.5fr 1fr;
	column-gap: 3px;
}
.empInfo{
	color: white;
}
.empInfo>span{
	font-weight: bold;
	font-size: 20px;
}
.empInfo>a{
	display: inline-block;
}
</style>
<body>
<header>
	<nav id="headerE-nav" class="navbar navbar-expand-sm navbar-dark bg-dark">
		<div>
			<a class="navbar-brand"
				href="${pageContext.request.contextPath }/ERP/erpMain.do">Mate</a>
		</div>		

		<div class="collapse navbar-collapse" id="navbarsExample03">
			<ul class="navbar-nav mr-auto">
				<li class="nav-item "><a class="nav-link"
					href="javascript:window.history.back();">Back</a></li>
				<c:if test="${loginEmp.status eq 0 }">
					<li class="nav-item"><a class="nav-link "
						href="${pageContext.request.contextPath}">쇼핑몰 전환</a></li>
				</c:if>
			</ul>
		</div>
		<div></div>
		<div class="empInfo">
			<span>${loginEmp.empName }</span>님 반갑습니다.
			<a class="nav-link "
				href="${pageContext.request.contextPath }/ERP/logout.do">logout</a>
		</div>
	</nav>
</header>
