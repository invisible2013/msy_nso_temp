package ge.koaladev.msy.nso.core.dto.objects;

import com.fasterxml.jackson.annotation.JsonInclude;
import ge.koaladev.msy.nso.database.model.UsersStatus;

import java.util.ArrayList;
import java.util.List;

/**
 * @author nino
 */
@JsonInclude(JsonInclude.Include.NON_NULL)
public class UsersStatusDTO {

    private Integer id;
    private String name;

    public static UsersStatusDTO parse(UsersStatus group) {

        UsersStatusDTO itemDTO = new UsersStatusDTO();
        itemDTO.setId(group.getId());
        itemDTO.setName(group.getName());
        return itemDTO;
    }

    public static List<UsersStatusDTO> parseToList(List<UsersStatus> items) {

        List<UsersStatusDTO> dTOs = new ArrayList<>();
        items.stream().forEach((p) -> {
            dTOs.add(UsersStatusDTO.parse(p));
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
