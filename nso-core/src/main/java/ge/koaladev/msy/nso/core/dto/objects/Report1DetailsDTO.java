package ge.koaladev.msy.nso.core.dto.objects;

/**
 * Created by mindia on 4/9/17.
 */
public class Report1DetailsDTO {

    private String eventName;
    private String eventTypeName;
    private double budget;

    public String getEventName() {
        return eventName;
    }

    public void setEventName(String eventName) {
        this.eventName = eventName;
    }

    public double getBudget() {
        return budget;
    }

    public void setBudget(double budget) {
        this.budget = budget;
    }

    public String getEventTypeName() {
        return eventTypeName;
    }

    public void setEventTypeName(String eventTypeName) {
        this.eventTypeName = eventTypeName;
    }
}
