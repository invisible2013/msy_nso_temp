package ge.koaladev.msy.nso.core.services;

import ge.koaladev.msy.nso.core.dao.MessageDao;
import ge.koaladev.msy.nso.core.dto.admin.CreateMessageHistoryRequest;
import ge.koaladev.msy.nso.core.dto.admin.GetMessageRequest;
import ge.koaladev.msy.nso.core.dto.admin.broadcastemail.SendBroadcastEmailRequest;
import ge.koaladev.msy.nso.core.dto.objects.MessageDTO;
import ge.koaladev.msy.nso.core.dto.objects.MessageHistoryDTO;
import ge.koaladev.msy.nso.core.services.file.FileService;
import ge.koaladev.msy.nso.database.model.Message;
import ge.koaladev.msy.nso.database.model.MessageHistory;
import ge.koaladev.msy.nso.database.model.MessageStatus;
import ge.koaladev.msy.nso.database.model.Users;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import javax.transaction.Transactional;
import java.io.File;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;

/**
 * Created by NINO on 4/2/2018.
 */

@Service
public class MessageService {

    @Autowired
    private MessageDao messageDao;

    @Autowired
    private FileService fileService;

    @Autowired
    private BroadcastEmailService broadcastEmailService;

    private static final Logger logger = Logger.getLogger(MessageService.class);


    @Transactional
    public MessageDTO createMessage(SendBroadcastEmailRequest request, MultipartFile[] files) throws Exception {

        if (files != null && files.length > 0) {
            MultipartFile file = files[0];
            String[] fileParts = file.getOriginalFilename().split("\\.");
            String fileExtension = fileParts.length > 1 ? fileParts[fileParts.length - 1] : "";
            String fileName = "m_" + 2 + "_" + UUID.randomUUID() + (fileExtension.length() > 0 ? ("." + fileExtension) : "");

            String fullPath = fileService.getRootDir() + "/" + fileName;

            File f = new File(fullPath);
            try {
                file.transferTo(f);
                request.setUrl(fileName);
            } catch (Exception ex) {
                logger.error("Unable to save document with, fullPath=" + fullPath, ex);
            }
        }

        for (int i : request.getRecipients()) {
            request.setReceiverUserId(i);
            addMessage(request);
        }
        List<String> messageFiles = new ArrayList<>();
        messageFiles.add(request.getUrl());
        broadcastEmailService.sendBroadcastEmail(request, messageFiles);


        return null;
    }

    @Transactional
    public void addMessage(SendBroadcastEmailRequest request) {
        Message message = new Message();
        message.setSenderUser(messageDao.find(Users.class, request.getSenderUserId()));
        message.setName(request.getTitle());
        message.setDescription(request.getBody());
        message.setNumber(request.getNumber());
        message.setDueDate(request.getDueDate());
        message.setReceiverUser(messageDao.find(Users.class, request.getReceiverUserId()));
        message.setStatus(messageDao.find(MessageStatus.class, 1));
        message.setCreateDate(new Date());
        message.setUrl(request.getUrl());
        messageDao.update(message);
    }


    @Transactional
    public MessageDTO createMessageHistory(CreateMessageHistoryRequest request, MultipartFile[] files) {

        Message message = messageDao.find(Message.class, request.getMessageId());

        MessageHistory history = new MessageHistory();
        history.setMessageId(request.getMessageId());
        history.setSender(messageDao.find(Users.class, request.getSenderUserId()));
        history.setNote(request.getNote());
        history.setRecipient(messageDao.find(Users.class, message.getSenderUser().getId()));
        history.setStatus(messageDao.find(MessageStatus.class, 2));
        history.setCreateDate(new Date());
        history = messageDao.update(history);

        if (files != null && files.length > 0) {
            MultipartFile file = files[0];
            String[] fileParts = file.getOriginalFilename().split("\\.");
            String fileExtension = fileParts.length > 1 ? fileParts[fileParts.length - 1] : "";
            String fileName = history.getId() + "_3_" + UUID.randomUUID() + (fileExtension.length() > 0 ? ("." + fileExtension) : "");

            String fullPath = fileService.getRootDir() + "/" + fileName;

            File f = new File(fullPath);
            try {
                file.transferTo(f);
                history.setUrl(fileName);
                messageDao.update(history);
            } catch (Exception ex) {
                logger.error("Unable to save document with, fullPath=" + fullPath, ex);
            }
        }

        message.setStatus(messageDao.find(MessageStatus.class, 2));
        messageDao.update(message);

        return null;
    }


    @Transactional
    public MessageDTO returnMessage(CreateMessageHistoryRequest request) {

        Message message = messageDao.find(Message.class, request.getMessageId());

        MessageHistory history = new MessageHistory();
        history.setMessageId(request.getMessageId());
        history.setSender(messageDao.find(Users.class, request.getSenderUserId()));
        history.setNote(request.getNote());
        history.setRecipient(messageDao.find(Users.class, message.getReceiverUser().getId()));
        history.setStatus(messageDao.find(MessageStatus.class, 3));
        history.setCreateDate(new Date());
        history = messageDao.update(history);

        message.setStatus(messageDao.find(MessageStatus.class, 3));
        messageDao.update(message);
        return null;
    }

    @Transactional
    public List<MessageDTO> getMessageByStatus(GetMessageRequest request) {
        List<Message> results = messageDao.getMessageByStatus(request.getUserId(), request.getStatusId(), request.getFullText(), request.getLimit(), request.getOffset(), request.isFedaration());
        return results != null ? MessageDTO.parseToList(results) : null;
    }

    public List<MessageHistoryDTO> getMessageHistory(int messageId) {
        return messageDao.getMessageHistory(messageId);
    }
}
