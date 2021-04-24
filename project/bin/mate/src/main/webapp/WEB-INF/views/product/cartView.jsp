<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<fmt:requestEncoding value="utf-8"/><%-- 한글 깨짐 방지 --%>    
<jsp:include page="/WEB-INF/views/common/headerS.jsp"></jsp:include>
<link rel="stylesheet"
	href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.0/css/bootstrap.min.css"
	integrity="sha384-9gVQ4dYFwwWSjIDZnLEWnxCjeSWFphJiwGPXr1jddIhOegiu1FwO5qRGvFXOdJZ4"
	crossorigin="anonymous">
<link
	href="//netdna.bootstrapcdn.com/bootstrap/3.0.0/css/bootstrap.min.css"
	rel="stylesheet" id="bootstrap-css">
<script
	src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/js/bootstrap.min.js"
	integrity="sha384-ChfqqxuZUCnJSK3+MXmPNIyE6ZbWh2IMqE241rYiqJxyMiZ6OW/JmZQ5stwEULTy"
	crossorigin="anonymous"></script>
<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.24.0/moment.min.js"></script>

<style>
.border{
	border: 1px solid black;
}
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
	width: 65%;
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
	background-color : rgb(164,80,68,0.6);
	border: 1px solid #000;
	min-height: 45px;
	border-radius: 25px 25px 0px 0px;
	
}
.modal-body{
	padding: 3%;
}
.modal-footer{
	padding: 1%;
	text-align: right;
}
.modal-submit{
	margin-right: 3%;
}
.modal-cancel{
}
.modal-title{
	font-family: 'UhBeeSe_hyun';
	padding-left: 5%;
}
#address-tbl{
	width: 100%;
}
#address-tbl, #address-tbl td, #address-tbl th{
	border: 1px solid black;
}
.guide{
	display: none;
}
.ok{
	color: green;
}
.error{
	color: red;
}
.center{
	text-align: center;
}
.container{
	height: 500px;
}
th{
	position:sticky; top:0;
}
#selectAddress-div{
	font-family: 'UhBeeSe_hyun';
	font-size:15px;
}
.delete-btn{
	background-color: red;
	width: 100%;
	height: 100%;
	color: white;
}
</style>
<!-- 주소API -->
<!-- 주소검색용 스크립트 -->
<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
<script>
function execPostCode() {
    new daum.Postcode({
        oncomplete: function(data) {
           // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

           // 도로명 주소의 노출 규칙에 따라 주소를 조합한다.
           // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
           var fullRoadAddr = data.roadAddress; // 도로명 주소 변수
           var extraRoadAddr = ''; // 도로명 조합형 주소 변수

           // 법정동명이 있을 경우 추가한다. (법정리는 제외)
           // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
           if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
               extraRoadAddr += data.bname;
           }
           // 건물명이 있고, 공동주택일 경우 추가한다.
           if(data.buildingName !== '' && data.apartment === 'Y'){
              extraRoadAddr += (extraRoadAddr !== '' ? ', ' + data.buildingName : data.buildingName);
           }
           // 도로명, 지번 조합형 주소가 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
           if(extraRoadAddr !== ''){
               extraRoadAddr = ' (' + extraRoadAddr + ')';
           }
           // 도로명, 지번 주소의 유무에 따라 해당 조합형 주소를 추가한다.
           if(fullRoadAddr !== ''){
               fullRoadAddr += extraRoadAddr;
           }

           // 우편번호와 주소 정보를 해당 필드에 넣는다.
           console.log(data.zonecode);
           console.log(fullRoadAddr);
           
           
          // $("[name=addr1]").val(data.zonecode);
          // $("[name=addr2]").val(fullRoadAddr);
           
           document.getElementById('addr1').value = data.zonecode; //5자리 새우편번호 사용
           document.getElementById('addr2').value = fullRoadAddr;
           /* document.getElementById('signUpUserCompanyAddressDetail').value = data.jibunAddress; */
       }
    }).open();
}





</script>

