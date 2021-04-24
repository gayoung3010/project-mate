----------------------
### 프로젝트명 : MATE
##### [Site 바로가기](park.jh92.kro.kr/mate)
##### [Project 상세정보](https://www.notion.so/MATE-Market-Adult-Toy-Erp-5bd15f0a8c5b44e6902a9fd7c69e27f1)
----------------------

### Sample ID 및 Password
> 일반 회원 : suzy / 1234 (쇼핑몰만 이용가능) <br>
> 관리자 : amin / 1234 (쇼핑몰 및 ERP 이용가능) <br>
> 지점 : toy1 / 1234 (ERP만 이용가능) <br>
> 제조사 : alter / 1234 (ERP만 이용가능) <br>
> > 회원가입시 포인트 부족으로 문자인증이 진행되지 않을 수 있습니다.<br>
> > f12를 누르신 후 console창을 통해 인증번호를 확인하실 수 있습니다.
--- 

### 개발 환경
**O/S :** Windows 10 <br>
**Server :** Apache Tomcat 8.5 <br>
**DB :** Oracle <br>
**Language :** Java, SQL, HTML5, CSS3, JavaScript <br>
**IDE :** Spring Tool Suite 4, SQL Developer <br>

---

### 핵심 기능
<details><summary>Index 페이지의 Best 5 상품 추천 기능</summary><div markdown="1">

> 온라인 쇼핑몰의 index 페이지에 구매가 많은 상위 5개의 상품의 사진들이 5초에 한번씩 변경되며 나타난다.

```html
	<div class="content-div">
		<div class="blur-div first-div best-div"></div>
		<div class="main-div best-div"></div>
		<div class="blur-div second-div best-div"></div>
		<div class="blur-div third-div best-div"></div>
	</div>

```
```javascript

	/* ajax를 통해 구매량이 가장 많은 상위 5개의 상품 이미지를 가져온다. */
	$(function(){
		$.ajax({
			url: "${pageContext.request.contextPath}/product/getBest.do",
			method: "get",
			dataType: "json",
			success:function(data){
				$(data).each(function(i, map){
					console.log(map);
					var html = "<div class='img-div img-none' id='bestImg-" + i + "'>";
					html += '<img class="bestImgs" data-id="'+map.productNo+'" src="${pageContext.request.contextPath}/resources/upload/mainimages/' + map.renamedFilename + '" alt="" />';
					html += "</div>";
					console.log(html);
					$(".content-div").after(html);
				});
				startPlayM(data.length);
				startPlay1(data.length);
				startPlay2(data.length);
				startPlay3(data.length);
			},
			error: function(xhr, status, err){
				console.log(xhr, status, err);
			}
		});
	});

	/* 각 div 마다 다른 상품을 보여주고, 5초마다 사진이 변경된다. */
	var startPlayM = function(i){
		var cnt = 1;
		$(".main-div").html($("#bestImg-"+ (cnt-1)).html());
		playM = setInterval(function() {
			$(".main-div").html($("#bestImg-"+cnt).html());
			if(cnt < i-1)cnt++;
			else cnt = 0;
		}, 5000);
	}
	var startPlay1 = function(i){
		var cnt = 0;
		$(".first-div").html($("#bestImg-"+ (i-1)).html());
		play1 = setInterval(function() {
			$(".first-div").html($("#bestImg-"+cnt).html());
			if(cnt < i-1)cnt++;
			else cnt = 0;
		}, 5000);
	}
	var startPlay2 = function(i){
		var cnt = 2;
		$(".second-div").html($("#bestImg-"+ (cnt-1)).html());
		play2 = setInterval(function() {
			$(".second-div").html($("#bestImg-"+cnt).html());
			if(cnt < i-1)cnt++;
			else cnt = 0;
		}, 5000);
	}
	var startPlay3 = function(i){
		var cnt = 3;
		$(".third-div").html($("#bestImg-"+ (cnt-1)).html());
		play3 = setInterval(function() {
			$(".third-div").html($("#bestImg-"+cnt).html());
			if(cnt < i-1)cnt++;
			else cnt = 0;
		}, 5000);
	}
	var stopPlay = function() {
		clearInterval(playM);
		clearInterval(play1);
		clearInterval(play2);
		clearInterval(play3);
	};

	/* div에 표시된 사진에 마우스를 hover시 사진이 변경이 멈추고, hover 종료시 다시 사진이 변경되게 된다. */
	$(function(){
		$(".best-div").hover(function(){
			console.log("stop");
			stopPlay();
		},function(){
			console.log("start");
			startPlayM(15);
			startPlay1(15);
			startPlay2(15);
			startPlay3(15);
		});

		$(".best-div").click(function(){
			var productNo = $(this).find("img").data("id");
			//console.log(productNo);
			location.href = '${pageContext.request.contextPath}/product/productDetail.do?productNo='+productNo;
		});
	});

```

