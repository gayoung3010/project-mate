<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>   
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<jsp:include page="/WEB-INF/views/common/headerS.jsp" />
<style>
.form-area{
	padding: 10px 40px 60px;
	margin: 10px 0px 60px;
	border: 1px solid GREY;
	overflow-y: scroll;
	overflow-x: none;
	max-height: 400px;
}
#purchaseLog-table table{
	text-align: center;
}
#purchaseLog-table td, #purchaseLog-table th{
	padding: 10px;
	text-align: center;
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
	background-color : gold;
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
[name=score]{
	display: none;
}
.modal-submit{
	margin-right: 3%;
}
.modal-cancel{
}
.score-img{
	height: 20px;
	weith: 20px;
}
.score-img-a{
	display: none;
}
.score-img:hover{
	cursor: pointer;
	background-color: yellow;
}
#review-comments, #return-content{
	resize: none;
	width: 100%;
}
th{
	position: sticky;
	top:0;
	background: white;
}
.search-div>.row{
	width:100%;
}
ul.nav>li,ul.nav>li>a{
	bottom:0;
	
}
.nav-pills>li.active>a, .nav-pills>li.active>a:hover, .nav-pills>li.active>a:focus {
	background: rgb(164,80,68,0.8);
}
</style>
<script>
	

	$(function(){

		$(".score-img").click(function(){
			var value = $(this).attr("data-value");
			var $scoreImgs = $(".score-img");

			$scoreImgs.each(function(i, scoreImg){

				if($(scoreImg).attr("data-value") <= value){
					if($(scoreImg).hasClass("score-img-b")) $(scoreImg).fadeOut(0);
					if($(scoreImg).hasClass("score-img-a")) $(scoreImg).fadeIn(0);
				}
				else{
					if($(scoreImg).hasClass("score-img-b")) $(scoreImg).fadeIn(0);
					if($(scoreImg).hasClass("score-img-a")) $(scoreImg).fadeOut(0);
				}
			});
			
			$("#review-score").val(value);
			
		});
		
		$("#memberFrm .btn-delete").click(function(){
			var $memberId = $("#memberId_");
			var $frm = $("#memberFrm");
			var $memberPWD = $frm.find("[name=memberPWD]").val();
			var $memberPCK = $frm.find("[name=memberPCK]").val();
			
			var member = {
					memberId : $memberId.val(),
					memberPWD : $memberPWD
				};
			
			console.log(member);
			 var delConfirm = confirm("????????? ?????????????????????????");
			if(delConfirm){
				$.ajax({
					url: "${ pageContext.request.contextPath}/member/memberDelete.do",
					method: "POST",
					contentType : "application/json; charset=utf-8",
					data : JSON.stringify(member),
					success: window.location.href = "${ pageContext.request.contextPath }",
					error:function(err, status, xhr){
						console.log(err);
						console.log(status);
						console.log(xhr);
					}					
				});
			}else{
				alert("?????????????????????");
				return;
			}
		
		});
		
	});

	$(function(){
		$("#memberFrm").submit(function(){
			var $frm = $("#memberFrm");
			var $memberPWD = $frm.find("[name=memberPWD]");
			var $memberPCK = $frm.find("[name=memberPCK]");
			
		    if($memberPWD.val() != $memberPCK.val() ){
				alert("?????? ????????? ?????? ?????? ????????????.");
				$memberPCK.select();
				return false;
			}

			return true;
		});
		
		$(".guide").hide();

		$("#memberPWD_").keyup(function(){
			var $this = $(this);
			var $memberId = $("#memberId_");
			if($this.val().length < 2){
				$(".guide").hide();
				$("#idValid").val(0);
				return;
			}
			$.ajax({
				url : "${ pageContext.request.contextPath}/member/checkPasswordDuplicate.do",
				data : {
					memberId : $memberId.val(),
					memberPWD : $this.val()
				},
				method : "GET",
				dataType : "json",
				success : function(data){
					console.log(data);
					var $ok = $(".guide.ok");
					var $error = $(".guide.error");
					var $idValid = $("#idValid");
					if(data.isAvailable){
						$ok.show();
						$error.hide();
						$idValid.val(1);				
					}else{
						$ok.hide();
						$error.show();
						$idValid.val(0);				
					}
					
				},
				error : function(xhr, status, err){
						console.log(xhr, status, err);
				}
					

			});
		
		});
		
	});

