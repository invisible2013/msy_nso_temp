package ge.koaladev.msy.nso.core.dto.objects;

import com.fasterxml.jackson.annotation.JsonInclude;
import ge.koaladev.msy.nso.database.model.ChampionshipSubType;
import ge.koaladev.msy.nso.database.model.ChampionshipType;

import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author nino
 */
@JsonInclude(JsonInclude.Include.NON_NULL)
public class ChampionshipSubTypeDTO {

    private Integer id;
    private String name;

    public static ChampionshipSubTypeDTO parse(ChampionshipSubType type) {

        ChampionshipSubTypeDTO personTypeDTO = new ChampionshipSubTypeDTO();
        personTypeDTO.setId(type.getId());
        personTypeDTO.setName(type.getName());

        return personTypeDTO;
    }

    public static List<ChampionshipSubTypeDTO> parseToList(List<ChampionshipSubType> types) {

        List<ChampionshipSubTypeDTO> dTOs = new ArrayList<>();
        types.stream().forEach((p) -> {
            dTOs.add(ChampionshipSubTypeDTO.parse(p));
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