</div>
</details>

<details><summary>장바구니를 통한 여러 상품 구매 기능</summary><div markdown="1">
	
> 상품 상세 페이지를 통해 상품을 장바구니에 담은 후, <br>
> 장바구니에서 구매 할 상품의 체크박스를 선택하고 구매하기 버튼 클릭 시,<br>
> 선택된 상품을 JSON과 ajax를 통해 한번에 구매가능하다.	

```javascript

	/* 선택된 상품 번호와 상품 수량을 배열로 만든다. */
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
	
	/* 생성된 상품 배열을 JSON문자열로 변환하여 ajax를 통해 서버로 전송 */
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

```
	
```java

	@ResponseBody
	@PostMapping("/purchaseProducts.do")
	public Map<String, Object> purchaseProducts(@RequestParam("jsonParam") String jsonParam) {
		
		//받아온 JSON문자열을 JSON배열로 변환
		JSONArray array = JSONArray.fromObject(jsonParam);
		
		List<Map<String, Object>> params = new ArrayList<>();
		
		//JSON배열을 map객체로 
		for(int i = 0; i < array.size(); i++) {
			JSONObject jObj = (JSONObject)array.get(i);
			Map<String, Object> map = new HashMap<>();
			map.put("addressName", jObj.get("addressName"));
			map.put("productNo", jObj.get("productNo"));
			map.put("amount", jObj.get("amount"));
			map.put("memberId", jObj.get("memberId"));
			
			params.add(map);
		}
		
		log.debug("params@controller = {}", params);
		
		int result = productService.purchaseProducts(params);
		
		Map<String, Object> map = new HashMap<>();
		map.put("result", result);
		map.put("purchaseNo", params.get(0).get("purchaseNo"));
		
		return map;
	}

```

</div>
</details>

<details><summary>구매자들의 배송지 관리 기능</summary><div markdown="1">

> 장바구니에서 상품 구매시 배송지를 선택할 때,<br>
> 배송지 선택하기 버튼을 클릭하여 모달창을 통해 배송지를 선택할 수 있다.<br>
> 기존에 배송지가 없을 시, 나타난 배송지 선택창에서 배송지 생성하기 버튼을 클릭하여<br>
> 새로 나타난 배송지 생성하기 모달창을 통해 배송지 생성 후 다시 배송지 선택을 할 수 있다.

```html
<!-- 배송지 선택하기 버튼 클릭시 나타나는 모달창 -->
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

<!-- 새로운 배송지 생성시 나타나는 모달창 -->
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
```

```javascript
//주소 선택 모달 실행시
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


					  + "<td colspan='9'>등록된 배송지가 없습니다. 새로운 배송지를 등록해주세요.</td>"


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

//주소 선택 모달 종료시
function closeAddressModal(){
	$("#address-modal").fadeOut(250);
	$("#address-tbl").html("");
}

//주소 생성 모달 실행시
function openAddressEnrollModal(){
	closeAddressModal();
	$("#addressEnroll-modal").fadeIn(250);
}

//주소 생성 모달 종료시
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

//주소 생성시 주소명 검사
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

//ajax를 통한 주소 생성
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

//ajax를 통한 주소 삭제
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
```

</div>
</details>

<details><summary>구매내역 확인 및 상품 환불 및 교환 기능</summary><div markdown="1">
> 모달창을 통하여 상품의 환불/교환 신청을 할 수 있다.
</div>
</details>

