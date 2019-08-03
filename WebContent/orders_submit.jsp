<%@ page contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta name="Generator" content="ECSHOP v2.7.3" />
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="Keywords" content="" />
<meta name="Description" content="" />
<title>提交订单</title>
<%@include file="inc/common_head.jsp"%>
<script type="text/javascript">
jQuery(function($) {
	
	//封装读取省市县信息
	function load( target, pid ) {
		$.ajax({
			url: "orders?method=loadSSX&pid=" + pid,
			dataType: "json",
			success: function(data) {
				//json串   data: [{id:11,name:北京}, {id:34, name:安徽},...]
				// 遍历数组，创建下拉框选项
				$(data).each(function() { //遍历
					// 创建option元素
					$("<option></option>")
					// 设置选项的文本，this表示数组中遍历的当前对象
					.text(this.name)
					.val(this.name)
					.attr("pid", this.id)
					// 追加到select标签中
					.appendTo(target)
					;
				});
			}
		});
	}
	
	// 读取省份的数据
	load("#sheng", -1);
	
	// 当选择省时，加载出对应的市
	$("#sheng").change(function() {
		// 清空市和县下拉框中的选项，但需要保留“请选择”项
		$("#shi,#xian").prop("length", 1);
		
		// this是下拉框对象，value属性表示选中的option的value值
		// 查找下拉框中选中的option的pid属性
		// :selected表示选中的
		var pid = $(this).find(":selected").attr("pid");
		load( "#shi", pid );
	});
	
	// 当选择省时，加载出对应的市
	$("#shi").change(function() {
		
		$("#xian").prop("length", 1);
		
		// this是下拉框对象，value属性表示选中的option的value值
		var pid = $(this).find(":selected").attr("pid");
		load( "#xian", pid );
	});
});
</script>
</head>
<body>
	<%@include file="inc/header.jsp"%>
	<div class="block clearfix"><div class="AreaR">
	<div class="block box"><div class="blank"></div>
		<div id="ur_here">
			当前位置: <a href="index.jsp">首页</a><code>&gt;</code>购物流程
		</div>
	</div><div class="blank"></div><div class="box"><div class="box_1">
	<div class="userCenterBox boxCenterList clearfix" style="_height:1%;">
	<form action="orders?method=submit" method="post">
		<!---------收货人信息开始---------->
		<h5><span>收货人信息</span></h5>
		<table width="100%" align="center" border="0" cellpadding="5"
			cellspacing="1" bgcolor="#dddddd">
			<tr>
				<td bgcolor="#ffffff" align="right" width="120px">区域信息：</td>
				<td bgcolor="#ffffff">
					<!-- 省 -->
					<select id="sheng" name="sheng">
						<option value="">-- 请选择省 --</option>
					</select>&nbsp;&nbsp;&nbsp;
					<!-- 市 -->
					<select id="shi" name="shi">
						<option value="">-- 请选择市 --</option>
					</select>&nbsp;&nbsp;&nbsp;
					<!-- 县(区) -->
					<select id="xian" name="xian">
						<option value="">-- 请选择县(区) --</option>
					</select>
				</td>
			</tr>
			<tr>
				<td bgcolor="#ffffff" align="right">详细地址：</td>
				<td bgcolor="#ffffff">
					<input style="width:347px;" id="dAddress"/>
				</td>
			</tr>
			<tr>
				<td bgcolor="#ffffff" align="right">邮政编码：</td>
				<td bgcolor="#ffffff"><input id="detailAddress"/></td>
			</tr>
			<tr>
				<td bgcolor="#ffffff" align="right">收货人姓名：</td>
				<td bgcolor="#ffffff"><input id="name"/></td>
			</tr>
			<tr>
				<td bgcolor="#ffffff" align="right">联系电话：</td>
				<td bgcolor="#ffffff"><input id="tel"/></td>
			</tr>
		</table>
		<!---------收货人信息结束---------->
		
		<!----------商品列表开始----------->
		<div class="blank"></div>
		<h5><span>商品列表</span></h5>
		<table width="100%" border="0" cellpadding="5" cellspacing="1"
			bgcolor="#dddddd">
			<tr>
				<th width="30%" align="center">商品名称</th>
				<th width="22%" align="center">市场价格</th>
				<th width="22%" align="center">商品价格</th>
				<th width="15%" align="center">购买数量</th>
				<th align="center">小计</th>
			</tr>
			<c:set var="sum" value="0" />
			<c:forEach items="${cList }" var="c">
			<c:set var="sum" value="${sum + c.goods.estoreprice * c.buynum }" />
			<tr>
				<td>
					<a href="javascript:;" class="f6">${c.goods.name }</a>
				</td>
				<td>${c.goods.marketprice }元</td>
				<td>${c.goods.estoreprice }元</td>
				<td align="center">${c.buynum }</td>
				<td>${c.goods.estoreprice * c.buynum }元</td>
			</tr>
			</c:forEach>
			<tr>
				<td colspan="5" style="text-align:right;padding-right:10px;font-size:25px;">
					商品总价&nbsp;<font color="red">&yen;${sum }</font>元
					<input type="submit" value="提交订单" class="btn" />
				</td>
			</tr>
		</table>
		<!----------商品列表结束----------->
	</form>
	</div></div></div></div></div>
	<%@include file="inc/footer.jsp"%>
</body>
</html>