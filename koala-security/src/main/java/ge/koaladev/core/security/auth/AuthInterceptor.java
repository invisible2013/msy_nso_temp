package ge.koaladev.core.security.auth;

import ge.koaladev.core.security.api.User;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * @author mindia
 */
@Component
public class AuthInterceptor extends HandlerInterceptorAdapter {

    public static final String CURRENT_USER = "currentUser";

    @Override
    public boolean preHandle(final HttpServletRequest request, final HttpServletResponse response, final Object handler) throws IOException {

        String uri = request.getRequestURI();
        User user = (User) request.getSession().getAttribute(CURRENT_USER);

        if (user == null && request.getHeader("X-Requested-With") == null) {

            // getRequestURI() contains root path, uri also contains root path, that's why one must be removed
            if (uri.startsWith(request.getContextPath())) {
                uri = uri.replace(request.getContextPath(), "");
            }

            if (uri.length() > 0 && !uri.equals("/")) {
                response.sendRedirect("login?uri=" + uri);
            } else {
                response.sendRedirect("login");
            }

            return false;
        } else if (user == null) {
            response.sendError(353, "Session Expired");
            return false;
        }
        return true;
    }
}
