<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<script src="http://code.jquery.com/jquery-latest.min.js"></script>

<!-- bootstrap js: jquery load 이후에 작성할것.-->
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js" integrity="sha384-ZMP7rVo3mIykV+2+9J3UJ46jBk0WLaUAdn689aCwoqbBJiSnjAK/l8WvCWPIPm49" crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/js/bootstrap.min.js" integrity="sha384-ChfqqxuZUCnJSK3+MXmPNIyE6ZbWh2IMqE241rYiqJxyMiZ6OW/JmZQ5stwEULTy" crossorigin="anonymous"></script>

<!-- bootstrap css -->
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.0/css/bootstrap.min.css" integrity="sha384-9gVQ4dYFwwWSjIDZnLEWnxCjeSWFphJiwGPXr1jddIhOegiu1FwO5qRGvFXOdJZ4" crossorigin="anonymous">

<!-- 사용자작성 css -->
<link rel="stylesheet" href="${pageContext.request.contextPath }/resources/css/style.css" />
<script>
$(function(){
	//모달 시각화 함수
	$("#empDetailModal").modal()
	//모달 감춰질때 발생 이벤트핸들러 바인딩
	.on("hide.bs.modal", function(){
		location.href = "${ header.referer }";
	});
});
</script>
<body>

<div class="modal fade" id="empDetailModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel">empDetailModal</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
				<form
					action="${ pageContext.request.contextPath }/ERP/infoUpdate.do"
					method="POST" id="infoFrm">
					<div class="modal-body">
						<table class="mx-auto">
							<tr>
								<th>아이디</th>
								<td>
									<div id="empId-container">
										<input type="text" class="form-control" name="empId"
											id="empId_" value="${ emp.empId }" readonly="readonly">
									</div>
								</td>
							</tr>
							<tr>
								<th>패스워드</th>
								<td><input type="text" class="form-control" name="empPwd"
									id="password_" value="${ emp.empPwd }"></td>
							</tr>
							<tr>
								<th>지점/업체 선택</th>
								<td><input type="radio" name="status" id="status" value="1"
									${ emp.status eq "1" ? "checked" : "" }>지점 <input
									type="radio" name="status" id="status" value="2"
									${ emp.status eq "2" ? "checked" : "" }>제조사</td>
							</tr>
							<tr>
								<th>지점/업체명</th>
								<td><input type="text" class="form-control" name="empName"
									id="empName" value="${ emp.empName }" required></td>
							</tr>
							<tr>
								<th>전화번호</th>
								<td><input type="tel" class="form-control"
									placeholder="(-없이)01012345678" name="empPhone" id="empPhone"
									value="${ emp.empPhone }" maxlength="11" required></td>
							</tr>
							<tr>
								<th>주소</th>
								<td><input class="form-control"
									style="width: 40%; display: inline;" placeholder="우편번호"
									name="empAddr1" id="empAddr1" type="text"
									value="${ emp.empAddr1 }" readonly="readonly">
									<button type="button" class="btn btn-default"
										onclick="execPostCode();">
										<i class="fa fa-search"></i> 우편번호 찾기
									</button> <input class="form-control" style="top: 5px;"
									placeholder="도로명 주소" name="empAddr2" id="empAddr2" type="text"
									value="${ emp.empAddr2 }" readonly="readonly" /> <input
									class="form-control" placeholder="상세주소" name="empAddr3"
									id="empAddr3" value="${ emp.empAddr3 }" type="text" /></td>
							</tr>
						</table>
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-secondary"
							data-dismiss="modal">닫기</button>
						<button type="submit" class="btn btn-primary" id="infoSubmit">정보
							수정</button>
						<button type="button" class="btn btn-danger" id="deleteBtn">지점/제조사
							삭제</button>
					</div>
				</form>
			</div>
  </div>
</div>
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
	
	$("#deleteBtn").click(function(){
		
		$("#infoFrm").attr("action", "${ pageContext.request.contextPath }/ERP/infoDelete.do");
		$("#infoFrm").attr("method", "POST");
		$("#infoFrm").submit();
	});
</script>
