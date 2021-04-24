<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<fmt:requestEncoding value="utf-8" />
<%-- 한글 깨짐 방지 --%>
<jsp:include page="/WEB-INF/views/common/headerE.jsp">
	<jsp:param value="MATE-ERP" name="headTitle"/>
</jsp:include>
<style>
.chk-label{
	background-color: rgba(54,54,54,0.2);
	color: black;
	margin: 0;
	font-weight: bold;
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
.minMax{
	text-align: right;
	width: 60px;
	height: 30px;
	font-size: 20px;
}
.minMax-span{
	font-weight: bold;
	font-size: 23px;
}
.mixMax-div{
	display: inline-block;
	height: 34px;
}
.grid{
	display: grid;
	grid-template-columns: 0.2fr 0.1fr 1.5fr 1.2fr 1.0fr 0.2fr 0.9fr;
	column-gap: 3px;
}
[name=search]{
	text-align: center;
	font-size: 23px;
	width: 210px;
}
.modal{
	display:none;
	position:fixed; 
	width:100%; height:100%;
	top:0; left:0; 
	background:rgba(0,0,0,0.3);
	z-index: 1001;
}
.btn{
	height: 34px;
	
}
.modal-section{
	position:fixed;
	top:50%; left:50%;
	transform: translate(-50%,-50%);
	background:white;
	min-width: 450px;
	max-width: 450px;
	border-radius: 25px;
}

.modal-close{
	display:block;
	position:absolute;
	width:30px; height:30px;
	border-radius:50%; 
	border: 3px solid #000;
	text-align:center; 
	line-height: 30px;
	text-decoration:none;
	color:#000; font-size:20px; 
	font-weight: bold;
	right:10px; top:10px;
}

.modal-head{
	padding: 3%; 
	background-color : gold;
	border: 1px solid #000;
	min-height: 45px;
	border-radius: 25px 25px 0px 0px;
	font-weight: bold;
	font-size: 24px;
}
.modal-body{
	padding: 3%;
	text-align: center;
}
.modal-footer{
	padding: 3%;
	text-align: right;
}
.modal-submit{
	margin-right: 3%;
}
#request-amount{
	width: 50px;
	border: none;
	border-bottom: 1px solid black;
	text-align: right;
}
.modal-body>span{
	font-weight: bold;
	font-size: 16px;
}
#productNoName{
	border-bottom : 3px solid black;
	font-size : 18px;
	
}
#search{
	height: 34px;
}
.enabled-radio {
	height: 34px;
	background: white;
	color: black;
	border: 3px solid #1d2124;
	font-weight: bold;
}

.enabled-radio:hover {
	background-color: darkgray;
	color: white;
}

