<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<style type="text/css">
.container {
	gap: 15px;
}

.list-section {
}

.deletebtn{
	position: absolute;
	right: 0;
}

.cart-head {
	width: 100%;
	height: 50px;
	margin-right: 15px;
	position: relative;
	border-bottom: 1px solid #ddd;
}

.cart-content {
	overflow-y:scroll; height:600px;
}

.cart-card {
	padding: 16px 0;
}

.cart-img img {
	width: 120px;
	height: 80px;
}

.cart-course-title {
	margin-left: 15px;
	padding: 4px 16px 16px;
}

.cart-course-title p {
	font-weight: 800;
	font-size: 16px;
	margin: 0;
}

.cart-course-title span:first-of-type {
	font-size: 14px;
	color: #555;
}

.cart-course-title span:last-of-type {
	font-size: 14px;
	font-weight: 600;	
	color: #0d6efd;
}

.closeBtnSection {
	padding: 4px 16px 16px;
	border-right: 1px solid #ddd;
	
}

.priceSection {
	width: 150px;
}

.priceSection {
	text-align: right;
}

.dcPercent {
	color: #F00;
	font-weight: 700;
	font-size: 14px;
}

.originalPrice {
	color: #ddd;
	text-decoration: line-through;
	font-size: 14px;
}

.finalPrice {
	font-weight: 900;
	font-size: 16px;
}

.pay-section:not(.term) {
	width: 300px;
	font-size: 14px;
	font-weight: 700;
}

.buyer{
	width: 100%;
	padding: 16px 16px;
	border-bottom: 1px solid #ddd;
	border-radius: 5px;
}

.buyer-info-title {
	position: relative;
	border-bottom: 1px solid #ddd;
	padding-bottom: 8px;
	margin-bottom: 12px;
}

.info-edit-btn {
	position: absolute;
	right: 0;
	border: none;
	text-decoration: underline;
	background: none;
}

.info-table td:first-child {
	color: #bbb;
	padding-right: 5px;
}

.info-table td:lsat-child {
	color: #777;
	padding-right: 5px;
	background: red;
}

.payment {
	border: 1px solid #ddd;
	border-radius: 5px;
	padding: 16px 16px;
	margin-top: 5px;
} 

.coupon , .point {
	display: flex;
	flex-wrap: wrap;
	justify-content: space-between;

}

.right span:nth-of-type(2) {
	color: #0d6efd;
}	

.iptBtn {
	width:100%;
	margin: 5px 0;
	display: flex;
	justify-content: space-between;
	gap: 5px;
	
}
	
.iptBtn input {
	height: 40px;
	padding: 0 12px;
	
}

.iptBtn button {
	height: 40px;
	border: 1px solid #ddd;
	padding: 0 12px;
	background: #fff;
	font-weight: 700;
	border-radius: 5px;
	width: 82px;
}

.confirmbtn {
	width: 100%;
	margin-top: 15px;
}

.amount-table {
	width: 100%;
	margin-top: 15px;
}
.amount-table td:last-child {
	text-align: right;
	padding: 2px 0;

}
</style>

<script type="text/javascript">
function ajaxFun(url, method, query, dataType, fn) {
	$.ajax({
		type:method,
		url:url,
		data:query,
		dataType:dataType,
		success:function(data) {
			fn(data);
		},
		beforeSend:function(jqXHR) {
			jqXHR.setRequestHeader("AJAX", true);
		},
		error:function(jqXHR) {
			if(jqXHR.status===403) {
				login();
				return false;
			}
	    	
			console.log(jqXHR.responseText);
		},
	});
}

function selectAll(selectAll)  {
	  const checkboxes 
	       = document.getElementsByName('cartCheck');
	  
	  checkboxes.forEach((checkbox) => {
	    checkbox.checked = selectAll.checked;
	  });
}


$(function(){
	$("input:checkbox").on('click', function() {
		let chk_val = [];
		$('.cart-content input:checkbox[name=cartCheck]:checked').each(function(i, iVal){
			chk_val.push(iVal.value);
		});
		
		if(chk_val.length == 0){
			chk_val.push(0);
		}
		
		let url = "${pageContext.request.contextPath}/mypage/cart/result";
		let query = {
				lectureNum : chk_val
		};
		
		var fn = function(data){
			console.log(data);
			$(".totalPrice").html(data.dto.totalPrice);
			$(".totalDc").html("-"+data.dto.totalDiscount);
			$(".totalResult").html(data.dto.totalPrice - data.dto.totalDiscount);
		};

		ajaxFun(url, "get", query, "json", fn);
	});
});




$(function() {
	$('.deletebtn').click(function() {
		let chk_val = [];
		$('.cart-content input:checkbox[name=cartCheck]:checked').each(function(i, iVal){
			chk_val.push(iVal.value);
		});
		
		if(chk_val.length == 0){
			alert('삭제할 항목을 선택하세요');
			return false;
		}
		
		if(!confirm('선택한 항목을 삭제하시겠습니까?')){
			return false;
		}
		
		let url = "${pageContext.request.contextPath}/mypage/cart/delete";
		let query = {
				lectureNum : chk_val
		};
		
		var fn = function(data){
			location.href = "${pageContext.request.contextPath}/mypage/cart";
		};

		ajaxFun(url, "get", query, "json", fn);
	});
});


