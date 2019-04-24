package ge.koaladev.core.security.auth;

import ge.koaladev.core.security.api.SecurityAPI;
import ge.koaladev.core.security.api.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

/**
 * @author mindia
 */
@Controller
@RequestMapping
public class AuthController {

    @Autowired(required = false)
    private SecurityAPI secApi;

    @RequestMapping(value = "/login", method = {RequestMethod.GET})
    public String login(HttpServletRequest request) {
        User user = (User) request.getSession().getAttribute(AuthInterceptor.CURRENT_USER);
        if (user == null) {
            return "login";
        } else {
            return "redirect:" + secApi.getHomePage();
        }
    }

    @RequestMapping(value = "/login", method = {RequestMethod.POST})
    @ResponseBody
    public Object verify(@RequestParam(value = "uri", required = false) String originalUri, HttpServletRequest request, HttpServletResponse response) throws IOException {

        Map<String, Object> params = new HashMap<>();

        originalUri = (originalUri != null && !originalUri.isEmpty()) ? originalUri : secApi.getHomePage();
        secApi.getLoginParameters().stream().forEach((p) -> {
            params.put(p, request.getParameter(p));
        });

        if (secApi.isTwoStepVerification()) {
            if (request.getParameterMap().containsKey(secApi.getTwoStepVerificationParam())) {
                User user = secApi.getUser(params);
                if (user != null) {
                    request.getSession().setAttribute(AuthInterceptor.CURRENT_USER, user);
                } else {
                    return false;
                }

                return originalUri;
            } else {
                return secApi.sendTwoStepVerificationCode(params);
            }
        } else {
            User user = secApi.getUser(params);
            if (user != null) {
                request.getSession().setAttribute(AuthInterceptor.CURRENT_USER, user);
            } else {
                return false;
            }

            return originalUri;
        }
    }


    @RequestMapping(value = "/logout", method = {RequestMethod.GET, RequestMethod.POST})
    public String logout(HttpSession session) {
        session.removeAttribute(AuthInterceptor.CURRENT_USER);
        session.invalidate();
        return "redirect:" + secApi.getLoginPage();
    }

    @RequestMapping(value = "/status", method = {RequestMethod.GET, RequestMethod.POST})
    @ResponseBody
    public Object status(HttpSession session, HttpServletResponse response) throws IOException {
        User u = (User) session.getAttribute(AuthInterceptor.CURRENT_USER);
        if (u != null) {
            return u;
        }
        response.sendError(400, "Unauthorized");
        return null;
    }

    @ResponseBody
    @RequestMapping(value = "/get-user", method = {RequestMethod.GET, RequestMethod.POST})
    public User getUser(HttpServletRequest httpServletRequest) {
        User user = (User) httpServletRequest.getSession().getAttribute(AuthInterceptor.CURRENT_USER);
        return user;
    }
}