<div class="search-div"></div>
<div class="content-div">

	<div class="container" style="overflow-y:scroll; overflow-x:hidden;">
	<table class="table table-hover">
	  <thead>
	    <tr>
	      <th scope="col">#</th>
	      <th scope="col">상품 이미지</th>
	      <th scope="col">상품명</th>
	      <th scope="col">카테고리</th>
	      <th scope="col">가격</th>
	      <th scope="col">수량</th>
	      <th scope="col">총 가격</th>
	      <th scope="col">삭제</th>
	    </tr>
	  </thead>
	  <tbody>
	    <c:if test="${ not empty cart }">
	    <c:forEach items="${cart}" var="c" varStatus="vs">
	    	<tr>
	    		<th scope="row">
	    			<input type="checkbox" class="cart-chk"/>
	    			<input type="hidden" class="hidden-price" value="${c.amount * c.selectedProduct.price}" />
	    			<input type="hidden" class="hidden-no" value="${c.productNo}" />
	    			<input type="hidden" class="hidden-amount" value="${c.amount}" />
	    			${vs.count }
	    		</th>
	    		<td>
	    			<img src="${ pageContext.request.contextPath }/resources/upload/mainimages/${ c.selectedProduct.pmiList.get(0).renamedFilename }" 
	    				 alt="상품이미지" width="50px"/>
	    		</td>
	    		<td>${ c.selectedProduct.productName }</td>
	    		<td>
		    		<c:if test="${ c.selectedProduct.category eq 'fg' }">
		    		피규어
		    		</c:if>
		    		<c:if test="${ c.selectedProduct.category eq 'pm' }">
		    		프라모델
		    		</c:if>
		    		<c:if test="${ c.selectedProduct.category eq 'rc' }">
		    		RC카
		    		</c:if>
		    		<c:if test="${ c.selectedProduct.category eq 'dr' }">
		    		드론
		    		</c:if>
	    		</td>
	    		<td>
	    			<fmt:formatNumber value="${ c.selectedProduct.price }" pattern="#,###"/>원
	    		</td>
	    		<td>${ c.amount }</td>
	    		<td>
	    			<fmt:formatNumber value="${c.amount * c.selectedProduct.price}" pattern="#,###" />원
	    		</td>
	    		
	    		<td>
	    			<div class="btn btn-group">
	    				<button type="button" class="btn btn-danger" onclick="deletFromCart(${c.productNo});">삭제</button>
	    			</div>
	    		</td>
	    	</tr>
	    </c:forEach>
	    </c:if>
	  </tbody>
	</table>
	
	<div class="center">
		<div class="row">
			<div class="col-3 border"><b>선택 상품 합계금액 : ￦</b><b id="cart-sum">0</b></div>
			<div class="col-2"><button type="button" class="btn btn-primary" onclick="openAddressModal();">배송지 선택하기</button></div>
			<div class="col-7" id="selectAddress-div"></div>
		</div>
	</div>
	<div class="center"><button class="btn btn-warning" type="button" id="purchase-btn" >결제하기</button></div>
	<div id="selectProduct-div-hidden"></div>
	<div id="selectAddress-div-hidden"></div>
	</div>
</div>
<script>
$("#purchase-btn").click(function(){
	var $productNos = $(".hidden-productNo");
	var $productAmounts = $(".hidden-productAmount");

	var param=[];
	$productNos.each(function(i, productNo){
		var dataId = $(productNo).data("id");
		var amount = null;
		$productAmounts.each(function(i, ProductAmount){
			if(dataId == $(ProductAmount).data("id")) amount = $(ProductAmount).val();
		});
		var data = {
			addressName : $("#hidden-addr").val(),
			productNo : $(productNo).val(),
			amount : amount,
			memberId : '${loginMember.memberId}'
		};
		param.push(data);
	});

	var jsonParam = JSON.stringify(param);
	
	$.ajax({
		url : "${pageContext.request.contextPath}/product/purchaseProducts.do",
		type : "POST",
		data : {jsonParam : jsonParam},
		dataType : "json",
		success : function(data){
			if(data.result > 0){
				//카카오페이
				openKakao(data.purchaseNo);
				location.href = '${pageContext.request.contextPath}/member/myPage.do';
			}
			else{
				alert("상품구매에 오류가 발생하였습니다. 다시 진행해주세요.");
				history.go(0);
			}
		},
		error : function(xhr, status, err){
			console.log(xhr, status, err);
		}
	});
});

