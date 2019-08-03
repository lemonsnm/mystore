<%@ page contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>注册</title>
<%@include file="inc/common_head.jsp"%>

<script type="text/javascript">
//在页面加载完成时，对页面中的元素进行事件的绑定
jQuery(function($){
	//$是JQuery的别名
	//#telephone 表示绑定id为telephone的元素
	//bind的方法表示绑定事件
	//keyup表示键盘抬起事件，blur表示离焦事件，多个事件使用空格
	//函数表示 当对应的时间发生时，执行的js代码
	/* 	onkeyup="check_tel_code(this.value);" 
	    nblur="check_tel_code(this.value);"  */
	    
	//判断输入的手机号是否正确 是否已经注册了
	$("#telephone").bind("keyup blur",function(){
		//判断是否是手机号 校验前端规则
		var isTel = check_telephone(this.value);
		
		if(isTel){
			//是手机号，需要进行后台的校验！是否被注册？
			//需要使用ajax技术
			
			// 在前端规则校验通过之后，发送ajax请求检查是否被占用注册过了
			$.ajax({
				//请求地址，SerVlet的访问路径
				url:"user?method=checkTel&tel="+this.value,
				
				// 后台返回结果之后，执行的代码
				// 函数中的参数表示后台返回的结果
				success: function(data){
					//data后台传来的数据
					if(data == "ok"){
					//alert("可以使用！");
					$("#telephone_notice")
					.attr("class","ok")      //添加绿色√样式
					.text(""); //清空文本提示
					}else{//被注册
						$("#telephone_notice")
						.attr("class","error") //添加红色×样式
						.text("已经被注册");     //文本提示
					}
				}
			});
			
		}
	});
	    
	    //获取手机验证码
	    $("#sendSMS").bind("click",function(){
	    	
	    	// 如果按钮中的文本不是“获取短信验证码”，就不执行下面的代码
	    	if($(this).text() != "获取短信验证码"){
	    		//结束方法执行
	    		return ;
	    	}
	    	
	    	/*判断是否是一个合法的手机号码 */
	    	var tel  = $("#telephone").val(); //获取输入的手机号
	    	// 如果不是合法的号码，则不执行之后的代码
	    	if(!/^1[345789]\d{9}$/.test(tel)){
	    		return ;
	    	}
	    	
	    	//倒计时操作
	    	var time = 60;
	    	$(this).text("再次发送(" + time + ")...")
	    	// 不可点击的视觉效果
	    	.css("cursor","not-allowed");
	    	//保存当前this
	    	var that = this;
	    	
	    	var intervalID= setInterval(function(){
	    		$(that).text("再次发送(" + --time + ")...");
	    		if(time == 0){
	    			clearInterval(intervalID);  //清除此循环
	    		    $(that).text("获取短信验证码") //重新设置内容：获取短信验证码
					.css("cursor", "");         // 移除不可点击的视觉效果
	    		}	
	    	}, 1000);//1000代表：一秒一次
	    	
	    	//请求生成验证码
	    	$.ajax({
	    		// 请求的地址，Servlet的访问路径
	    		url: "user?method=sendSMS&tel=" + $("#telephone").val(),
	    	});
	    });
	    
	 // 校验短信验证码的正确性
	 $("#code_phone").bind("keyup blur",function(){ //绑定 按键按下 与松开事件
		// ok为ture，表示满足6位数字的要求
		var ok = check_tel_code(this.value);
	 
		// 在满足6位数字的情况下，进行后台的验证
	 if(!ok){//如果输入的不是六位数，不用验证 直接退出
	 		return ;
	 	}
		
		$.ajax({
			url:"user?method=checkSMSCode&smsCode=" + this.value,   //验证码校验， smsCode：输入的验证码
			success: function(data) { //成功时，servlet返回的数据
				if(data == "true"){
					$("#code_phone_notice")  //验证码后面显示
					.attr("class", "ok")     //绿色√样式
					.text("");               //清空文本内容
				}else{ //验证码输入错误
					$("#code_phone_notice")     //验证码后面显示
					.attr("class", "error")     //绿色×样式
					.text("验证码错误！");
				}
			}
			
		});
	 
	 });
	 
	
});
</script>
</head>
<body>
	<%@include file="inc/header.jsp"%>
	<div class="block block1">
		<div class="blank"></div>
		<div class="usBox">
			<div class="usBox_1">
				<div class="login_tab">
					<ul>
						<li onclick="location.href='login.jsp';">
							<a href="javascript:;">用户登录</a>
						</li>
						<li class="active">用户注册</li>
					</ul>
				</div>
				<form action="user?method=register&tel" method="post" name="formUser"
					onsubmit="return register();">
					<table width="100%" border="0" align="left" cellpadding="5"
						cellspacing="3">
						<tr>
							<td width="70px" class="justify">昵称</td>
							<td>
								<input name="nickname" type="text" id="nickname" placeholder="请输入昵称" 
									onkeyup="check_nickname(this.value);"
									onblur="check_nickname(this.value);" 
									class="inputBg" />
								<span id="nickname_notice"></span>
							</td>
						</tr>
						<tr>
							<td class="justify">密码</td>
							<td>
								<input name="password" type="password" id="password1" placeholder="请输入密码" 
									onkeyup="check_password(this.value);" 
									onblur="check_password(this.value);" 
									class="inputBg" />
								<span id="password_notice"></span>
							</td>
						</tr>
						<tr>
							<td class="justify">确认密码</td>
							<td>
								<input name="confirm_password" type="password" id="conform_password"
									onkeyup="check_conform_password(this.value);"
									onblur="check_conform_password(this.value);"
									class="inputBg" placeholder="请输入确认密码"  />
								<span id="conform_password_notice"></span>
							</td>
						</tr>
						<tr>
							<td class="justify">手机号码</td>
							<td>
								<input type="text" name="telephone" id="telephone" 
									class="inputBg" placeholder="请输入手机号码" />
									<!--  -->
								<span id="telephone_notice"></span>
							</td>
						</tr>
						<tr>
							<td class="justify">手机验证码</td>
							<td>
								<input type="text" name="code_phone" id="code_phone" 
								
									class="inputBg" placeholder="请输入手机验证码" /><a 
									href="javascript:;" class="get_code"
								    id = "sendSMS">获取短信验证码</a>
								<span id="code_phone_notice" style="margin-left:-132px;"></span>
							</td>
						</tr>
						<!-- <tr>
							<td class="justify">图片验证码</td>
							<td>
								<input id="captcha" name="captcha" class="inputBg" 
									placeholder="请输入图片验证码" maxlength="4"
									onkeyup="check_captcha(this.value);" 
									onblur="check_captcha(this.value);" 
								/><img id="vcode" src="validatecode.jsp" 
									onclick="src='validatecode.jsp?'+Math.random()" />
								<span id="captcha_notice"></span>
							</td>
						</tr> -->
						<tr>
							<td>&nbsp;</td>
							<td>
								<a href="javascript:;">
									<input id="regBtn" value="立  即  注  册" 
										type="submit" class="us_Submit_reg"/>
								</a>
							</td>
						</tr>
						<tr>
							<td>&nbsp;</td>
							<td>
								<a href="javascript:;" onclick="location='login.jsp'">
									<input id="loginBtn" value="已有账号？立即登录" 
										type="button" class="us_Submit_log" />
								</a>
							</td>
						</tr>
						<tr>
							<td colspan="2">&nbsp;</td>
						</tr>
					</table>
				</form>
				<div class="blank"></div>
			</div>
		</div>
	</div>
	<%@include file="inc/footer.jsp"%>
</body>
</html>