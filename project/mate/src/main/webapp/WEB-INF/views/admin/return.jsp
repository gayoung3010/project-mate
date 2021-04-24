<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<fmt:requestEncoding value="utf-8"/><%-- 한글 깨짐 방지 --%>

<jsp:include page="/WEB-INF/views/common/headerS.jsp">
	<jsp:param value="MATE-반품 관리" name="headTitle"/>
</jsp:include>
<style>
.modal{
	display:none;
	position:fixed; 
	width:100%; height:100%;
	top:0; left:0; 
	background:rgba(0,0,0,0.3);
	z-index: 1001;
}

.modal-section{
	position:fixed;
	top:50%; left:50%;
	transform: translate(-50%,-50%);
	background:white;
	min-width: 170px;
	width: 50%;
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
	padding: 1%; 
	background-color : rgb(164,80,68,0.8);
	border: 1px solid #000;
	min-height: 45px;
	border-radius: 25px 25px 0px 0px;
	
}
.modal-title{
	font-family: 'UhBeeSe_hyun';
	padding: 2%;
}
.modal-body{
	padding: 3%;
}
.modal-footer{
	padding: 1%;
	text-align: right;
}
.modal-cancel{
}
.modal-inbody-div{
	display: inline-block;
}
th{
	position: sticky;
	top:0;
	background: white;
}
.content-div{
	overflow-y: scroll;
	overflow-x: none;
	height: 15px;
}
tr{
	cursor: pointer;
}
</style>

<script>
$(function(){
	$(".return-tr").click(function(){
		var returnNo = Number($(this).find(".return-no").text());

		$.ajax({
			url : "${pageContext.request.contextPath}/product/returnDetail.do",
			method : 'GET',
			data : {
				returnNo : returnNo
			},
			dataType : 'json',
			success : function(data){
				if(data.imageList != null){
					var img = "";
					$(data.imageList).each(function(i, image){
						img += '<img id="image-${i}" src="${pageContext.request.contextPath}/resources/upload/return/${image.renamedFilename}" alt="" />';
					});
					$("#modal-images-div").html(img);
				}
				else{
					$("#modal-images-div").html("등록된 사진이 없습니다.");
				}

				$("#modal-content-div").html(data.content);
				
				openReturnModal(returnNo);
			},
			error : function(xhr, status, err){
				console.log(xhr, status, err);
			}
		});
	});
});
function openReturnModal(returnNo){
	$("#hidden-return-no").val(Number(returnNo));
	$("#return-modal").fadeIn(300);
}

function closeReturnModal(){
	$("#return-modal").fadeOut(300);
	$(".modal-inbody-div").html();
	$("#hidden-return-no").val();
}
function returnSubmit(confirm){
	$("#hidden-return-confirm").val(Number(confirm));
	$("#hidden-frm").submit();
}
</script>

<div class="search-div">
</div>
<div class="content-div">

	<div id="buy" class="tab-pane fade active show in">
		<div class="col-md-15">
		    <div class="form-area">  
				<table id="purchaseLog-table" class="table">
					<thead class="thead-dark">
						<tr>
							<th scope="col">반품 번호</th>
							<th scope="col">구매자 아이디</th>
							<th scope="col">환불/교환</th>
							<th scope="col">상품 번호</th>
							<th scope="col">상품 이름</th>
							<th scope="col">수량</th>
						</tr>
					</thead>
					<c:if test="${ !empty mapList }">
						<tbody>
							<c:forEach items="${ mapList }" var="rt">
								<tr class="return-tr">
									<td class="return-no">${ rt.returnNo }</td>
									<td>${ rt.memberId }</td>
									<td>${ rt.status eq "R" ? "환불" : rt.status eq "E" ? "교환" : "" }</td>
									<td>${ rt.productNo }</td>
									<td>${ rt.productName }</td>
									<td>${ rt.amount }</td>
								</tr>
							</c:forEach>
						</tbody>
					</c:if>
					<c:if test="${ empty mapList }">
						<tr>
							<td colspan="9">반품이 존재하지 않습니다.</td>
						</tr>
					</c:if>
				</table>
			</div>
		</div>
	</div>
</div>

<div class="modal" id="return-modal">
	<div class="modal-section">
		<div class="modal-head">
			<a href="javascript:closeReturnModal();" class="modal-close">X</a>
			<p class="modal-title">반품 내용</p>
		</div>
		<div class="modal-body">
			<div class="modal-inbody-div" id="modal-img-div"></div>
			<div class="modal-inbody-div" id="modal-content-div"></div>
		</div>
		<div class="modal-footer">
			<input class="modal-cancel modal-btn" type="button" value="수락" onclick="returnSubmit(1);"/>
			<input class="modal-cancel modal-btn" type="button" value="거절" onclick="returnSubmit(-1);"/>
			<form action="${ pageContext.request.contextPath }/product/returnSubmit.do" method="POST" id="hidden-frm">
				<input type="hidden" name="returnNo" id="hidden-return-no" />
				<input type="hidden" name="confirm" id="hidden-return-confirm" />
			</form>
		</div>
	</div>
</div>
<jsp:include page="/WEB-INF/views/common/footerS.jsp"/>
