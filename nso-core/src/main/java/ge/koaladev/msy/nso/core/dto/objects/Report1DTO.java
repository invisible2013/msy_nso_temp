package ge.koaladev.msy.nso.core.dto.objects;

import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import ge.koaladev.msy.nso.core.misc.JsonDateSerializeSupport;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * Created by mindia on 4/9/17.
 */
public class Report1DTO {

    private String federationName;
    private int federationId;
    private List<Integer> eventTypes;
    @JsonSerialize(using = JsonDateSerializeSupport.class)
    private Date startDate;
    @JsonSerialize(using = JsonDateSerializeSupport.class)
    private Date endDate;
    private double sum;
    private List<Report1DetailsDTO> details = new ArrayList<>();
    private int eventsCount;

    public String getFederationName() {
        return federationName;
    }

    public void setFederationName(String federationName) {
        this.federationName = federationName;
    }

    public int getFederationId() {
        return federationId;
    }

    public void setFederationId(int federationId) {
        this.federationId = federationId;
    }

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

    public double getSum() {
        return sum;
    }

    public void setSum(double sum) {
        this.sum = sum;
    }

    public List<Report1DetailsDTO> getDetails() {
        return details;
    }

    public void setDetails(List<Report1DetailsDTO> details) {
        this.details = details;
    }

    public int getEventsCount() {
        return eventsCount;
    }

    public void setEventsCount(int eventsCount) {
        this.eventsCount = eventsCount;
    }
}
