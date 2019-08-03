<%@ page contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta name="Generator" content="ECSHOP v2.7.3" />
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="Keywords" content="" />
<meta name="Description" content="" />
<title>新增商品</title>
<%@include file="inc/common_head.jsp"%>
<script type="text/javascript">
jQuery(function($) {
	
	//封装商品类别信息
	function load( target, pid ) {
		$.ajax({
			url: "admin?method=loadCategory",
			dataType: "json",
			success: function(data) {
				//json串   data: [{id:11,name:北京}, {id:34, name:安徽},...]
				// 遍历数组，创建下拉框选项
				$(data).each(function() { //遍历
					// 创建option元素
					$("<option></option>")
					// 设置选项的文本，this表示数组中遍历的当前对象
					.text(this.name)
					.val(this.id)
					/* .attr("cid", this.id) */
					// 追加到select标签中
					.appendTo(target)
					;
				});
			}
		});
	}
	
	// 读取类别的数据
	load("#Category", -1);
	
	//表单提交
/* 	 $('#formSumbit').submit(function (event) {
        //首先验证文件格式
        var fileName = $(this).find("input[name=file]").val();
        if (fileName === '') {
            alert('请选择文件');
            return;
        }
        //判断是否是图片
        var fileType = (fileName.substring(fileName.lastIndexOf(".") + 1, fileName.length)).toLowerCase();
        if (fileType !== 'png' && fileType !== '') {
            alert('文件格式不正确，excel文件！');
            return;
        }
        
	 }); */

});
</script>
</head>
<body>
	<%@include file="inc/header.jsp"%>
	<div class="block clearfix"><div class="AreaR">
	<div class="block box"><div class="blank"></div>
		<div id="ur_here">
			当前位置: <a href="index.jsp">首页</a><code>&gt;</code>新增商品
		</div>
	</div><div class="blank"></div><div class="box"><div class="box_1">
	<div class="userCenterBox boxCenterList clearfix" style="_height:1%;">
	<form action='admin?method=addGoods' method="post" enctype="multipart/form-data">
		<!---------新增商品开始---------->
		<h5><span>新增商品</span></h5>
		<table width="100%" align="center" border="0" cellpadding="5"
			cellspacing="1" bgcolor="#dddddd">
			<tr>
				<td bgcolor="#ffffff" align="right">商品名称：</td>
				<td bgcolor="#ffffff"><input id="name" name="goodsName"/></td>
			</tr>
			<tr>
				<td bgcolor="#ffffff" align="right" width="120px">商品类别：</td>
				<td bgcolor="#ffffff">
					<!-- 类别 -->
					<select id="Category" name="category" >
						<option value="">-- 请选择商品类别 --</option>
					</select>&nbsp;&nbsp;&nbsp;
				</td>
			</tr>
			<tr>
				<td bgcolor="#ffffff" align="right">市场价：</td>
				<td bgcolor="#ffffff">
					<input id="marketprice" name="marketprice"/>
				</td>
			</tr>
			<tr>
				<td bgcolor="#ffffff" align="right">商城价：</td>
				<td bgcolor="#ffffff"><input id="estoreprice" name="estoreprice"/></td>
			</tr>
			<tr>
				<td bgcolor="#ffffff" align="right">库存量：</td>
				<td bgcolor="#ffffff"><input id="num" name ="num"/></td>
			</tr>
			<tr>
				<td bgcolor="#ffffff" align="right">商品图片：</td>
				<td bgcolor="#ffffff"><input id="tel" type="file" name="fileupload"/></td>
			</tr>
			<tr>
				<td align="right" valign="top">商品描述：</td>
				<td><textarea id="content" name="content" class="inputBorder"
				style="height:50px; width:620px;"></textarea> 
				</td>
			</tr>
			<tr>
				<td colspan="5" style="text-align:right;padding-right:10px;font-size:25px;">
					<input type="submit" value="确认新增" class="btn" />
				</td>
			</tr>
		</table>
		<!---------商品信息填写结束---------->
	</form>
	</div></div></div></div></div>
	<%@include file="inc/footer.jsp"%>
</body>
</html>