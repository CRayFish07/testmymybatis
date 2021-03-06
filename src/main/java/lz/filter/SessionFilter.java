package lz.filter;

import java.io.IOException;
import java.util.List;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import lz.business.systemManage.service.ParamService;
import lz.model.SystemParam;
import lz.model.User;

import org.springframework.context.ApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;


/**
 * Servlet Filter implementation class SessionFilter
 */
public class SessionFilter implements Filter {
    //@Resource
	private ParamService paramService;
	FilterConfig config;  
    public SessionFilter() {
        super();
    }

	public void destroy() {
		this.config = null;  
	}

	/**
	 * 登录拦截器，如果用户未登录，则统一拦截跳回到登录页面
	 * 其中，一部分用户的请求不做拦截（登录，注册，找回密码等）
	 */
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
		HttpServletRequest hreq = (HttpServletRequest) request; 
		HttpServletResponse hres = (HttpServletResponse) response;
		hres.setDateHeader("Expires",-1);
		hres.setHeader("Cache-Control","no-cache");
		hres.setHeader("Pragma","no-cache");
		String servletPath = hreq.getServletPath();
		User user = (User)hreq.getSession().getAttribute("loginUser");
		if(user!=null){
			chain.doFilter(request, response);
		}else{
			//如果没登录，验证请求是否是资源文件
			if(servletPath.startsWith("/bower_components/")||
					servletPath.startsWith("/css/")||
					servletPath.startsWith("/js/")||
					servletPath.startsWith("/fonts/")||
					servletPath.startsWith("/img/")||
					servletPath.startsWith("/misc/")||
					servletPath.startsWith("/asset/")||
					servletPath.startsWith("/indexController/")||
					servletPath.startsWith("/otherController/")||
					servletPath.startsWith("/test.html")
					){
				chain.doFilter(request, response);
			}else{
				//验证是否是我配置的一些不需要拦截的请求
				SystemParam param = paramService.getParamByParamKey("noFilterUrl");
				if(param!=null){
					boolean flag = false;
					for(String url:param.getParamValue().split(";")){
						if(servletPath.indexOf(url)>-1){
							flag = true;
							break;
						}
					}
					if(flag){
						chain.doFilter(request, response);
					}else{
						hres.sendRedirect(hreq.getContextPath()+"/index.jsp");
					}
				}else{
					chain.doFilter(request, response);
				}
			}
		}
	}
	public void init(FilterConfig fConfig) throws ServletException {
		this.config = fConfig; 
		ServletContext servletContext = fConfig.getServletContext();
		ApplicationContext ctx=WebApplicationContextUtils.getWebApplicationContext(servletContext);
		paramService =(ParamService)ctx.getBean("paramService");
	}

}
