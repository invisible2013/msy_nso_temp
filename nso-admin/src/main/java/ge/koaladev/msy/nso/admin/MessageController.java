package ge.koaladev.msy.nso.admin;

import com.fasterxml.jackson.databind.ObjectMapper;
import ge.koaladev.core.security.HasRight;
import ge.koaladev.core.security.api.User;
import ge.koaladev.core.security.auth.AuthInterceptor;
import ge.koaladev.msy.nso.core.dto.admin.CreateMessageHistoryRequest;
import ge.koaladev.msy.nso.core.dto.admin.GetMessageRequest;
import ge.koaladev.msy.nso.core.dto.admin.broadcastemail.SendBroadcastEmailRequest;
import ge.koaladev.msy.nso.core.dto.objects.UserDTO;
import ge.koaladev.msy.nso.core.misc.Response;
import ge.koaladev.msy.nso.core.services.BroadcastEmailService;
import ge.koaladev.msy.nso.core.services.MessageService;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@Controller
@RequestMapping({"/message"})
public class MessageController {
    @Autowired
    private BroadcastEmailService broadcastEmailService;

    @Autowired
    private MessageService messageService;
    private Logger logger = Logger.getLogger(MessageController.class);


    @ResponseBody
    @RequestMapping({"/send-message"})
    @HasRight(rights = {"admin", "top", "chancellery"})
    public Response sendMessage(@RequestParam("data") String data, @RequestParam(value = "files", required = false) MultipartFile[] files, HttpServletRequest httpServletRequest) {
        ObjectMapper mapper = new ObjectMapper();
        try {
            SendBroadcastEmailRequest sendBroadcastEmailRequest = (SendBroadcastEmailRequest) mapper.readValue(data, SendBroadcastEmailRequest.class);
            User user = (User) httpServletRequest.getSession().getAttribute(AuthInterceptor.CURRENT_USER);
            UserDTO u = (UserDTO) user.getUserData();
            sendBroadcastEmailRequest.setSenderUserId(u.getId());
            messageService.createMessage(sendBroadcastEmailRequest, files);
            return Response.ok();
        } catch (Exception e) {
            logger.error(e);
            return Response.withError("Unable to send broadcast email , please try again");
        }
    }


    @RequestMapping({"/get-messages"})
    @ResponseBody
    private Response getMessages(@RequestBody GetMessageRequest request, HttpSession session) {
        User user = (User) session.getAttribute(AuthInterceptor.CURRENT_USER);
        UserDTO u = (UserDTO) user.getUserData();
        request.setUserId(u.getId());
        request.setFedaration(u.getUsersGroup().getId() == UserDTO.USER_FEDERATION ? true : false);
        return Response.withSuccess(messageService.getMessageByStatus(request));
    }

    @RequestMapping({"/get-message-history"})
    @ResponseBody
    private Response getMessageHistory(@RequestBody GetMessageRequest request) {
        return Response.withSuccess(messageService.getMessageHistory(request.getMessageId()));
    }


    @RequestMapping({"/response-message"})
    @ResponseBody
    private Response responseMessage(@RequestParam("data") String data, @RequestParam(value = "files", required = false) MultipartFile[] files, HttpSession session) {
        try {
            ObjectMapper mapper = new ObjectMapper();
            CreateMessageHistoryRequest request = (CreateMessageHistoryRequest) mapper.readValue(data, CreateMessageHistoryRequest.class);
            User user = (User) session.getAttribute(AuthInterceptor.CURRENT_USER);
            UserDTO u = (UserDTO) user.getUserData();
            request.setSenderUserId(u.getId());
            return Response.withSuccess(messageService.createMessageHistory(request, files));
        } catch (IOException ex) {
            logger.error(ex);
            return Response.withError("შეუძლებელია მონაცემის წაკითხვა, თავიდან სცადეთ");
        }
    }

    @RequestMapping({"/return-message"})
    @ResponseBody
    private Response returnMessage(@RequestBody CreateMessageHistoryRequest request, HttpSession session) {
        User user = (User) session.getAttribute(AuthInterceptor.CURRENT_USER);
        UserDTO u = (UserDTO) user.getUserData();
        request.setSenderUserId(u.getId());
        return Response.withSuccess(messageService.returnMessage(request));
    }
}
