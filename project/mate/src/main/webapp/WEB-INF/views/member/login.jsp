<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%> 
<fmt:requestEncoding value="utf-8"/><%-- 한글 깨짐 방지 --%>   
<script src="http://code.jquery.com/jquery-latest.min.js"></script><!--문자 인증 때문에 필요함  -->

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
<jsp:include page="/WEB-INF/views/common/headerS.jsp">
	<jsp:param value="MATE-로그인" name="headTitle"/>
</jsp:include>
<style>
.modal {
	text-align: center;
}

.modal-dialog {
	position: relative;
	float: left;
	display: block;
	margin-left: 0 auto;
	margin-right: 0 auto;
	vertical-align: middle;
}

.modal-content {
	margin-top: 30%;
	margin-left: -50%;
}
.sns-login{
	text-align: center;
	display: inline-block;
}
.center-block{
	margin:0;
	display: inline-block;
}
.or-box{
	text-align: center;
}
.search-div{
	min-height: 30vh;
}

.login-div{
	margin:0;
	padding:0;
	position: absolute;
	right: 40vw;
	top:56vh;
	 font-family: 'CookieRunOTF-Bold';
}
.login-div>ul.nav>li{
	background: rgba(54,54,54,0.3);
}
.login-div>ul.nav>li>a{
	color: black;
 	text-shadow: -1px 0 rgb(240, 240, 240), 0 1px rgb(240, 240, 240), 1px 0 rgb(240, 240, 240), 0 -1px rgb(240, 240, 240);
}
.heading-desc{
	text-shadow: -1px 0 rgb(240, 240, 240), 0 1px rgb(240, 240, 240), 1px 0 rgb(240, 240, 240), 0 -1px rgb(240, 240, 240);
}
</style>
<script>
	$(function() {

		$('#login-form-link').click(function(e) {
			$("#login-form").delay(100).fadeIn(100);
			$("#register-form").fadeOut(100);
			$("#passwordForm").fadeOut(100);
			$('#register-form-link').removeClass('active');
			$(this).addClass('active');
			e.preventDefault();
			location.href = "http://park.jh92.kro.kr/mate/member/memberLogin.do";
		});
		$('#register-form-link').click(function(e) {
			$("#register-form").delay(100).fadeIn(100);
			$("#login-form").fadeOut(100);
			$("#passwordForm").fadeOut(100);
			$('#login-form-link').removeClass('active');
			$(this).addClass('active');
			e.preventDefault();
		});

		$('#passwordFinderA').click(function(e) {
			$("#passwordForm").delay(100).fadeIn(100);
			$("#register-form").fadeOut(100);
			$("#login-form").fadeOut(100);
			$('#login-form-link').removeClass('active');	
			$(this).addClass('active');
			e.preventDefault();
		});
		$('#password-form-link').click(function(e) {
			$("#login-form").delay(100).fadeIn(100);
			$("#passwordForm").fadeOut(100);
			$("#register-form").fadeOut(100);
			$('#login-form-link').removeClass('active');
			$(this).addClass('active');
			e.preventDefault();
		});
		
		if(${ not empty snsMember }){
			
			$("#register-form").delay(100).fadeIn(100);
			$("#login-form").fadeOut(100);
			$('#login-form-link').removeClass('active');
			$("#register-form").addClass('active');
			
		}
		
	});

	$(function() {
	
		$("#phone-send").click(function(){
			var $phone = $("#phone").val();
			console.log($phone);
			if(typeof $phone == "undefined" || $phone == ""){
				alert("핸드폰 번호를 입력하세요");
				return false;
			}
			$.ajax({
				url:"${ pageContext.request.contextPath}/member/phoneSend.do",
				data:{
					receiver: $phone
				},
				dataType:"json",
				method: "post",
				success: function(data){
						var $num = $("#MocheckNum_").html(data);
						console.log(data);						
						openModal(data);		
				},
				error: function(xhr, status, err){
						console.log(xhr);
						console.log(status);
						console.log(err);
				}
			}); 
			
		});

		
	});
	function closeReturnModal(){
		$("#myModal").fadeOut(300);
		$("#myModal").removeClass("show");
		$(".modal-backdrop").removeClass("show");
		$(".modal-backdrop").fadeOut();
	}
	
	function openModal(phoneCheck){
		console.log("호출됨?");
		$("#MocheckNum_").val(Number(phoneCheck));
		$("#myModal").fadeIn(300);
		
	}

	

	$(document).ready(function(){
		var key = getCookie("key");	
		var $memberId = $("#memberId_").val(key);
		var $remember = $("#remember_");

		if( $memberId != ""){
			$remember.prop("checked", true);
		}else{
			$remember.prop("checked", false)

		}

		$("#remember_").change(function(){

			if($remember.is(":checked")){
				setCookie("key", $("#memberId_").val(), 7);
			}else{
				deleteCookie("key");
				$remember.prop("checked", false)
			}
		});

		$($memberId).keyup(function(){
			if($remember.is(":checked")){
				setCookie("key", $("#memberId_").val(), 7);
			}else{
				deleteCookie("key");
				$remember.prop("checked", false)
			}	
		});
		if($("#phone-send").val() == '인증완료'){
			$("#myModal").fadeOut(300);
		}
	});

	function setCookie(cookieName, value, exdays){
		var exdate = new Date();
		exdate.setDate(exdate.getDate() + exdays);

		var cookieValue = escape(value) + ((exdays==null) ? "" : "; expires=" + exdate.toGMTString());
		document.cookie = cookieName + "=" +cookieValue;
		
	}

	function deleteCookie(cookieName){
	    var expireDate = new Date();
	    expireDate.setDate(expireDate.getDate() - 1);
	    document.cookie = cookieName + "= " + "; expires=" + expireDate.toGMTString();
	}
	 
	function getCookie(cookieName) {
	    cookieName = cookieName + '=';
	    var cookieData = document.cookie;
	    var start = cookieData.indexOf(cookieName);
	    var cookieValue = '';
	    if(start != -1){
	        start += cookieName.length;
	        var end = cookieData.indexOf(';', start);
	        if(end == -1)end = cookieData.length;
	        cookieValue = cookieData.substring(start, end);
	    }
	    return unescape(cookieValue);
	}
	function phoneCheck(){
		
		var num = $("#MophoneNum_").val();
		var num2 = 	$("#MocheckNum_").val();
		console.log(num);
		if(num != num2){
			alert("인증번호가 다릅니다.");

		}else {
			alert("인증 되었습니다.");
			$("#phone-send").val("인증완료").prop("disabled", "disabled");
			$("#myModal").removeClass("show");
			closeReturnModal();
		}
		
	};

	function check(){
		 var $frm = $("#register-form");
		 var $phone = $("#phone-send").val();

		 if($phone == '문자인증'){
			alert("핸드폰 인증을 해주세요");
		}else{
			$frm.submit();
		}
	}

	$(document).ready(function(){
		
		$(".guide").hide();

		$("#phoneFinder_").blur(function(){
			var $this = $(this).val();
			console.log($this);
			var $pmemberId = $("#findeMemberId_");
			console.log($pmemberId.val());
			if(typeof $this == 'undefined' || $this == ''){
				$(".guide").hide();
				$("#idValid").val(0);
				alert("입력해주세요");
				return;
			}
 
 		
			$.ajax({
				url : "${ pageContext.request.contextPath }/member/checkPasswordDuplicate.do",
				data : {
					 "pmemberId" : $pmemberId.val(),
					 "phone" : $this
				},
				method : "get",
				dataType : "json",
				success : function(data){
					console.log(data);
					var $ok = $(".guide.ok");
					var $error = $(".guide.error");
					var $idValid = $("#idValid");
					var $sendPasswordPhone = $("#sendPasswordPhone");
					var $sendPasswordMemberId = $("#sendPasswordMemberId");
				 	if(data.isAvailable){
						$ok.show();
						$error.hide();
						$idValid.val(1);
						$sendPasswordPhone.val(data.phone);
						$sendPasswordMemberId.val(data.memberId);			
					}else{
						$ok.hide();
						$error.show();
						$idValid.val(0);				
					} 
					
				},
				error : function(xhr, status, err){
						console.log(xhr);
						console.log( status);
						console.log( err);
					
				}
					

			});
		
		});
		
	});

	function passwordSend(){
		var $idValid = $("#idValid");
		var $sendPasswordPhone = $("#sendPasswordPhone");
		var $sendPasswordMemberId = $("#sendPasswordMemberId");
		if($idValid.val() == 0){
			alert("아이디 및 핸드폰 번호를 입력해주세요");
			return;
		}
		console.log($sendPasswordPhone.val());

		$.ajax({
			url : "${ pageContext.request.contextPath}/member/sendPassword",
			data:{
				receiver: $sendPasswordPhone.val(),
				memberId: $sendPasswordMemberId.val()
			},
			dataType:"json",
			method: "post",
			success: function(data){
					console.log(data);
					alert("임시비밀번호가 전송되었습니다. 임시비밀번호로 로그인 해주세요");
					location.href = '${ pageContext.request.contextPath }/member/memberLogin.do';

			},
			error: function(xhr, status, err){
					console.log(xhr);
					console.log(status);
					console.log(err);
				
			}
		});

	}	


