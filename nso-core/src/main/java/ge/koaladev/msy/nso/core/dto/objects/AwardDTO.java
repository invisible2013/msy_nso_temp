package ge.koaladev.msy.nso.core.dto.objects;

import com.fasterxml.jackson.annotation.JsonInclude;
import ge.koaladev.msy.nso.database.model.Award;
import ge.koaladev.msy.nso.database.model.ChampionshipType;

import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author nino
 */
@JsonInclude(JsonInclude.Include.NON_NULL)
public class AwardDTO {

    private Integer id;
    private String name;

    public static AwardDTO parse(Award type) {

        AwardDTO personTypeDTO = new AwardDTO();
        personTypeDTO.setId(type.getId());
        personTypeDTO.setName(type.getName());

        return personTypeDTO;
    }

    public static List<AwardDTO> parseToList(List<Award> types) {

        List<AwardDTO> dTOs = new ArrayList<>();
        types.stream().forEach((p) -> {
            dTOs.add(AwardDTO.parse(p));
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
