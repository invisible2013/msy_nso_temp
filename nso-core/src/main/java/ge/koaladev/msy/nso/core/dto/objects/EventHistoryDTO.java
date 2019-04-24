/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ge.koaladev.msy.nso.core.dto.objects;

import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import ge.koaladev.msy.nso.core.misc.JsonDateSerializeSupport;
import ge.koaladev.msy.nso.database.model.EventHistory;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 *
 * @author mindia
 */
public class EventHistoryDTO {

    private Integer id;

    private EventDTO event;

    private UserDTO sender;

    private UserDTO recipient;

    private EventStatusDTO status;

    @JsonSerialize(using = JsonDateSerializeSupport.class)
    private Date createDate;

    private String note;

    public static EventHistoryDTO parse(EventHistory eventHistory, boolean event, boolean sender, boolean recipient) {

        EventHistoryDTO historyDTO = new EventHistoryDTO();
        historyDTO.setId(eventHistory.getId());
        if (event) {
            historyDTO.setEvent(EventDTO.parse(eventHistory.getEvent(), false, false));
        }
        if (sender) {
            historyDTO.setSender(UserDTO.parse(eventHistory.getSender(), false));
        }
        if (recipient && eventHistory.getRecipient() != null) {
            historyDTO.setRecipient(UserDTO.parse(eventHistory.getRecipient(), false));
        }
        historyDTO.setStatus(EventStatusDTO.parse(eventHistory.getStatus()));
        historyDTO.setCreateDate(eventHistory.getCreateDate());
        historyDTO.setNote(eventHistory.getNote());

        return historyDTO;
    }

    public static List<EventHistoryDTO> parseToList(List<EventHistory> events, boolean event, boolean sender, boolean recipient) {

        List<EventHistoryDTO> dTOs = new ArrayList<>();
        events.stream().forEach((n) -> {
            dTOs.add(EventHistoryDTO.parse(n, event, sender, recipient));
        });
        return dTOs;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public EventDTO getEvent() {
        return event;
    }

    public void setEvent(EventDTO event) {
        this.event = event;
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

    public EventStatusDTO getStatus() {
        return status;
    }

    public void setStatus(EventStatusDTO status) {
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

}
