/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ge.koaladev.msy.nso.core.dto.objects;

import com.fasterxml.jackson.annotation.JsonInclude;
import ge.koaladev.msy.nso.database.model.ApplicationType;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author nl
 */
@JsonInclude(JsonInclude.Include.NON_NULL)
public class ApplicationTypeDTO {

    private Integer id;
    private String name;

    public static ApplicationTypeDTO parse(ApplicationType type) {

        ApplicationTypeDTO typeDTO = new ApplicationTypeDTO();
        typeDTO.setId(type.getId());
        typeDTO.setName(type.getName());
        return typeDTO;
    }

    public static List<ApplicationTypeDTO> parseToList(List<ApplicationType> types) {

        List<ApplicationTypeDTO> dTOs = new ArrayList<>();
        types.stream().forEach((p) -> {
            dTOs.add(ApplicationTypeDTO.parse(p));
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
