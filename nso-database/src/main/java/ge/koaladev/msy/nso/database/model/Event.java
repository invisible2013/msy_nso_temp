/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ge.koaladev.msy.nso.database.model;

import java.io.Serializable;
import java.util.Date;
import java.util.List;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.OneToMany;
import javax.persistence.OneToOne;
import javax.persistence.Table;
import javax.persistence.TableGenerator;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import javax.xml.bind.annotation.XmlRootElement;

/**
 *
 * @author mindia
 */
@Entity
@Table(name = "event")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "Event.findAll", query = "SELECT e FROM Event e")})
public class Event implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @TableGenerator(name = "id_generator", table = "id_generator", valueColumnName = "value", pkColumnName = "pk_column_name", pkColumnValue = "event_max_id", allocationSize = 1)
    @GeneratedValue(strategy = GenerationType.TABLE, generator = "id_generator")
    private Integer id;

    @Column(name = "key")
    private String key;

    @Column(name = "event_name")
    private String eventName;
    @JoinColumn(name = "sender_user_id")
    @OneToOne
    private Users senderUser;
    @Column(name = "dispatcher_id")
    private Integer dispatcherId;
    @Column(name = "supervisor_id")
    private Integer supervisorId;
    @Column(name = "accountant_id")
    private Integer accountantId;
    @JoinColumn(name = "last_status_id")
    @OneToOne
    private EventStatus lastStatus;
    @Column(name = "last_status_date")
    @Temporal(TemporalType.DATE)
    private Date lastStatusDate;
    @Column(name = "create_date")
    @Temporal(TemporalType.DATE)
    private Date createDate;
    @Column(name = "last_update_date")
    @Temporal(TemporalType.DATE)
    private Date lastUpdateDate;
    @Column(name = "event_description")
    private String eventDescription;
    @Column(name = "purpose")
    private String purpose;
    @Column(name = "expected_result")
    private String expectedResult;
    @Column(name = "start_date")
    @Temporal(TemporalType.DATE)
    private Date startDate;
    @Column(name = "end_date")
    @Temporal(TemporalType.DATE)
    private Date endDate;
    // @Max(value=?)  @Min(value=?)//if you know range of your decimal fields consider using these annotations to enforce field validation
    @Column(name = "budget")
    private Double budget;
    @Column(name = "report_delivery_date")
    @Temporal(TemporalType.DATE)
    private Date reportDeliveryDate;
    @Column(name = "responsible_person")
    private String responsiblePerson;
    @Column(name = "responsible_person_position")
    private String responsiblePersonPosition;
    @Column(name = "event_type")
    private Integer eventType;
    @JoinColumn(name = "decision_id")
    @OneToOne
    private EventDecision eventDecision;
    @JoinColumn(name = "application_type_id")
    @OneToOne
    private ApplicationType applicationType;
    @Column(name = "real_amount")
    private Double realAmount;
    @Column(name = "last_user_id")
    private Integer lastUserId;
    @Column(name = "iteration")
    private Integer iteration;
    @Column(name = "last_sender_user_id")
    private Integer lastSenderUserId;
    @Column(name = "id_number")
    private String idNumber;
    @Column(name = "registration_number")
    private String registrationNumber;
    @Column(name = "letter_number")
    private String letterNumber;

    @OneToMany
    @JoinColumn(name = "event_id")
    private List<EventPerson> persons;

    @OneToMany
    @JoinColumn(name = "event_id")
    private List<EventDocument> documents;

    public Event() {
    }

    public Event(Integer id) {
        this.id = id;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getKey() {
        return key;
    }

    public void setKey(String key) {
        this.key = key;
    }

    public String getEventName() {
        return eventName;
    }

    public void setEventName(String eventName) {
        this.eventName = eventName;
    }

    public Users getSenderUser() {
        return senderUser;
    }

    public void setSenderUser(Users senderUser) {
        this.senderUser = senderUser;
    }

    public Integer getDispatcherId() {
        return dispatcherId;
    }

    public void setDispatcherId(Integer dispatcherId) {
        this.dispatcherId = dispatcherId;
    }

    public Integer getSupervisorId() {
        return supervisorId;
    }

    public void setSupervisorId(Integer supervisorId) {
        this.supervisorId = supervisorId;
    }

    public EventStatus getLastStatus() {
        return lastStatus;
    }

    public void setLastStatus(EventStatus lastStatus) {
        this.lastStatus = lastStatus;
    }

    public Date getLastStatusDate() {
        return lastStatusDate;
    }

    public void setLastStatusDate(Date lastStatusDate) {
        this.lastStatusDate = lastStatusDate;
    }

    public Date getCreateDate() {
        return createDate;
    }

    public void setCreateDate(Date createDate) {
        this.createDate = createDate;
    }

    public Date getLastUpdateDate() {
        return lastUpdateDate;
    }

    public void setLastUpdateDate(Date lastUpdateDate) {
        this.lastUpdateDate = lastUpdateDate;
    }

    public String getEventDescription() {
        return eventDescription;
    }

    public void setEventDescription(String eventDescription) {
        this.eventDescription = eventDescription;
    }

    public String getPurpose() {
        return purpose;
    }

    public void setPurpose(String purpose) {
        this.purpose = purpose;
    }

    public String getExpectedResult() {
        return expectedResult;
    }

    public void setExpectedResult(String expectedResult) {
        this.expectedResult = expectedResult;
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

    public Double getBudget() {
        return budget;
    }

    public void setBudget(Double budget) {
        this.budget = budget;
    }

    public Date getReportDeliveryDate() {
        return reportDeliveryDate;
    }

    public void setReportDeliveryDate(Date reportDeliveryDate) {
        this.reportDeliveryDate = reportDeliveryDate;
    }

    public String getResponsiblePerson() {
        return responsiblePerson;
    }

    public void setResponsiblePerson(String responsiblePerson) {
        this.responsiblePerson = responsiblePerson;
    }

    public String getResponsiblePersonPosition() {
        return responsiblePersonPosition;
    }

    public void setResponsiblePersonPosition(String responsiblePersonPosition) {
        this.responsiblePersonPosition = responsiblePersonPosition;
    }

    public Integer getEventType() {
        return eventType;
    }

    public void setEventType(Integer eventType) {
        this.eventType = eventType;
    }

    public List<EventPerson> getPersons() {
        return persons;
    }

    public void setPersons(List<EventPerson> persons) {
        this.persons = persons;
    }

    public List<EventDocument> getDocuments() {
        return documents;
    }

    public void setDocuments(List<EventDocument> documents) {
        this.documents = documents;
    }

    public EventDecision getEventDecision() {
        return eventDecision;
    }

    public void setEventDecision(EventDecision eventDecision) {
        this.eventDecision = eventDecision;
    }

    public ApplicationType getApplicationType() {
        return applicationType;
    }

    public void setApplicationType(ApplicationType applicationType) {
        this.applicationType = applicationType;
    }

    public Integer getAccountantId() {
        return accountantId;
    }

    public void setAccountantId(Integer accountantId) {
        this.accountantId = accountantId;
    }

    public Double getRealAmount() {
        return realAmount;
    }

    public void setRealAmount(Double realAmount) {
        this.realAmount = realAmount;
    }

    public Integer getLastUserId() {
        return lastUserId;
    }

    public void setLastUserId(Integer lastUserId) {
        this.lastUserId = lastUserId;
    }

    public Integer getIteration() {
        return iteration;
    }

    public void setIteration(Integer iteration) {
        this.iteration = iteration;
    }

    public Integer getLastSenderUserId() {
        return lastSenderUserId;
    }

    public void setLastSenderUserId(Integer lastSenderUserId) {
        this.lastSenderUserId = lastSenderUserId;
    }

    public String getIdNumber() {
        return idNumber;
    }

    public void setIdNumber(String idNumber) {
        this.idNumber = idNumber;
    }

    public String getRegistrationNumber() {
        return registrationNumber;
    }

    public void setRegistrationNumber(String registrationNumber) {
        this.registrationNumber = registrationNumber;
    }

    public String getLetterNumber() {
        return letterNumber;
    }

    public void setLetterNumber(String letterNumber) {
        this.letterNumber = letterNumber;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (id != null ? id.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof Event)) {
            return false;
        }
        Event other = (Event) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "Event[ id=" + id + " ]";
    }

}
