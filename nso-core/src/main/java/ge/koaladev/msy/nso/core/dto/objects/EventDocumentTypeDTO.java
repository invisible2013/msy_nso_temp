/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ge.koaladev.msy.nso.core.dto.objects;

import com.fasterxml.jackson.annotation.JsonInclude;
import ge.koaladev.msy.nso.database.model.EventDocumentType;

import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author mindia
 */
@JsonInclude(JsonInclude.Include.NON_NULL)
public class EventDocumentTypeDTO {

    private Integer id;
    private String name;

    public static EventDocumentTypeDTO parse(EventDocumentType documentType) {

        EventDocumentTypeDTO eventDocumentTypeDTO = new EventDocumentTypeDTO();
        eventDocumentTypeDTO.setId(documentType.getId());
        eventDocumentTypeDTO.setName(documentType.getName());

        return eventDocumentTypeDTO;
    }

    public static List<EventDocumentTypeDTO> parseToList(List<EventDocumentType> eventDocumentTypes) {

        List<EventDocumentTypeDTO> dTOs = new ArrayList<>();
        eventDocumentTypes.stream().forEach((p) -> {
            dTOs.add(EventDocumentTypeDTO.parse(p));
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

}