<details><summary>지점별 매출/입출고/재고/발주 관리 기능</summary><div markdown="1">
> 매출 : chart.js 사용하여 월별/일별 매출 현황을 그래프를 통해 확인할 수 있다.<br>
> 입출고, 재고, 발주 : 입출고, 재고, 발주 로그를 테이블을 통해 확인할 수 있다.<br>
> sql트리거를 이용하여, 상품의 주문/결제/반품/입고/발주 등이 버튼 한두번의 클릭으로 가능하다.
	
```sql
-- 주문 로그에 결제 컬럼 update시 입출고 로그에 출고로 insert 되고 cart에 삭제하는 트리거
create or replace trigger trg_purchase_log
    before
    update on purchase_log
    for each row
declare    
    v_member_id member.member_id%type;
begin
    if :new.purchased = 1 then
        insert into
            io_log
        values(
            seq_io_no.nextval,
            'O',
            :new.amount,
            default,
            :new.product_no,
            'admin',
            '온라인 - 구매'
        );
        
        select
            member_id
        into
            v_member_id
        from
            purchase
        where
            purchase_no = :new.purchase_no;
        
        delete from
            cart
        where 
            member_id = v_member_id
            and product_no = :new.product_no;
    end if;
end;
/

-- 환불 수락시 입출고 로그에 입고로 insert 되는 트리거
create or replace trigger trg_return
    before
    update on return
    for each row
declare    
    v_product_no product.product_no%type;
begin
    if :new.confirm = 1 and :new.status = 'R' then
    
        select 
            product_no
        into
            v_product_no
        from 
            purchase_log
        where
            purchase_log_no = :new.purchase_log_no;
            
        insert into
            io_log
        values(
            seq_io_no.nextval,
            'I',
            :new.amount,
            default,
            v_product_no,
            'admin',
            '온라인 - 환불'
        );
    end if;
    
    if :new.confirm = 1 and :new.status = 'E' then
    
        select 
            product_no
        into
            v_product_no
        from 
            purchase_log
        where
            purchase_log_no = :new.purchase_log_no;
            
        insert into
            io_log
        values(
            seq_io_no.nextval,
            'O',
            :new.amount,
            default,
            v_product_no,
            'admin',
            '온라인 - 교환'
        );
            
        insert into
            io_log
        values(
            seq_io_no.nextval,
            'I',
            :new.amount,
            default,
            v_product_no,
            'admin',
            '불량품 교환'
        );
    end if;
end;
/

-- 입고 수락(update)시 입출고 로그에 입고로 insert 되는 트리고
create or replace trigger trg_receive
    before
    update on receive
    for each row
declare
    v_emp_name emp.emp_name%type;
begin
    if :new.confirm = 1 then
        select
            emp_name
        into
            v_emp_name
        from
            emp
        where
            emp_id = :new.manufacturer_id;
        
        insert into
            io_log
        values(
            seq_io_no.nextval,
            'I',
            :new.amount,
            default,
            :new.product_no,
            :new.emp_id,
            v_emp_name || ' - 입고'
        );
    end if;
end;
/

-- 입출고 로그에 입고/출고시 재고 반영 관련 트리거
create or replace trigger trg_io_log
    before
    insert on io_log
    for each row
begin
    if :new.status = 'I' then
        update
            stock
        set
            stock = stock + :new.amount
        where
            product_no = :new.product_no and
            emp_id = :new.emp_id;
    end if;
    if :new.status = 'O' then
           update
            stock
        set
            stock = stock - :new.amount
        where
            product_no = :new.product_no and
            emp_id = :new.emp_id;
    end if;
end;
/

-- 제조사가 발주 로그 확인 후 수락(update) 시 입고테이블에 insert 관련 트리거
create or replace trigger trg_request_log
    before
    update on request_log
    for each row
begin
    if :new.confirm = 1 then
        insert into
            receive
        values(
            seq_receive_no.nextval,
            :new.manufacturer_id,
            :new.amount,
            default,
            default,
            :new.product_no,
            :new.emp_id
        );
    end if;
end;
/

-- 반품신청에서 관리자가 승인/거절 하게되면 주문로그의 상태 변경
create or replace trigger trg_return_purchase_log
    before
    update on return
    for each row
begin
    if :new.confirm = 1 then
        update purchase_log
        set status = -2
        where purchase_log_no = :new.purchase_log_no;
    end if;
    if :new.confirm = -1 then
        update purchase_log
        set status = -3
        where purchase_log_no = :new.purchase_log_no;
    end if;
end;
/

-- 상품 발주시 재고테이블 insert
create or replace trigger trg_stock
    before
    insert on request_log
    for each row
declare
    cnt number;
begin
    select 
        count(*)
    into
        cnt
    from
        stock
    where
        product_no = :new.product_no
        and emp_id = :new.emp_id;
        
    if cnt = 0 then
        insert into
            stock
        values(
            :new.product_no,
            :new.emp_id,
            0
        );
    end if;
end;
/
```
</div>
</details>

