package ge.koaladev.msy.nso.core.dto.objects;

import com.fasterxml.jackson.annotation.JsonInclude;
import ge.koaladev.msy.nso.database.model.PersonType;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author nino
 */
@JsonInclude(JsonInclude.Include.NON_NULL)
public class PersonTypeDTO {

    private Integer id;
    private String name;

    public static PersonTypeDTO parse(PersonType personType) {

        PersonTypeDTO personTypeDTO = new PersonTypeDTO();
        personTypeDTO.setId(personType.getId());
        personTypeDTO.setName(personType.getName());

        return personTypeDTO;
    }

    public static List<PersonTypeDTO> parseToList(List<PersonType> personTypes) {

        List<PersonTypeDTO> dTOs = new ArrayList<>();
        personTypes.stream().forEach((p) -> {
            dTOs.add(PersonTypeDTO.parse(p));
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
