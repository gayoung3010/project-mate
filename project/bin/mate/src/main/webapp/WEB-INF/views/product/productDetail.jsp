<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>   
<jsp:include page="/WEB-INF/views/common/headerS.jsp"/>
<script src="${ pageContext.request.contextPath }/resources/ckeditor/ckeditor.js"></script>
<style>
.card{
	padding:0;
	margin:0;
	min-width: 25%;
	max-width: 25%;
	background : #F1F1F1;
	display:inline-block;
	border: 1px solid black;
	min-height: 130px;
	border-radius: 3%;
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
	border-radius: 3%;
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
.Rfixed-div{
	position:fixed;
	right: 0;
	bottom: 10vh;
	width: 80vw;
	display: inline-block;
	text-align: right;
	padding-right: 3vw;
	z-index: 1000;
}
.btn-group{
	margin-right: 2vw;
}
.content-div{
	text-align: center;
}
.card-toggle-btn{
	width: 30px;
	height: 30px;
}
</style>

<script>
	<c:if test="${! empty msg}">alert(msg);</c:if>
</script>

<script>
$(function(){
	$(".imgNav-img").click(function(){
		
		var src = $(this).attr("src");
		var $topSectionImg = $(this).parent().siblings(".top-section").find("img");
		$topSectionImg.attr("src", src);
	});
	$("#left-btn").hide();
	$(".card-toggle-btn").click(function(){
		$(this).hide(1000);
		$(this).siblings(".card-toggle-btn").show(1000);
		$(".card").fadeToggle(1000);
	});
});

</script>

<div class="search-div">

</div>
<div class="Rfixed-div">
	<img src="${ pageContext.request.contextPath }/resources/images/right.png" alt="" id="right-btn" class="card-toggle-btn"/>
	<img src="${ pageContext.request.contextPath }/resources/images/left.png" alt="" id="left-btn" class="card-toggle-btn"/>
	<div class="card">
		<div class="top-section">
			<img src="${pageContext.request.contextPath}/resources/upload/mainimages/${product.pmiList[0].renamedFilename}"
				 alt="???????????????" class="mainImg"
				 width="200px"/>
		</div>
		<div class="imgNav">
			<c:forEach items="${product.pmiList }" var="Thumbs" varStatus="vs">
				<img src="${pageContext.request.contextPath}/resources/upload/mainimages/${Thumbs.renamedFilename}"
					 alt="thums${vs.count}"
					 width="50px" class="imgNav-img"/>
			</c:forEach>
		</div>
		<div class="product-info">
			<form id="productDetailFrm">

				<!-- ?????? ?????? -->
				<input type="hidden" name="productNo" value="${ product.productNo }" />
				<input type="hidden" name="memberId" value="${ loginMember.memberId }" />
				<div class="product-detail">
					<div class="product-name">
						????????? : <span>${ product.productName }</span>
					</div>
					
					<div class="product-category">
						???????????? : <span>
							<c:if test="${ product.category eq 'fg' }">
				    		?????????
				    		</c:if>
				    		<c:if test="${ product.category eq 'pm' }">
				    		????????????
				    		</c:if>
				    		<c:if test="${ product.category eq 'rc' }">
				    		RC???
				    		</c:if>
				    		<c:if test="${ product.category eq 'dr' }">
				    		??????
				    		</c:if>
						</span>
					</div>
					
					<div class="product-price">
						?????? : <span><fmt:formatNumber value="${ product.price }" pattern="#,###"></fmt:formatNumber></span>???
					</div>
					
					<!-- ?????? ?????? ??????  -->
					<div class="product-amount">
						?????? : <input type="number" name="amount" min="1" value="1" required/> ???
					</div>
					<br />
					<!-- ?????? ????????? ????????? ?????? ???????????? | ???????????? ?????? ?????? -->
					<div class="btn-group">
						<button type="button" class="btn btn-warning" onclick="saveCart();">????????????</button>
						<button type="submit" class="btn btn-primary" onclick="purchaseProduct();">????????????</button>
					</div>
				
				</div>
			</form>
		</div>
	</div>
</div>
<div class="content-div">
	<!-- ????????? ????????? ?????? -->
	<div class="product-content">
	${ product.content }
	</div>
	
</div>
<script>
function saveCart(){
	var $frm = $("#productDetailFrm");
	$frm.attr("action", "${ pageContext.request.contextPath}/product/saveCart.do");
	$frm.attr("method", "POST");
	$frm.submit();
	
}

function purchaseProduct(){
	var $frm = $("#productDetailFrm");
	$frm.attr("action", "${ pageContext.request.contextPath }/product/purchaseProduct.do");
	$frm.attr("method", "POST");
	$frm.submit();
	
}
</script>

<jsp:include page="/WEB-INF/views/common/footerS.jsp"/>