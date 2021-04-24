<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<jsp:include page="/WEB-INF/views/common/headerE.jsp"/>
<div id="enroll-container" class="mx-auto text-center">
	<form id="empEnrollFrm" 
		  action="EmpEnroll.do" 
		  method="post">
		<table class="mx-auto">
			<tr>
				<th>아이디</th>
				<td>
					<div id="empId-container">
						<input type="text" 
							   class="form-control" 
							   placeholder="4글자이상"
							   name="empId" 
							   id="empId_"
							   required>
						<span class="guide ok">이 아이디는 사용가능합니다.</span>
						<span class="guide error">이 아이디는 사용할 수 없습니다.</span>
						<input type="hidden" id="idValid" value="0" />
					</div>
				</td>
			</tr>
			<tr>
				<th>패스워드</th>
				<td>
					<input type="password" class="form-control" name="empPwd" id="password_" required>
				</td>
			</tr>
			<tr>
				<th>패스워드확인</th>
				<td>	
					<input type="password" class="form-control" id="password2" required>
				</td>
			</tr>  
			<tr>
				<th>지점/업체 선택</th>
				<td>	
					<input type="radio" name="status" id="status" value="1" checked>지점
					<input type="radio" name="status" id="status" value="2" >제조사				
				</td>
			</tr>  	
			<tr>
				<th>지점/업체명</th>
				<td>	
					<input type="text" class="form-control" name="empName" id="empName" required>
				</td>
			</tr>
			<tr>
				<th>전화번호</th>
				<td>	
					<input type="tel" class="form-control" placeholder="(-없이)01012345678" name="empPhone" id="empPhone" maxlength="11" required>
				</td>
			</tr>
			<tr>
				<th>주소</th>
				<td>
					<input class="form-control" style="width: 40%; display: inline;" placeholder="우편번호" name="empAddr1" id="empAddr1" type="text" readonly="readonly" >
    				<button type="button" class="btn btn-default" onclick="execPostCode();"><i class="fa fa-search"></i> 우편번호 찾기</button> 	
					<input class="form-control" style="top: 5px;" placeholder="도로명 주소" name="empAddr2" id="empAddr2" type="text" readonly="readonly" />
					<input class="form-control" placeholder="상세주소" name="empAddr3" id="empAddr3" type="text"  />
				</td>
			</tr>
		</table>
		<input type="submit" value="생성" >
		<input type="reset" value="취소">
	</form>
</div>
<script>
$("#empId_").keyup(function(){
	var $this = $(this);

	if($this.val().length < 4){
		$(".guide").hide();
		$("#idValid").val(0);
		return;
	}
	
	$.ajax({
		url : "${ pageContext.request.contextPath }/ERP/checkIdDuplicate.do",
		data : {
			empId : $this.val()
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
			}
			else{
				$ok.hide();
				$error.show();
				$idValid.val(0);
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

$("#password2").blur(function(){
	var $p1 = $("#password_"), $p2 = $("#password2");
	if(p1.val() != p2.val()){
		alert("패스워드가 일치하지 않습니다.");
		$p1.focus();
	}
});
	
$("#empEnrollFrm").submit(function(){

	var $empId = $("#empId_");
	if(/^\w{4,}$/.test($empId.val()) == false) {
		alert("아이디는 최소 4자리이상이어야 합니다.");
		$empId.focus();
		return false;
	}

	var $idValid = $("#idValid");
	if($idValid.val() == 0){
		alert("사용가능한 아이디를 입력하세요.");
		$empId.select();
		return false;
	}

	return true;
});


</script>

<!-- 주소API -->
<!-- 주소검색용 스크립트 -->
<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
<script src="/resources/js/addressapi.js"></script>
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
           
           document.getElementById('empAddr1').value = data.zonecode; //5자리 새우편번호 사용
           document.getElementById('empAddr2').value = fullRoadAddr;
           /* document.getElementById('signUpUserCompanyAddressDetail').value = data.jibunAddress; */
       }
    }).open();
}
</script>

