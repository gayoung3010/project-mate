<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<link href="//maxcdn.bootstrapcdn.com/bootstrap/3.3.0/css/bootstrap.min.css" rel="stylesheet" id="bootstrap-css">
<script src="//maxcdn.bootstrapcdn.com/bootstrap/3.3.0/js/bootstrap.min.js"></script>
<!-- bootstrap css -->
<link rel="stylesheet"
	href="${ pageContext.request.contextPath }/resources/css/headerS.css" />
<script src="//code.jquery.com/jquery-1.11.1.min.js"></script>
<!-- 김찬희 카테고리 작업 스크립트 -->
<script>

function category(ct){
	console.log(ct);
	var $searchCategory = $('[name=searchCategory]');
	var $category = $('[name=category]');
	$category.val(ct);
	console.log($category.val())
	$searchCategory.submit();
	
}
</script>
<!-- 김찬희 카테고리작업 스크립트끝 -->
</head>
<body>
<header>
<div class="container-fluid">
    <!-- Second navbar for categories -->
    <nav class="navbar navbar-default">
      <div class="container">
        <!-- Brand and toggle get grouped for better mobile display -->
        <div class="navbar-header">
          <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar-collapse-1">
          <span class="sr-only"><img src="${ pageContext.request.contextPath }/resources/images/play.png"  width="50px" class="menuImg"/></span>
          </button>
          <a class="navbar-brand" href="${ pageContext.request.contextPath }">Mate</a>
        </div>
        <!-- Collect the nav links, forms, and other content for toggling -->
        <div class="collapse navbar-collapse" id="navbar-collapse-1">
          <ul class="nav navbar-nav navbar-right">
              <a class="btn btn-default btn-outline btn-circle"  data-toggle="collapse" href="#nav-collapse1" aria-expanded="false" aria-controls="nav-collapse1">
              	<img src="${ pageContext.request.contextPath }/resources/images/play.png" width="50px" class="menuImg"/> 
             </a>
          </ul>
          <ul class="collapse nav navbar-nav nav-collapse" id="nav-collapse1">
              <!-- 도균이 erp확인용  -->
               <li class="nav-item">
			        <a class="nav-link" href="${ pageContext.request.contextPath }/ERP/menu.do">ERP확인용</a>
			   </li>

            <li><a href="${ pageContext.request.contextPath }/member/myPage.do">MyPage</a></li>
            <li><a href="${pageContext.request.contextPath}/cs/cs.do">C/S</a></li>
            <li><a href="${ pageContext.request.contextPath }/company/location.do">Location</a></li>
            <li><a href="${ pageContext.request.contextPath }/product/selectCart.do?memberId=${ loginMember.memberId }">장바구니</a></li>
            <!-- 1. 추가 : 판매 상품 보기 -> toy -->
            <li class="nav-item dropdown">
		        <a class="nav-link dropdown-toggle" href="#"
		           id="products" role="button"
		           data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
		          	Toy
		        </a>
	        <div class="dropdown-menu" aria-labelledby="navbarDropdown">
	        <!-- 종완 수정 - 주소추가 -->
	          <a class="dropdown-item" href="${ pageContext.request.contextPath }/product/productList.do">전체 상품 보기</a>
	          <div class="dropdown-divider"></div>
	           <!-- 김찬희 헤더 카테고리검색 추가함 -->
	          <a class="dropdown-item" onclick="category('PM')">프라모델</a>
	          <a class="dropdown-item" onclick="category('FG')">피규어</a>
	          <a class="dropdown-item" onclick="category('RC')">RC카</a>
	         <a class="dropdown-item" onclick="category('DR')">드론</a>
	        </div>
	      </li>
	      <!-- 로그인 -->
			<!-- otherwise쓰면 오류떠서 when으로 수정 -->
			<!-- emp session 추가 -->
	   <c:choose>
			<c:when test="${ empty loginMember && empty loginEmp }">
				<li class="nav-item">
		        	<a class="nav-link" href="${ pageContext.request.contextPath}/member/memberLogin.do">로그인</a>
		      	<!-- 장바구니 불리 -->
				<li class="nav-item">
		        	<a class="nav-link" href="#"><img src="${ pageContext.request.contextPath }/resources/images/cart.png" width="80px" class="loginImg"/></a>
		      	</li>
			</c:when>
			<c:when test="${ not empty loginMember }">
				${ loginMember.memberName }님, 반갑습니다.	
				<button class="btn btn-outline-success my-2 my-sm-0"
	               type="button"
	               onclick="location.href='${ pageContext.request.contextPath}/member/logout.do'">로그아웃</button>
			</c:when>
			<c:when test="${not empty loginEmp }" >
				${ loginEmp.empName }님, 반갑습니다.	
				<button class="btn btn-outline-success my-2 my-sm-0"
		               type="button"
		               onclick="location.href='${ pageContext.request.contextPath}/ERP/logout.do'">로그아웃</button>
			</c:when>
		   </c:choose> 
          </ul>
        </div><!-- /.navbar-collapse -->
      </div><!-- /.container -->
    </nav><!-- /.navbar -->
</div><!-- /.container-fluid -->
 <!-- 김찬희 작업 -->
<form action="${ pageContext.request.contextPath }/product/productCategory.do"
		name="searchCategory">
	<input type="hidden" name="category" value=""/>
</form>
<!-- 김찬희 작업끝 -->

</header>

<section id="content-sec">