function openReviewModal(no){
	$("#hiddenPurchaseLogNo-review").val(no);
	$("#review-modal").fadeIn(300);
}

function closeReviewModal(){
	$("#review-modal").fadeOut(300);
	$("#review-content").val("");
	$(".score-img-b").fadeIn(0);
	$(".score-img-a").fadeOut(0);
	$("#review-score").val("");
	$("#hiddenPurchaseLogNo-review").val("");
}


function closeReturnModal(){
	$("#return-modal").fadeOut(300);
	$("#return-content").val("");
	$("#hiddenPurchaseLogNo-return").val("");
	$("#amount").prop("max", "");
}



$(function(){

	$(".return-btn").click(function(){
		var no = $(this).parent().siblings(".purchaseLogNo-td").text();
		var amount = $(this).parent().siblings(".amount-td").text();
		console.log(no, amount);
		$("#hiddenPurchaseLogNo-return").val(no);
		$("#amount").prop("max", amount);
		$("#return-modal").fadeIn(300);
	});

	$(".confirm-btn").click(function(){
		if(confirm("?????? ?????? ???????????????????")==false) return;
		var $btnTd = $(this).parent();
		var plNo = Number($btnTd.siblings(".purchaseLogNo-td").text());
		
		$.ajax({
			url : "${ pageContext.request.contextPath}/product/purchaseConfirm.do",
			data : {
				purchaseLogNo : plNo
			},
			method : "POST",
			dataType : "json",
			success : function(data){
				if(data.result > 0) {
					console.log("???????????????");
					location.reload();
				}
				else alert("??????????????? ?????????????????????. ???????????? ????????????.");
			},
			error : function(xhr, status, err){
				console.log(xhr, status, err);
			}
		});	
	});
});

$(function(){
	$("#return-modal-submit").click(function(){
		console.log("return-modal-submit");
		var data = new FormData();
		data.append('file', $("#return-file")[0].files[0]);
		data.append('purchaseLogNo', Number($("#hiddenPurchaseLogNo-return").val()));
		data.append('status', $("[name=return-status]:checked").val());
		data.append('content', $("#return-content").val());
		data.append('amount', Number($("#amount").val()));

		console.log(data);
		
		$.ajax({
			url : "${pageContext.request.contextPath}/product/return.do",
			type : "POST",
			processData : false,
	        contentType : false,
			data: data,
			dataType: 'json',
			success: function(data) {
				console.log("??????");
				closeReturnModal();
				location.reload();
			},
			error: function(xhr, status, err){
				console.log(xhr,status,err);
			}
		});
		
	});
		
});


function openKakao(purchaseNo, sum){
	var popupX = (document.body.offsetWidth / 2) - (200 / 2);
	//&nbsp;?????? ????????? ?????? ????????? 1/2 ?????? ??????????????? ????????????
	var popupY= (window.screen.height / 2) - (300 / 2);
	//&nbsp;?????? ????????? ?????? ????????? 1/2 ?????? ??????????????? ????????????
	
	window.open("${pageContext.request.contextPath}/member/kakaopay.do?memberId=${loginMember.memberId}&sum="+sum+"&purchaseNo="+purchaseNo, 'kakaoPay', 'status=no, height=533, width=421, left='+ popupX + ', top='+ popupY);
}


</script>


<div class="search-div">
	<div class="row">
		<div class="col-sm-6">
		  <ul class="nav nav-pills" >
		    <li class="active" style="width:50%"><a aria-expanded="true" class="btn btn-lg btn-default nav-link active" data-toggle="tab" href="#buy" aria-selected="true">????????????</a></li> 
		    <li class="" style="width:48%"><a class="btn btn-lg btn-default nav-link " data-toggle="tab" href="#menu1" aria-selected="true">????????????</a></li>
		  </ul>
		</div>
	</div>