function openKakao(purchaseNo){
	var popupX = (document.body.offsetWidth / 2) - (200 / 2);
	//&nbsp;만들 팝업창 좌우 크기의 1/2 만큼 보정값으로 빼주었음
	var popupY= (window.screen.height / 2) - (300 / 2);
	//&nbsp;만들 팝업창 상하 크기의 1/2 만큼 보정값으로 빼주었음
	
	var sum = $("#cart-sum").text();
	sum = removeCommas(sum);
	
	window.open("${pageContext.request.contextPath}/member/kakaopay.do?memberId=${loginMember.memberId}&sum="+sum+"&purchaseNo="+purchaseNo, 'kakaoPay', 'status=no, height=533, width=421, left='+ popupX + ', top='+ popupY);
}
</script>


<!-- 배송지 modal -->
<div class="modal" id="address-modal">
	<div class="modal-section">
		<div class="modal-head">
			<a href="javascript:closeAddressModal();" class="modal-close">X</a>
			<p class="modal-title">배송지를 선택 해주세요.</p>
		</div>
		<div class="modal-body">
			<table id="address-tbl">
				
			</table>
			<input type="button" value="배송지 생성하기" onclick="openAddressEnrollModal();"/>
		</div>
		<div class="modal-footer">
			<input class="modal-cancel modal-btn" type="button" value="취소" onclick="closeAddressModal();"/>
			<input class="modal-submit modal-btn" type="submit" value="선택" onclick="selectAddress();"/>
		</div>

	</div>
</div>

<!-- AddressEnrollModal -->
<div class="modal" id="addressEnroll-modal">
	<div class="modal-section">
		<div class="modal-head">
			<a href="javascript:closeAddressEnrollModal();" class="modal-close">X</a>
			<p class="modal-title">새로운 배송지 정보를 입력해주세요.</p>
		</div>
		<div class="modal-body">
		
		<div id="container-addr">
			<div class="form-row">
			    <div class="form-group col-md-6">
			      <label for="inputEmail4">배송지 명</label>
			      <input type="text" class="form-control addressEnrollInput" id="addressName" name="addressName" required>
			      <span class="guide ok">이 배송지명은 사용가능합니다.</span>
				  <span class="guide error">이 배송지명은 사용할 수 없습니다.</span>
				  <input type="hidden" id="nameValid" value="0" />
			    </div>
			    <div class="form-group col-md-6">
			      <label for="inputPassword4">회원 ID</label>
			      <input type="text" class="form-control addressEnrollInput" id="memberId" value="${ loginMember.memberId }" readonly>
			    </div>
		    </div>
			<div class="form-row">
			    <div class="form-group col-md-6">
			      <label for="inputEmail4">수취인 성명</label>
			      <input type="text" class="form-control addressEnrollInput" id="receiverName" required >
			    </div>
			    <div class="form-group col-md-6">
			      <label for="inputPassword4">수취인 연락처</label>
			      <input type="text" class="form-control addressEnrollInput" id="receiverPhone" oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');" required >
			    </div>
		    </div>
		    
		    <div class="form-group">
				<button type="button" class="btn btn-default" onclick="execPostCode();"><i class="fa fa-search"></i> 우편번호 찾기</button> 	
		    	<input class="form-control addressEnrollInput" style="width: 40%; display: inline;" 
		    	 	   name="addr1" 
		    	 	   id="addr1" type="text" readonly required>
			</div>
			<div class="form-group">
			    <label for="addr2">도로명 주소</label>
				<input class="form-control addressEnrollInput" style="top: 5px;" 
					   name="addr2" id="addr2" type="text" readonly required/>
		    </div>
			<div class="form-group">
			    <label for="addr3">상세 주소</label>
				<input class="form-control addressEnrollInput" 
					   placeholder="상세주소를 입력해주세요." 
					   name="addr3" id="addr3" type="text" required/>
		    </div>
		</div>
	
		</div>
		<div class="modal-footer">
			<input class="modal-cancel modal-btn" type="button" value="취소" onclick="closeAddressEnrollModal();"/>
			<input class="modal-submit modal-btn" type="submit" value="등록" onclick="addressEnroll();"/>
		</div>

	</div>
