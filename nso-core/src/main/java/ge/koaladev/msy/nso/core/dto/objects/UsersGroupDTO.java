package ge.koaladev.msy.nso.core.dto.objects;

import com.fasterxml.jackson.annotation.JsonInclude;
import ge.koaladev.msy.nso.database.model.UsersGroup;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author nino
 */
@JsonInclude(JsonInclude.Include.NON_NULL)
public class UsersGroupDTO {

    private Integer id;
    private String name;
    private String description;

    public static UsersGroupDTO parse(UsersGroup group, boolean sensitive) {

        UsersGroupDTO groupDTO = new UsersGroupDTO();
        groupDTO.setId(group.getId());

        groupDTO.setDescription(group.getDescription());
        if (sensitive) {
            groupDTO.setName(group.getName());
        }
        return groupDTO;
    }

    public static List<UsersGroupDTO> parseToList(List<UsersGroup> personTypes, boolean sensitive) {

        List<UsersGroupDTO> dTOs = new ArrayList<>();
        personTypes.stream().forEach((p) -> {
            dTOs.add(UsersGroupDTO.parse(p,sensitive));
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

}