</div>
<div class="content-div">
	<div class="tab-content">
		<div id="menu1" class="tab-pane fade in">
			<div class="col-md-15">
			    <div class="form-area">  
					<form action="${ pageContext.request.contextPath}/member/memberUpdate.do" method="post" id="memberFrm">
						<div class="form-group">
						 	<label class="control-label " for="memberId_">?????????:</label>
							<input type="text" class="form-control" placeholder="????????? (4????????????)"name="memberId" id="memberId_" readonly value="${ loginMember.memberId }" required> 
						</div>
						<div class="form-group">
						  	<label class="control-label" for="memberPCK">????????????:</label>
							<input type="hidden" class="form-control" name="memberPCK" id="memberPCK_"  value="${ loginMember.memberPWD}" required> 
							<input type="password" class="form-control" name="memberPWD" id="memberPWD_"  value="" required> 
							<span class="guide ok" style="color:blue;">?????? ????????? ?????? ?????????.</span> 
							<span class="guide error" style="color:red;">?????? ????????? ???????????? ????????????.</span>
							<input type="hidden" id="idValid" value="0"/> 
						</div>
						<div class="form-group">
						  	<label class="control-label" for="memberName_">??????:</label>
							<input type="text" class="form-control" placeholder="??????" name="memberName" id="memberName_" value="${ loginMember.memberName}" required> 
						</div>
						<div class="form-group">
						  	<label class="control-label " for="phone_">????????????:</label>
							<input type="tel" class="form-control" placeholder="???????????? (???:01012345678)" name="phone"  id="phone_" value="${ loginMember.phone }" id="phone" maxlength="11"required> 
						</div>
						<div class="form-check form-check-inline">
						  <label class="control-label " for="gender">??????:</label>
							<input type="radio" class="form-check-input" name="gender" id="gender0" value="M" ${ loginMember.gender eq  "M" ? "checked" :"" }>
							<label  class="form-check-label" for="gender0">???</label>&nbsp;
							<input type="radio" class="form-check-input" name="gender" id="gender1" value="F" ${ loginMember.gender eq  "F" ? "checked" :"" } >
							<label  class="form-check-label" for="gender1">???</label>
						</div>
						<div class="buttons-group">
							<button type="submit" class="btn btn-success btn-update" id="memberUpdate">????????????</button>
							<button type="submit" class="btn btn-danger btn-delete" id="memberDelete">????????????</button>
							<button type="button" class="btn btn-warning" onclick="location.href='${pageContext.request.contextPath }'">??????</button>
						</div>
					</form>
				</div>
			</div>
		</div>
		<!-- ?????? ??????  -->
		<div id="buy" class="tab-pane fade active show in">
			<div class="col-md-15">
			    <div class="form-area">  
					<table id="purchaseLog-table" class="table table-hover">
						<thead class="thead-dark">
							<tr>
								<th scope="col">#</th>
								<th scope="col">????????????</th>
								<th scope="col">????????????</th>
								<th scope="col">????????????</th>
								<th scope="col">?????????</th>
								<th scope="col">??????</th>
								<th scope="col">??????</th>
								<th scope="col">??????</th>
								<th scope="col">????????????</th>
							</tr>
						</thead>
						<c:if test="${ !empty mapList }">
							<tbody>
								<c:forEach items="${ mapList }" var="purchase" varStatus="vs">
								<tr>
									<th scope="row">${ vs.count }</th>
									<td class="purchaseLogNo-td">${ purchase.purchaseLogNo }</td>
									<td><fmt:formatDate value="${ purchase.purchaseDate }" pattern="yyyy-MM-dd HH:mm"/></td>
									<td>${ purchase.productNo }</td>
									<td>${ purchase.productName }</td>
									<td class="amount-td">${ purchase.amount }</td>
									<td>
										${ purchase.status == 0 ? "<input type='button' class='return-btn' value='??????/??????' /><input type='button' class='confirm-btn' value='????????????' />" 
										 : purchase.status == 1 ? "<p>????????????</p>" 
										 : purchase.confirm == 0 ? "??????/?????? ?????????"
										 : purchase.confirm == 1 ? "<p>??????/?????? ?????? ??????</p>" 
										 : "<p>??????/?????? ??????</p>" }
									</td>
									<td>
										<c:if test="${ empty purchase.reviewNo }">
											<input class="review-btn" type='button' value='?????? ?????? ??????' onclick="openReviewModal(${ purchase.purchaseLogNo });"/>
										</c:if>
										<c:if test="${ ! empty purchase.reviewNo }">
											?????? ?????? ??????	
										</c:if>
									</td>
									<td>
										<c:if test="${ purchase.purchased == 0 }">
											<input type='button' value='????????????' onclick='openKakao(${purchase.purchaseNo}, ${purchase.pirce*purchase.amount});' />
										</c:if>
										<c:if test="${ purchase.purchased != 0 }">
											????????????
										</c:if>
									</td>
								</tr>
								</c:forEach>
							</tbody>
						</c:if>
						<c:if test="${ empty mapList }">
							<tr>
								<td colspan="9">?????? ????????? ???????????? ????????????.</td>
							</tr>
						</c:if>
					</table>
		
				</div>
			</div>
		</div>
	</div>
