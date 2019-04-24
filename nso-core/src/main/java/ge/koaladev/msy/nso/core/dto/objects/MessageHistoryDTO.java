/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ge.koaladev.msy.nso.core.dto.objects;

import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import ge.koaladev.msy.nso.core.misc.JsonDateSerializeSupport;
import ge.koaladev.msy.nso.database.model.EventHistory;
import ge.koaladev.msy.nso.database.model.MessageHistory;
import ge.koaladev.msy.nso.database.model.MessageStatus;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * @author mindia
 */
public class MessageHistoryDTO {

    private Integer id;

    private Integer messageId;

    private UserDTO sender;

    private UserDTO recipient;

    private MessageStatus status;

    @JsonSerialize(using = JsonDateSerializeSupport.class)
    private Date createDate;

    private String note;
    private String url;

    public static MessageHistoryDTO parse(MessageHistory history) {

        MessageHistoryDTO historyDTO = new MessageHistoryDTO();
        historyDTO.setId(history.getId());

        historyDTO.setSender(UserDTO.parse(history.getSender(), false));
        historyDTO.setRecipient(UserDTO.parse(history.getRecipient(), false));
        historyDTO.setStatus(history.getStatus());
        historyDTO.setCreateDate(history.getCreateDate());
        historyDTO.setNote(history.getNote());
        historyDTO.setUrl(history.getUrl());

        return historyDTO;
    }

    public static List<MessageHistoryDTO> parseToList(List<MessageHistory> events) {

        List<MessageHistoryDTO> dTOs = new ArrayList<>();
        events.stream().forEach((n) -> {
            dTOs.add(MessageHistoryDTO.parse(n));
        });
        return dTOs;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getMessageId() {
        return messageId;
    }

    public void setMessageId(Integer messageId) {
        this.messageId = messageId;
    }

    public UserDTO getSender() {
        return sender;
    }

    public void setSender(UserDTO sender) {
        this.sender = sender;
    }

    public UserDTO getRecipient() {
        return recipient;
    }

    public void setRecipient(UserDTO recipient) {
        this.recipient = recipient;
    }

    public MessageStatus getStatus() {
        return status;
    }

    public void setStatus(MessageStatus status) {
        this.status = status;
    }

    public Date getCreateDate() {
        return createDate;
    }

    public void setCreateDate(Date createDate) {
        this.createDate = createDate;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }
}