</script>


<div class="container d-flex mt-5">
	<div class="list-section flex-fill mx-3">
		<h3 style="font-weight: 800;">수강바구니</h3>
		<div class="cart-head d-flex align-items-center justify-content-baseline">
			<div class="form-check">
				<input class="form-check-input" type="checkbox" name="cartCheck" value="selectall" id="flexCheckDefault" onclick='selectAll(this)'>
				<span>전체선택</span>
			</div>
			<button type="button" class="btn btn-primary deletebtn">선택 삭제 <i class="fa-solid fa-xmark"></i></button>
		</div>
		<div class="cart-content" >
			<c:forEach var="dto" items="${list}">
				<div class="cart-card d-flex px-3">
					<div class="form-check">
						<input class="form-check-input" name="cartCheck" type="checkbox" value="${dto.lectureNum}" id="flexCheckDefault">
					</div>
					<div class="cart-img">
						<img src="http://res.heraldm.com/content/image/2022/05/25/20220525000713_0.jpg" >
					</div>
					<div class="cart-course-title flex-fill">
						<p>${dto.lectureSubject}</p>
						<span>${dto.memberNickname}&nbsp;&nbsp;|&nbsp;&nbsp;</span><span>수강 기간 ${dto.lectureDuration == 0 ? "무제한" : dto.lectureDuration + "까지"}</span>				
					</div>
					<div class="closeBtnSection">
						<i class="fa-solid fa-xmark"></i>
					</div>
					<div class="priceSection">
						<span class="dcPercent">${dto.dcPercent}%</span> <span class="originalPrice">${dto.lecturePrice}원</span>
						<p class="finalPrice">${dto.dcAfterPrice}원</p>
					</div>
				</div>
			</c:forEach>
			<!-- 할인 안하는 카드 가격 확인용(지우고 작업해주세요) -->
			<!-- 
			<div class="cart-card d-flex ">
					<div class="form-check">
						<input class="form-check-input" type="checkbox" value="" id="flexCheckDefault">
					</div>
					<div class="cart-img">
						<img src="http://res.heraldm.com/content/image/2022/05/25/20220525000713_0.jpg" >
					</div>
					<div class="cart-course-title flex-fill">
						<p>스프링 CSS 웹개발 어쩌구</p>
						<span>강사이름&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;</span><span> 수강 기간</span>				
					</div>
					<div class="closeBtnSection">
						<i class="fa-solid fa-xmark"></i>
					</div>
					<div class="priceSection">
						<p class="finalPrice">69,300원</p>
					</div>
				</div>
			 -->
		</div>
	</div>
	
	<div class="pay-section ">
		<div class="buyer border">
			<div class="buyer-info-title">
				<span>구매자 정보</span>
				<button class="info-edit-btn">수정</button>
			</div>
			<div class="buyer-info">
				<table class="info-table">
					<tr>
						<td>이름</td>
						<td>${sessionScope.member.memberName}</td>
					</tr>
					<tr>
						<td>이메일</td>
						<td>${sessionScope.member.memberEmail}</td>
					</tr>
				</table>
			</div>
		</div>
		<div class="payment">
			<div class="coupon">
				<span>쿠폰 <i class="fa-solid fa-circle-question"></i></span>
				<div class="right">
					<span>사용가능 </span><span>0</span>
				</div>
				<div class="iptBtn">
					<input type="text" placeholder="0" class="">
					<button type="button" style="width:82px;">쿠폰선택</button>
				</div>
			</div>
			<div class="point">
				<span>포인트 <a><i class="fa-solid fa-circle-question"></i></a></span>
				<div class="right">
					<span>보유 </span><span>0</span>
				</div>
				<div class="iptBtn">
					<div>
						<input type="text" placeholder="0" class="">
					</div>
					<div>
						<button type="button">전액사용</button>
					</div>
				</div>
			</div>
			<div class="show-amount">
				<table class="amount-table">
					<tr>
						<td style="font-weight: 500;">선택상품 금액</td>
						<td class="totalPrice"></td>
					</tr>
					<tr class="totalDiscount" style="color:red;">
						<td> - 할인금액</td>
						<td class="totalDc">- 0</td>
					</tr>
					<!-- 
					<tr class="discounted" style="color: #999;">
						<td>&nbsp;- 쿠폰할인</td>
						<td> -20,000</td>
					</tr>
					<tr class="discounted2" style="color: #999;">
						<td>&nbsp;- 포인트사용</td>
						<td> -20,000</td>
					</tr>
					 -->
					<tr>
						<td>총 결제 금액</td>
						<td class="totalResult">0</td>
					</tr>
				</table>
			</div>
			<button type="button" class="btn btn-primary confirmbtn">결제하기</button>
			<p class="term" style="font-size: 12px; color: #ddd;">회원 본인은 주문내용을 확인했으며, 구매조건 및 개인정보취급방침과 결제에 동의합니다.</p>
		</div>
	</div>
</div>
