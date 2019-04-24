package ge.koaladev.msy.nso.core.dto.objects;

import com.fasterxml.jackson.annotation.JsonInclude;
import ge.koaladev.msy.nso.database.model.CalendarType;
import ge.koaladev.msy.nso.database.model.PersonType;

import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author nino
 */
@JsonInclude(JsonInclude.Include.NON_NULL)
public class CalendarTypeDTO {

    private Integer id;
    private String name;

    public static CalendarTypeDTO parse(CalendarType type) {

        CalendarTypeDTO personTypeDTO = new CalendarTypeDTO();
        personTypeDTO.setId(type.getId());
        personTypeDTO.setName(type.getName());

        return personTypeDTO;
    }

    public static List<CalendarTypeDTO> parseToList(List<CalendarType> types) {

        List<CalendarTypeDTO> dTOs = new ArrayList<>();
        types.stream().forEach((p) -> {
            dTOs.add(CalendarTypeDTO.parse(p));
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
