<%@page import="java.util.ArrayList"%>
<%@page import="com.kh.mate.product.model.vo.ProductMainImages"%>
<%@page import="com.kh.mate.product.model.vo.Product"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<fmt:requestEncoding value="utf-8"/><%-- 한글 깨짐 방지 --%>

<jsp:include page="/WEB-INF/views/common/headerS.jsp">
	<jsp:param value="MATE-상품 리스트" name="headTitle"/>
</jsp:include>

<style>
@-webkit-keyframes rotation{
	from {-webkit-transform: rotate(0deg);}
	to {-webkit-transform: rotate(359deg);}
}
.product-list{
	display: inline-block;
	width: 100%;
	height: 100%;
	padding:0;
}
.card{
	padding:0;
	margin:0;
	min-width: 24%;
	max-width: 24%;
	background : #F1F1F1;
	display:inline-block;
	border: 1px solid black;
	min-height: 320px;
	max-height: 320px;
	overflow: hidden;
}
.top-section{
	height: 180px;
	overflow: hidden;
	background: #fff;
	position: relative;
}
.mainImg{
	width: 100%;
	height: 100%;
}
.imgNav{
	text-align: center;
}
.imgNav img{
	width: 80px;
	height: 50px;
	border: 1px solid #ddd;
	margin: 8px 2px;
	cursor:pointer;
	transition: 0.3s;
}
.imgNav img:hover{
	border-color: #6AB04C;
}
.product-info{
	padding-top: 10px;
	padding-bottom: 10px;
	border-top: 1px solid black;
	max-height: 80px;
	min-height: 80px;
	text-align: center;
	font-weight: bold;
}
.chk-label{
	background-color: rgba(54,54,54,0.2);
	color: white;
	margin: 0;
}
.chk-label:hover{
	background-color: rgba(54,54,54,0.6);
	color: white;
}
.chk-label:active{
	background-color: rgb(164,80,68);
	color: white;
}
.chk-label.active{
	background-color: rgb(164,80,68);
	color: white;
}
input[name=search]{
	border: none;
	background: none;
	width: 40%;
	height: 80px;
	font-size: 60px;
	border-bottom: 10px solid rgba(54,54,54,0.6);
	display: inline-block;
	padding-top: 10px;
	border-radius: 10%;
	color: rgba(54,54,54,0.8);
	font-family: 'CookieRunOTF-Bold';
}

.product-search{
	width: 100%;
}
.product-search [type=submit]{
	background-color: rgba(54,54,54,0.3);
	color: white;
	margin: 0;
	border: 1px solid white;
}
#refresh-btn{
	width: 30px;
	height: 30px;
	margin: 10px;
}
#refresh-btn:hover{
	-webkit-animation: rotation 2s infinite linear;
	cursor: pointer;
}
#pl-pageBar{
	position:relative;
	left:50%;
	right: 50%;
	transform: translateX(-50%);
	width: 100%;
	text-align: center;
}
.product-info-a:hover,
.product-info-a:active{
	text-decoration: none;
}
.product-info-title{

}
.product-info-price{

}

#soldProduct{
	background-color: gray;
}
#soldProduct img{
filter : grayscale(100%);
-webkit-filter : grayscale(100%);
}
#soldProduct a{
	color: black;
}
</style>
<script>
 function pageing(now,cnt){
	var $nowPage = $('[name = nowPage]');
	var $cntPerPage = $('[name = cntPerPage]');
	var $search = $('[name = search]');
	
	$nowPage.val(now);
	$cntPerPage.val(cnt);
	$search.submit();
}

function sReset(){
	 $(".chk-label").removeClass("active");
	 $("[type=checkbox][name=category]").prop("checked", "");
	 $("[type=text][name=search]").val("");
}
$(function(){
	$("#search-btn").click(function(){
		var $category = $(".product-search [name=category]:checked");
		var category = "";
		$.each($category,function(i, ct){
			category += $(ct).val();
			if(i != $category.length-1) category += ",";
		});
		var search = $(".product-search [name=search]").val();
		var loc = "${ pageContext.request.contextPath }/product/productList.do?";
		if(category != null && category != "" ) loc += "&category=" + category;
		if(search != null && search != "") loc += "&search=" + search;
	
		location.href = loc;
		
	});
});

