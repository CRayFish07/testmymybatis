<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ include file="/common/common.jsp" %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <title>Free HTML5 Bootstrap Admin Template</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="Charisma, a fully featured, responsive, HTML5, Bootstrap admin template.">
    <meta name="author" content="Muhammad Usman">
    <script type="text/javascript">
    var countdown = 0;
    var phoneRegex = /^[1][0-9]{10}$/;
    	$(function(){
    		//document.onkeydown=keyDownSearch;
    		$("input").keypress(function(e){
        		// 兼容FF和IE和Opera    
        		var theEvent = e || window.event;    
                var code = theEvent.keyCode || theEvent.which || theEvent.charCode;
     		   	if (code == 13) {
     		   		loginFunction();
     		   	}
     		 });
    	});

    	function registerFunction(){
    		if($("#username").val()==null||(!$("#username").val().length>0)){
    			$("#alertContent").html("请输入用户名");
    			$("#alertId").show();
    		}else if($("#telephone").val().length>0&&!phoneRegex.test($("#telephone").val())){
    			$("#alertId").show();
    			$("#alertContent").html("请输入合法的手机号，如：15899999999");
    		}else if($("#password").val()==null||(!$("#password").val().length>0)){
    			$("#alertId").show();
    			$("#alertContent").html("请输入密码");
    		}else if($("#security").val()==null||(!$("#security").val().length>0)){
    			$("#alertId").show();
    			$("#alertContent").html("验证码不能为空");
    		}
    		else{
    			$.ajax({
    		        url: '${appctx}/loginController/register',
    		        async: true,
    		        contentType:"application/json",
    		        type: 'POST',
    		        data: JSON.stringify({name:$("#username").val(),pwd:$("#password").val(),phone:$("#telephone").val(),securityCode:$("#security").val()}),
    		        success: function(data , textStatus){
    		        	$("#alertId").show();
    			          if(data.result=="success"){
    			        	  countdown = 5;
    			        	  settime1();
    			          }else if(data.result=="securityError"){
    			        	  $("#alertContent").html("验证码验证失败，请重新输入！");
    			          }
    			          else if(data.result=="nameIsExist"){
    			        	  $("#alertContent").html("该用户名已经被注册，请重新输入！");
    			          }else if(data.result=="phoneIsExist"){
    			        	  $("#alertContent").html("该手机号已经被注册，请重新输入！");
    			          }else if(data.result=="error"){
    			        	  $("#alertContent").html("注册失败，请联系管理员");
    			          }
    		        },
    		        error: function(jqXHR , textStatus , errorThrown){
    		        	$("#alertId").show();
    		        	$("#alertContent").html("系统异常，请联系管理员！");
    		        }
    		      });
    		}
    	}
    	//获取验证码
    	function getSecurityCode(){
    		countdown = 60; 
    		settime();
    		var telephone = $("#telephone").val();
    		$.ajax({
		        url: '${appctx}/loginController/sendSecurityCode',
		        async: true,
		        contentType:"application/json",
		        type: 'POST',
		        data: JSON.stringify({"telephone":telephone}),
		        success: function(data , textStatus){
		          if(data.result=="success"){
		        	  $("#alertId").show();
		        	  $("#alertContent").html("发送成功,验证码是"+data.securityCode);
		          }else if(data.result=="error"){
		        	  $("#alertId").show();
		        	  $("#alertContent").html("发送失败");
		          }
		        },
		        error: function(jqXHR , textStatus , errorThrown){
		        	$("#alertId").show();
		        	$("#alertContent").html("系统异常，请联系管理员！");
		        }
		      });
    	}
    	function settime() { 
    		if (countdown == 0) { 
        		$("#getSecurityCode").html("获取验证码");
        		$("#getSecurityCode").attr("href","javascript:getSecurityCode()");
        		return;
        	} else { 
        		$("#getSecurityCode").attr("href","javascript:void(0)");
        		$("#getSecurityCode").html("重新发送("+countdown+ ")");
        		countdown--; 
        	} 
    		setTimeout(function() { 
    			settime(); 
    		},1000);
    	} 
    	function settime1(){
    		if (countdown == 0) { 
    			location.href="${appctx}/index.jsp";
        		return;
        	} else { 
        		$("#alertContent").html("注册成功，"+countdown+"秒后跳转到<a herf='/index.jsp'>登录<a>页面");
        		countdown--; 
        	} 
    		setTimeout(function() { 
    			settime1(); 
    		},1000);
    	}
    </script>
</head>
<body>
<div class="ch-container">
    <div class="row">
    <div class="row">
        <div class="col-md-12 center login-header">
            <h2>欢迎注册</h2>
        </div>
    </div>
    <div class="row">
        <div class="well col-md-5 center login-box">
            <div class="alert alert-danger" id="alertId" style="display: none;">
				<button type="button" class="close" data-dismiss="alert">&times;</button>
				<strong id="alertContent"></strong>
			</div>
            <form class="form-horizontal">
                <fieldset>
                    <div class="input-group input-group-lg">
                        <span class="input-group-addon"><i class="glyphicon glyphicon-user red"></i></span>
                        <input type="text" class="form-control" id="username" placeholder="请输入用户名">
                    </div>
                    <div class="clearfix"></div><br>

					<div class="input-group input-group-lg">
                        <span class="input-group-addon"><i class="glyphicon glyphicon-earphone red"></i></span>
                        <input type="text" class="form-control" id="telephone" placeholder="请输入手机号">
                    </div>
                    <div class="clearfix"></div><br>
                    <div class="input-group input-group-lg">
                        <span class="input-group-addon"><i class="glyphicon glyphicon-lock red"></i></span>
                        <input type="password" class="form-control" id="password" placeholder="请输入密码">
                    </div>
                    <div class="clearfix"></div><br>
					<div class="input-group input-group-lg">
                        <span class="input-group-addon"><i class="red">验证码</i></span>
                        <input type="password" class="form-control" id="security" placeholder="请输入验证码">
                        <span class="input-group-addon"><i class="blue"><a id="getSecurityCode" href="javascript:getSecurityCode()" class="blue">获取验证码</a></i></span>
                        <!-- <span>
                        	<button type="button" class="btn btn-primary" id="loginId" onclick="loginFunction()">获取验证码</button>
                        </span> -->
                    </div>
                    <div class="clearfix"></div>
                    <p class="center col-md-5">
                    	<button type="button" class="btn btn-primary" id="loginId" onclick="registerFunction()">注册</button>
                    </p>
                    
                </fieldset>
            </form>
        </div>
        <!--/span-->
    </div><!--/row-->
</div><!--/fluid-row-->

</div><!--/.fluid-container-->

</body>
</html>
