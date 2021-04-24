<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<fmt:requestEncoding value="utf-8"/><%-- 한글 깨짐 방지 --%>
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<link rel="stylesheet"
	href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.0/css/bootstrap.min.css"
	integrity="sha384-9gVQ4dYFwwWSjIDZnLEWnxCjeSWFphJiwGPXr1jddIhOegiu1FwO5qRGvFXOdJZ4"
	crossorigin="anonymous">
<link
	href="//netdna.bootstrapcdn.com/bootstrap/3.0.0/css/bootstrap.min.css"
	rel="stylesheet" id="bootstrap-css">
<link rel="stylesheet"
	href="${ pageContext.request.contextPath }/resources/css/loginForm.css" />
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js"
	integrity="sha384-ZMP7rVo3mIykV+2+9J3UJ46jBk0WLaUAdn689aCwoqbBJiSnjAK/l8WvCWPIPm49"
	crossorigin="anonymous"></script>
<script
	src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/js/bootstrap.min.js"
	integrity="sha384-ChfqqxuZUCnJSK3+MXmPNIyE6ZbWh2IMqE241rYiqJxyMiZ6OW/JmZQ5stwEULTy"
	crossorigin="anonymous">
</script>
<script src="https://cdn.jsdelivr.net/npm/chart.js@2.8.0"></script>
<script>
function numberWithCommas(x) {
    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}
function getColor(){
	var color = 'rgba(' + Math.floor(Math.random() * 255) + ',' + Math.floor(Math.random() * 255) + ',' + Math.floor(Math.random() * 255) + ')'; 
	return color;
}
$(function(){
	chart();
	var html = "";
	for(i=1; i<13; i++){
		html += '<option value="'+i+'">'+i+'월</option>';
	}
	$("#select-month").append(html);
});

function chart(){
	
	var labels = [];
	var datasets = [];
	
	<c:if test="${ empty month }">
		$("#ioDate").html("${year}년");
		for(i=1; i<13; i++){
			var label = i + "월";
			labels.push(label);
		}
		<c:forEach items="${empList}" var="emp">
			var dataset = {
				label: '${emp.empName}',
			}
			
			var data = [];
			for(i=1; i<13; i++){
				var sum = 0;
				<c:forEach items="${mapList}" var="map" varStatus="vs">
					if('${emp.empName}' == '${map.empName}'){
						var ioDate = '${map.ioDate}';

						if(Number(ioDate.substring(4,6)) == i){
							if(${map.status eq 'O'}){
								sum += Number(${map.price}) * ${map.amount};
							}
							else{
								sum -= (Number(${map.price}) * ${map.amount})/2;
							}
						}
					}
				</c:forEach>
				data.push(sum);
			}
			dataset.data = data;
			dataset.backgroundColor = 'rgba(0, 0, 0, 0)';
			dataset.borderColor = getColor();
			
		datasets.push(dataset);
		</c:forEach>
		
	</c:if>
	<c:if test="${! empty month}">
		var month = ${month};
		var year = ${year};
		var date = new Date(Number(year), Number(month), 0).getDate();
		
		$("#ioDate").html(year + "년 " + month + "월");
		for(i=1; i<date; i++){
			var label = i + "일";
			labels.push(label);
		}
		<c:forEach items="${empList}" var="emp">
			var dataset = {
				label: '${emp.empName}',
			}
			
			var data = [];
			for(i=1; i<date; i++){
				var sum = 0;
				<c:forEach items="${mapList}" var="map" varStatus="vs">
					if('${emp.empName}' == '${map.empName}'){
						var ioDate = '${map.ioDate}';

						if(Number(ioDate.substring(6)) == i){
							if(${map.status eq 'O'}){
								sum += Number(${map.price}) * ${map.amount};
							}
							else{
								sum -= (Number(${map.price}) * ${map.amount})/2;
							}
						}
					}
				</c:forEach>
				data.push(sum);
			}
			dataset.data = data;
			dataset.backgroundColor = 'rgba(0, 0, 0, 0)';
			dataset.borderColor = getColor();
			
		datasets.push(dataset);
		</c:forEach>
	</c:if>

	console.log(datasets);
	
	var ctx = document.getElementById('myChart').getContext('2d');
	var chart = new Chart(ctx, {
		    type: 'line',	
		    data: 
		    	{
			        labels: labels,
			        datasets: datasets
		    	},
		    options: {
	        scales: {
	            yAxes: [{
	                ticks: {
	                    callback: function(value, index, values) {
	                        return '￦' + numberWithCommas(value);
	                    }
	                }
	            }]
	        }
	    }
	});
	
}

</script>
<jsp:include page="/WEB-INF/views/common/headerE.jsp">
	<jsp:param value="MATE-ERP" name="headTitle"/>
</jsp:include>
</head>
	<body>  	
		<div class="container">
			<div class="nav">
			<h2>매출 현황 조회</h2>
			</div>	
				<form action="${ pageContext.request.contextPath }/ERP/PriceLog.do" method="GET">
					<select name="year" required>
						<option value="" selected disabled>년도 설정</option>
						<c:forEach items="${ yearList }" var="years">
							<option value="${ years }">${ years }년</option>
						</c:forEach>
					</select>
					<select name="month" id="select-month">
						<option value="" selected>월 전체</option>					
					</select>
					<input type="submit" value="검색" />
				</form>
				<p id="ioDate"></p>
				<canvas id="myChart"></canvas>
			
		</div>			
	</body>
</html>