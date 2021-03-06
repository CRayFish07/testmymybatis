<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"></c:set>
<c:set var="appctx" value="${pageContext.request.contextPath}"></c:set>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<title>Free HTML5 Bootstrap Admin Template</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="description"
	content="Charisma, a fully featured, responsive, HTML5, Bootstrap admin template.">
<meta name="author" content="Muhammad Usman">
<script type="text/javascript">
	$(function() {
		
	});
	function saveSubmit(){
		if($("#resourceName1").val()==null||(!$("#resourceName1").val().length>0)){
			$("#alertId").show();
			$("#alertContent").html("资源名字不能为空");
		}else if($("#resourceUrl").val()==null||(!$("#resourceUrl").val().length>0)){
			$("#alertId").show();
			$("#alertContent").html("资源地址不能为空");
		}
		else{
			var jsonData  = {};
			jsonData.resourceName=$("#resourceName1").val();
			jsonData.resourceUrl=$("#resourceUrl").val();
			jsonData.pid=$("#pid").val();
			jsonData.icons=$("#icons").val();
			jsonData.remark=$("#remark").val();
			$.ajax({
		        url: '${appctx}/resourceController/add',
		        async: true,
		        contentType:"application/json",
		        type: 'POST',
		        data: JSON.stringify(jsonData),
		        success: function(data , textStatus){
		          $("#alertId").show();
		          if(data.result=="success"){
		        	  $("#alertContent").html("保存成功！");
		        	  setTimeout("$('#myModal').modal('hide')",1000); 
		        	  $("#saveBtn").attr("onclick","");
		        	  table.fnDraw();
		          }else if(data.result=="error"){
		        	  $("#alertContent").html("保存失败，请联系管理员");
		          }
		          
		        },
		        error: function(jqXHR , textStatus , errorThrown){
		        	$("#alertId").show();
		        	$("#alertContent").html("系统异常，请联系管理员");
		        }
		       
		      });
		}
	}
</script>
</head>
<body>
	<div class="alert alert-danger" id="alertId" style="display:none;">
		<button type="button" class="close" data-dismiss="alert">&times;</button>
		<strong id="alertContent"></strong>
	</div>
	<font color="red">注意：如果资源地址没有，就录入“#”(表示是父菜单)</font>
	<form class="form-horizontal" role="form">
	   <div class="form-group">
	      <label class="col-sm-3 control-label">
	         资源名字：<font color="red">*</font>
	      </label>
	      <div class="col-sm-9">
	         <input type="text" class="form-control" id="resourceName1">
	      </div>
	   </div>
	   <div class="form-group">
	      <label class="col-sm-3 control-label">
	         资源地址：<font color="red">*</font>
	      </label>
	      <div class="col-sm-9">
	         <input type="text" class="form-control" id="resourceUrl">
	      </div>
	   </div>
	   <div class="form-group">
          <label class="control-label col-sm-3 " for="selectError">父资源：</label>
		  <div class="col-sm-9">
		  	<select id="pid" class="col-sm-9 form-control">
		  	  <option value="0"></option>
		  	  <c:forEach items="${listResource}" var="resource">
		  	  	<option value="${resource.id}">${resource.resourceName}</option>
		  	  </c:forEach>
			</select>
		  </div>
       </div>
	   <div class="form-group">
	      <label class="col-sm-3 control-label">
	         资源图标：
	      </label>
	      <div class="col-sm-9">
	         <input type="text" class="form-control" id="icons">
	      </div>
	   </div>
	   <div class="form-group">
	      <label class="col-sm-3 control-label">
	         备注：
	      </label>
	      <div class="col-sm-9">
	      		<textarea class="form-control" rows="3" id="remark"></textarea>
	      </div>
	   </div>
	</form>
</body>
</html>
