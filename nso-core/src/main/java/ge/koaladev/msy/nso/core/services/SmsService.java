package ge.koaladev.msy.nso.core.services;

import ge.koaladev.utils.email.EmailNotSentException;
import ge.koaladev.utils.email.SendEmailWithAttachment;
import ge.koaladev.utils.email.SendEmailWithAttachmentFactory;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.Arrays;
import java.util.List;

/**
 * Created by mindia on 2/28/16.
 */
public class SmsService {

    private String smsEndpointEmail;
    private String smsBodyPrefix;

    private Logger logger = Logger.getLogger(SmsService.class);

    @Autowired
    private SendEmailWithAttachmentFactory sendEmailWithAttachmentFactory;

    public boolean sendSms(List<String> phone, String text) {

        SendEmailWithAttachment sendEmailWithAttachment = sendEmailWithAttachmentFactory.getInstance();

        sendEmailWithAttachment.setSubject("sms");
        sendEmailWithAttachment.setTextPlain(true);

        StringBuilder to = new StringBuilder();

        for (String p : phone) {
            to.append(p).append(" ");
        }

        sendEmailWithAttachment.setBody("" +
                "to: " + to.toString().trim() + "\n" +
                "data: " + text);

        sendEmailWithAttachment.setTo(smsEndpointEmail);

        logger.info("Generated Email : \n" + sendEmailWithAttachment.getBody());
        logger.info("Sending ...");
        try {
            sendEmailWithAttachment.send();
        } catch (EmailNotSentException e) {
            logger.error("Unable to send sms to phone " + phone, e);
            return false;
        }
        logger.info("DONE");
        return true;
    }


    public boolean sendOneTimePassword(String phone, String text) {
        return sendSms(Arrays.asList(phone), smsBodyPrefix + " " + text);
    }

    public String getSmsEndpointEmail() {
        return smsEndpointEmail;
    }

    public void setSmsEndpointEmail(String smsEndpointEmail) {
        this.smsEndpointEmail = smsEndpointEmail;
    }

    public String getSmsBodyPrefix() {
        return smsBodyPrefix;
    }

    public void setSmsBodyPrefix(String smsBodyPrefix) {
        this.smsBodyPrefix = smsBodyPrefix;
    }
}
