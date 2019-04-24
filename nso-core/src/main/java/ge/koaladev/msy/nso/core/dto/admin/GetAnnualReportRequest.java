package ge.koaladev.msy.nso.core.dto.admin;

/**
 * Created by ninolomineishvili on 4/16/18.
 */
public class GetAnnualReportRequest {


    private Integer id;
    private Integer annualReportId;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getAnnualReportId() {
        return annualReportId;
    }

    public void setAnnualReportId(Integer annualReportId) {
        this.annualReportId = annualReportId;
    }
}
