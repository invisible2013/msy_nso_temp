package ge.koaladev.msy.nso.core.dto.admin.reporting;

import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import ge.koaladev.msy.nso.core.misc.JsonDateDeSerializeSupport;

import java.util.Date;
import java.util.List;

/**
 * Created by mindia on 4/9/17.
 */
public class Report1DetailsRequest {

    private List<Integer> eventTypes;
    private Integer federation;
    @JsonDeserialize(using = JsonDateDeSerializeSupport.class)
    private Date startDate;
    @JsonDeserialize(using = JsonDateDeSerializeSupport.class)
    private Date endDate;


    public List<Integer> getEventTypes() {
        return eventTypes;
    }

    public void setEventTypes(List<Integer> eventTypes) {
        this.eventTypes = eventTypes;
    }

    public Date getStartDate() {
        return startDate;
    }

    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }

    public Date getEndDate() {
        return endDate;
    }

    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }

    public Integer getFederation() {
        return federation;
    }

    public void setFederation(Integer federation) {
        this.federation = federation;
    }
}