</div>

<script>
function selectAddress(){
	var flag = 0;
	$("[name=address-radio]").each(function(i, addr){
		if($(addr).prop("checked")) flag++;
	});
	if(flag <= 0) {
		alert("배송지를 선택해주세요.");
		return;
	}
	var addrName = $("[name=address-radio]:checked").parent().siblings(".addrName").text();
	var receiverName = $("[name=address-radio]:checked").parent().siblings(".receiverName").text();
	var receiverPhone = $("[name=address-radio]:checked").parent().siblings(".receiverPhone").text();
	var addr2 = $("[name=address-radio]:checked").parent().siblings(".addr2").text();
	var addr3 = $("[name=address-radio]:checked").parent().siblings(".addr3").text();

	var text = addrName + " | " + receiverName + " : " + receiverPhone + " | " + addr2 + " " + addr3;
	var html = "<input type='hidden' value='" + addrName + "' id='hidden-addr'/>";
	$("#selectAddress-div").text(text);
	$("#selectAddress-div-hidden").html(html);
	closeAddressModal();
}

function openAddressModal(){
	
	var memberId = "${loginMember.memberId}";
	var html = "<tr><th>#</th><th>배송지명</th><th>수취인명</th><th>수취인 전화번호</th><th>우편번호</th><th>배송지 주소</th><th>배송지 상세주소</th><th>배송지 생성일</th><th>삭제</th></tr>";
	$.ajax({
		url : "${ pageContext.request.contextPath}/member/selectMemberAddress.do",
		data : {
			memberId : memberId
		},
		method : "GET",
		dataType : "json",
		success : function(data){
			console.log(data);
			
			if(data.length != 0){
				$(data).each(function(i, addr){
					var stillUtc = moment.utc(addr.regDate).toDate();
					html += "<tr>"
						  + "<td><input type='radio' name='address-radio'/>"
						  + "<td class='addrName'>" + addr.addressName + "</td>"
						  + "<td class='receiverName'>" + addr.receiverName + "</td>"
						  + "<td class='receiverPhone'>" + addr.receiverPhone + "</td>"
						  + "<td>" + addr.addr1 + "</td>"
						  + "<td class='addr2'>" + addr.addr2 + "</td>"
						  + "<td class='addr3'>" + addr.addr3 + "</td>"
						  + "<td>" + moment(stillUtc).local().format('YYYY-MM-DD') + "</td>"
						  + "<td><input class='delete-btn' type='button' value='X' onclick='deleteAddress(\"" + addr.addressName + "\");' /></td>"
						  + "</tr>";
				});
			}
			else{
				html += "<tr>"
<<<<<<< HEAD
					  + "<td colspan='8'>등록된 배송지가 없습니다. 새로운 배송지를 등록해주세요.</td>"
=======

					  + "<td colspan='9'>등록된 배송지가 없습니다. 새로운 배송지를 등록해주세요.</td>"

>>>>>>> branch 'master' of https://github.com/j81512/mate.git
					  + "</tr>";
				
			}
			
			$("#address-tbl").append(html);
		},
		error : function(xhr, status, err){
			console.log(xhr,status,err);
		}
	});
	
	$("#address-modal").fadeIn(250);
}

function closeAddressModal(){
	$("#address-modal").fadeOut(250);
	$("#address-tbl").html("");
}
function openAddressEnrollModal(){
	closeAddressModal();
	$("#addressEnroll-modal").fadeIn(250);
}
function closeAddressEnrollModal(){
	$("#addressEnroll-modal").fadeOut(250);
	openAddressModal();
	$("#addressName").val("");
	$("#receiverName").val("");
	$("#receiverPhone").val("");
	$("#addr1").val("");
	$("#addr2").val("");
	$("#addr3").val("");
	$("#nameValid").val(0);
	$(".guide").hide();
}