.enabled-radio:active {
	background-color: rgb(#23272b);
	color: white;
}

.enabled-radio.active {
	background-color: #23272b;
	color: white;
}
</style>
<script>
function openRequestModal(no, name, manuId){
	$("#hiddenProductNo-request").val(no);
	$("#productNoName").html(no + "번 : " + name + "<br />");
	$("#hiddenManuId-request").val(manuId);
	$("#request-modal").fadeIn(300);
}

function closeRequestModal(){
	$("#request-modal").fadeOut(300);
	$("#productNoName").html("");
	$("#request-amount").val(0);
	$("#hiddenProductNo-request").val("");
	$("#hiddenManuId-request").val("");
}

function formReset(){
	$(".chk-label").removeClass("active").find("input").prop("checked","");
	$(".minMax").val("");
	$("#search").val("");
	$(".enabled-radio").removeClass("active").find("input").prop("checked", "");
}

function deleteProduct(no){
	var $frm = $("#productDelFrm");

	var confirm_val = confirm("정말로 상품을 삭제하시겠습니까?");

	if(confirm_val){
		location.href="${pageContext.request.contextPath}/ERP/productDelete.do?productNo="+no
	}
	else{return false;}

}

function resaleProduct(productNo){
	$.ajax({
		url: "${pageContext.request.contextPath}/ERP/productResale.do",
		data:{
			productNo: productNo
		},
		dataType: 'json',
		method: "POST",
		success: function(data){
			window.location.reload();
		},
		error: function(xhr, status, err){
			console.log(xhr, status, err);
		}
	});
}

$(function(){
	$("#request-amount").focus(function(){
		$("#request-amount").val("");
	});
});

function productEnroll(){
	location.href="${ pageContext.request.contextPath }/ERP/productEnroll.do";		
}
$(function(){
	$("#request-modal-submit").click(function(){
	
		console.log("?");
		var amount = $("#request-amount").val();
		console.log(amount);
		if(amount == null || amount <= 0){
			alert("0개 이상 주문해주세요.");
			return false;
		}
	
		$.ajax({
			url: "${pageContext.request.contextPath}/ERP/productOrder.do",
			method: "POST",
			data: {
				productNo : $("#hiddenProductNo-request").val(),
				amount: amount,
				manufacturerId: $("#hiddenManuId-request").val(),
				empId: '${loginEmp.empId}'
			},
			dataType: "json",
			success: function(data){
				alert(data.msg);
				closeRequestModal();
				location.reload(true);
			},
			error: function(xhr, status, err){
				console.log(xhr, status, err);
			}
		});
	});
});

</script>
<div class="container">
	<form action="">
		<div class="grid">
			<input type="button" value="상품등록" class="btn btn-success" onclick="productEnroll();"/>
			<input type="button" value="초기화"  class="btn btn-warning" onclick="formReset();"/>
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
			<div class="mixMax-div">
				<span class="minMax-span">재고</span>
				<input class="minMax" type="text" name="min" id="min" pattern="[0-9]+" placeholder="이상" value="${ param.min }"/>
				~
				<input class="minMax" type="text" name="max" id="max" pattern="[0-9]+" placeholder="이하" value="${ param.max }"/>
			</div>
			<input type="text" name="search" id="search" placeholder="상품번호나 상품명" value="${ param.search }"/>
			<input type="submit" value="검색"  class="btn btn-primary"/>
			<div class="radio-div btn-group-toggle btn-group" data-toggle="buttons">
				<label id="enabled-0" for="enabled-0" class='btn enabled-radio ${ param.enabled eq 0 ? "active" : "" }'>
					<input type="radio" name="enabled" id="enabled-0" value="0" ${ param.enabled eq 0 ? "checked" : "" }/> 판매중
				</label> 
				<label id="enabled-1" for="enabled-1" class='btn enabled-radio ${ param.enabled eq 1 ? "active" : "" }'>
					<input type="radio" name="enabled" id="enabled-1" value="1" ${ param.enabled eq 1 ? "checked" : "" }/> 판매중지
				</label>
			</div>
		</div>
	</form>
	<table class="table">
		<tr>
			<th style="width: 10%;">상품번호</th>
			<th style="width: 30%;">상품명</th>
			<th style="width: 10%;">카테고리</th>
			<th style="width: 10%;">제조사</th>
			<th style="width: 10%;">등록일</th>
			<th style="width: 10%;">재고</th>
			<th style="width: 10%;">발주</th>
			<th style="width: 10%;"></th>
		</tr>
		<c:forEach items="${ list }" var="product">
			<tr>
				<td>${ product.productNo }</td>
				<td><a href="${ pageContext.request.contextPath }/ERP/productUpdate.do?productNo=${product.productNo}">${ product.productName }</a></td>
				<td>${ product.category eq "dr" ? "드론" : product.category eq "pl" ? "프라모델" : product.category eq "fg" ? "피규어" : product.category eq "rc" ? "RC카" : ""  }</td>
				<td>${ product.manufacturerName }</td>
				<td><fmt:formatDate value="${ product.regDate }" pattern="yyyy/MM/dd" /></td>
				<td>${ product.stock eq 0 ? "재고 없음" : product.stock eq -1 ? "미발주 상품" : product.stock }</td>
				<td>
					<c:if test="${ product.request eq 0 }">
						<b>처리중</b>
					</c:if>
					<c:if test="${ product.request ne 0 }">
						<input type='button' value='발주' onclick='openRequestModal(${product.productNo}, "${ product.productName }", "${ product.manufacturerId }")'/>
					</c:if>
				</td>
				<td class="enabled-${ product.enabled }">
					<c:if test="${ product.enabled eq 0 }">
						<input type='button' value='삭제' onclick='deleteProduct(${product.productNo});' />
					</c:if>
					<c:if test="${ product.enabled eq 1 }">
						<input type='button' value='재판매' onclick='resaleProduct(${product.productNo});' />
					</c:if>
				</td>
			</tr>
		</c:forEach>
	</table>

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

<!-- 발주모달 -->
<div class="modal" id="request-modal">
	<div class="modal-section">
		<div class="modal-head">
			<a href="javascript:closeRequestModal();" class="modal-close">X</a>
			<p class="modal-title">발주</p>
		</div>
		<div class="modal-body">
			<span id="productNoName"></span>
			<span>발주하실 수량을 입력해주세요.</span>
			<input type="text" id="request-amount" value="0" oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');" /><span>개</span>
		</div>
		<div class="modal-footer">
			<input class="modal-cancel modal-btn" type="button" value="취소" onclick="closeRequestModal();"/>
			<input class="modal-submit modal-btn" type="button" value="발주" id="request-modal-submit"/>
			<input type="hidden" id="hiddenProductNo-request"/>
			<input type="hidden" id="hiddenManuId-request"/>
		</div>
	</div>
</div>

<jsp:include page="/WEB-INF/views/common/footerE.jsp" />