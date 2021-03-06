<%@ page language="java" contentType="text/html;charset=utf-8"
	pageEncoding="utf-8"%>
<!-- 引入spring标签库 -->
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html;charset=utf-8">
<title>还款管理</title>
<jsp:include page="../../common/link.jsp" />
<!--弹出框-->
<script type="text/javascript"
	src="${app.staticResourceUrl}/ybl/resources/js/jquery.dragndrop.js"></script>
<script type="text/javascript"
	src="${app.staticResourceUrl}/ybl/resources/js/jquery.msgbox.js"></script>
<script type="text/javascript">
	$(function() {
		view = function(id) {
			
			var applyId = $("input[type='checkbox']:checked").val();
			
			if($("input[type='checkbox']:checked").length!=1 || !applyId){
				alert($.i18n.prop('sys.client.select.one.record'));/* 请选择一条记录 */
				return false;
			}
			
			$.msgbox({
						height : 622,
						width : 1050,
						content : '/repaymentController/advanceRepay?applyId='+applyId,
						type : 'iframe',
						title : $.i18n.prop('sys.client.Prepayment')/* 提前还款 */
					});
		}
	});
</script>
<script>

$(function(){
	Date.prototype.format = function(fmt) { 
	     var o = { 
	        "M+" : this.getMonth()+1,                 //月份 
	        "d+" : this.getDate(),                    //日 
	        "h+" : this.getHours(),                   //小时 
	        "m+" : this.getMinutes(),                 //分 
	        "s+" : this.getSeconds(),                 //秒 
	        "q+" : Math.floor((this.getMonth()+3)/3), //季度 
	        "S"  : this.getMilliseconds()             //毫秒 
	    }; 
	    if(/(y+)/.test(fmt)) {
	            fmt=fmt.replace(RegExp.$1, (this.getFullYear()+"").substr(4 - RegExp.$1.length)); 
	    }
	     for(var k in o) {
	        if(new RegExp("("+ k +")").test(fmt)){
	             fmt = fmt.replace(RegExp.$1, (RegExp.$1.length==1) ? (o[k]) : (("00"+ o[k]).substr((""+ o[k]).length)));
	         }
	     }
	    return fmt; 
	}     
	
	
	$.extend({    
	    formatFloat:function(src, pos){    
	        var num = parseFloat(src).toFixed(pos);    
	        num = num.toString().replace(/\$|\,/g,'');    
	        if(isNaN(num)) num = "0";    
	        sign = (num == (num = Math.abs(num)));    
	        num = Math.floor(num*100+0.50000000001);    
	        cents = num%100;    
	        num = Math.floor(num/100).toString();    
	        if(cents<10) cents = "0" + cents;    
	        for (var i = 0; i < Math.floor((num.length-(1+i))/3); i++)    
	        num = num.substring(0,num.length-(4*i+3))+','+num.substring(num.length-(4*i+3));    
	        return (((sign)?'':'-') + num + '.' + cents);    
	    } 

	})
})
	$(document).ready(function() {
		//限制多选框单选
		$("#pageForm").find('input[type=checkbox]').bind('click',function(){
			$("#pageForm").find('input[type=checkbox]').not(this).attr("checked",false);
		})
		
		
		$(".open").click(function() {
			var tr = $(this).parent().parent().parent();
			$(this).hide();
			$(this).next(".close").show();
			//查询凭证信息
			 $.ajax({
				async:false,
				type:"get",
				url:"/financeApplyController/queryVouceherByApplyId?applyId="+$(this).attr('value'),
			 	dataType:'json',
			 	success : function(data){
			 		console.log(data);
					if("SUCCESS" == data.responseType){
						//查询成功，拼接凭证信息
						var str ='<tr class="z_table ">'
							+'<td colspan="14">'
								+'<table width="100%" border="0" cellspacing="0" cellpadding="0"'
								+'id="tb1">'
								+'<tr>'
								+'<th width="50"></th>'
								+'<th width="50"></th>'
								+'<th><spring:message code="sys.client.no"></spring:message></th>'/* 序号 */
								+'<th><spring:message code="sys.client.voucherNumber"></spring:message></th>'/* 凭证编码 */
								+'<th><spring:message code="sys.client.coreCompanyName"></spring:message></th>'/* 核心企业名称 */
								+'<th><spring:message code="sys.client.voucherAmount"></spring:message></th>'/* 凭证面额/元 */
								+'<th><spring:message code="sys.client.voucherType"></spring:message></th>'/* 凭证类型 */
								+'<th><spring:message code="sys.client.voucherOverdueTime"></spring:message></th>'/* 凭证到期日 */
								+'</tr>';
					
					for(var i =0;i<data.object.length;i++){
						var obj = data.object[i];
						str+='<tr>'
								+'<td></td>'
								+'<td></td>'
								+'<td>'+(i+1)+'</td>'
								+'<td>'+obj.voucher_no +'</td>'
								+'<td>'+obj.enterprise_name+'</td>'
								+'<td>￥'+$.formatFloat(obj.amount_,2)+'</td>'
								+'<td>'+obj.type_+'</td>'
								+'<td>'+new Date(parseInt(obj.expire_date)).format("yyyy-MM-dd")+'</td>'
								+'</tr>';
						}
					//补全table标签
					str+=('</table></td></tr>');
					tr.after(str);
			 		}
			 	},
			 	error:function(){
			 		alert($.i18n.prop('sys.client.operationFail'));/* 操作失败 */
			 	}
				
			}) 
			
			
			$(this).parent().parent().parent().next(".z_table").slideDown(100);
		});

		$(".close").click(function() {
			$(this).hide();
			$(this).prev(".open").show();
			$(this).parent().parent().parent().next(".z_table").slideUp(100);
		});
	});
	
	$(function(){
		$("#queryRepaymentBtn").click(function(){
			$("#pageForm").submit();
		})
		
		$("#repaymentResetBtn").click(function(){
			$("input[name='number']").val("");
			$("input[name='enterpriseName']").val("");
			$("select[name='status']").val("");
		})
	})
	
	
