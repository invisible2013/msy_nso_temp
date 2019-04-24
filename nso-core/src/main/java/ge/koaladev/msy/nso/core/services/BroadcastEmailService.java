package ge.koaladev.msy.nso.core.services;

import ge.koaladev.msy.nso.core.dao.UserDao;
import ge.koaladev.msy.nso.core.dto.admin.broadcastemail.SendBroadcastEmailRequest;
import ge.koaladev.msy.nso.core.services.file.FileService;
import ge.koaladev.msy.nso.database.model.Users;
import ge.koaladev.utils.email.FileAttachment;
import ge.koaladev.utils.email.SendEmailWithAttachment;
import ge.koaladev.utils.email.SendEmailWithAttachmentFactory;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

/**
 * Created by mindia on 3/26/17.
 */
@Service
public class BroadcastEmailService {

    @Autowired
    private SendEmailWithAttachmentFactory emailFactory;

    @Autowired
    private UserDao userDao;

    @Autowired
    private SmsService smsService;

    @Autowired
    private FileService fileService;

    private Logger logger = Logger.getLogger(BroadcastEmailService.class);

    public void sendBroadcastEmail(SendBroadcastEmailRequest sendBroadcastEmailRequest, MultipartFile[] files) throws Exception {

        List<Users> users = userDao.getUsersById(sendBroadcastEmailRequest.getRecipients());
        SendEmailWithAttachment sendEmailWithAttachment = emailFactory.getInstance();

        switch (sendBroadcastEmailRequest.getSendBy()) {

            case "email": {
                try {
                    for (Users us : users) {
                        if (us.getEmail() != null) {
                            sendEmailWithAttachment.addBCC(us.getEmail());
                        }
                    }
                    sendEmailWithAttachment.setBody(sendBroadcastEmailRequest.getBody());
                    sendEmailWithAttachment.setSubject(sendBroadcastEmailRequest.getTitle());

                    if (files != null) {
                        for (MultipartFile multipartFile : files) {
                            File convFile = new File(multipartFile.getOriginalFilename());
                            multipartFile.transferTo(convFile);
                            FileAttachment fileAttachment = new FileAttachment();
                            fileAttachment.setFile(convFile);
                            fileAttachment.setName(multipartFile.getOriginalFilename());
                            sendEmailWithAttachment.getFileUrls().add(fileAttachment);
                        }
                    }
                    sendEmailWithAttachment.send();
                } catch (Exception e) {
                    logger.error(e);
                    throw new Exception("Unable to send broadcast email , please try again ");
                }
            }
            break;
            case "sms": {
                List<String> phones = new ArrayList<>();
                for (Users us : users) {
                    if (us.getPhone() != null) {
                        phones.add(us.getPhone());
                    }
                }
                smsService.sendSms(phones, sendBroadcastEmailRequest.getBody());
            }
            break;
        }

    }


    public void sendBroadcastEmail(SendBroadcastEmailRequest sendBroadcastEmailRequest, List<String> files) throws Exception {

        List<Users> users = userDao.getUsersById(sendBroadcastEmailRequest.getRecipients());
        SendEmailWithAttachment sendEmailWithAttachment = emailFactory.getInstance();

        switch (sendBroadcastEmailRequest.getSendBy()) {

            case "email": {
                try {
                    for (Users us : users) {
                        if (us.getEmail() != null) {
                            sendEmailWithAttachment.addBCC(us.getEmail());
                        }
                    }
                    sendEmailWithAttachment.setBody(sendBroadcastEmailRequest.getBody());
                    sendEmailWithAttachment.setSubject(sendBroadcastEmailRequest.getTitle());

                    if (files != null) {
                        for (String fileName : files) {
                            FileAttachment fileAttachment = new FileAttachment();
                            fileAttachment.setName(fileName);
                            fileAttachment.setPath(fileService.getFileFullPath(fileName));
                            sendEmailWithAttachment.getFileUrls().add(fileAttachment);
                        }
                    }
                    sendEmailWithAttachment.send();
                } catch (Exception e) {
                    logger.error(e);
                    throw new Exception("Unable to send broadcast email , please try again ");
                }
            }
            break;
            case "sms": {
                List<String> phones = new ArrayList<>();
                for (Users us : users) {
                    if (us.getPhone() != null) {
                        phones.add(us.getPhone());
                    }
                }
                smsService.sendSms(phones, sendBroadcastEmailRequest.getBody());
            }
            break;
        }

    }
}
