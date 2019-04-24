/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ge.koaladev.msy.nso.core.dto.objects;

import ge.koaladev.msy.nso.database.model.EventDocument;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author mindia
 */
public class EventDocumentDTO {

    private Integer id;
    private Integer eventId;
    private EventDocumentTypeDTO type;
    private String name;
    private String url;

    public static EventDocumentDTO parse(EventDocument eventDocument) {

        EventDocumentDTO eventDocumentDTO = new EventDocumentDTO();
        eventDocumentDTO.setId(eventDocument.getId());
        eventDocumentDTO.setEventId(eventDocument.getEventId());
        eventDocumentDTO.setName(eventDocument.getName());
        eventDocumentDTO.setUrl(eventDocument.getUrl());
        if(eventDocument.getType()!=null){
        eventDocumentDTO.setType(EventDocumentTypeDTO.parse(eventDocument.getType()));
        }

        return eventDocumentDTO;
    }

    public static List<EventDocumentDTO> parseToList(List<EventDocument> events) {

        List<EventDocumentDTO> dTOs = new ArrayList<>();
        events.stream().forEach((n) -> {
            dTOs.add(EventDocumentDTO.parse(n));
        });
        return dTOs;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getEventId() {
        return eventId;
    }

    public void setEventId(Integer eventId) {
        this.eventId = eventId;
    }


    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public EventDocumentTypeDTO getType() {
        return type;
    }

    public void setType(EventDocumentTypeDTO type) {
        this.type = type;
    }

}