</script>
</head>
<body>
	<!--top start -->
	<jsp:include page="../../common/top.jsp?step=1" />
	<!--top end -->

	<div class="path"><spring:message code='sys.client.location'></spring:message>-><!-- 当前位置 -->
	 <spring:message code='sys.client.loan.manage'></spring:message>-> <!-- 贷款管理 -->
	  <spring:message code='sys.client.repay.manage'></spring:message> <!-- 还款管理 -->
	  </div>
	<div class="vip_conbody">
	 <form action="/repaymentController/repayment" id="pageForm" method="post">
	 
	
		<!--搜索条件-->
		<div class="seach_box" id="submit_box">
			<div class="switch" onclick="hideform();">
				<a></a>
			</div>
			<div class="fl">
				<ul>
					<li><label><spring:message code='sys.client.financeNumber'></spring:message>:</label><input type="text"  name="number" value="${vo.number }" /></li><!-- 融资编号 -->
					<li><label><spring:message code='sys.client.factor.enterpriseName'></spring:message>:</label><input type="text" name="enterpriseName" value="${vo.enterpriseName }"/></li><!-- 保理商名称 -->
					<li>
					<label><spring:message code='sys.client.finance.apply.status'></spring:message>:</label><!-- 融资状态 -->
						<select name="status">
							<option value=""><spring:message code='sys.client.queryAll'></spring:message></option><!-- 全部 -->
							<option value="repaymented" <c:if test="${vo.status=='repaymented' }">selected='selected'</c:if>><spring:message code='sys.client.hasPayed'></spring:message></option><!-- 已还款 -->
							<option value="unrepayment" <c:if test="${vo.status=='unrepayment' }">selected='selected'</c:if>><spring:message code='sys.client.not.payed'></spring:message></option><!-- 未还款 -->
						</select>
					</li>
					<li><div class="button_yellow">
							<a id="queryRepaymentBtn"><spring:message code='sys.admin.search'></spring:message></a><!-- 查询 -->
						</div></li>
					<li><div class="button_gary">
							<a id="repaymentResetBtn" ><spring:message code='sys.client.reset'></spring:message></a><!-- 重置 -->
						</div></li>
				</ul>
			</div>
		</div>
		<!--搜索条件-->
		<!--table-->
		<div class="table_box">
			<div class="table_top ">
				<div class="table_nav">
					<ul>

						<li><a href="javascript:view(1);" class="but_ico3"><spring:message code='sys.client.Prepayment'></spring:message></a></li><!-- 提前还款 -->
						<li><a href="javascript:view(1);" class="but_ico4"><spring:message code='sys.admin.view'></spring:message></a></li><!-- 查看 -->
					</ul>
				</div>
			</div>
			<!--按钮top-->
			<div class="table_con">
				<table width="100%" border="0" cellspacing="0" cellpadding="0"
					id="tb">
					<tr>
						<th width="50"><input name="" type="checkbox" value="" /></th>
						<th><spring:message code='sys.client.no'></spring:message></th><!-- 序号 -->
						<th><spring:message code='sys.client.financeNumber'></spring:message></th><!-- 融资编号 -->
						<th><spring:message code='sys.client.factor.enterpriseName'></spring:message></th><!-- 保理商名称 -->
						<th><spring:message code='sys.client.factorType'></spring:message></th><!-- 保理类型 -->
						<th><spring:message code='sys.client.loan.amount'></spring:message></th><!-- 贷款金额/元 -->
						<th><spring:message code='sys.client.yearRate'></spring:message></th><!-- 年利率 -->
						<th><spring:message code='sys.client.loanPeriod'></spring:message></th><!-- 贷款期限 -->
						<th><spring:message code='sys.client.repaymentTime'></spring:message></th><!-- 还款日期 -->
						<th><spring:message code='sys.client.investBidManage.serviceCharge'></spring:message></th><!-- 服务费/元 -->
						<th><spring:message code='sys.client.overdue.fee'></spring:message></th><!-- 逾期费/元 -->
						<th><spring:message code='sys.clinet.liquidated.damages'></spring:message></th><!-- 违约费/元 -->
						<th><spring:message code='sys.client.finance.apply.status'></spring:message></th><!-- 融资状态 -->
						<th></th>
					</tr>
				 <c:forEach items="${repaymentList }" var="repay" varStatus="varstatus">
					<tr>
						<td><input name="" type="checkbox" value="${repay.financeApplyId}" /></td>
						<td>${varstatus.count }</td>
						<td>${repay.number}</td>
						<td>${repay.enterpriseName }</td>
						<td>${repay.factorType }</td>
						<td><fmt:formatNumber value="${repay.amount }" pattern="#,##0.00"></fmt:formatNumber></td>
						<td><fmt:formatNumber value="${repay.rate}" pattern="0.00%"></fmt:formatNumber></td>
						<td>${repay.loanPeriod }
							<c:if test="${repay.period_type =='day'}"><spring:message code='sys.client.day'></spring:message></c:if><!-- 天 -->
							<c:if test="${repay.period_type =='month'}"><spring:message code='sys.client.month'></spring:message></c:if><!-- 月 -->
							<c:if test="${repay.period_type =='year'}"><spring:message code='sys.client.year'></spring:message></c:if><!-- 年 -->
						</td>
						<td><fmt:formatDate value="${repay.repaymentDate }" pattern="yyyy-MM-dd" /></td>
						<td>--</td>
						<td><fmt:formatNumber value="${repay.overduePenalty}" pattern="#,##0.00"></fmt:formatNumber></td>
						<td><fmt:formatNumber value="${repay.advancePenalty}" pattern="#,##0.00"></fmt:formatNumber></td>
						<td>
							<c:if test="${repay.status=='repaymented' }"><spring:message code=''></spring:message><spring:message code='sys.client.hasPayed'></spring:message></c:if><!-- 已还款 -->
							<c:if test="${repay.status=='unrepayment' }"><spring:message code=''></spring:message><spring:message code='sys.client.not.payed'></spring:message></c:if><!-- 未还款 -->
						</td>
						<td><div class="but_ss">
								<a class="open " value="${repay.financeApplyId }"></a>
								<a class="close" style="display: none;"></a>
							</div></td>
					</tr>
				 </c:forEach>
					<!-- <tr class="z_table ">
						<td colspan="14">
							<table width="100%" border="0" cellspacing="0" cellpadding="0"
								id="tb1">
								<tr>
									<th width="50"></th>
									<th width="50"></th>
									<th>序号</th>
									<th>凭证编码</th>
									<th>核心企业名称</th>
									<th>凭证面额（万元</th>
									<th>凭证类型</th>
									<th>凭证到期日</th>
								</tr>
								<tr>
									<td></td>
									<td></td>
									<td>1</td>
									<td>00002</td>
									<td>京东</td>
									<td>￥5000.00</td>
									<td>应收账款凭证</td>
									<td>2016/12/30</td>
								</tr>
							</table>
						</td>
					</tr> -->
				</table>

			</div>
			<div class="pages">
				<jsp:include page="../../common/page.jsp"></jsp:include>
			</div>
		</div>
	</div>
		 </form>
		<!--table-->
   </div>
	<!-- 底部jsp -->
	<jsp:include page="../../common/bottom.jsp" />
	<!-- 底部jsp -->
</body>
</html>