$("#addressName").keyup(function(){
	var $this = $(this);

	if($this.val().length < 1){
		$(".guide").hide();
		$("#nameValid").val(0);
		return;
	}
	
	$.ajax({
		url : "${ pageContext.request.contextPath }/member/checkAddressName.do",
		data : {
			memberId : "${loginMember.memberId}",
			addressName : $this.val()
		},
		method : "GET",
		dataType : "json",
		success : function(data){
			console.log(data);
			var $ok = $(".guide.ok");
			var $error = $(".guide.error");
			var $nameValid = $("#nameValid");
	
			if(data.isAvailable){
				$ok.show();
				$error.hide();
				$nameValid.val(1);
			}
			else{
				$ok.hide();
				$error.show();
				$nameValid.val(0);
			}
			
		},
		error : function(xhr, status, err){
			console.log("처리실패!");
			console.log(xhr);
			console.log(status);
			console.log(err);
		}
	});

});


function addressEnroll(){
	var flag = 0;
	$(".addressEnrollInput").each(function(i, input){
		if($(input).val() == null || $(input).val() == "") {
			alert("모든 항목을 입력해주세요.");
			flag++;
		}
	});
	if(flag > 0) return false;
	if(/^[0-9]{11,11}$/.test($("#receiverPhone").val()) == false){
		alert("전화번호는 숫자 11자를 입력해야합니다.");
		return false;
	}
	if($("#nameValid").val() == 0) flag++;
	
	if(flag > 0) return;

	var data = {
		memberId : $("#memberId").val(),
		addressName : $("#addressName").val(),
		receiverName : $("#receiverName").val(),
		receiverPhone : $("#receiverPhone").val(),
		addr1 : $("#addr1").val(),
		addr2 : $("#addr2").val(),
		addr3 : $("#addr3").val(),
	};
	$.ajax({
		url : "${ pageContext.request.contextPath}/member/addressEnroll.do",
		data : data,
		method : "POST",
		dataType : "json",
		success : function(data){
			if(data){
				alert("배송지 등록이 완료되었습니다.");
				closeAddressEnrollModal();
			}
			else{
				alert("배송지 등록이 실패하였습니다. 다시 등록해주세요.");
			}
		},
		error : function(xhr, status, err){
			console.log(xhr, status, err);
		}
	});
}

function deletFromCart(no) {

	location.href = "${ pageContext.request.contextPath }/product/deleteFromCart.do?productNo="+no;
	
}
$(".cart-chk").change(function(){
	var $cartChks = $(".cart-chk:checked");
	var sum = 0;
	var html = "";

	$cartChks.each(function(i, cartChk){
		sum += Number($(cartChk).siblings(".hidden-price").val());
		html += "<input type='hidden' value='" + $(cartChk).siblings(".hidden-no").val() + "' data-id='" + i + "' class='hidden-productNo'/>";
		html += "<input type='hidden' value='" + $(cartChk).siblings(".hidden-amount").val() + "' data-id='" + i + "' class='hidden-productAmount'/>";
	});
	
	$("#cart-sum").html(numberWithCommas(sum));
	$("#selectProduct-div-hidden").html(html);
});

function numberWithCommas(x) {
    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}
function removeCommas(str){
	return parseInt(str.replace(/,/g,""));
}

function deleteAddress(addressName){
	$.ajax({
		url: '${pageContext.request.contextPath}/member/deleteAddress.do',
		method: 'POST',
		data: {
			memberId: '${loginMember.memberId}',
			addressName: addressName
		},
		dataType: 'json',
		success: function(data){
			alert(data.msg);
			closeAddressModal();
			openAddressModal();
		},
		error: function(xhr, status, err){
			console.log(xhr, status, err);
		}
	});
}
</script>
<jsp:include page="/WEB-INF/views/common/footerS.jsp"></jsp:include>