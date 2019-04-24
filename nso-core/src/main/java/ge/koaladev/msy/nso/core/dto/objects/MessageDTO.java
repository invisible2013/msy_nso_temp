package ge.koaladev.msy.nso.core.dto.objects;

import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import ge.koaladev.msy.nso.core.misc.JsonDateSerializeSupport;
import ge.koaladev.msy.nso.database.model.Event;
import ge.koaladev.msy.nso.database.model.EventDecision;
import ge.koaladev.msy.nso.database.model.Message;
import ge.koaladev.msy.nso.database.model.MessageStatus;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * @author nino
 */
public class MessageDTO {

    private Integer id;
    private String name;
    private String number;
    private String description;
    private MessageStatus messageStatus;
    private Integer senderUserId;
    private Integer receiverUserId;
    private String url;
    @JsonSerialize(using = JsonDateSerializeSupport.class)
    private Date createDate;
    @JsonSerialize(using = JsonDateSerializeSupport.class)
    private Date dueDate;
    private UserDTO senderUser;
    private UserDTO receiverUser;

    public static int MESSAGE_STATUS_BLOCKED = 3;

    private List<MessageDocumentDTO> documents;


    public static MessageDTO parse(Message message) {

        MessageDTO requestDTO = new MessageDTO();
        requestDTO.setId(message.getId());
        requestDTO.setNumber(message.getNumber());
        requestDTO.setName(message.getName());
        requestDTO.setDescription(message.getDescription());
        requestDTO.setMessageStatus(message.getStatus());
        requestDTO.setCreateDate(message.getCreateDate());
        requestDTO.setUrl(message.getUrl());
        requestDTO.setDueDate(message.getDueDate());
        requestDTO.setSenderUser(UserDTO.parse(message.getSenderUser(), true));
        requestDTO.setReceiverUser(UserDTO.parse(message.getReceiverUser(), true));

        if (message.getDocuments() != null) {
            requestDTO.setDocuments(MessageDocumentDTO.parseToList(message.getDocuments()));
        }
        return requestDTO;
    }

    public static List<MessageDTO> parseToList(List<Message> events) {

        List<MessageDTO> dTOs = new ArrayList<>();
        events.stream().forEach((n) -> {
            dTOs.add(MessageDTO.parse(n));
        });
        return dTOs;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getNumber() {
        return number;
    }

    public void setNumber(String number) {
        this.number = number;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Integer getReceiverUserId() {
        return receiverUserId;
    }

    public void setReceiverUserId(Integer receiverUserId) {
        this.receiverUserId = receiverUserId;
    }

    public MessageStatus getMessageStatus() {
        return messageStatus;
    }

    public void setMessageStatus(MessageStatus messageStatus) {
        this.messageStatus = messageStatus;
    }

    public Integer getSenderUserId() {
        return senderUserId;
    }

    public void setSenderUserId(Integer senderUserId) {
        this.senderUserId = senderUserId;
    }

    public Date getCreateDate() {
        return createDate;
    }

    public void setCreateDate(Date createDate) {
        this.createDate = createDate;
    }

    public Date getDueDate() {
        return dueDate;
    }

    public void setDueDate(Date dueDate) {
        this.dueDate = dueDate;
    }

    public UserDTO getSenderUser() {
        return senderUser;
    }

    public void setSenderUser(UserDTO senderUser) {
        this.senderUser = senderUser;
    }

    public UserDTO getReceiverUser() {
        return receiverUser;
    }

    public void setReceiverUser(UserDTO receiverUser) {
        this.receiverUser = receiverUser;
    }

    public List<MessageDocumentDTO> getDocuments() {
        return documents;
    }

    public void setDocuments(List<MessageDocumentDTO> documents) {
        this.documents = documents;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }
}
