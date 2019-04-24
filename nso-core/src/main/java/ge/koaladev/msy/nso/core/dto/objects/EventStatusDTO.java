/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ge.koaladev.msy.nso.core.dto.objects;

import com.fasterxml.jackson.annotation.JsonInclude;
import ge.koaladev.msy.nso.database.model.EventStatus;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author mindia
 */
@JsonInclude(JsonInclude.Include.NON_NULL)
public class EventStatusDTO {

    private Integer id;
    private Integer stage;
    private String name;
    private String description;

    public static EventStatusDTO parse(EventStatus eventStatus) {

        EventStatusDTO item = new EventStatusDTO();
        item.setId(eventStatus.getId());
        item.setStage(eventStatus.getStage());
        item.setDescription(eventStatus.getDescription());

        return item;
    }

    public static List<EventStatusDTO> parseToList(List<EventStatus> eventCategories) {

        List<EventStatusDTO> dTOs = new ArrayList<>();
        eventCategories.stream().forEach((p) -> {
            dTOs.add(EventStatusDTO.parse(p));
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

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Integer getStage() {
        return stage;
    }

    public void setStage(Integer stage) {
        this.stage = stage;
    }

}
