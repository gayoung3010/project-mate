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

<jsp:include page="/WEB-INF/views/common/headerS.jsp"></jsp:include>

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
	min-width: 25%;
	max-width: 25%;
	background : #F1F1F1;
	display:inline-block;
	border: 1px solid black;
	min-height: 130px;
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
	padding-left: 25px;
	padding-right: 25px;
	padding-top: 10px;
	padding-bottom: 10px;
	border-top: 1px solid black;
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
</script>
<div class="search-div">
<!-- ajax처리 -->
	 <div class="product-search">
		<form class="form-inline"
				action="${pageContext.request.contextPath}/product/searchProduct.do">
			<br />
			<div class="radio-div btn-group-toggle btn-group" data-toggle="buttons">
				<label for="pm" class="btn chk-label ${ sCategory.contains('pm') ? 'active' : '' }">
					<input type="checkbox" name="category" id="pm" value="pm" ${ sCategory.contains("pm") ? 'checked' : '' }/>
					프라모델
				</label>
				<label for="fg" class="btn chk-label ${ sCategory.contains('fg') ? 'active' : '' }">
					<input type="checkbox" name="category" id="fg" value="fg" ${ sCategory.contains("fg") ? 'checked' : '' }/>
					피규어
				</label>
				<label for="rc" class="btn chk-label ${ sCategory.contains('rc') ? 'active' : '' }">
					<input type="checkbox" name="category" id="rc" value="rc" ${ sCategory.contains("rc") ? 'checked' : '' }/>
					RC카
				</label>
				<label for="dr" class="btn chk-label ${ sCategory.contains('dr') ? 'active' : '' }">
					<input type="checkbox" name="category" id="dr" value="dr" ${ sCategory.contains("dr") ? 'checked' : '' }/>
					드론
				</label>
			</div>
			<img id="refresh-btn" src="${ pageContext.request.contextPath }/resources/images/refresh.png" onclick="sReset();" alt="" />
			<br />
		    <input class="mr-sm-2" type="text" placeholder="-- 뭐 찾아? --" name="search" value="${ search }">
		    <button class="btn btn-outline-success my-2 my-sm-0" type="submit">검색</button>
			<input type="hidden" name="category" value="${ category }" />
			<input type="hidden" name="nowPage" value="1" />
			<input type="hidden" name="cntPerPage" value="4" />
		</form>
	</div>
</div>
	
<div class="content-div">
	<div class="product-list">
		<!-- 상품이 있을 경우 -->
		<c:if test="${ not empty list }">
			<c:forEach items="${ list }" var="product">
			<div class="card">
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
						<div class="productName">
							상품명 : ${product.productName}
						</div>
						<div class="price">
							가격 : ${product.price}원
						</div>
						<div class="category">
							카테고리 :
							<c:if test="${ product.category eq 'fg' }">
				    		피규어
				    		</c:if>
				    		<c:if test="${ product.category eq 'pm' }">
				    		프라모델
				    		</c:if>
				    		<c:if test="${ product.category eq 'rc' }">
				    		RC카
				    		</c:if>
				    		<c:if test="${ product.category eq 'dr' }">
				    		드론
				    		</c:if>
						</div>
						<div class="manufac">
							제조사 : ${product.manufacturerId}
						</div>
					</div>
				</a>
			</div>
			</c:forEach>
		</c:if>
		<!-- 상품이 없을 경우 -->
		<c:if test="${ empty list }">
				<span>상품이 존재하지 않습니다.</span>
		</c:if>
	</div>
	<nav aria-label="Page navigation example" id="pl-pageBar">
		<ul class="pagination justify-content-center">
			<c:if test="${ page.nowPage != 1 }">
		     	<a class="page-link" href="${pageContext.request.contextPath}/product/searchProduct.do?nowPage=${page.nowPage-1 }&cntPerPage=${page.cntPerPage}&search=${ search }&category=${ sCategory }" tabindex="-1" aria-disabled="true">Previous</a>
			</c:if>
			<c:forEach begin="${page.startPage }" end="${page.endPage}" var="p">
				<c:choose>
				<c:when test="${ p == page.nowPage }">
		    		<li class="page-item"><a class="page-link" href="#" style="color: black">${p }</a></li>
				</c:when>
				<c:when test="${ p != page.nowPage }">
		    		<li class="page-item"><a class="page-link" href="${pageContext.request.contextPath}/product/searchProduct.do?nowPage=${p }&cntPerPage=${page.cntPerPage}&search=${ search }&category=${ sCategory }">${p }</a></li>
				</c:when>
				</c:choose>
			</c:forEach>
			<c:if test="${ page.nowPage != page.endPage }">
		    	<a class="page-link" href="${pageContext.request.contextPath}/product/searchProduct.do?nowPage=${page.nowPage+1 }&cntPerPage=${page.cntPerPage}&search=${ search }&category=${ sCategory }">Next</a>
			</c:if>
		</ul>
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