</div>

<!-- ??????/?????? ?????? -->
<div class="modal" id="return-modal">
	<div class="modal-section">
		<div class="modal-head">
			<a href="javascript:closeReturnModal();" class="modal-close">X</a>
			<p class="modal-title">??????/??????</p>
		</div>
		<div class="modal-body">
			<input type="radio" name="return-status" id="refund" value="R" required/>
			<label for="refund">??????</label>
			&nbsp;&nbsp;
			<input type="radio" name="return-status" id="exchange" value="E" />
			<label for="exchange">??????</label>
			<br />
			<input type="file" name="returnFile" id="return-file" />
			?????? : <input type="number" name="amount" id="amount" max="" min="1"/>
			<textarea name="comments" id="return-content" rows="5" required></textarea>
			
		</div>
		<div class="modal-footer">
			<input class="modal-cancel modal-btn" type="button" value="??????" onclick="closeReturnModal();"/>
			<input class="modal-submit modal-btn" type="button" value="??????" id="return-modal-submit"/>
			<input type="hidden" name="purchaseLogNo" id="hiddenPurchaseLogNo-return"/>
		</div>
	</div>
</div>

<!-- ?????? ?????? -->
<div class="modal" id="review-modal">
	<div class="modal-section">
		<div class="modal-head">
			<a href="javascript:closeReviewModal();" class="modal-close">X</a>
			<p class="modal-title">????????? ?????? ????????? ????????? ??????????????????.</p>
		</div>
		<form action="${ pageContext.request.contextPath }/product/insertReview.do" method="POST">
		<div class="modal-body">
			<textarea name="comments" id="review-comments" rows="5" required></textarea>
			<br /><br />
			??????
			<img class="score-img-b score-img" src="../resources/images/star1.png" id="score-img-1" alt="" data-value="1" />
			<img class="score-img-a score-img" src="../resources/images/star2.png" id="score-img-1" alt="" data-value="1" />
			<img class="score-img-b score-img" src="../resources/images/star1.png" id="score-img-2" alt="" data-value="2" />
			<img class="score-img-a score-img" src="../resources/images/star2.png" id="score-img-2" alt="" data-value="2" />
			<img class="score-img-b score-img" src="../resources/images/star1.png" id="score-img-3" alt="" data-value="3" />
			<img class="score-img-a score-img" src="../resources/images/star2.png" id="score-img-3" alt="" data-value="3" />
			<img class="score-img-b score-img" src="../resources/images/star1.png" id="score-img-4" alt="" data-value="4" />
			<img class="score-img-a score-img" src="../resources/images/star2.png" id="score-img-4" alt="" data-value="4" />
			<img class="score-img-b score-img" src="../resources/images/star1.png" id="score-img-5" alt="" data-value="5" />
			<img class="score-img-a score-img" src="../resources/images/star2.png" id="score-img-5" alt="" data-value="5" />
			<input type="number" name="score" id="review-score" required/>
		</div>
		<div class="modal-footer">
			<input class="modal-cancel modal-btn" type="button" value="??????" onclick="closeReviewModal();"/>
			<input class="modal-submit modal-btn" type="submit" value="??????" />
			<input type="hidden" name="purchaseLogNo" id="hiddenPurchaseLogNo-review"/>
		</div>
		</form>
	</div>
</div>
<jsp:include page="/WEB-INF/views/common/footerS.jsp" />