<details><summary>ERP게시판을 통한 지점간의 상품 교환 기능</summary><div markdown="1">
</div>
</details>

<details><summary>유저의 각종 문의 및 건의, 관리자의 공지사항 및 답변을 위한 고객센터</summary><div markdown="1">
</div>
</details>

<details><summary>open API를 사용한 로그인, 결제, 매장 위치확인, 상품 정보 입력, 핸드폰 인증 기능 <br>&nbsp;&nbsp;&nbsp;
  (kakao login, kakao map, daum 주소, naver login, ckeditor, coolsms, iamport 사용)</summary><div markdown="1">
	
> 
</div>
</details>
  
---

### 주요 테이블  
  
+ MEMBER ( 쇼핑몰 회원 관리 테이블 )
  + 쇼핑몰 회원 정보가 관리되는 테이블
  + MEMBER_ID COLUMN을 Primary key로 사용
  
+ EMP ( 관리자 회원 관리 테이블 )
  + ERP 시스템 사용자 정보가 관리되는 테이블
  + EMP_ID COLUMN을 Primary key로 사용
  + STATUS값으로 지점, 제조사, admin회원을 구분할 수 있다. ( 0 = admin, 1 = 지점, 2 = 제조사 )
  
+ PRODUCT ( 상품 정보 관리 테이블 )
  + 취급 상품 정보가 관리되는 테이블
  + PRODUCT_NO COLUMN을 Primary key로 사용
  + ENABLED COLUMN값으로 판매 상태를 결정하도록 한다. ( '0'일 경우 판매, '1'일 경우 판매 중지)
  
+ STOCK ( 상품 재고 관리 테이블 )
  + 각 지점 별 취급 상품의 재고를 관리하는 테이블
  + 각 지점에서 판매를 원하는 상품을 발주시 해당 테이블에 상품의 정보가 입력되며 재고 관리가 가능하게된다.
  + PRODICT_ID와 EMP_ID를 Primary key로 사용
  
+ REQUEST_LOG ( 발주 요청 관리 테이블 )
  + 지점에서 신청한 발주 요청을 관리하는 테이블
  + REQUEST_NO COLUMN을 Primary key로 사용
  + 제조사 회원이 발주 승인시 CONFIRM COLUMN 값이 '1'로 update되며 동시에 입고 로그 테이블에 해당 상품 정보가 입력되는 Trigger가 실행된다.
 
+ RECEIVE ( 입고 요청 관리 테이블 )
  + 제조사 회원이 발주 요청 승인 시, 실행되는 Trigger에 의해 입고 요청 정보가 입력되는 테이블
  + RECEIVE_NO COLUMN을 Primary key로 사용
  + 지점 회원이 입고 요청 목록을 확인 후, 승인 시 CONFIRM COLUMN 값이 '1'로 update되며 입출고 로그 테이블에 기록되는 Trigger가 실행된다.   
   입출고 로그 테이블에 입력이 감지되면 그 상태값이 'I'일 경우, 해당 상품과 지점 정보를 통해 상품 재고 테이블의 재고를 update는 Trigger가 실행되며 재고 관리가 가능하다.
  
--- 