</script>
<div class="search-div">
<!-- ajax처리 -->
	 <div class="product-search">
		<br />
		<div class="radio-div btn-group-toggle btn-group" data-toggle="buttons">
			<label for="pm" class='btn chk-label ${ fn:contains(category, "pl") ? "active" : "" }'>
				<input type="checkbox" name="category" id="pl" value="pl" ${ fn:contains(category, "pl") ? 'checked' : '' }/>
				프라모델
			</label>
			<label for="fg" class='btn chk-label ${ fn:contains(category, "fg") ? "active" : "" }'>
				<input type="checkbox" name="category" id="fg" value="fg" ${ fn:contains(category, "fg") ? 'checked' : '' }/>
				피규어
			</label>
			<label for="rc" class='btn chk-label  ${ fn:contains(category, "rc") ? "active" : "" }'>
				<input type="checkbox" name="category" id="rc" value="rc" ${ fn:contains(category, "rc") ? 'checked' : '' }/>
				RC카
			</label>
			<label for="dr" class='btn chk-label  ${ fn:contains(category, "dr") ? "active" : "" }'>
				<input type="checkbox" name="category" id="dr" value="dr" ${ fn:contains(category, "dr") ? 'checked' : '' }/>
				드론
			</label>
		</div>
		<img id="refresh-btn" src="${ pageContext.request.contextPath }/resources/images/refresh.png" onclick="sReset();" alt="" />
		<br />
	    <input class="mr-sm-2" type="text" placeholder="" name="search" value="${ param.search }">
	    <button class="btn btn-outline-success my-2 my-sm-0" type="button" id="search-btn">검색</button>
		<input type="hidden" name="category" value="${ category }" />
		<input type="hidden" name="nowPage" value="1" />
		<input type="hidden" name="cntPerPage" value="4" />
	</div>
</div>
	
<div class="content-div">
	<div class="product-list">
		<!-- 상품이 있을 경우 -->
		<c:if test="${ not empty list }">
			<c:forEach items="${ list }" var="product">
			<c:if test="${product.stock >= 0}">
			<div class="card" ${product.stock eq 0 ? "id='soldProduct'" : "" }>
				<div class="top-section">
				<a href="${pageContext.request.contextPath}/product/productDetail.do?productNo=${product.productNo}">
					<img src="${pageContext.request.contextPath}/resources/upload/mainimages/${product.pmiList[0].renamedFilename}"
						 alt="대표이미지" class="mainImg"
						 width="200px"/>
				</a>
				</div>
				<div class="imgNav">
					<c:forEach items="${product.pmiList }" var="Thumbs" varStatus="vs">
						<img src="${pageContext.request.contextPath}/resources/upload/mainimages/${Thumbs.renamedFilename}"
							 alt="thums${vs.count}"
							 width="50px" class="imgNav-img"/>
					</c:forEach>
				</div>
				<a class="product-info-a" href="${pageContext.request.contextPath}/product/productDetail.do?productNo=${product.productNo}">
					<div class="product-info">
						<p class="product-info-title">${ product.productName }</p>
						<p class="product-info-price"><fmt:formatNumber value="${ product.price }" pattern="###,###"/>원</p>
					</div>
				</a>
			</div>
			</c:if>
			</c:forEach>
		</c:if>
		<!-- 상품이 없을 경우 -->
		<c:if test="${ empty list }">
				<span>상품이 존재하지 않습니다.</span>
		</c:if>
	</div>
	
	<!-- 페이징 바 -->
	<nav aria-label="..." style="text-align: center;">
		<div class="pageBar">
			<ul class="pagination">
				<c:if test="${not empty pageBar }">
						<li>${ pageBar }</li>
				</c:if>
			</ul>
		</div>
	</nav>
	
</div>
<script>
$(".imgNav-img").click(function(){
	
	var src = $(this).attr("src");
	var $topSectionImg = $(this).parent().siblings().siblings(".top-section").find("img");
	$topSectionImg.attr("src", src);
});
</script>

<jsp:include page="/WEB-INF/views/common/footerS.jsp"></jsp:include>