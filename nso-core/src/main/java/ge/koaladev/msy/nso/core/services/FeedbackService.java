package ge.koaladev.msy.nso.core.services;

import ge.koaladev.msy.nso.core.dto.admin.feedback.SendFeedbackRequest;
import ge.koaladev.utils.email.SendEmailWithAttachmentFactory;
import ge.koaladev.utils.email.EmailNotSentException;
import ge.koaladev.utils.email.SendEmailWithAttachment;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * Created by mindia on 3/25/17.
 */
@Service
public class FeedbackService {

    @Autowired
    private SendEmailWithAttachmentFactory sendEmailWithAttachmentFactory;

    private Logger logger = Logger.getLogger(FeedbackService.class);

    //    private static final String TO = "nso@msy.gov.ge";
    private static final String TO = "nino.lomineisvili@gmail.com";

    public void sendFeedback(SendFeedbackRequest sendFeedbackRequest) throws Exception {

        SendEmailWithAttachment sendEmailWithAttachment = sendEmailWithAttachmentFactory.getInstance();

        sendEmailWithAttachment.setTo(TO);
        sendEmailWithAttachment.setSubject(sendFeedbackRequest.getTitle() + " -- " + sendFeedbackRequest.getSender());
        sendEmailWithAttachment.setBody(sendFeedbackRequest.getText());

        try {
            sendEmailWithAttachment.send();
        } catch (EmailNotSentException e) {
            logger.error(e);
            throw new Exception("Unable to send feedback, please try again later");
        }
    }
}
