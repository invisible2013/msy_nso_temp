package ge.koaladev.msy.nso.core.dto.objects;

import com.fasterxml.jackson.annotation.JsonInclude;
import ge.koaladev.msy.nso.database.model.AnnualReport;
import ge.koaladev.msy.nso.database.model.AnnualReportStatus;
import ge.koaladev.msy.nso.database.model.CalendarStatus;

import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author nino
 */
@JsonInclude(JsonInclude.Include.NON_NULL)
public class AnnualReportStatusDTO {

    private Integer id;
    private String name;

    public static AnnualReportStatusDTO parse(AnnualReportStatus type) {

        AnnualReportStatusDTO personTypeDTO = new AnnualReportStatusDTO();
        personTypeDTO.setId(type.getId());
        personTypeDTO.setName(type.getName());

        return personTypeDTO;
    }

    public static List<AnnualReportStatusDTO> parseToList(List<AnnualReportStatus> types) {

        List<AnnualReportStatusDTO> dTOs = new ArrayList<>();
        types.stream().forEach((p) -> {
            dTOs.add(AnnualReportStatusDTO.parse(p));
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
