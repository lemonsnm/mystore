<%@ page contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>商品详情</title>
<%@include file="inc/common_head.jsp"%>
<script type="text/javascript" src="themes/ecmoban_jumei/js/action.js"></script>
<script type="text/javascript" src="themes/ecmoban_jumei/js/mzp-packed-me.js"></script>
<script type="text/javascript" src="themes/ecmoban_jumei/js/good_detail.js"></script>
</head>
<body>
<%@ include file="inc/header.jsp"%>
<div class="block clearfix">
<div class="AreaR" style="width:950px;">
	<div class="block box">
		<div class="blank"></div>
		<div id="ur_here">
			当前位置: <a href=".">首页</a>
			<code>&gt;</code>
			商品详情
		</div>
	</div>
	<div class="blank"></div>
<!-- 商品信息开始 -->
	<div id="goodsInfo" class="clearfix">
		<!-- 商品图片信息开始 -->
		<div class="imgInfo">
			<!-- 当前显示的大图 -->
			<a href="${goods.imgurl }"
				id="zoom1" class="MagicZoom MagicThumb">
				<img src="${goods.imgurl }" width="360px" />
			</a>
		</div>
		<!-- 商品文字信息 -->
		<div class="textInfo">
			<h1 class="clearfix">${goods.name }</h1>
			<ul class="ul2 clearfix">
				<li class="clearfix">
					<dd>
						<strong>市场售价：</strong>
						<font class="market">${goods.marketprice }元</font>
					</dd>
				</li>
				<li class="clearfix">
					<dd>
						<strong>本店售价：</strong>
						<font class="shop">${goods.estoreprice }元</font>
					</dd>
				</li>
				<li class="clearfix">
					<dd>
						<strong>商品库存：</strong> ${goods.num }件
					</dd>
				</li>
				<li class="clearfix">
					<dd>
						<strong>商品分类：</strong>
						<!-- 等类别加载完成之后，改变这个标签中的值即可 -->
						<label id="cName"></label>
					</dd>
				</li>
				<li class="clearfix" style="width:100%;">
					<dd>
						<strong>商品描述：</strong>
						<div style="text-indent: 2em;">
							${goods.description }
						</div>
					</dd>
				</li>
			</ul><br/>
			<ul class="bnt_ul">
				<li class="clearfix">
					<dd>
						<strong>购买此商品可使用：</strong><font class="f4">155 积分</font>
					</dd>
				</li>
				<li class="clearfix">
					<dd>
						<strong style="vertical-align: middle;">购买数量：</strong>
						<input name="buynum" id="buynum" maxlength="5" value="1" />
					</dd>
				</li>
				<!-- 添加到购物车 -->
				<li class="padd">
					<a href="javascript:;" id="addCart">
						<img src="themes/ecmoban_jumei/images/goumai2.gif" />
					</a>
					<!-- 添加到收藏夹 -->
					<a href="javascript:;" id="addFavorite">
						<img src="themes/ecmoban_jumei/images/shoucang3.gif" />
					</a>
					<!-- 判断是否是管理员 -->
					<c:if test="${ AdminUser != null }">
					<!-- 修改功能 -->
									<a href="admin?method=updateGoods&id=${goods.id}" id="updateGoods">
						<img src="themes/ecmoban_jumei/images/xiugai.png" />
					</a>
					<!-- 删除功能 -->
					<a href="javascript:;"  del="${goods.id}">
						<img src="themes/ecmoban_jumei/images/shanchu.png" />
					</a>
					</c:if>
					
				</li>
				
				<script>
				//添加点击购物车点击事件
				jQuery(function($){
					$("#addCart").click(function() {
					/* 	//测试点击事件的绑定
						alert("点击"); */
						location="cart?method=add&gid=${goods.id}&buynum="+$("#buynum").val();
					});
					
					//添加到收藏夹
					$("#addFavorite").click(function() {
						 
						
						location="favorite?method=add&gid=${goods.id}";
						alert("收藏成功");  
						
						
					});
					
					//删除功能： 
					
					//选择含有del属性的a标签
					$("a[del]").click(function() {
						/*  //测试绑定事件
						alert("点击");  */ 
						
						//获取del属性的值
						var id = $(this).attr("del");
			        	 //测试获取del的值gid
						/* alert(id);  */ 
					
						if(confirm("确定删除吗？")){
					 	
						/* 	//采用页面刷新，用户体验不好
						location="favorite?method=del&gid=" + gid; */  
						
						//采用Ajax部分页面刷新技术 
						//获取要删除的行 距离删除最近的tr标签
						 var $tr = $(this).closest("tr");
						$.ajax({
							url:"admin?method=delAjax&id=" + id,
							success:function(data){
								
								if(data == "ok"){
									$tr.remove();//删除行
									location ="goods?method=query";
								}else {//未登录 则去登录
									location = "login.jsp";
								}
							}
						}); 
						
						}
					});
					
				});
				
				
				</script>
			</ul>
		</div>
	</div>
	<!-- 商品信息结束 -->
	
	<div class="blank"></div>
	<div class="box">
		<div style="padding:0 0px;">
			<div id="com_b" class="history clearfix">
				<h2>商品描述</h2>
				<h2 class="h2bg">商品属性</h2>
				<h2 class="h2bg">商品标签</h2>
				<h2 class="h2bg">相关商品</h2>
			</div>
		</div>
		<div class="box_1">
			<div id="com_v" class="  " style="padding:6px;"></div>
			<div id="com_h">
				<blockquote>
					<p>&nbsp;</p>
					<div class="more_pic"
						style="margin: 0px 20px; padding: 0px; overflow: hidden; text-align: center; color: rgb(102, 102, 102); font-family: Arial;">
						<img src="${goods.imgurl }" alt="${goods.name }"
							class="load_img"
							style="border: 0px; display: block; margin-left: auto; margin-right: auto; background-image: url(images/loading.gif); height: 710px; width: 640px; background-position: 50% 50%; background-repeat: no-repeat no-repeat;" />
					</div>
					
				</blockquote>
				<blockquote>
					<table class="table" width="100%" border="0" cellpadding="3"
						cellspacing="1" bgcolor="#dddddd">
						<tr>
							<th colspan="2" bgcolor="#FFFFFF">商品属性</th>
						</tr>
						<tr>
							<td bgcolor="#FFFFFF" align="left" width="30%" class="f1">[花型]</td>
							<td bgcolor="#FFFFFF" align="left" width="70%">印花/绣花</td>
						</tr>
						<tr>
							<td bgcolor="#FFFFFF" align="left" width="30%" class="f1">[袖型]</td>
							<td bgcolor="#FFFFFF" align="left" width="70%">七分袖</td>
						</tr>
						<tr>
							<td bgcolor="#FFFFFF" align="left" width="30%" class="f1">[风格]</td>
							<td bgcolor="#FFFFFF" align="left" width="70%">简约</td>
						</tr>
					</table>
				</blockquote>
				<blockquote>
					<div class="box">
						<div class="box_1">
							<h3>
								<span class="text">商品标签</span>
							</h3>
							<div class="boxCenterList clearfix ie6">
								<form name="tagForm" action="javascript:;" id="tagForm">
									<p id="ECS_TAGS" style="margin-bottom:5px;"></p>
									<p>
										<input type="text" name="tag" id="tag" class="inputBg"
											size="35" /> <input type="submit" value="添 加"
											class="bnt_blue" style="border:none;" /> <input
											type="hidden" name="goods_id" value="139" />
									</p>
								</form>
							</div>
						</div>
					</div>
					<div class="blank5"></div>
				</blockquote>
				<blockquote></blockquote>
			</div>
		</div>
	</div>
	<script type="text/javascript">reg("com");</script>
	<div class="blank"></div>
	<div class="box">
		<div class="box_1">
			<h3>
				<span class="text">购买过此商品的人还购买过</span>
			</h3>
			<div class="boxCenterList clearfix ie6" style="padding:2px;">
				<div class="goodsItem" style="padding: 10px 2px 15px 2px;">
					<a href="javascript:;"><img
						src="images/201501/thumb_img/137_thumb_G_1420325495120.jpg"
						alt="海绵宝宝多元海藻呵护洗沐500ml" class="goodsimg" /></a><br />
					<p>
						<a href="javascript:;" title="海绵宝宝多元海藻呵护洗沐500ml">海绵宝宝多元海藻呵护洗沐500ml</a>
					</p>
					<font class="shop_s">87元</font>
				</div>
				<div class="goodsItem" style="padding: 10px 2px 15px 2px;">
					<a href="javascript:;"><img
						src="images/201501/thumb_img/134_thumb_G_1421183937155.jpg"
						alt="飘柔（Rejoice）倍瑞丝护理专研顺滑优惠装（洗发露450ML+护发素230ML）"
						class="goodsimg" /></a><br />
					<p>
						<a href="javascript:;"
							title="飘柔（Rejoice）倍瑞丝护理专研顺滑优惠装（洗发露450ML+护发素230ML）">飘柔（Rejoice）倍瑞丝护理专研顺滑优惠装（洗发露450...</a>
					</p>
					<font class="shop_s">110元</font>
				</div>
				<div class="goodsItem" style="padding: 10px 2px 15px 2px;">
					<a href="javascript:;"><img
						src="images/201501/thumb_img/140_thumb_G_1420324897667.jpg"
						alt="完美芦荟胶一对 40g*2" class="goodsimg" /></a><br />
					<p>
						<a href="javascript:;" title="完美芦荟胶一对 40g*2">完美芦荟胶一对
							40g*2</a>
					</p>
					<font class="shop_s">110元</font>
				</div>
				<div class="goodsItem" style="padding: 10px 2px 15px 2px;">
					<a href="javascript:;"><img
						src="images/201501/thumb_img/141_thumb_G_1420324798329.jpg"
						alt="兰蔻清滢柔肤水400ml" class="goodsimg" /></a><br />
					<p>
						<a href="javascript:;" title="兰蔻清滢柔肤水400ml">兰蔻清滢柔肤水400ml</a>
					</p>
					<font class="shop_s">110元</font>
				</div>
			</div>
		</div>
	</div>
	<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
	<div class="blank5"></div>
	<div id="ECS_COMMENT">
		<div class="box">
			<div class="box_1">
				<h3>
					<span class="text">用户评论</span>(共<font class="f1">${ commentsList.size()}</font>条评论)
				</h3>
				<div class="boxCenterList clearfix" style="height:1%;">
					<ul class="comments">
					<c:if test="${ commentsList.size() == 0 }">
						<li>暂时还没有任何用户评论</li>
					</c:if>
					
					<c:if test="${ commentsList.size() != 0 }">
					<c:forEach items="${commentsList}" var="c">
					<li>
						<div class="f1">${c.nickname}
						<c:if test="${c.level == 1}">
						<img src="themes/ecmoban_jumei/images/stars1.gif" />
						</c:if>
						<c:if test="${c.level == 2}">
						<img src="themes/ecmoban_jumei/images/stars2.gif" />
						</c:if>
						<c:if test="${c.level == 3}">
						<img src="themes/ecmoban_jumei/images/stars3.gif" />
						</c:if>
						<c:if test="${c.level == 4}">
						<img src="themes/ecmoban_jumei/images/stars4.gif" />
						</c:if>
						<c:if test="${c.level == 5}">
						<img src="themes/ecmoban_jumei/images/stars5.gif" />
						</c:if>
						</div>
					    <div >${c.comments}</div>
						<div class="f5">
						<fmt:formatDate value="${c.createtime}" pattern="yyyy-MM-dd HH:mm:ss"/>
						</div>
					</li>
						</c:forEach>
					</c:if>
					
					</ul>

					<div id="pagebar" class="f_r">
						<form name="selectPageForm" action="javascript:;" method="get">
							<div id="pager">
								总计${ commentsList.size()}个记录，共 1 页。 <span> <a
								id="firstPage">第一页</a> <a
									href="javascript:;">上一页</a> <a href="javascript:;">下一页</a> <a
									href="javascript:;">最末页</a>
								</span>
							</div>
						</form>
					</div>

					<div class="blank5"></div>
					<div class="commentsList"> 
						<form action="comments?method=add&gid=${goods.id}" method="post" 
							onsubmit="submitComment(this)"
							 name="commentForm" id="commentForm">
							<table width="710" border="0" cellspacing="5" cellpadding="0">
								<tr>
									<td width="64" align="right">用户名：</td>
									<td width="631">${loginUser.nickname}</td>
								</tr>

								<tr>
									<td align="right">评价等级：</td>
									<td><input name="comment_rank" type="radio" value="1"
										id="comment_rank1" /> <img
										src="themes/ecmoban_jumei/images/stars1.gif" /> <input
										name="comment_rank" type="radio" value="2"
										id="comment_rank2" /> <img
										src="themes/ecmoban_jumei/images/stars2.gif" /> <input
										name="comment_rank" type="radio" value="3"
										id="comment_rank3" /> <img
										src="themes/ecmoban_jumei/images/stars3.gif" /> <input
										name="comment_rank" type="radio" value="4"
										id="comment_rank4" /> <img
										src="themes/ecmoban_jumei/images/stars4.gif" /> <input
										name="comment_rank" type="radio" value="5" checked="checked"
										id="comment_rank5" /> <img
										src="themes/ecmoban_jumei/images/stars5.gif" /></td>
								</tr>
								<tr>
									<td align="right" valign="top">评论内容：</td>
									<td><textarea name="content" class="inputBorder"
											style="height:50px; width:620px;"></textarea> <input
										type="hidden" name="cmt_type" value="0" /> <input
										type="hidden" name="id" value="139" /></td>
								</tr>
								<tr>
									<td colspan="2">
										<div style="padding-left:15px; text-align:left; float:left;">
											验证码：<input type="text" name="captcha" class="inputBorder"
												style="width:50px; margin-left:5px;" /> <img
												src="validatecode.jsp" alt="captcha"
												onClick="this.src='validatecode.jsp?'+Math.random()"
												class="captcha">
										</div> <input name="" type="submit" value="评论咨询"
										class="f_r bnt_blue_1" style=" margin-right:8px;">
									</td>
								</tr>
							</table>
						</form>
					</div>
				</div>
			</div>
		</div>
		<div class="blank5"></div>
	</div>
</div>
</div>
<%@include file="inc/footer.jsp"%>

</body>
</html>