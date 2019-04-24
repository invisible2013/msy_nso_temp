package ge.koaladev.msy.nso.core.dto.objects;

import com.fasterxml.jackson.annotation.JsonInclude;
import ge.koaladev.msy.nso.database.model.Gender;
import ge.koaladev.msy.nso.database.model.PersonType;

import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author nino
 */
@JsonInclude(JsonInclude.Include.NON_NULL)
public class GenderDTO {

    private Integer id;
    private String name;

    public static GenderDTO parse(Gender gender) {

        GenderDTO personTypeDTO = new GenderDTO();
        personTypeDTO.setId(gender.getId());
        personTypeDTO.setName(gender.getName());

        return personTypeDTO;
    }

    public static List<GenderDTO> parseToList(List<Gender> genders) {

        List<GenderDTO> dTOs = new ArrayList<>();
        genders.stream().forEach((p) -> {
            dTOs.add(GenderDTO.parse(p));
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
