package ge.koaladev.msy.nso.core.dto.objects;

import com.fasterxml.jackson.annotation.JsonInclude;
import ge.koaladev.msy.nso.database.model.CalendarType;
import ge.koaladev.msy.nso.database.model.ChampionshipType;

import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author nino
 */
@JsonInclude(JsonInclude.Include.NON_NULL)
public class ChampionshipTypeDTO {

    private Integer id;
    private String name;

    public static ChampionshipTypeDTO parse(ChampionshipType type) {

        ChampionshipTypeDTO personTypeDTO = new ChampionshipTypeDTO();
        personTypeDTO.setId(type.getId());
        personTypeDTO.setName(type.getName());

        return personTypeDTO;
    }

    public static List<ChampionshipTypeDTO> parseToList(List<ChampionshipType> types) {

        List<ChampionshipTypeDTO> dTOs = new ArrayList<>();
        types.stream().forEach((p) -> {
            dTOs.add(ChampionshipTypeDTO.parse(p));
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
