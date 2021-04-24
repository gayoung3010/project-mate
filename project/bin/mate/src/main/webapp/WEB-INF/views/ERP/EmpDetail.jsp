<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<fmt:requestEncoding value="utf-8"/><%-- 한글 깨짐 방지 --%>
<jsp:include page="/WEB-INF/views/common/headerE.jsp"/>
</head>
<body>
<div class="container">
	<div id="buy" class="tab-pane fade active show in">
		<div class="col-md-15">
		    <div class="form-area">
			    <table id="purchaseLog-table" class="table">
			    	<tr>
			    		<th>
					    	<button type="button" 
					    			class="btn btn-default btn-lg"
					    			onclick="location.href='${ pageContext.request.contextPath }/ERP/StockLog.do';">
							  <span class="glyphicon glyphicon-cog" aria-hidden="true"></span>재고
							</button>
			    		</th>
						<th>
					    	<button type="button" 
					    			class="btn btn-default btn-lg"
					    			onclick="location.href='${ pageContext.request.contextPath }/ERP/OrderLog.do';">
							  <span class="glyphicon glyphicon-gift" aria-hidden="true"></span>발주
							</button>
						</th>
					</tr>
					<tr>
						<th>
					    	<button type="button" 
					    			class="btn btn-default btn-lg"
					    			onclick="location.href='${ pageContext.request.contextPath }/ERP/PriceLog.do';">
							  <span class="glyphicon glyphicon-list-alt" aria-hidden="true"></span>매출
							</button>
						</th>
						<th>
					    	<button type="button" 
					    			class="btn btn-default btn-lg"
					    			onclick="location.href='${ pageContext.request.contextPath }/ERP/ReceiveLog.do';">
							  <span class="glyphicon glyphicon-remove" aria-hidden="true"></span>입출고
							</button>
						</th>
			    	</tr>	
			    </table>
    		</div>
 		</div>
	</div>
</div>
<jsp:include page="/WEB-INF/views/common/footerE.jsp"/>	
</body>
</html>
