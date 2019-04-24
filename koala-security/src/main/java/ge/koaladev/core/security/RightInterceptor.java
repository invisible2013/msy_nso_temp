/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ge.koaladev.core.security;

import ge.koaladev.core.security.api.User;
import ge.koaladev.core.security.auth.AuthInterceptor;
import ge.koaladev.core.security.auth.UserAccessDeniedException;
import org.springframework.web.method.HandlerMethod;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * @author mindia
 */
public class RightInterceptor extends HandlerInterceptorAdapter {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws UserAccessDeniedException, IOException {

        boolean result = true;

        HandlerMethod method = (HandlerMethod) handler;
        User user = (User) request.getSession().getAttribute(AuthInterceptor.CURRENT_USER);
        HasRight hasRight = method.getMethod().getAnnotation(HasRight.class);

        if (hasRight != null) {
            result = false;
            String[] rights = hasRight.rights();
            if (rights != null && rights.length > 0) {
                for (String right : rights) {
                    if (user.getRights().contains(right.toLowerCase())) {
                        result = true;
                        break;
                    }
                }
            }
            if (hasRight.value() != null && !hasRight.value().isEmpty()) {
                if (user.getRights().contains(hasRight.value().toLowerCase())) {
                    result = true;
                }
            }
        }

        if (!result) {
            response.sendError(403);
            return result;
        }
        return result;
    }
}
