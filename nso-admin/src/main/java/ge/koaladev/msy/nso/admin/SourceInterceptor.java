package ge.koaladev.msy.nso.admin;

import ge.koaladev.msy.nso.core.services.ApplicationServices;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Created by mindia on 1/10/17.
 */
public class SourceInterceptor extends HandlerInterceptorAdapter {

    @Autowired
    private ApplicationServices applicationService;

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {

        String url = request.getRequestURI();
        String v = request.getParameter("v");
        if (v != null && v.equals(applicationService.getAppVersion())) {
            return true;
        }
        response.sendRedirect(url + "?v=" + applicationService.getAppVersion());
        return false;
    }
}
