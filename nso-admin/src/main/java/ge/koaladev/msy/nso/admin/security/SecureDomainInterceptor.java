package ge.koaladev.msy.nso.admin.security;

import ge.koaladev.core.security.api.User;
import ge.koaladev.core.security.auth.AuthInterceptor;
import ge.koaladev.msy.nso.database.model.Groups;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Created by mindia on 2/4/16.
 */
@Component
public class SecureDomainInterceptor extends HandlerInterceptorAdapter {

    @Autowired
    private SecureDomainManager secureDomainManager;

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {

        String uri = request.getRequestURI();

        if (!secureDomainManager.isEnableAllDomain()) {

            User user = (User) request.getSession().getAttribute(AuthInterceptor.CURRENT_USER);

            if (!user.getRights().contains(Groups.FEDERATION.getName())) {
                //is client behind something?
                String ipAddress = request.getHeader("X-FORWARDED-FOR");
                if (ipAddress == null) {
                    ipAddress = request.getRemoteAddr();
                }
                if (!secureDomainManager.getSecureDomain().contains(ipAddress.trim())) {
                    response.sendError(403, "Unable to access this resource from this ip");
                }
            }
        }
        return true;
    }
}
