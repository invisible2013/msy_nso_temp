package ge.koaladev.msy.nso.admin;

import ge.koaladev.core.security.HasRight;
import ge.koaladev.core.security.api.User;
import ge.koaladev.core.security.auth.AuthInterceptor;
import ge.koaladev.msy.nso.core.dto.admin.feedback.SendFeedbackRequest;
import ge.koaladev.msy.nso.core.dto.objects.UserDTO;
import ge.koaladev.msy.nso.core.misc.Response;
import ge.koaladev.msy.nso.core.services.FeedbackService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;

@RequestMapping({"/feedback"})
@Controller
public class FeedbackController {
    @Autowired
    private FeedbackService feedbackService;

    @RequestMapping({"/send-feedback"})
    @ResponseBody
    public Response sendFeedback(@RequestBody SendFeedbackRequest sendFeedbackRequest, HttpServletRequest httpServletRequest)
            throws Exception {
        User user = (User) httpServletRequest.getSession().getAttribute(AuthInterceptor.CURRENT_USER);
        UserDTO u = (UserDTO) user.getUserData();
        sendFeedbackRequest.setSender(u.getName());
        this.feedbackService.sendFeedback(sendFeedbackRequest);
        return Response.ok();
    }
}
