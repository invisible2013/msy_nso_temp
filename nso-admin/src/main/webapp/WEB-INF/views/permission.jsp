<%@page import="ge.koaladev.core.security.auth.AuthInterceptor"%>
<%@page import="ge.koaladev.core.security.api.User"%>
<%!
    public boolean hasPermissions(HttpServletRequest request, String permission) {
        User user = (User) request.getSession().getAttribute(AuthInterceptor.CURRENT_USER);
        return user.getRights().contains(permission);
    }
%>