</script>



	<div class="row">
		<div class="col-md-3 col-md-offset-4 login-div">
			<ul class="nav nav-tabs">
				<li class="active"><a href="#member" data-toggle="tab" aria-expanded="true">일반 회원</a></li>
				<li><a href="#adminTab" data-toggle="tab">관리자 회원</a></li>
			</ul>
			<div id="myTabContent" class="tab-content">
				<div class="tab-pane active in" id="member">
					<div class="form">
						<form class="form"
							action="${ pageContext.request.contextPath }/member/loginCheck.do"
							method="post" id="login-form">
							<h3 class="heading-desc">로그인</h3>
							<div class="form-group">
								<input type="text" class="form-control" name="memberId"
									id="memberId_" placeholder="아이디" required autofocus />
							</div>
							<div class="form-group">
								<input type="password" class="form-control" name="memberPWD"
									id="memberPWD_" placeholder="비밀번호" required />
							</div>
							<label class="checkbox"> <input type="checkbox"
								name="remember" id="remember_" /> 아이디저장
							</label> <a class="forgotLnk" class="btn btn-primary btn-lg" href="#"
								id="passwordFinderA" data-toggle="tab">비밀번호를 잊어 버리셨나요 ?</a>
							<button class="btn btn-lg btn-block purple-bg" type="submit">
								로그인</button>
							<div class="or-box">
								<div class="row sns-login">
									<!-- 호근 수정 로그인버튼만 누르면 바로 연동되게 할 수 있게 수정  -->
									<div class="center-block">
										<div class="col-md-12 row-block" id="naver_id_login">
											<div id="naver_id_login">
												<a class="social-login-btn social-facebook" href="${url}">
													<img width="50"
													src="${pageContext.request.contextPath}/resources/images/naverLogo.jpg"
													class="img-rounded" />
												</a>
											</div>
										</div>
									</div>
									<!-- 카카오 로그인 버튼 추가  -->
									<div class="center-block">
										<div class="col-md-12 row-block" id="kakao_id_login">
											<div id="kakao_id_login">
												<a class="social-login-btn social-kakao" href="${ kakaoUrl }"> 
													<img width="50"
													src="${pageContext.request.contextPath}/resources/images/kakaolinkbtnsmall.png"
													class="img-rounded" />
												</a>
											</div>
										</div>
									</div>
								</div>
							</div>
							<div class="or-box row-block">
								<div class="row">
									<div class="col-md-12 row-block" id="register-form-link">
										<button class="btn btn-lg btn-block purple-bg">회원가입</button>
									</div>
								</div>
							</div>

						</form>
						<!-- 회원가입 폼 추가 -->
						<form id="register-form"
							action="${pageContext.request.contextPath}/member/memberEnroll.do"
							method="post" role="form" style="display: none;">
							<h3 class="heading-desc">회원가입</h3>
							<div class="form-group">
								<input type="text" name="memberId" id="memberId_" tabindex="1"
									class="form-control" placeholder="아이디를 입력해 주세요"
									value="${ snsMember.memberId != null ? snsMember.memberId : ''}"
									${ not empty snsMember ? "readOnly" : "" }>
							</div>
							<div class="form-group">
								<input type="password" name="memberPWD" id="memberPWD_"
									tabindex="2" class="form-control" placeholder="비밀번호를 입력해주세요"
									value="${ snsMember.memberPWD != null ? snsMember.memberPWD : ''}"
									${ not empty snsMember ? "readOnly" : "" }>
							</div>
							<div class="form-group">
								<input type="password" name="memberPWDCK" id="memberPWDCK_"
									tabindex="2" class="form-control" placeholder="비밀번호를 확인해주세요"
									value="${ snsMember.memberPWD != null ? snsMember.memberPWD : ''}"
									${ not empty snsMember ? "readOnly" : "" }>
							</div>
							<div class="form-group">
								<input type="text" name="memberName" id="memberName_"
									tabindex="1" class="form-control" placeholder="이름을 입력해주세요"
									value="${ snsMember.memberName != null ? snsMember.memberName : ''}"
									${ not empty snsMember ? "readOnly" : "" }>
							</div>
							<div class="form-check form-check-inline">
								<input type="radio" class="form-check-input" name="gender"
									id="gender0" value="M"
									${ snsMember.gender eq  "M" ? "checked readonly" :"" }>
								<label class="form-check-label" for="gender0">남</label>&nbsp; <input
									type="radio" class="form-check-input" name="gender"
									id="gender1" value="F"
									${ snsMember.gender eq  "F" ? "checked readonly" :"" }>
								<label class="form-check-label" for="gender1">여</label>
							</div>
							<div class="form-group">
								<input type="tel" class="form-control"
									placeholder="(-없이)01012345678" name="phone" id="phone"
									maxlength="11" required>
								<div class="form-check form-check-inline">
									<input type="button" class="btn btn-primary"
										data-target="#myModal" data-toggle="modal" id="phone-send"
										value="문자인증" />
								</div>
							</div>
							<div class="form-group">
								<div class="row">
									<div class="col-sm-6 col-sm-offset-3">
										<button class="btn btn-lg btn-block purple-bg" type="button"
											onclick="check();">가입하기</button>
									</div>
								</div>
							</div>
							<div class="or-box row-block">
								<div class="row">
									<div class="col-md-12 row-block">
										<a href="#" id="login-form-link">이전 페이지</a>
									</div>
								</div>
							</div>
						</form>
						<!-- 비밀번호 찾기 -->
						<form id="passwordForm" method="get" role="form"
							style="display: none;">
							<h3 class="heading-desc">비밀번호 찾기</h3>
							<div class="form-group">
								<!--  <label for="empId_">아이디</label> -->
								<input type="text" placeholder="아이디를 입력하세요" name="finderEmpId"
									id="findeMemberId_" class="form-control">
							</div>
							<div class="form-group">
								<!--    <label for="empPassword_">비밀번호</label> -->
								<input type="text" placeholder="핸드폰번호를 입력하세요" name="phoneFinder"
									id="phoneFinder_" class="form-control"> <input
									type="hidden" name="sendPasswordPhone" id="sendPasswordPhone" />
								<input type="hidden" name="sendPasswordMemberId"
									id="sendPasswordMemberId" /> <span class="guide ok"
									style="color: blue;">확인 되었습니다.</span> <span class="guide error"
									style="color: red;">잘못 입력하셨습니다.</span> <input type="hidden"
									id="idValid" value="0" />
							</div>
							<div>
								<button type="button" class="btn btn-lg" id="buttonFinder"
									onclick="passwordSend();">확인</button>
							</div>
							<div class="row">
								<div class="col-md-12 row-block">
									<a href="#" id="password-form-link">이전 페이지</a>
								</div>
							</div>
						</form>

					</div>
				</div>
				<!-- 관리자용 로그인 화면 -->
				<div class="tab-pane fade in " id="adminTab">
					<div class="form">

						<form id="admin"
							action="${ pageContext.request.contextPath }/ERP/erpLogin.do"
							method="post">
							<h3 class="heading-desc">관리자 로그인</h3>
							<div class="form-group">
								<!--  <label for="empId_">아이디</label> -->
								<input type="text" placeholder="아이디를 입력하세요" name="empId"
									id="empId" class="form-control">
							</div>
							<div class="form-group">
								<!--    <label for="empPassword_">비밀번호</label> -->
								<input type="password" placeholder="비밀번호를 입력하세요" name="empPwd"
									class="form-control">
							</div>
							<div>
								<button type="submit" class="btn btn-lg btn-block purple-bg">로그인</button>
							</div>
						</form>
					</div>
				</div>

			</div>
		</div>
	</div>


<!-- 핸드폰 인증 -->
<div class="modal fade " id="myModal"
 data-backdrop="static" tabindex="-1" role="dialog" aria-labelledby="staticBackdropLabel" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-head">
				<h4 class="modal-title" id="myModalLabel">인증번호를 입력하세요</h4>
			</div>
			<div class="modal-body">
				인증번호 : <input type="text" class="form-control" name="MophoneNum"
					id="MophoneNum_"> <input type="hidden"
					class="form-control" name="MocheckNum" id="MocheckNum_">
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default" data-dismiss="modal"
					onclick="closeReturnModal();">닫기</button>
				<button type="button" class="btn btn-primary btn-delete"
					id="infoSubmit" name="infoSubmit" onclick="phoneCheck();">확인</button>
			</div>
		</div>
	</div>
</div>


<jsp:include page="/WEB-INF/views/common/footerS.jsp" />